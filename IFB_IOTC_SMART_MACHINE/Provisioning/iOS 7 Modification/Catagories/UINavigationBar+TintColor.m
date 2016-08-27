//
//  UINavigationBar+TintColor.m
//  Provisioning
//
//  Created by GainSpan India on 26/08/13.
//
//

#import "UINavigationBar+TintColor.h"
#import "Identifiers.h"


@implementation UINavigationBar (TintColor)

-(void)setTintSupportedColor {
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
       
        [self setTintColor:[UIColor blackColor]];
    }
    
   else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
       [self setBarTintColor:[UIColor clearColor]];
    }
   else {
       
   }
    
}

@end
