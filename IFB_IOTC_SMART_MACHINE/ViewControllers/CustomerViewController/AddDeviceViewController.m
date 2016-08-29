//
//  AddDeviceViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 12/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "Reachability.h"
#import "AppConstant.h"
#import "MBProgressHUD.h"
#import "APICallManager.h"
#import "CustomViewUtils.h"

@interface AddDeviceViewController ()
{
    APICallManager *apiCallManager;
    CustomViewUtils *customViewUtils;
    Reachability * reachability;
}
@end

@implementation AddDeviceViewController

#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    apiCallManager = [[APICallManager alloc] init];
    customViewUtils = [[CustomViewUtils alloc] init];
    reachability = [Reachability reachabilityForInternetConnection];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [self setUI];
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    self.navigationItem.title = @"Add Device";
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(goToPrevious)];
    self.navigationItem.leftBarButtonItem = barBtnItem;
}

#pragma mark - UINavigationItem Button Action
/**
 *  go back to previous view
 */
-(void)goToPrevious {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Button Actions
- (IBAction)addDeviceButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self addDevice];
}

/**
 *  Add New Device.
 */
-(void)addDevice {
    if(reachability.isReachable) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,ADD_DEVICE_API];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    
        [postData setObject:self.deviceNameTextField.text forKey:@"deviceName"];
        [postData setObject:self.deviceSerialNoTextfield.text forKey:@"serial"];
        [postData setObject:self.deviceMacAddressTextfield.text forKey:@"mac"];
        [postData setObject:@"1" forKey:@"app_token"];
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        progressHud.labelText = @"Please Wait....";
        [apiCallManager httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            NSLog(@"result is %@", result);
            bool isStatus = [result valueForKey:@"status"];
            if (isStatus) {

                [customViewUtils makeSuccessToast:self andLabelText:[result valueForKey:@"message"]];
            }
            else {
                [customViewUtils makeErrorToast:self andLabelText:[result valueForKey:@"message"]];
            }
        }];
    }
    else {
        [customViewUtils makeErrorToast:self andLabelText:@"No Internet"];
    }
}
#pragma mark - UITextfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.deviceNameTextField) {
        [self.deviceSerialNoTextfield becomeFirstResponder];
    }
    else if (textField == self.deviceSerialNoTextfield) {
        [self.deviceMacAddressTextfield becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}
@end
