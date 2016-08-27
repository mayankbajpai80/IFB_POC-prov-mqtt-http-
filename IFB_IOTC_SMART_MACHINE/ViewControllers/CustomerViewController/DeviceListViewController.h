//
//  MachineListViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 10/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GS_ADK_ServiceManager.h"

@interface DeviceListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, GS_ADK_ServiceManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceListTableView; // device list table view.
@end
