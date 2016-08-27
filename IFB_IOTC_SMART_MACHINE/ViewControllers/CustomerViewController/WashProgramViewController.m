//
//  WashProgramViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 14/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "WashProgramViewController.h"
#import "WashProgramTableViewCell.h"
#import "DeviceOpertaionViewController.h"
#import "MySingleton.h"
#import "SocketConstant.h"
#import "CommonParsing.h"
#import "MBProgressHUD.h"
#import "CustomViewUtils.h"
#import "SharedPrefrenceUtil.h"
#import "AppConstant.h"

#import "HTTPConnection.h"

@interface WashProgramViewController ()
{
    NSArray *washProgramListArray;
    NSArray *imgArray;
    NSString *runningprogram;
    CommonParsing *commonParsing;
    NSInteger runningProgramIndex;
    CustomViewUtils *customViewUtils;
    SharedPrefrenceUtil *sharedPrefrenceUtil;
    NSIndexPath *selectedIndexPath;
    MBProgressHUD *progressHUD;
    BOOL isProgramSelect;
    BOOL isConnectionFail;
    BOOL isChangeProgram;
    BOOL isReadStatus;
    NSTimer *hideHUDTimer;
    HTTPConnection *httpConnection;
    NSMutableArray *byteArray;
}
@end

@implementation WashProgramViewController

#pragma mark - view controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    washProgramListArray = [NSArray arrayWithObjects:@"COTTON", @"COTTON ECO",@"SYNTHETIC",@"QUICK WASH",@"CRADLE WASH", @"WOOL",@"RINSE SPIN", @"DRAIN SPIN PLUS", nil];
    imgArray = [NSArray arrayWithObjects:@"cotton", @"express", nil];
    commonParsing = [[CommonParsing alloc] init];
    customViewUtils = [[CustomViewUtils alloc] init];
    sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
    byteArray = [[NSMutableArray alloc] init];
    httpConnection = [[HTTPConnection alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    runningProgramIndex = -1;
    isProgramSelect = NO;
    isChangeProgram = NO;
    isReadStatus = YES;
    [self setUI];
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRunningProgram:) name:@"getRunningProgram" object:nil];
        [globalValues.mqtt publish:[NSString stringWithFormat:@"Command/%@",[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_MAC]] withCommand:Machine_GET_STATUS];
    }
    else {
        [self sendLocalCommand:Machine_GET_STATUS];
    }
    [self.washProgramTableView reloadData];
}


-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    selectedIndexPath = nil;
    [hideHUDTimer invalidate];
    hideHUDTimer = nil;
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    self.navigationItem.title = [[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_INFO] valueForKey:@"deviceName"];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(goToPrevious)];
    self.navigationItem.leftBarButtonItem = barBtnItem;
    self.washProgramTableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark UINavigationItem Button Action
/**
 *  go back to previous view
 */
-(void)goToPrevious {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HUD Methods

/**
 *  Show HUD.
 */
-(void)showHUD {
    progressHUD =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [progressHUD setLabelText:@"Please wait..."];
    progressHUD.dimBackground = YES;
    isConnectionFail = YES;
    hideHUDTimer = [NSTimer scheduledTimerWithTimeInterval:11.0 target:self selector:@selector(hideHUD) userInfo:nil repeats:NO];
}

/**
 *  Hide HUD after timeout.
 */
-(void)hideHUD {
    if (isConnectionFail) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [customViewUtils makeErrorToast:self andLabelText:@"Device is not connected."];
        runningProgramIndex = -2;
    }
    else {
        runningProgramIndex = -2;
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [customViewUtils makeErrorToast:self andLabelText:@"Please Try Again."];
    }
}

/**
 *  Hide HUD after success of the operation.
 */
