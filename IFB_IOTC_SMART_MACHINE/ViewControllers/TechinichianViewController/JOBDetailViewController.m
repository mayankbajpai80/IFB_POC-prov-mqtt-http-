//
//  JOBDetailViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 19/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "JOBDetailViewController.h"
#import "SharedPrefrenceUtil.h"
#import "AppConstant.h"
#import "APICallManager.h"
#import "AppConstant.h"
#import "CustomViewUtils.h"
#import "Reachability.h"

@interface JOBDetailViewController ()
{
    APICallManager *apiCallManager;
    CustomViewUtils *customViewUtils;
    Reachability * reachability;
    NSString *csrfToken;
}
@end

@implementation JOBDetailViewController

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
    [self.JOBDetailScrollView setContentSize:CGSizeMake(self.mainView.frame.size.width, self.mainView.frame.size.height*1.5)];
    [self setUI];
    //[self getCSRFToken];
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    self.navigationItem.title = @"JOB Details";
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(goToPrevious)];
    self.navigationItem.leftBarButtonItem = barBtnItem;
    [self setValues];
}

#pragma mark - UINavigationItem Button Action
/**
 *  go back to previous view
 */
-(void)goToPrevious {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setValues {
    self.orderIDTextfield.text = [self.JOBInfo valueForKey:@"OrderId"];;
    self.productID.text = [self.JOBInfo valueForKey:@"ProductId"];
    self.productStatus.text = [self.JOBInfo valueForKey:@"MachineStatus"];;
    self.modelName.text = [self.JOBInfo valueForKey:@"ModelName"];;
    self.customerName.text = [self.JOBInfo valueForKey:@"CustomerName"];;
    self.customerEmail.text = [self.JOBInfo valueForKey:@"CustomerEmail"];;
    self.customerAddress.text = [self.JOBInfo valueForKey:@"CustomerAddress"];;
    self.customerPhoneNo.text = [self.JOBInfo valueForKey:@"CustomerTelephone"];;
    
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
        dropDown =  [[ButtonDropDown alloc] showDropDown:self.selectMachine :&f :arr :arrImage :@"down":self];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:self.selectMachine];
        [self nilDropDown];
    }
}

- (IBAction)sendButtonPerssed:(id)sender {
    [self processRequest];
}

-(void)processRequest {
    
    if(reachability.isReachable) {
        NSString *urlString = [NSString stringWithFormat:@"http://10.0.5.85:3000/%@",TECHNICHIAN_STATUS_UPDATE_API];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        NSArray *postDataArray = [NSArray arrayWithObjects:@"0x63", @"0x13", @"0x03", @"0x00", @"0x01", @"0x03", @"0x00", @"0x03", @"0xE8", @"0x28", @"0x00", @"0x00", @"0x00", @"0x00", @"0x01", @"0x00", @"0x00", @"0x00", @"0x00", @"0x91", @"0x22", nil];
        [postData setObject:postData forKey:@"OrderId"];
        [postData setObject:@"Closed" forKey:@"Status"];
        [postData setObject:self.feedBackTextView.text forKey:@"Notes"];
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        progressHud.labelText = @"Please Wait....";
        [apiCallManager httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            NSLog(@"result is %@", result);
            if ([[result valueForKey: @"status"] boolValue]) {
                [customViewUtils makeSuccessToast:self andLabelText:[result valueForKey: @"message"]];
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

#pragma mark - Drop down delegate methods

- (void) niDropDownDelegateMethod: (ButtonDropDown *) sender {
    [self nilDropDown];
}

-(void)nilDropDown{
    dropDown = nil;
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
 */


/*
 -(void)processRequest {
 if(reachability.isReachable) {
 NSString *urlString = @"http://192.168.52.124:8000/sap/opu/odata/sap/ZIOT_POC_SRV/TechnicianUpdateSet";
 
 NSString *authStr = [NSString stringWithFormat:@"hiarpit:Arpit@12345"];
 NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
 NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
 [request setValue:authValue forHTTPHeaderField:@"Authorization"];
 [request setValue:csrfToken forHTTPHeaderField:@"x-csrf-token"];
 NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
 
 [postData setObject:@"100000" forKey:@"OrderId"];
 [postData setObject:@"Closed" forKey:@"Status"];
 [postData setObject:self.feedBackTextView.text forKey:@"Notes"];
 MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
 progressHud.labelText = @"Please Wait....";
 [apiCallManager httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
 
 [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
 NSLog(@"result is %@", result);
 if (result != nil) {
 [customViewUtils makeSuccessToast:self andLabelText:@"Updation Successfull"];
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
@end
