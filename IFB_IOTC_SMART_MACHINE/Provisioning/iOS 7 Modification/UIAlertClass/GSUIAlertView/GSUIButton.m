//
//  GSUIButton.m
//  Alert_Test
//
//  Created by Vikash on 9/12/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//
#import "GSUIButton.h"

@interface GSUIButton()
@property(nonatomic) UIEdgeInsets defaultEdgeInsets;
@property(nonatomic) UIEdgeInsets normalEdgeInsets;
@property(nonatomic) UIEdgeInsets highlightedEdgeInsets;
@end

@implementation GSUIButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultEdgeInsets = self.titleEdgeInsets;
    }
    return self;
}

- (void) setHighlighted:(BOOL)highlighted {
    self.titleEdgeInsets = highlighted ? self.highlightedEdgeInsets : self.normalEdgeInsets;
    [super setHighlighted:highlighted];
}

- (void) setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self configureFlatButton];
}

- (void) setButtonColor:(UIColor *)buttonColor {
    _buttonColor = buttonColor;
    [self configureFlatButton];
}

- (void) setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    [self configureFlatButton];
}

- (void) setShadowHeight:(CGFloat)shadowHeight {
    _shadowHeight = shadowHeight;
    UIEdgeInsets insets = self.defaultEdgeInsets;
    self.highlightedEdgeInsets = insets;
    insets.top -= shadowHeight;
    self.normalEdgeInsets = insets;
    self.titleEdgeInsets = insets;
    [self configureFlatButton];
}

- (void) configureFlatButton {
  // Add design / rendering for flat look
}

@end
