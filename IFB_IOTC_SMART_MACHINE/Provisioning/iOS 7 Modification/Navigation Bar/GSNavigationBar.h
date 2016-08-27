//
//  GSNavigationBar.h
//  Provisioning
//
//  Created by GainSpan India on 25/09/13.
//
//

#import <UIKit/UIKit.h>




@protocol GSNavigationBarDelegate;

@class GSViewController;

@interface GSNavigationBar : UINavigationBar

enum{
    
    ViewControllerTypeRoot,
    ViewControllerTypeRegular,
    ViewControllerTypeModal,
    ViewControllerTypeInfo,
    ViewControllerTypeCuncurrent,
    ViewControllerTypeMode, 
    ViewControllerTypeSummary
};
typedef int ViewControllerType;

enum{
    
    NavigationItemBack,
    NavigationItemCancel,
    NavigationItemInfo,
    NavigationItemDone,
    NavigationItemMode
};
typedef int NavigationItem;


@property (nonatomic, weak) id <GSNavigationBarDelegate> delegate;

@property (nonatomic, strong) NSString *mode;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) ViewControllerType viewControllerType;

//- (id)initWithParentController;

- (id)initWithParentController:(GSViewController *)parentController;

//-(void)setViewControllerType:(ViewControllerType)viewControllerType;

@end

@protocol GSNavigationBarDelegate <NSObject>

- (void)navigationItemTapped:(NavigationItem)item;

@end

