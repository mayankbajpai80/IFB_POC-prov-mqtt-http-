//
//  MachineListViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 10/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "DeviceListViewController.h"
#import "SWRevealViewController.h"
#import "DeviceListTableViewCell.h"
#import "ProgramsViewController.h"
#import "AddDeviceViewController.h"
#import "AppConstant.h"
#import "APICallManager.h"
#import "Reachability.h"
#import "CustomViewUtils.h"
#import "SharedPrefrenceUtil.h"
#import "LoginViewController.h"
#import "SocketConstant.h"
#import "MySingleton.h"
#import "CustomViewUtils.h"
#import "AppUtils.h"
#import "MQTTViewController.h"

@interface DeviceListViewController ()
{
    NSArray *deviceListArray; // array of machines details.
    NSArray *deviceNameArray;
    NSArray *deviceSerialNoArray;
    NSArray *deviceMacArray;
    NSArray *deviceStatusArray;
    NSArray *deviceIdArray;
    APICallManager *apiCallManager;
    CustomViewUtils *customViewUtils;
    Reachability * reachability;
    SharedPrefrenceUtil *sharedPrefrenceUtil;
    AppUtils *appUtils;
    MQTTViewController *mqtt;
    GS_ADK_ServiceManager *m_gObjServiceManager;
    NSMutableDictionary *mdnsServiceDataDict;
    NSMutableArray *onlineMACs;
    NSMutableArray *onlineDevices;
}
@end

@implementation DeviceListViewController

#pragma mark - view controller life cycle

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.deviceListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.deviceListTableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([self.deviceListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.deviceListTableView.layoutMargins = UIEdgeInsetsZero;
    }
    if ([self.deviceListTableView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.deviceListTableView.preservesSuperviewLayoutMargins = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiCallManager = [[APICallManager alloc] init];
    customViewUtils = [[CustomViewUtils alloc] init];
    reachability = [Reachability reachabilityForInternetConnection];
    sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
    customViewUtils = [[CustomViewUtils alloc] init];
    // establish CLoud MQTT connection
    mqtt = [[MQTTViewController alloc] init];
    globalValues.mqtt = mqtt;
    // Local mdns service
    onlineMACs = [[NSMutableArray alloc] init];
    onlineDevices = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUI];
    // Pull to refresh code
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        [self getDeviceList];
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [self.deviceListTableView addSubview:refreshControl];
    }
    else {
        m_gObjServiceManager = [[GS_ADK_ServiceManager alloc] initWithTimeOut:0 namePattern:[NSArray arrayWithObjects:@"gslink_prov",@"prov",@"Prov",nil] textRecordPattern:[NSArray arrayWithObjects:@"gs_sys_prov",nil] serviceType:@"_http._tcp" domainName:@""];
        
        [m_gObjServiceManager setM_cObjDelegate:self];
        [m_gObjServiceManager startDiscovery];
        [self establishLocalSocketConnection];
    }
}

-(void)didUpdateSeriveInfo:(NSMutableDictionary *)pObjServiceInfo {
    
    NSLog(@"pObjServiceInfo = %@",pObjServiceInfo);
    
    if ([pObjServiceInfo isKindOfClass:[NSMutableDictionary class]]) {
        
        if([[pObjServiceInfo allKeys] count]>0)
        {
            
            NSString *serviceMAC = [[[[[[pObjServiceInfo allKeys] objectAtIndex:0] componentsSeparatedByString:@"_"] objectAtIndex:2] componentsSeparatedByString:@"-"] objectAtIndex:1];
            NSMutableString *macString = [[NSMutableString alloc] initWithString:@"20:f8:5e"];
            for (int i =0; i < serviceMAC.length; i++) {
                if (i%2 == 0) {
                    [macString appendString:[NSString stringWithFormat:@":%c",[serviceMAC characterAtIndex:i]]];
                }
                else {
                    [macString appendString:[NSString stringWithFormat:@"%c",[serviceMAC characterAtIndex:i]]];
                }
            }
            
            if (![onlineMACs containsObject:macString]) {
                [onlineDevices addObject:[pObjServiceInfo valueForKey:[[pObjServiceInfo allKeys] objectAtIndex:0]]];
                [onlineMACs addObject:macString];
                NSLog(@"\nSevice Found:%@\nWith MAC:%@", [pObjServiceInfo allKeys],macString);
                [self.deviceListTableView reloadData];
            }
            
            //NSString *serviceName = [NSString stringWithString:[mdnsServiceDataDict allKeys]];
            
            //NSString *hostName = [NSString stringWithString:[[mdnsServiceDataDict allKeys] valueForKey:@"hostName"]];
            
            //NSString *ipAddress = [NSString stringWithString:[[mdnsServiceDataDict allKeys] valueForKey:@"ipAddress"]];
            
        }
        else {
            NSLog(@"Sevice Fail...");
        }
    }
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Machine List";
    self.deviceListTableView.tableFooterView = [[UIView alloc] init];
    
    // Add Left MenuBar Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:[self revealViewController] action:@selector(revealToggle:)];
    [self.view addGestureRecognizer:[self revealViewController].panGestureRecognizer];
    
    // Add Right Bar Button
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Refresh"] style:UIBarButtonItemStyleDone target:self action:@selector(refreshButtonAction)];
    }
}

