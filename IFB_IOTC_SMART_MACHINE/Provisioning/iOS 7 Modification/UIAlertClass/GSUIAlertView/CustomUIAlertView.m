//
//  CustomUIAlertView.m
//  Alert_Test
//
//  Created by Vikash on 9/12/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import "CustomUIAlertView.h"
#import "GSUIButton.h"
#import "GSUIAlertView.h"
#import "Identifiers.h"

@interface CustomUIAlertView()

//@property(nonatomic, weak) UIView *alertContentContainer;


@end

@implementation CustomUIAlertView

+ (void)initialize {
    if (self == [CustomUIAlertView class]) {
        CustomUIAlertView *appearance = [self appearance];
        // CustomUIAlertView *appearance = (CustomUIAlertView *)self;
        [appearance setButtonSpacing:0.0f];
        [appearance setAnimationDuration:0.2f];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<CustomUIAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        
        // This mask is set to force lay out of subviews when superview's bounds change
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIView *backgroundOverlay = [[UIView alloc] init];
        //[backgroundOverlay.layer setCornerRadius:10.0f];
        backgroundOverlay.backgroundColor = [UIColor blackColor];
        backgroundOverlay.userInteractionEnabled = NO;
        [self addSubview:backgroundOverlay];
        backgroundOverlay.alpha = 0;
        _backgroundOverlay = backgroundOverlay;
        
        UIView *alertContainer = [[UIView alloc] init];
        alertContainer.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [alertContainer setClipsToBounds:YES];
        [self addSubview:alertContainer];
        [self bringSubviewToFront:alertContainer];
        _alertContainer = alertContainer;
        
        UIView *alertContentContainer = [[UIView alloc] init];
        alertContentContainer.backgroundColor = [UIColor clearColor];
        [self.alertContainer addSubview:alertContentContainer];
        [self.alertContainer bringSubviewToFront:alertContentContainer];
        _alertContentContainer = alertContentContainer;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.title;
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [alertContentContainer addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = self.message;
        [messageLabel setFont:[UIFont systemFontOfSize:12]];
        [alertContentContainer addSubview:messageLabel];
        _messageLabel = messageLabel;
        
        
        if (cancelButtonTitle) {
            [self addButtonWithTitle:cancelButtonTitle];
            [self setHasCancelButton:YES];
        }
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
            [self addButtonWithTitle:arg];
        }
        va_end(args);
    }
    return self;
}



- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    
    if (CGAffineTransformIsIdentity(self.alertContainer.transform)) {
        
        self.backgroundOverlay.frame = self.bounds;
        CGFloat padding = 15;
        
        CGRect contentContainerFrame = CGRectMake(padding, padding, 0, 0);
        
        contentContainerFrame.size = [self calculateSize];
        
        //contentContainerFrame.size = CGSizeMake(250, 180);
        self.alertContentContainer.frame = contentContainerFrame;
        CGRect alertContainerFrame = CGRectInset(contentContainerFrame, -padding, -padding);
        alertContainerFrame.origin = CGPointMake(floorf((self.frame.size.width - alertContainerFrame.size.width) / 2),
                                                 floorf((self.frame.size.height - alertContainerFrame.size.height) / 2));
        
        alertContainerFrame.origin.y = MAX(10, alertContainerFrame.origin.y - 30);
        self.alertContainer.frame = alertContainerFrame;
        
        CGRect titleFrame = self.titleLabel.frame;
        
        titleFrame.size.width = self.alertContentContainer.frame.size.width;
        self.titleLabel.frame = titleFrame;
        [self.titleLabel sizeToFit];
        titleFrame = self.titleLabel.frame;
        CGPoint titleOrigin = CGPointMake(floorf((self.alertContentContainer.frame.size.width - self.titleLabel.frame.size.width)/2), 0);
        titleFrame.origin = titleOrigin;
        self.titleLabel.frame = titleFrame;
        CGRect messageFrame = self.messageLabel.frame;
        messageFrame.size.width = self.alertContentContainer.frame.size.width;
        self.messageLabel.frame = messageFrame;
        [self.messageLabel sizeToFit];
        messageFrame = self.messageLabel.frame;
        CGPoint messageOrigin = CGPointMake(floorf((self.alertContentContainer.frame.size.width - self.messageLabel.frame.size.width)/2), CGRectGetMaxY(titleFrame) + 10);
        messageFrame.origin = messageOrigin;
        self.messageLabel.frame = messageFrame;
        
        __block CGFloat startingButtonY = self.alertContentContainer.frame.size.height - [self totalButtonHeight];
        
        [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = obj;
            if (self.hasCancelButton && idx == 0) {
                CGFloat lastButtonY = self.alertContentContainer.frame.size.height - button.frame.size.height;
                [self setButton:obj atHeight:lastButtonY];
            } else {
                [self setButton:obj atHeight:startingButtonY];
                startingButtonY += (button.frame.size.height + self.buttonSpacing);
            }
        }];
        
    }
    
}

- (void)setButton:(UIButton *)button atHeight:(CGFloat)height {
    
    CGRect buttonFrame = button.frame;
    buttonFrame.origin = CGPointMake(-35, height);
    
    buttonFrame.size.width = 320;
    
    button.frame = buttonFrame;
}

- (CGFloat) totalButtonHeight {
    __block CGFloat buttonHeight = 0;
    [self.buttons enumerateObjectsUsingBlock:^(GSUIButton *button, NSUInteger idx, BOOL *stop) {
        buttonHeight += (button.frame.size.height + self.buttonSpacing);
    }];
    buttonHeight -= self.buttonSpacing;
    return buttonHeight;
}

