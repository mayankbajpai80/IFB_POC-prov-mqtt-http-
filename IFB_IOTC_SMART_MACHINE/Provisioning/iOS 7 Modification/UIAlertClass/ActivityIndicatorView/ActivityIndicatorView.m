//
//  ActivityIndicatorView.m
//  CustomAlertView
//
//  Created by GainSpan India on 16/09/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import "ActivityIndicatorView.h"

@implementation ActivityIndicatorView

@synthesize alertActivityIndicator = _alertActivityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _alertActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _alertActivityIndicator.frame = CGRectMake(0, 0, 30, 30);
        [self addSubview:_alertActivityIndicator];
        
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
