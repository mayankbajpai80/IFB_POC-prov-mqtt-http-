//
//  JOBDetailViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 19/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonDropDown.h"

@interface JOBDetailViewController : UIViewController<ButtonDropDownDelegate> {
    ButtonDropDown *dropDown;
}


@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *JOBDetailScrollView;
@property (strong , nonatomic) NSDictionary *JOBInfo;
@property (weak, nonatomic) IBOutlet UITextField *orderIDTextfield;
@property (weak, nonatomic) IBOutlet UITextField *productID;
@property (weak, nonatomic) IBOutlet UITextField *productStatus;
@property (weak, nonatomic) IBOutlet UITextField *modelName;
@property (weak, nonatomic) IBOutlet UITextField *customerName;
@property (weak, nonatomic) IBOutlet UITextField *customerEmail;
@property (weak, nonatomic) IBOutlet UITextField *customerAddress;
@property (weak, nonatomic) IBOutlet UITextField *customerPhoneNo;
@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectMachine;
@end
