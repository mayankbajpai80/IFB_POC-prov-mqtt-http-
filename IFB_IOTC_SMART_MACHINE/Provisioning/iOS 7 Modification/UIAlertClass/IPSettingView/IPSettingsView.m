//
//  IPSettingsView.m
//  CustomAlertView
//
//  Created by GainSpan India on 16/09/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import "IPSettingsView.h"
#import "Identifiers.h"

@implementation IPSettingsView
@synthesize segmentControl = _segmentControl;

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        _segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"DHCP",@"Static", nil]];
        _segmentControl.frame = CGRectMake(0, 0, self.frame.size.width, 44);
       // [_segmentControl addTarget:delegate action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
        //_segmentControl.selectedSegmentIndex = IP_TYPE_DHCP;
        [self addSubview:_segmentControl];
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
