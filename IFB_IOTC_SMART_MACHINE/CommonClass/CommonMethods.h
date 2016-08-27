//
//  CommonMethods.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 09/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>

@interface CommonMethods : NSObject

/**
 *  @brief  validates the format of the email
 *
 *  @param email email string to be validated
 *
 *  @return bool variable, YES if valid otherwise NO
 */
+ (BOOL)isEmailValid:(NSString *)email;

/**
 *  @brief  validates the phone number
 *
 *  @param phoneNo phone number string to be validated
 *
 *  @return bool variable, YES if valid otherwise NO
 */
+ (BOOL)isValidPhoneNumber:(NSString *)phoneNo;

/**
 *  @brief  validates the passsword (should be minimum of 8 characters)
 *
 *  @param pswd password string to be validated
 *
 *  @return bool variable, YES if valid otherwise NO
 */
+ (BOOL)isValidPassword:(NSString *)pswd;

/**
 *  @brief  checks if the textfield is empty or not
 *
 *  @param textfield textfield to be validated
 *
 *  @return bool variable, YES if valid otherwise NO
 */
+ (BOOL)textFieldBlankorNot:(UITextField *)textfield;

/**
 *  @brief  displays the alert
 *
 *  @param title       title of the alert
 *  @param message_str message of the alert
 */
+ (void)show:(NSString *)title message:(NSString *)message_str;



@end
