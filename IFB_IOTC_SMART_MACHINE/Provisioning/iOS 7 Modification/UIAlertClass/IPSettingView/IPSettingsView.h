//
//  IPSettingsView.h
//  CustomAlertView
//
//  Created by GainSpan India on 16/09/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPSettingsView : UIView

@property (nonatomic,strong)UISegmentedControl *segmentControl;

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;

@end
