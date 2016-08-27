//
//  ValidationUtils.h
//  Provisioning
//
//  Created by GainSpan India on 16/01/15.
//
//

#import <Foundation/Foundation.h>

@interface ValidationUtils : NSObject

+(BOOL)validateSSIDLength:(NSString *)ssidString;
+(BOOL)validatePassphraseLength:(NSString *)passphraseString;
+(BOOL)validateHexValue:(NSString *)lObjString;
+(BOOL)validateCharacters:(NSString *)lObjString;
+(BOOL)validateIPAddress:(NSString *)lObjString;
+(BOOL)validateIPAddress:(NSString *)lObjString withTitle:(NSString *)title;


@end
