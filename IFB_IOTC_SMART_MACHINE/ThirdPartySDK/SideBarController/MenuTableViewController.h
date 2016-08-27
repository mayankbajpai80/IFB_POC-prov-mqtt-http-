//
//  MenuTableViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 12/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MenuTableViewController : UITableViewController<SWRevealViewControllerDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITabBarDelegate>

@property (strong, nonatomic) NSArray *menuList;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@end
