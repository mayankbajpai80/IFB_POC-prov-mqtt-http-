//
//  ConcurrentModeInfoViewController.h
//  Provisioning
//
//  Created by GainSpan India on 10/07/14.
//
//

#import <UIKit/UIKit.h>
#import "GSNavigationBar.h"
#import "GSViewController.h"

@interface ConcurrentModeInfoViewController : GSViewController

@property (nonatomic, strong) NSMutableDictionary *concurrentInfoDict;

@property (nonatomic, strong) NSMutableArray *firstSectionNameArray;
@property (nonatomic, strong) NSMutableArray *secondSectionNameArray;

@property (nonatomic, strong) UITableView *tableView;

@end
