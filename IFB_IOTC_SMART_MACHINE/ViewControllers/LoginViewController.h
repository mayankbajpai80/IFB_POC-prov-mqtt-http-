//
//  ViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 09/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField; // username textfield.
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField; // password textfield.

@end

