//
//  JOBCardViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 11/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JOBCardViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *jobCardTableView;
@end
