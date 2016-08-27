//
//  AddDeviceViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 12/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceSerialNoTextfield;
@property (weak, nonatomic) IBOutlet UITextField *deviceMacAddressTextfield;
@end
