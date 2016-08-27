//
//  ProgramsViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 11/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgramsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, NSStreamDelegate>

@property (strong , nonatomic) NSDictionary *deviceInfo;
@property (weak, nonatomic) IBOutlet UICollectionView *progrmaGridView;
@end
