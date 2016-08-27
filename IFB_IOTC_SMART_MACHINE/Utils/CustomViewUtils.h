//
//  CustomViewUtils.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 09/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface CustomViewUtils : UIView

/**
 *  Customize Navigation Bar i.e. Bar_items, bar color.
 */
-(void)makeCustomNavigationView;

/**
 *  Show error/warning with message.
 *
 *  @param viewcontroller visible view controller.
 *  @param labelText      error/warning message.
 */
-(void)makeErrorToast :(UIViewController *)viewcontroller andLabelText:(NSString *)labelText;

/**
 *  Show success message
 *
 *  @param viewcontroller visible view controller.
 *  @param labelText      success message.
 */
-(void)makeSuccessToast :(UIViewController *)viewcontroller andLabelText:(NSString *)labelText;

/**
 *  Show Alert.
 *
 *  @param title   alert title
 *  @param message alert message
 *  @param view    visible view controller.
 */
-(void)makeAlertView:(NSString *)title :(NSString *)message viewForAlertView:(UIViewController *)view :(UIAlertAction *)okAction;

/**
 *  Get User Home View controller.
 *
 *  @return return user Home view conreoller object.
 */
-(UIViewController *)loadUserHomeView;

/**
 *  Get Login View.
 *
 *  @return return NavigationController with Login View.
 */
-(UINavigationController *)loadFirstView;


/**
 *  Get Technichian Home View.
 *
 *  @return return Technichian Home view conreoller object.
 */
-(UIViewController *)loadTechnichianHomeView;

/**
 *  Get User Complaint View controller.
 *
 *  @return return user Home view conreoller object.
 */
-(UIViewController *)addComplaint;

/**
 *  Get User Provisioning View controller.
 *
 *  @return return user Home view conreoller object.
 */
-(UIViewController *)startProvisioning;
@end
