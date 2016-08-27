//
//  DeviceOpertaionViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 13/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "DeviceOpertaionViewController.h"
#import "SocketConstant.h"
#import "MySingleton.h"
#import "TCPConnection.h"
#import "SharedPrefrenceUtil.h"
#import "AppConstant.h"
#import "CommonParsing.h"
#import "MBProgressHUD.h"
#import "CustomViewUtils.h"

#import "HTTPConnection.h"


@interface DeviceOpertaionViewController ()
{
    bool isMachineON;
    bool isMachineStart;
    TCPConnection *tcpConnection;
    NSMutableArray *error1;
    NSMutableArray *error2;
    SharedPrefrenceUtil *sharedPrefrenceUtil;
    CommonParsing *commonParsing;
    MBProgressHUD *progressHUD;
    BOOL isConnectionFail;
    CustomViewUtils *customViewUtils;
    NSTimer *hideHUDTimer;
    HTTPConnection *conncetion;
    
    NSMutableArray *byteArray; // response array
    
}
@end

@implementation DeviceOpertaionViewController

#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.onOffSwitch setHidden:YES];
    sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
    customViewUtils = [[CustomViewUtils alloc] init];
    commonParsing = [[CommonParsing alloc] init];
    conncetion = [[HTTPConnection alloc] init];
    byteArray = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUI];
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        [globalValues.mqtt publish:[NSString stringWithFormat:@"Command/%@",[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_MAC]] withCommand:Machine_GET_STATUS];
    }
    else {
        [self sendCommand:Machine_GET_STATUS];
    }
    error1 = [[NSMutableArray alloc] init];
    error2 = [[NSMutableArray alloc] init];
    [sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_INFO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentStatus:) name:@"getCurrentStatus" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [hideHUDTimer invalidate];
    hideHUDTimer = nil;
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    
    self.navigationItem.title = [[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_INFO] valueForKey:@"deviceName"];
    // Add Back Bar Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(goToPrevious)];
    
    // Add Refresh Right Bar Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Refresh"] style:UIBarButtonItemStyleDone target:self action:@selector(refreshButtonAction)];
    
    self.error1Btn.layer.borderWidth = 1.0;
    self.error1Btn.layer.borderColor = [UIColor blackColor].CGColor;
    self.error2Btn.layer.borderWidth = 1.0;
    self.error2Btn.layer.borderColor = [UIColor blackColor].CGColor;
}

#pragma mark UINavigationBar Button Action

/**
 *  go back to previous view
 */
-(void)goToPrevious {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  Refresh states according to the Machine.
 */
-(void)refreshButtonAction {
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        [globalValues.mqtt publish:[NSString stringWithFormat:@"Command/%@",[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_MAC]] withCommand:Machine_GET_STATUS];
    }
    else {
        [self sendCommand:Machine_GET_STATUS];
    }
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
    }
    else {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [customViewUtils makeErrorToast:self andLabelText:@"Please Try Again!"];
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

#pragma mark - Button Actions

- (IBAction)onOffSwitchAction:(id)sender {
    if (isMachineON) {
        [globalValues.tcpConnection performOprations:Machine_powerOFF];
    }
    else {
        [globalValues.tcpConnection performOprations:Machine_powerON];
    }
}

- (IBAction)playPauseButtonAction:(id)sender {
    
    if (isMachineStart) {
        if ([globalValues.isLocal isEqualToString:@"no"]) {
            [globalValues.mqtt publish:[NSString stringWithFormat:@"Command/%@",[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_MAC]] withCommand:Machine_PAUSE];
        }
        else {
            [self sendCommand:Machine_PAUSE];
        }
    }
    else {
        if ([globalValues.isLocal isEqualToString:@"no"]) {
            [globalValues.mqtt publish:[NSString stringWithFormat:@"Command/%@",[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_MAC]] withCommand:Machine_START];
        }
        else {
            [self sendCommand:Machine_START];
        }
    }
}

- (IBAction)changeProgram:(id)sender {
    
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        [globalValues.mqtt publish:[NSString stringWithFormat:@"Command/%@",[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_MAC]] withCommand:Machine_programChange];
    }
    else {
        [self sendCommand:Machine_programChange];
    }
}

#pragma mark - HTTP Send Commands.

