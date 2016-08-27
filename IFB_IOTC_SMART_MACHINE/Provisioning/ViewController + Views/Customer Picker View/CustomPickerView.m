//
//  CustomPickerView.m
//  CustomPicker
//
//  Created by GainSpan India on 05/09/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import "CustomPickerView.h"

@implementation CustomPickerView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate withTag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
       // _delegate = delegate;
                
        _lObjPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
        _lObjPicker.delegate = delegate;
        _lObjPicker.dataSource = delegate;
        _lObjPicker.tag=tag;
        _lObjPicker.showsSelectionIndicator = YES;
        [self addSubview:_lObjPicker];
        
        [_lObjPicker selectRow:1 inComponent:0 animated:NO];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
