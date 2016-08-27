//
//  MenuTableViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 12/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuHeaderTableViewCell.h"
#import "MenuTableViewCell.h"

#import "AppConstant.h"
#import "APICallManager.h"
#import "Reachability.h"
#import "CustomViewUtils.h"
#import "SharedPrefrenceUtil.h"
#import "LoginViewController.h"
#import "SocketConstant.h"
#import "MySingleton.h"

@interface MenuTableViewController ()
{
    APICallManager *apiCallManager;
    CustomViewUtils *customViewUtils;
    Reachability * reachability;
    SharedPrefrenceUtil *sharedPrefrenceUtil;
}
@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    [self revealViewController].delegate = self;
    apiCallManager = [[APICallManager alloc] init];
    customViewUtils = [[CustomViewUtils alloc] init];
    reachability = [Reachability reachabilityForInternetConnection];
    sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenuTable) name:@"updateMenuTable" object:nil];
    
    [self updateMenuTable];
    //self.menuList = [NSArray arrayWithObjects:@"HOME", @"LOGOUT", nil];
}

-(void)updateMenuTable {
    
    if ([(NSString *)[sharedPrefrenceUtil getNSObject:ROLE] integerValue] == 1) {
        if ([sharedPrefrenceUtil getBoolValuesFromUserDefaults:CONNECTION_STATUS]) {
            self.menuList = [NSArray arrayWithObjects:@"HOME", @"DISCONNECT", @"ADD COMPLAINT",@"PROVISION", @"LOGOUT", nil];
        }
        else {
            self.menuList = [NSArray arrayWithObjects:@"HOME", @"CONNECT",@"ADD COMPLAINT",@"PROVISION", @"LOGOUT", nil];
        }
    }
    else if ([(NSString *)[sharedPrefrenceUtil getNSObject:ROLE] integerValue] == 3) {
        self.menuList = [NSArray arrayWithObjects:@"HOME", @"LOGOUT", nil];
    }
    else {
        self.menuList = nil;
    }
    [self.menuTableView reloadData];
}

-(void)setupUI {
    [self.navigationController setNavigationBarHidden:YES];
    self.menuTableView.tableFooterView = [[UIView alloc] init];
    self.menuTableView.backgroundColor = [UIColor colorWithRed:93.0/255.0 green:206.0/255.0 blue:244.0/255.0 alpha:1.0];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.menuTableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([self.menuTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.menuTableView.layoutMargins = UIEdgeInsetsZero;
    }
    if ([self.menuTableView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.menuTableView.preservesSuperviewLayoutMargins = NO;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuList count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        NSString *identifier = @"MenuHeaderTableViewCell";
        MenuHeaderTableViewCell *menuHeaderTableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        return menuHeaderTableViewCell;
    }
    else {
        NSString *identifier = @"MenuTableViewCell";
        MenuTableViewCell *menuTableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        menuTableViewCell.label.text = self.menuList[indexPath.row - 1];
        menuTableViewCell.tag = indexPath.row;
        return menuTableViewCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([(NSString *)[sharedPrefrenceUtil getNSObject:ROLE] integerValue] == 1) {
        
        if (indexPath.row == 0) {
            
        }
        else if (indexPath.row == 1) {
            
            UIViewController *viewController = [customViewUtils loadUserHomeView];
            [[UIApplication sharedApplication] keyWindow].rootViewController = viewController;
        }
        else if (indexPath.row == 2) {
            if ([sharedPrefrenceUtil getBoolValuesFromUserDefaults:CONNECTION_STATUS]) {
                [globalValues.tcpConnection close];
            }
            else {
                
                NSString *SSID = (NSString *)[sharedPrefrenceUtil getNSObject:CONNECTED_SSID];
                if ([SSID containsString:SSID_IDENTIFIER] && SSID != nil) {
                    [globalValues.tcpConnection connectToServer:SOCKET_LOCAL_HOST :SOCKET_LOCAL_PORT];
                }
                else {
                    [globalValues.tcpConnection connectToServer:SOCKET_SERVER_HOST :SOCKET_SERVER_PORT];
                }
            }
        }
        else if (indexPath.row == 3) {
            UIViewController *viewController = [customViewUtils addComplaint];
            [[UIApplication sharedApplication] keyWindow].rootViewController = viewController;
        }
        else if (indexPath.row == 4) {
            UIViewController *viewController = [customViewUtils startProvisioning];
            [[UIApplication sharedApplication] keyWindow].rootViewController = viewController;
        }
        else if (indexPath.row == 5) {
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self doLogout];
            }];
            [customViewUtils makeAlertView:@"Confirm Logout" :@"Are you sure to do Logout?" viewForAlertView:self.navigationController :confirmAction];
        }
    }
    else if ([(NSString *)[sharedPrefrenceUtil getNSObject:ROLE] integerValue] == 3) {
        if (indexPath.row == 0) {
            
        }
        else if (indexPath.row == 1) {
            
            UIViewController *viewController = [customViewUtils loadTechnichianHomeView];
            [[UIApplication sharedApplication] keyWindow].rootViewController = viewController;
        }
        else if (indexPath.row == 2) {
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self doLogout];
            }];
            [customViewUtils makeAlertView:@"Confirm Logout" :@"Are you sure to do Logout?" viewForAlertView:self.navigationController :confirmAction];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return 73;
    }
    return 50;
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
    
    /// Making selection effect on the menu.
    UIView *selectedCellBgView = [[UIView alloc] init];
    selectedCellBgView.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    cell.selectedBackgroundView = selectedCellBgView;
}

-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    
    if (position == FrontViewPositionRight)   // Menu will get revealed
    {
        [[self revealViewController] frontViewController].view.userInteractionEnabled = YES;
        [[[self revealViewController] frontViewController].view addGestureRecognizer:[self revealViewController].tapGestureRecognizer];
    }
    else if (position == FrontViewPositionLeft)    // Menu will close
    {
        [[self revealViewController] frontViewController].view.userInteractionEnabled = YES;
        [[[self revealViewController] frontViewController].view removeGestureRecognizer:[self revealViewController].tapGestureRecognizer];
    }
}


-(void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    
    
    if (position == FrontViewPositionRight)   // Menu will get revealed
    {
        [[self revealViewController] frontViewController].view.userInteractionEnabled = YES;
        [[[self revealViewController] frontViewController].view addGestureRecognizer:[self revealViewController].tapGestureRecognizer];
    }
    else if (position == FrontViewPositionLeft)    // Menu will close
    {
        [[self revealViewController] frontViewController].view.userInteractionEnabled = YES;
        [[[self revealViewController] frontViewController].view removeGestureRecognizer:[self revealViewController].tapGestureRecognizer];
    }
}

-(void)doLogout {
    if(reachability.isReachable) {
        NSString *urlString = @"http://52.32.88.197/logout?app_token=1";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        progressHud.labelText = @"Please Wait....";
        progressHud.dimBackground = YES;
        [apiCallManager httpGetRequest:request resultCallBack:^(NSDictionary *result, NSString *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            NSLog(@"result is %@", result);
            if ([[result valueForKey: @"status"] boolValue]) {
                
                [sharedPrefrenceUtil removeObject:USER_ID];
                LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
                UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [[UIApplication sharedApplication] keyWindow].rootViewController = loginNavigationController;
                [globalValues.tcpConnection close];
            }
            else {
                [customViewUtils makeErrorToast:self andLabelText:@"Something went wrong! "];
            }
        }];
    }
    else {
        [customViewUtils makeErrorToast:self andLabelText:@"No Internet"];
    }
    
}
@end