-(void)sendCommand: (NSArray *)postDataArray {
    
    [byteArray removeAllObjects];
    NSString *urlString = @"http://10.0.6.209/gainspan/profile/tls?t=1470715355439";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    Byte myByteArray[16];
    for (int i = 0; i < 12; i++) {
        myByteArray[i] = strtoul([postDataArray[i] UTF8String], NULL, 16);
    }
    NSData *data = [NSData dataWithBytes:myByteArray length:postDataArray.count];
    [postData setObject:data forKey:@"Command"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Please Wait...";
    [conncetion httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        NSData *data = [result valueForKey:@"data"];
        NSUInteger len = data.length;
        uint8_t *bytes = (uint8_t *)[data bytes];
        
        for (NSUInteger i = 0; i < len; i++) {
            [byteArray addObject:[NSString stringWithFormat:@"%hhu",bytes[i]]];
        }
        if (byteArray.count > 37) {
            [self getLocalCurrentStatus:byteArray];
        }
    }];
}

#pragma mark - Handle Current state with acknowledgement.

-(void)getLocalCurrentStatus:(NSArray *)dataArray {
    
    isConnectionFail = NO;
    [error1 removeAllObjects];
    [error2 removeAllObjects];
    if (dataArray.count > 37) {
        
        if ([[dataArray objectAtIndex:2] integerValue]== 129) {
            
            if ([[dataArray objectAtIndex:5] integerValue] == 4)    // change program
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([[dataArray objectAtIndex:5] integerValue] == 3) // isPause
            {
                [self setPlayPauseButtonStatus:dataArray];
                
            }
            else if ([[dataArray objectAtIndex:5] integerValue] == 1) // isPlay
            {
                [self setPlayPauseButtonStatus:dataArray];
            }
            
            // set temprature
            self.tempTextField.text = [NSString stringWithFormat:@"%@C",[dataArray objectAtIndex:21]];
            
            // set state
            self.statusTextField.text = [commonParsing getStateString:[[dataArray objectAtIndex:30] integerValue]];
            
            // set program
            self.programLabel.text = [commonParsing getProgramString:[[dataArray objectAtIndex:6] integerValue]];
            // set play pause
            [self setPlayPauseButtonStatus:dataArray];
            // Error1
            [self getError1:dataArray];
            //Error2
            [self getError2:dataArray];
            // process time
            [self showProcessTime:dataArray];
            
        }
        else {
            // program commands
        }
    }
    else {
        // error case
    }
}

/**
 *  change state according to acknowledgement
 *
 *  @param notification notification with user info.
 */
-(void)getCurrentStatus:(NSNotification *)notification {
    
    NSArray  *dataArray = [[notification userInfo] objectForKey:@"myArray"];
    isConnectionFail = NO;
    [error1 removeAllObjects];
    [error2 removeAllObjects];
    if (dataArray.count > 37) {
        
        if ([[dataArray objectAtIndex:2] integerValue]== 129) {
            
            if ([[dataArray objectAtIndex:5] integerValue] == 4)    // change program
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([[dataArray objectAtIndex:5] integerValue] == 3) // isPause
            {
                [self setPlayPauseButtonStatus:dataArray];
                
            }
            else if ([[dataArray objectAtIndex:5] integerValue] == 1) // isPlay
            {
                [self setPlayPauseButtonStatus:dataArray];
            }
            
            // set temprature
            self.tempTextField.text = [NSString stringWithFormat:@"%@C",[dataArray objectAtIndex:21]];
            
            // set state
            self.statusTextField.text = [commonParsing getStateString:[[dataArray objectAtIndex:30] integerValue]];
            
            // set program
            self.programLabel.text = [commonParsing getProgramString:[[dataArray objectAtIndex:6] integerValue]];
            // set play pause
            [self setPlayPauseButtonStatus:dataArray];
            // Error1
            [self getError1:dataArray];
            //Error2
            [self getError2:dataArray];
            // process time
            [self showProcessTime:dataArray];
            
        }
        else {
            // program commands
        }
    }
    else {
        // error case
    }
}

-(void)getError1:(NSArray *)theArray {
    NSMutableString *alarm1 = [NSMutableString stringWithFormat:@"%@",[self decToBinary:[[theArray objectAtIndex:26] integerValue]]];
    alarm1 = [self validateBinaryValue:alarm1];
    for(int i =0 ;i<[alarm1 length]; i++) {
        char character = [alarm1 characterAtIndex:i];
        NSString *chrStr = [NSString stringWithFormat:@"%c",character];
        if ([chrStr isEqualToString:@"1"]) {
            [error1 addObject:[commonParsing getError1String:i+1]];
            //[self getError1String:i+1];
        }
    }
    [self showError1];
}

-(void)showError1 {
    if ([error1 count] > 0) {
        [self.error1Btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.error1Btn setTitle:[NSString stringWithFormat:@"%@",[error1 objectAtIndex:0]] forState:UIControlStateNormal];
    }
    else {
        [self.error1Btn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:205.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.error1Btn setTitle:@"No Alarm" forState:UIControlStateNormal];
    }
}

