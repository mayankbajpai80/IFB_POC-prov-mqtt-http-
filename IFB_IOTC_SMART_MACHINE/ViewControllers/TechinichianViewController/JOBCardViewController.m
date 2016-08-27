//
//  JOBCardViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 11/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "JOBCardViewController.h"
#import "SWRevealViewController.h"
#import "JobCardTableViewCell.h"
#import "MBProgressHUD.h"
#import "AppConstant.h"
#import "APICallManager.h"
#import "JOBDetailViewController.h"
#import "CustomViewUtils.h"
#import "Reachability.h"

@interface JOBCardViewController ()
{
    NSArray *jobCardArray;
    APICallManager *apiCallManager;
    CustomViewUtils *customViewUtils;
    Reachability * reachability;
}
@end

@implementation JOBCardViewController

#pragma mark - view controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiCallManager = [[APICallManager alloc] init];
    customViewUtils = [[CustomViewUtils alloc] init];
    reachability = [Reachability reachabilityForInternetConnection];
    [self getJOBList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUI];
}

-(void)viewWillDisappear:(BOOL)animated {
    //    jobCardArray = nil;
    //    [self.jobCardTableView reloadData];
}
#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    
    // Add Right Menu Bar
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Job Card";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:[self revealViewController] action:@selector(revealToggle:)];
    [self.view addGestureRecognizer:[self revealViewController].panGestureRecognizer];
    
    // Refresh Bar button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Refresh"] style:UIBarButtonItemStyleDone target:self action:@selector(getJOBList)];
}

#pragma mark - UITableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [jobCardArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobCardTableViewCell *cell;
    NSString *identifier = @"JobCardTableViewCell";
    if (cell == nil) {
        cell = [self.jobCardTableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.label.text = [NSString stringWithFormat:@"Job Card %ld",indexPath.row+1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JOBDetailViewController *jobCardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JOBDetailViewController"];
    jobCardVC.JOBInfo = [jobCardArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:jobCardVC animated:YES];
}

#pragma mark - Get List of devices


/**
 *  Get List of devices
 */

-(void)getJOBList {
    if(reachability.isReachable) {
        NSString *urlString = [NSString stringWithFormat:@"http://10.0.5.85:3000/%@",GET_TECHNICHAIN_JOB_LIST_API];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        progressHud.labelText = @"Please Wait....";
        progressHud.dimBackground = YES;
        [apiCallManager httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
            
            
            if ([[result valueForKey: @"status"] boolValue]) {
                //[customViewUtils makeSuccessToast:self andLabelText:[result valueForKey: @"message"]];
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                NSLog(@"result is %@", [result valueForKey:@"message"]);
                NSArray *jobArray = [result valueForKey:@"message"];
                jobCardArray = [NSArray arrayWithArray:jobArray];
                [self.jobCardTableView reloadData];
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

/*
-(void)getJOBList {
    
    NSString *urlString = @"http://192.168.52.124:8000/sap/opu/odata/sap/ZUI002_SRV/Headers?$format=json";
    
    NSString *authStr = [NSString stringWithFormat:@"hiarpit:Arpit@12345"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHud.labelText = @"Please Wait....";
    [apiCallManager httpGetRequest:request resultCallBack:^(NSDictionary *result, NSString *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        NSLog(@"result is %@", [[result valueForKey:@"d"] valueForKey:@"results"]);
        NSArray *jobArray = [[result valueForKey:@"d"] valueForKey:@"results"];
        jobCardArray = [NSArray arrayWithArray:jobArray];
        [self.jobCardTableView reloadData];
    }];
}
*/

@end
