//
//  ConfigurationViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 04/08/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigurationViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *stationSSID;
@property (weak, nonatomic) IBOutlet UITextField *stationPassword;
@property (weak, nonatomic) IBOutlet UITextField *apSSID;
@property (weak, nonatomic) IBOutlet UITextField *apPassword;
- (IBAction)applyConfiguration:(id)sender;
@end
