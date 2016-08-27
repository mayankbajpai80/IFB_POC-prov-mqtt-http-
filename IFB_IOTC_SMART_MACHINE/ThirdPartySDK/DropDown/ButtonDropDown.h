//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonDropDown;
@protocol ButtonDropDownDelegate
- (void) niDropDownDelegateMethod: (ButtonDropDown *) sender;
@end

@interface ButtonDropDown : UIButton <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}
@property (nonatomic, retain) id <ButtonDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
/**
 *  Hide drop down list.
 *
 *  @param button tapped button.
 */
-(void)hideDropDown:(UIButton *)button;

/**
 *  Open drop down list.
 *
 *  @param button         tapped button
 *  @param height         height of the drop down view.
 *  @param arr            array of the drop down list.
 *  @param imgArr         array of drop down images (if want to set image with title).
 *  @param direction      direction (i.e. up or down).
 *  @param viewController view controller object (from where it has been called).
 *
 *  @return drop down list.
 */
- (id)showDropDown:(UIButton *)button :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction :(UIViewController *)viewController;
@end
