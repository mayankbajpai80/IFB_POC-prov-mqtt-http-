//
//  WPSPINTextView.m
//  Provisioning
//
//  Created by GainSpan India on 30/10/13.
//
//

#import "WPSPINTextView.h"

@interface WPSPINTextView ()

@end

@implementation WPSPINTextView




- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor lightGrayColor];
        
       _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 1, frame.size.width, frame.size.height-1)];
		[_textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
		_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.textAlignment = NSTextAlignmentCenter;
		[_textField setTag:1001];
		[_textField setBackgroundColor:[UIColor whiteColor]];
		[_textField setDelegate:delegate];
		[self addSubview:_textField];
        
        
        
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
