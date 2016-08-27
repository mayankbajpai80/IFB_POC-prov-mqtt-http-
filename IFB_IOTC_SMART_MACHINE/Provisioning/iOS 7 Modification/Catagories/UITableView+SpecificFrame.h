//
//  UITableView+SpecificFrame.h
//  Provisioning
//
//  Created by GainSpan India on 03/09/13.
//
//

#import <UIKit/UIKit.h>

@interface UITableView (SpecificFrame)

-(void)setSpecificFrame ;
-(void)setSpecificFrameWithMargin:(CGFloat)margin withAdjustment:(CGFloat)adjustment;
-(id)  initWithiOSVersionSpecificMargin:(CGFloat) margin withAdjustment:(CGFloat)adjustment;
-(id)  initWithiOSVersionSpecificMargin:(CGFloat) margin withAdjustment:(CGFloat)adjustment style: (UITableViewStyle) style;

@end
