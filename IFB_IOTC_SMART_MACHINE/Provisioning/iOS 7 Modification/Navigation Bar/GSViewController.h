//
//  GSViewController.h
//  Provisioning
//
//  Created by GainSpan India on 25/09/13.
//
//

#import <UIKit/UIKit.h>
#import "GSNavigationBar.h"

@interface GSViewController : UIViewController 

- (id)initWithControllerType:(int)type;

//-(void)setViewControllerType:(int)type;

@property (nonatomic, strong) GSNavigationBar *navigationBar;

//@property (nonatomic, assign) int controllerType;


@end
