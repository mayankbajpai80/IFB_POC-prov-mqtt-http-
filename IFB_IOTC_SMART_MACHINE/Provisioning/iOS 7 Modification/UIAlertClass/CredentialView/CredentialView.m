//
//  CredentialView.m
//  CustomAlertView
//
//  Created by GainSpan India on 16/09/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import "CredentialView.h"

@implementation CredentialView

@synthesize userTextField = _userTextField;
@synthesize passwordTextField = _passwordTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _userTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        _userTextField.backgroundColor = [UIColor clearColor];
        _userTextField.delegate=self;
        _userTextField.textAlignment = NSTextAlignmentLeft;
        _userTextField.font = [UIFont systemFontOfSize:15];
        _userTextField.placeholder=@"Login";
        [_userTextField setBorderStyle:UITextBorderStyleRoundedRect];
        _userTextField.clearsOnBeginEditing = YES;
        [self addSubview:_userTextField];
        
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _userTextField.frame.origin.y+_userTextField.frame.size.height+5, self.frame.size.width, 44)];
        _passwordTextField.backgroundColor = [UIColor clearColor];
        [_passwordTextField setBorderStyle:UITextBorderStyleRoundedRect];
        _passwordTextField.textAlignment = NSTextAlignmentLeft;
        _passwordTextField.delegate = self;
        _passwordTextField.font = [UIFont systemFontOfSize:15];
        _passwordTextField.placeholder=@"Password";
        _passwordTextField.clearsOnBeginEditing = YES;
        _passwordTextField.secureTextEntry = YES;
        [self addSubview:_passwordTextField];
        
        
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {             // called when 'return' key pressed. return NO to ignore.

    [textField resignFirstResponder];
    return YES;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//    
//}


@end
