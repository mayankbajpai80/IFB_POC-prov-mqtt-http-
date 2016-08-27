//
//  ProgramsCollectionViewCell.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 11/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgramsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *programLabel;
@property (weak, nonatomic) IBOutlet UIImageView *programsBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *programImageView;
@end
