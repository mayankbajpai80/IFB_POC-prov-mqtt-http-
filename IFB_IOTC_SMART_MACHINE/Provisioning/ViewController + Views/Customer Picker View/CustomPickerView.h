//
//  CustomPickerView.h
//  CustomPicker
//
//  Created by GainSpan India on 05/09/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickerView : UIView 


@property (nonatomic,strong)UIPickerView *lObjPicker;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate withTag:(int)tag;

@end
