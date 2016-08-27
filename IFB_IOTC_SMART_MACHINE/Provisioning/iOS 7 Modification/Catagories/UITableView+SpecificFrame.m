

#import "UITableView+SpecificFrame.h"
#import "Identifiers.h"


//#define STATUS_BAR_HEIGHT_LESS_THAN_IOS_7 20

@implementation UITableView (SpecificFrame)

-(void)setSpecificFrame {
    

    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [self setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 135)];
    }
    
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [self setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 22)];
    }
    else {
        
    }

}

-(void)setSpecificFrameWithMargin: (CGFloat)margin withAdjustment:(CGFloat)adjustment{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [self setFrame:CGRectMake(0, margin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - STATUS_BAR_HEIGHT - adjustment - margin)];
    }
    
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [self setFrame:CGRectMake(0, margin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - margin)];
    }
    else {
        
    }
}

-(id) initWithiOSVersionSpecificMargin:(CGFloat) margin withAdjustment:(CGFloat)adjustment {
    
    return [self  initWithiOSVersionSpecificMargin:margin withAdjustment:adjustment style:UITableViewStyleGrouped];
}

-(id)  initWithiOSVersionSpecificMargin:(CGFloat) margin withAdjustment:(CGFloat)adjustment style: (UITableViewStyle) style{
   
    CGRect osSpecificRect;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        osSpecificRect = CGRectMake(0, NAVIGATION_BAR_HEIGHT+STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - adjustment - margin- STATUS_BAR_HEIGHT);
        
    }
    
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        osSpecificRect = CGRectMake(0, margin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - margin);
        
    }
    
    return [self initWithFrame:osSpecificRect style:style];
}

//-(id)initWithTableViewFrameWithTopMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin style:(UITableViewStyle)tableViewStyle {
//    
//     CGRect frame;
//    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
//        
//        frame = CGRectMake(0, topMargin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - bottomMargin);
//        
//    }
//    
//    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        
//        frame = CGRectMake(0, topMargin, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - bottomMargin);
//        
//    }
//
//    return [self initWithFrame:frame style:tableViewStyle];
//}

@end
