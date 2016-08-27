//
//  DeviceOpertaionViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 13/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonDropDown.h"

@interface DeviceOpertaionViewController : UIViewController<ButtonDropDownDelegate>
{
    ButtonDropDown *dropDown;
}

@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (weak, nonatomic) IBOutlet UILabel *programLabel;

@property (weak, nonatomic) IBOutlet UITextField *tempTextField;
@property (weak, nonatomic) IBOutlet UITextField *erro1TextField;
@property (weak, nonatomic) IBOutlet UITextField *erro2TextField;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *processTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *error1Btn;
@property (weak, nonatomic) IBOutlet UIButton *error2Btn;

@end
