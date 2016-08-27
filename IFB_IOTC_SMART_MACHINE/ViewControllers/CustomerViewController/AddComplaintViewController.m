//
//  AddComplaintViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 19/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "AddComplaintViewController.h"
#import "SWRevealViewController.h"
#import "AppConstant.h"
#import "SharedPrefrenceUtil.h"
#import "MBProgressHUD.h"
#import "APICallManager.h"
#import "AppConstant.h"
#import "CustomViewUtils.h"
#import "Reachability.h"

@interface AddComplaintViewController ()
{
    APICallManager *apiCallManager;
    CustomViewUtils *customViewUtils;
    Reachability * reachability;
    NSString *csrfToken;
}
@end

@implementation AddComplaintViewController

#pragma mark - view controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiCallManager = [[APICallManager alloc] init];
    customViewUtils = [[CustomViewUtils alloc] init];
    reachability = [Reachability reachabilityForInternetConnection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUI];
    // Pull to refresh code
    //[self getCSRFToken];
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Add Complaint";
    // Add Left MenuBar Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:[self revealViewController] action:@selector(revealToggle:)];
    [self.view addGestureRecognizer:[self revealViewController].panGestureRecognizer];
    
}
- (IBAction)selectMachine:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    SharedPrefrenceUtil *sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[sharedPrefrenceUtil getNSObject:DEVICE_LIST]];
    NSArray *devicesArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *deviceNameArray = [[NSMutableArray alloc] init];
    for (int i= 0; i<devicesArray.count; i++) {
        [deviceNameArray addObject:[[devicesArray objectAtIndex:i] valueForKey:@"deviceName"]];
    }
    
    NSArray * arrImage = [[NSArray alloc] init];
    arr = deviceNameArray;
    if(dropDown == nil) {
        CGFloat f = 40*arr.count;
        self.view.tag = 1;
        dropDown =  [[ButtonDropDown alloc] showDropDown:self.selectDevice :&f :arr :arrImage :@"down":self];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:self.selectDevice];
        [self nilDropDown];
    }
}

#pragma mark - Drop down delegate methods

- (void) niDropDownDelegateMethod: (ButtonDropDown *) sender {
    [self nilDropDown];
}

-(void)nilDropDown{
    dropDown = nil;
}


/**
 *  Get List of devices
 */
/*
-(void)getCSRFToken {
    
    NSString *urlString = @"http://192.168.52.124:8000/sap/opu/odata/sap/ZIOT_POC_SRV/CustomerSet";
    
    NSString *authStr = [NSString stringWithFormat:@"hiarpit:Arpit@12345"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"Fetch" forHTTPHeaderField:@"x-csrf-token"];
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHud.labelText = @"Please Wait....";
    
    [apiCallManager GetCSRFTokenRequest:request resultCallBack:^(NSDictionary *result, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        if (result != nil) {
            NSLog(@"csrf token is %@", [result valueForKey:@"x-csrf-token"]);
            csrfToken = [result valueForKey:@"x-csrf-token"];
        }
        else {
            [customViewUtils makeErrorToast:self andLabelText:@"Something went wrong! "];
        }
    }];
    
}

-(void)sendComplaint {
    if(reachability.isReachable) {
        NSString *urlString = @"http://192.168.52.124:8000/sap/opu/odata/sap/ZIOT_POC_SRV/CustomerSet";
        
        NSString *authStr = [NSString stringWithFormat:@"hiarpit:Arpit@12345"];
        NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        [request setValue:csrfToken forHTTPHeaderField:@"x-csrf-token"];
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        
       
        [postData setObject:@"1" forKey:@"CustId"];
        [postData setObject:@"23456789" forKey:@"SerialNo"];
        [postData setObject:self.problemDescriptionTextView.text forKey:@"ProblemDes"];
        
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        progressHud.labelText = @"Please Wait....";
        [apiCallManager httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            NSLog(@"result is %@", result);
            if (result != nil) {
                [customViewUtils makeSuccessToast:self andLabelText:@"Complaint Added Successfull"];
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
*/

-(void)sendComplaint {
    if(reachability.isReachable) {
        NSString *urlString = [NSString stringWithFormat:@"http://10.0.5.85:3000/%@",ADD_SAP_COMPLAINT_API];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:@"1" forKey:@"CustId"];
        [postData setObject:@"23456789" forKey:@"SerialNo"];
        [postData setObject:self.problemDescriptionTextView.text forKey:@"ProblemDes"];
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        progressHud.labelText = @"Please Wait....";
        progressHud.dimBackground = YES;
        [apiCallManager httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            NSLog(@"result is %@", result);
            if ([[result valueForKey: @"status"] boolValue]) {
                [customViewUtils makeSuccessToast:self andLabelText:@"Complaint send successfull."];
                self.complaintIDLbl.text = [NSString stringWithFormat:@"Complaint id :%@",[[result valueForKey: @"message"] valueForKey:@"orderId"]];
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

- (IBAction)sendComplaint:(id)sender {
    self.complaintIDLbl.text = @"";
    [self sendComplaint];
}

#pragma mark - Text View delegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)hideKeyboardOnTap:(id)sender {
    [self.view endEditing:YES];
}
@end
