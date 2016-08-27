//
//  CustomViewUtils.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 09/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "CustomViewUtils.h"
#import "LoginViewController.h"
#import "SWRevealViewController.h"

@implementation CustomViewUtils
{
    UIViewController *returnVC;
}

-(void)makeCustomNavigationView {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:93.0/255.0 green:206.0/255.0 blue:244.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:YES];
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Thonburi-Bold" size:18.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor]
                               };
    [[UINavigationBar appearance] setTitleTextAttributes:attrDict];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-360, -60) forBarMetrics:UIBarMetricsDefault];
}

-(void)makeErrorToast:(UIViewController *)viewcontroller andLabelText:(NSString *)labelText {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:viewcontroller.view animated:YES];
    progressHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x_mark"]];
    progressHud.mode = MBProgressHUDModeCustomView;
    progressHud.detailsLabelText = labelText;
    [self performSelector:@selector(hideToast:) withObject:viewcontroller.view afterDelay:1.0];
}

-(void)makeSuccessToast :(UIViewController *)viewcontroller andLabelText:(NSString *)labelText {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:viewcontroller.view animated:YES];
    progressHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
    progressHud.mode = MBProgressHUDModeCustomView;
    progressHud.detailsLabelText = labelText;
    [self performSelector:@selector(hideToast:) withObject:viewcontroller.view afterDelay:1.0];
}

-(void)hideToast: (UIView *)view {
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

-(void)makeAlertView:(NSString *)title :(NSString *)message viewForAlertView:(UIViewController *)view :(UIAlertAction *)okAction {
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:nil];
        if (okAction != nil) {
            [alert addAction:okAction];
        }
        [alert addAction:cancel];
        
        
        [view presentViewController:alert animated:YES completion:nil];
    });

    
}

-(UIViewController *)loadUserHomeView {
    
    return [self makeViewWithMenuBar:@"DeviceListViewController"];;
}

-(UIViewController *)loadTechnichianHomeView {
    
    return [self makeViewWithMenuBar:@"JOBCardViewController"];
}

-(UINavigationController *)loadFirstView {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    return navigationController;
}

-(UIViewController *)addComplaint {
    return [self makeViewWithMenuBar:@"AddComplaintViewController"];
}

-(UIViewController *)startProvisioning {
    return [self makeViewWithMenuBar:@"StartProvisioningViewController"];
}

-(UIViewController *)makeViewWithMenuBar:(NSString *)VCIdentifier {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *menuController = [sb instantiateViewControllerWithIdentifier:@"MenuTableViewController"];
    
    UIViewController *jobCardListVC = [sb instantiateViewControllerWithIdentifier:VCIdentifier];
    
    UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:menuController];
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:jobCardListVC];
    returnVC = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    returnVC = [[SWRevealViewController alloc] initWithRearViewController:menuNavigationController frontViewController:secondNavigationController];
    return returnVC;
}

@end
