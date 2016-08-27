//
//  CredentialView.h
//  CustomAlertView
//
//  Created by GainSpan India on 16/09/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CredentialView : UIView <UITextFieldDelegate>

@property (nonatomic,strong)UITextField *userTextField;
@property (nonatomic,strong)UITextField *passwordTextField;

@end