-(void)hideHUDOnSuccess {
    [hideHUDTimer invalidate];
    hideHUDTimer = nil;
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

/**
 *  Get Current state of machine.
 */
#pragma mark - HTTP Send Commands.

-(void)sendLocalCommand: (NSArray *)postDataArray {
    
    [byteArray removeAllObjects];
    NSString *urlString = @"http://10.0.6.209/gainspan/profile/tls?t=1470715355439";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    Byte myByteArray[25];
    
    for (int i = 0; i < postDataArray.count; i++) {
        myByteArray[i] = strtoul([postDataArray[i] UTF8String], NULL, 16);
    }
    NSData *data = [NSData dataWithBytes:myByteArray length:postDataArray.count];
    [postData setObject:data forKey:@"Command"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Please Wait...";
    [httpConnection httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        NSData *data = [result valueForKey:@"data"];
        NSUInteger len = data.length;
        uint8_t *bytes = (uint8_t *)[data bytes];
        
        for (NSUInteger i = 0; i < len; i++) {
            [byteArray addObject:[NSString stringWithFormat:@"%hhu",bytes[i]]];
        }
        if (byteArray.count > 37) {
            [self getLocalRunningProgram:byteArray];
        }
    }];
}

-(void)getLocalRunningProgram:(NSArray *)theArray {
    
    if (theArray.count > 37) {
        
        NSLog(@"command is: %@", [theArray objectAtIndex:5]);
        NSLog(@"program is: %@", [theArray objectAtIndex:6]);
        NSLog(@"type is :%@",[theArray objectAtIndex:2]);
        
        if ([[theArray objectAtIndex:2] integerValue]== 129) {
            
            
            if ([[theArray objectAtIndex:5] integerValue] == 4)    // change program
            {
                if (selectedIndexPath != nil) {
                    [self setProgram:selectedIndexPath];
                    return;
                }
            }
            // Set states or programmes
            runningprogram = [commonParsing getProgramString:[[theArray objectAtIndex:6] integerValue]];
            
            if ([runningprogram isEqualToString: @"No Program"]) {
                runningProgramIndex = -1;
            }
            else {
                if ([washProgramListArray containsObject:runningprogram]) {
                    runningProgramIndex = [washProgramListArray indexOfObject:runningprogram];
                }
            }
            [self.washProgramTableView reloadData];
        }
        else if ([[theArray objectAtIndex:2] integerValue]== 131) {
            // program commands
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            DeviceOpertaionViewController *programVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceOpertaionViewController"];
            [self.navigationController pushViewController:programVC animated:YES];
        }
    }
    else {
        // error case
    }
}

/**
 *  Received acknowledgement.
 *
 *  @param notification array of bytes.
 */
-(void)getRunningProgram:(NSNotification *)notification {
    
    NSArray  *theArray = [[notification userInfo] objectForKey:@"myArray"];
    if (theArray.count > 37) {
        
        NSLog(@"command is: %@", [theArray objectAtIndex:5]);
        NSLog(@"program is: %@", [theArray objectAtIndex:6]);
        NSLog(@"type is :%@",[theArray objectAtIndex:2]);
        
        if ([[theArray objectAtIndex:2] integerValue]== 129) {
            
            
            if ([[theArray objectAtIndex:5] integerValue] == 4)    // change program
            {
                if (selectedIndexPath != nil) {
                    [self setProgram:selectedIndexPath];
                    return;
                }
            }
            // Set states or programmes
            runningprogram = [commonParsing getProgramString:[[theArray objectAtIndex:6] integerValue]];
            
            if ([runningprogram isEqualToString: @"No Program"]) {
                runningProgramIndex = -1;
            }
            else {
                if ([washProgramListArray containsObject:runningprogram]) {
                    runningProgramIndex = [washProgramListArray indexOfObject:runningprogram];
                }
            }
            [self.washProgramTableView reloadData];
        }
        else if ([[theArray objectAtIndex:2] integerValue]== 131) {
            // program commands
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            DeviceOpertaionViewController *programVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceOpertaionViewController"];
            [self.navigationController pushViewController:programVC animated:YES];
        }
    }
    else {
        // error case
    }
}

#pragma mark - UITableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [washProgramListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WashProgramTableViewCell *cell;
    NSString *identifier = @"WashProgramTableViewCell";
    if (cell == nil) {
        cell = [self.washProgramTableView dequeueReusableCellWithIdentifier:identifier];
    }
    if ((indexPath.row % 2) == 0) {
        cell.washProgramImageView.image = [UIImage imageNamed:@"cotton"];
    }
    else {
        cell.washProgramImageView.image = [UIImage imageNamed:@"express"];
    }
    cell.washProgramLabel.text = [washProgramListArray objectAtIndex:indexPath.row];
    if (indexPath.row == runningProgramIndex) {
        
        
        cell.backgroundColor = [UIColor colorWithRed:93.0/255.0 green:206.0/255.0 blue:244.0/255.0 alpha:1.0];
        cell.washProgramLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = [UIColor clearColor];
        cell.washProgramLabel.textColor = [UIColor colorWithRed:93.0/255.0 green:206.0/255.0 blue:244.0/255.0 alpha:1.0];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (runningProgramIndex >= 0) {
        
        if (indexPath.row == runningProgramIndex) {
            [self setProgram:indexPath];
        }
        else {
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
                selectedIndexPath = indexPath;
                if ([globalValues.isLocal isEqualToString:@"no"]) {
                    [globalValues.mqtt publish:[NSString stringWithFormat:@"Command/%@",[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_MAC]] withCommand:Machine_programChange];
                }
                else {
                    [self sendLocalCommand:Machine_programChange];
                }
                isProgramSelect = YES;
                [self.washProgramTableView reloadData];
            }];
            [customViewUtils makeAlertView:@"Change Program" :@"Wash program already running. Do you want to change program?" viewForAlertView:self.navigationController :confirmAction];
        }
    }
    else {
        [self setProgram:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
}

#pragma mark - Set New Washing Program

/**
 *  Set new washing program.
 *
 *  @param indexPath selected program indexpath.
 */
-(void)setProgram :(NSIndexPath *)indexPath {
    
    NSArray *selectedProgram;
    if (indexPath.row == 0) {
        selectedProgram = Program_Cotton;
    }
    else if (indexPath.row == 1) {
        selectedProgram = Program_CottonEco;
    }
    else if (indexPath.row == 2) {
        selectedProgram = Program_synthetic;
    }
    else if (indexPath.row == 3) {
        selectedProgram = Program_quickWash;
    }
    else if (indexPath.row == 4) {
        selectedProgram = Program_cradleWash;
    }
    else if (indexPath.row == 5) {
        selectedProgram = Program_wool;
    }
    else if (indexPath.row == 6) {
        selectedProgram = Program_RinseSpin;
    }
    else if (indexPath.row == 7) {
        selectedProgram = Program_drainSpinPlus;
    }
    // send program command..
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        // publish command..
        [globalValues.mqtt publish:[NSString stringWithFormat:@"Command/%@",[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_MAC]] withCommand:selectedProgram];
    }
    else {
        [self sendLocalCommand:selectedProgram];
    }
}

@end