- (CGSize) calculateSize {
    
    return [(GSUIAlertView *)self calculateSize];
}

- (NSInteger) numberOfButtons {
    return (NSInteger)self.buttons.count;
}

- (void)show {
    
    NSLog(@"Custom alert show method");
    
    self.alertContainer.alpha = 0.75;
    self.alertContainer.transform = CGAffineTransformMakeScale(1.3, 1.3);
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (topController == nil) {
        
        UIView *rootView = [UIApplication sharedApplication].keyWindow;
        self.frame = rootView.bounds;
        [rootView addSubview:self];
        [rootView bringSubviewToFront:self];
        
    }
    else{
        
        while (topController.presentedViewController && !topController.presentedViewController.isBeingDismissed) {
            topController = topController.presentedViewController;
        }
        
        UIView *rootView;
        
        if ([topController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tabController = (UITabBarController *)topController;
            
            if ([[tabController selectedViewController] isKindOfClass:[UINavigationController class]]) {
                
                UINavigationController *navController = (UINavigationController *)[tabController selectedViewController];
                
                rootView = navController.visibleViewController.view;
                
            }
            else{
                
                UIViewController *viewController = (UIViewController *)[tabController selectedViewController];
                
                rootView = viewController.view;
                
            }
            
        }
        else if ([topController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *navController = (UINavigationController *)topController;
            
            rootView = navController.visibleViewController.view;
            
        }
        else{
            
            rootView = topController.view;
            
        }
        
        if(rootView) {
            
            self.frame = rootView.bounds;
        }
        
        [rootView addSubview:self];
        [rootView bringSubviewToFront:self];
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundOverlay.alpha = 0.3;
        self.alertContainer.alpha = 1;
        self.alertContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished0) {
        _visible = YES;
        
        if ([self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
            [self.delegate didPresentAlertView:self];
        }
    }];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < 0 || buttonIndex > (NSInteger)self.buttons.count) {
        return nil;
    }
    return [[self.buttons objectAtIndex:(NSUInteger)buttonIndex] titleForState:UIControlStateNormal];
}



- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    //todo delegate

    self.alertContainer.transform = CGAffineTransformIdentity;
    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundOverlay.alpha = 0;
        self.alertContainer.alpha = 0;
        self.alertContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _visible = NO;
        if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
            [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
        }
    }];
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    if (!title) return -1;
    if (!self.buttons) {
        self.buttons = [NSMutableArray array];
    }
    //    GSUIButton *button = [[GSUIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    
    GSUIButton *button = [[GSUIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    button.cornerRadius = 3;
    button.buttonColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    button.shadowColor = [UIColor clearColor];
    button.shadowHeight = 0;
    //    [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //    [button.layer setBorderWidth:0.5f];
    
    //
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [topBorder setBackgroundColor:[UIColor lightGrayColor]];
    [button addSubview:topBorder];
    
    //
    
    [button setTitleColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1] forState:UIControlStateNormal];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContentContainer addSubview:button];
    [self.buttons addObject:button];
    return (NSInteger)self.buttons.count-1;
}

- (void) buttonPressed:(GSUIButton *)sender {
    NSUInteger index = [self.buttons indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:(NSInteger)index];
    }
    [self dismissWithClickedButtonIndex:(NSInteger)index animated:YES];
}

- (void)clickButtonAtIndex:(NSInteger)buttonIndex {
    [[self.buttons objectAtIndex:(NSUInteger)buttonIndex] sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void) setDefaultButtonFont:(UIFont *)defaultButtonFont {
    _defaultButtonFont = defaultButtonFont;
    [self.buttons enumerateObjectsUsingBlock:^(GSUIButton *button, NSUInteger idx, BOOL *stop) {
        button.titleLabel.font = defaultButtonFont;
    }];
}

- (void) setDefaultButtonTitleColor:(UIColor *)defaultButtonTitleColor {
    _defaultButtonTitleColor = defaultButtonTitleColor;
    [self.buttons enumerateObjectsUsingBlock:^(GSUIButton *button, NSUInteger idx, BOOL *stop) {
        [button setTitleColor:defaultButtonTitleColor forState:UIControlStateNormal & UIControlStateHighlighted];
    }];
}

- (void) setDefaultButtonColor:(UIColor *)defaultButtonColor {
    _defaultButtonColor = defaultButtonColor;
    [self.buttons enumerateObjectsUsingBlock:^(GSUIButton *button, NSUInteger idx, BOOL *stop) {
        button.buttonColor = defaultButtonColor;
    }];
}

- (void) setDefaultButtonShadowColor:(UIColor *)defaultButtonShadowColor {
    _defaultButtonShadowColor = defaultButtonShadowColor;
    [self.buttons enumerateObjectsUsingBlock:^(GSUIButton *button, NSUInteger idx, BOOL *stop) {
        button.shadowColor = defaultButtonShadowColor;
    }];
}

- (void) setDefaultButtonCornerRadius:(CGFloat)defaultButtonCornerRadius {
    _defaultButtonCornerRadius = defaultButtonCornerRadius;
    [self.buttons enumerateObjectsUsingBlock:^(GSUIButton *button, NSUInteger idx, BOOL *stop) {
        button.cornerRadius = defaultButtonCornerRadius;
    }];
}

- (void) setDefaultButtonShadowHeight:(CGFloat)defaultButtonShadowHeight {
    _defaultButtonShadowHeight = defaultButtonShadowHeight;
    [self.buttons enumerateObjectsUsingBlock:^(GSUIButton *button, NSUInteger idx, BOOL *stop) {
        button.shadowHeight = defaultButtonShadowHeight;
    }];
}

@end