#pragma mark UINavigationBar Button Action

-(void)refreshButtonAction {
    [self getDeviceList];
}

#pragma mark - Get List of devices
/**
 *  Get List of devices
 */
-(void)getDeviceList {
    if(reachability.isReachable) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,GET_DEVICE_LIST_API];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:[sharedPrefrenceUtil getNSObject:USER_ID] forKey:@"userId"];
        [postData setObject:@"1" forKey:@"app_token"];
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        progressHud.dimBackground = YES;
        progressHud.labelText = @"Please Wait....";
        [apiCallManager httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            NSLog(@"result is %@", result);
            if ([[result valueForKey: @"status"] boolValue]) {
                // connect mqtt/cloud...
                [mqtt connectMQTT];
                deviceListArray = [result valueForKey:@"message"];
                [sharedPrefrenceUtil saveNSObject:deviceListArray forKey:DEVICE_LIST];
                deviceNameArray = [deviceListArray valueForKey:@"deviceName"];
                deviceIdArray = [deviceListArray valueForKey:@"_id"];
                deviceSerialNoArray = [deviceListArray valueForKey:@"serial"];
                deviceMacArray = [deviceListArray valueForKey:@"mac"];
                deviceStatusArray = [deviceListArray valueForKey:@"status"];
                [self.deviceListTableView reloadData];
                NSLog(@"%@", deviceMacArray);
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

-(void)establishLocalSocketConnection {
    // start scan for mdns service..
    deviceListArray = (NSArray *)[sharedPrefrenceUtil getNSObject:DEVICE_LIST];
    deviceNameArray = [deviceListArray valueForKey:@"deviceName"];
    deviceIdArray = [deviceListArray valueForKey:@"_id"];
    deviceSerialNoArray = [deviceListArray valueForKey:@"serial"];
    deviceMacArray = [deviceListArray valueForKey:@"mac"];
    deviceStatusArray = [deviceListArray valueForKey:@"status"];
    [self.deviceListTableView reloadData];
}

#pragma mark - UITableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [deviceListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceListTableViewCell *cell;
    NSString *identifier = @"DeviceListTableViewCell";
    if (cell == nil) {
        cell = [self.deviceListTableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.deviceStatus.layer.cornerRadius = cell.deviceStatus.frame.size.height/2;
    cell.deviceName.text = [deviceNameArray objectAtIndex:indexPath.row];
    
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        
        if ([[deviceStatusArray objectAtIndex:indexPath.row] isEqualToString: @"Disconnected"]) {
            cell.deviceStatus.backgroundColor = [UIColor redColor];
        }
        else {
            cell.deviceStatus.backgroundColor = [UIColor greenColor];
        }
    }
    else {
        NSLog(@"%@",onlineMACs);
        NSLog(@"%@",deviceMacArray);
        if ([onlineMACs containsObject:[deviceMacArray objectAtIndex:indexPath.row]]) {
            cell.deviceStatus.backgroundColor = [UIColor greenColor];
        }
        else {
            cell.deviceStatus.backgroundColor = [UIColor redColor];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        // subscribe for device.
        [sharedPrefrenceUtil saveNSObject:[deviceMacArray objectAtIndex:indexPath.row] forKey:@"currentDeviceMac"];
        NSString *subscribeTopic = [NSString stringWithFormat:@"Response/%@", [deviceMacArray objectAtIndex:indexPath.row ]];
        [globalValues.mqtt subscribeForTopic:subscribeTopic];
    }
    else {
        // get ip address of selected device and ping that device.
    }
    [self enterInDevice:indexPath];
}

-(void)enterInDevice: (NSIndexPath *)indexPath {
    
    ProgramsViewController *programVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProgramsViewController"];
    [sharedPrefrenceUtil saveNSObject:[deviceListArray objectAtIndex:indexPath.row] forKey:SELECTED_DEVICE_INFO];
    programVC.deviceInfo = [deviceListArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:programVC animated:YES];
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

#pragma mark - PULL to refresh
/**
 *  called In case of PULL to refresh
 *
 *  @param refreshControl refresh
 */
-(void)refresh: (UIRefreshControl *)refreshControl{
    [self getDeviceList];
    [refreshControl endRefreshing];
}

@end