-(void)getError2:(NSArray *)theArray {
    NSMutableString *alarm2 = [NSMutableString stringWithFormat:@"%@",[self decToBinary:[[theArray objectAtIndex:27] integerValue]]];
    alarm2 = [self validateBinaryValue:alarm2];
    for(int i =0 ;i<[alarm2 length]; i++) {
        char character = [alarm2 characterAtIndex:i];
        NSString *chrStr = [NSString stringWithFormat:@"%c",character];
        if ([chrStr isEqualToString:@"1"]) {
            [error2 addObject:[commonParsing getError2String:i+1]];
            //[self getError1String:i+1];
        }
    }
    [self showError2];
}

-(void)showError2 {
    if ([error2 count] > 0) {
        [self.error2Btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.error2Btn setTitle:[NSString stringWithFormat:@"%@",[error2 objectAtIndex:0]] forState:UIControlStateNormal];
    }
    else {
        [self.error2Btn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:205.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.error2Btn setTitle:@"No Alarm" forState:UIControlStateNormal];
    }
}

-(void)showProcessTime: (NSArray *)theArray {
    
    // Process time
    NSMutableString *processTime = [[NSMutableString alloc] init];
    [processTime appendString:[self validateProcessTime:[NSMutableString stringWithFormat:@"%@",[theArray objectAtIndex:17]]]];
    [processTime appendString:@":"];
    [processTime appendString:[self validateProcessTime:[NSMutableString stringWithFormat:@"%@",[theArray objectAtIndex:18]]]];
    self.processTimeLabel.text = processTime;
}

-(NSMutableString *) validateProcessTime:(NSMutableString *)currentBin {
    if ([currentBin length] < 2)
    {
        long count = 2 - [currentBin length];
        for (int i=0; i< count; i++) {
            [currentBin insertString:@"0" atIndex:0];
        }
    }
    return currentBin;
}

-(NSString *)decToBinary:(NSUInteger)decInt
{
    NSString *string = @"" ;
    NSUInteger x = decInt;
    
    while (x>0) {
        string = [[NSString stringWithFormat: @"%lu", x&1] stringByAppendingString:string];
        x = x >> 1;
    }
    return string;
}

-(NSMutableString *) validateBinaryValue:(NSMutableString *)currentBin {
    if ([currentBin length] < 8)
    {
        long count = 8 - [currentBin length];
        for (int i=0; i< count; i++) {
            [currentBin insertString:@"0" atIndex:0];
        }
    }
    return currentBin;
}

#pragma mark - handle toggle button state

-(void)setONOffButtonStatus: (NSArray *)currentValue {
    if ([[currentValue objectAtIndex:30] integerValue] > 0) {
        isMachineON = YES;
    }
    else {
        isMachineON = NO;
    }
}

-(void)setPlayPauseButtonStatus: (NSArray *)currentValue {
    
    if ([[currentValue objectAtIndex:30] integerValue] == 14) {
        isMachineStart = NO;
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else if ([[currentValue objectAtIndex:30] integerValue] == 1) {
        isMachineStart = NO;
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else {
        isMachineStart = YES;
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

- (IBAction)error1BtnAction:(id)sender {
    
    if (error1.count > 0) {
        
        NSArray * arr = error1;
        NSArray * arrImage = [[NSArray alloc] init];
        if(dropDown == nil) {
            CGFloat f = 40*arr.count;
            self.view.tag = 1;
            dropDown =  [[ButtonDropDown alloc] showDropDown:self.error1Btn :&f :arr :arrImage :@"down":self];
            dropDown.delegate = self;
        }
        else {
            [dropDown hideDropDown:self.error1Btn];
            [self nilDropDown];
        }
    }
}

- (IBAction)error2BtnAction:(id)sender {
    if (error2.count > 0) {
        
        NSArray * arr = error2;
        
        NSArray * arrImage = [[NSArray alloc] init];
        if(dropDown == nil) {
            CGFloat f = 40*arr.count;
            self.view.tag = 1;
            dropDown =  [[ButtonDropDown alloc] showDropDown:self.error2Btn :&f :arr :arrImage :@"down":self];
            dropDown.delegate = self;
        }
        else {
            [dropDown hideDropDown:self.error2Btn];
            [self nilDropDown];
        }
    }
}

#pragma mark - Drop down delegate methods

- (void) niDropDownDelegateMethod: (ButtonDropDown *) sender {
    [self nilDropDown];
}

-(void)nilDropDown{
    dropDown = nil;
}

@end
