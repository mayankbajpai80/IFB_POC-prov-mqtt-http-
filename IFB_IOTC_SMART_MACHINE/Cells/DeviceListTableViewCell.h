//
//  MachineListTableViewCell.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 11/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *deviceIcon; // Device picture
@property (weak, nonatomic) IBOutlet UILabel *deviceName; // Device Name
@property (weak, nonatomic) IBOutlet UIImageView *deviceStatus; // Device Picture
@end
