//
//  CommonMethods.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 09/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods

#pragma mark validation method


+ (BOOL)isEmailValid:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)textFieldBlankorNot:(UITextField *)textfield
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [[textfield text] stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0)
    return YES;
    else
    return NO;
}

+ (BOOL)isValidPassword:(NSString *)pswd
{
    if (pswd.length < 8)
        return FALSE;
    else
        return TRUE;
}

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNo
{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:phoneNo] == YES)
    return TRUE;
    else
    return FALSE;
}


#pragma mark Alertview methods

+ (void)show:(NSString *)title message:(NSString *)message_str
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message_str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alert addAction:cancel];
    
    
    //[self presentViewController:alert animated:YES completion:nil];
}

@end
