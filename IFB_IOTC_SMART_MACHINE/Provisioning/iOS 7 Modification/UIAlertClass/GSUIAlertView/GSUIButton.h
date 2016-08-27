//
//  GSUIButton.h
//  Alert_Test
//
//  Created by Vikash on 9/12/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSUIButton : UIButton

@property(nonatomic, strong, readwrite) UIColor *buttonColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, readwrite) UIColor *shadowColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, readwrite) CGFloat shadowHeight UI_APPEARANCE_SELECTOR;
@property(nonatomic, readwrite) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

@end
