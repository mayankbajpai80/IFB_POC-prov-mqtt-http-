//
//  ViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 09/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomViewUtils.h"
#import "AppConstant.h"
#import "APICallManager.h"
#import "Reachability.h"
#import "SharedPrefrenceUtil.h"
#import "SWRevealViewController.h"
#import "CommonMethods.h"
#import "AppUtils.h"
#import "MySingleton.h"

@interface LoginViewController ()
{
    APICallManager *apiCallManager;
    CustomViewUtils *customViewUtils;
    Reachability * reachability;
    SharedPrefrenceUtil *sharedPrefrenceUtil;
    CommonMethods *commonMethods;
    AppUtils *appUtils;
}
@end

@implementation LoginViewController

#pragma mark - view controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    apiCallManager = [[APICallManager alloc] init];
    customViewUtils = [[CustomViewUtils alloc] init];
    sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
    reachability = [Reachability reachabilityForInternetConnection];
    commonMethods = [[CommonMethods alloc] init];
    appUtils = [[AppUtils alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUI];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Customize Navigation Bar
/**
 *  Customize Navigation Bar
 */
-(void)setUI {
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - Button Actions
/**
 *  Login Button Pressed
 *
 *  @param sender sender
 */
- (IBAction)loginAction:(id)sender {
    
    globalValues.isLocal = @"no";
    [self.view endEditing:YES];
    if (self.emailTextField.text != nil || self.passwordTextField.text != nil) {
        [self doLogin];
    }
    else {
        [customViewUtils makeErrorToast:self andLabelText:@"Fields can not be blank"];
    }
}

- (IBAction)goOffline:(id)sender {
    
    globalValues.isLocal = @"yes";
    UIViewController *viewController = [customViewUtils loadUserHomeView];
    [[UIApplication sharedApplication] keyWindow].rootViewController = viewController;
}

#pragma mark - Login Actions
/**
 *  Validate user - username and password.
 */
-(void)doLogin {
    if(reachability.isReachable) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_API];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:self.emailTextField.text forKey:@"email"];
        
        [postData setObject:self.passwordTextField.text forKey:@"password"];
        [postData setObject:@"1" forKey:@"app_token"];
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        progressHud.labelText = @"Please Wait....";
        [apiCallManager httpPostRequest:request forPostData:postData resultCallBack:^(NSDictionary *result, NSString *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            NSLog(@"result is %@", result);
            if ([[result valueForKey: @"status"] boolValue]) {
                
                //NSDictionary *userProfile = [[result objectForKey:@"message"] objectForKey:@"profile"];
                NSString *userId = [[result objectForKey:@"message"] objectForKey:@"userId"];
                [sharedPrefrenceUtil saveNSObject:userId forKey:USER_ID];
                NSString *role = [[result objectForKey:@"message"] objectForKey:@"role"];
                [sharedPrefrenceUtil saveNSObject:role forKey:ROLE];
                if ([role integerValue] == 1) {

                    UIViewController *viewController = [customViewUtils loadUserHomeView];
                    [[UIApplication sharedApplication] keyWindow].rootViewController = viewController;
                }
                else {
                    UIViewController *viewController = [customViewUtils loadTechnichianHomeView];
                    [[UIApplication sharedApplication] keyWindow].rootViewController = viewController;
                }
                NSArray *coockie = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
                [sharedPrefrenceUtil saveNSObject:coockie forKey:SAVED_COOKIES];
                [sharedPrefrenceUtil saveNSObject:[result valueForKey: @"user_token"] forKey:AUTH_TOKEN];
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

#pragma mark - UITextfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}


- (IBAction)hideTextfields:(id)sender {
    [self.view endEditing:YES];
}
@end
