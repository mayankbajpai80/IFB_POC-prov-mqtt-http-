//
//  ValidationUtils.m
//  Provisioning
//
//  Created by GainSpan India on 16/01/15.
//
//

#import "ValidationUtils.h"
#import "GSAlertInfo.h"
#import "GSUIAlertView.h"

@implementation ValidationUtils

/**
 *  Checking SSID length,The string length should not be greather than 32 characters.
 *
 *  @param ssidString-> ssid string
 *
 *  @return  bool value.
 */

+(BOOL)validateSSIDLength:(NSString *)ssidString {
    
    NSString *lObjStr = ssidString;
    
    if(lObjStr.length < 33)
    {
        return YES;
    }
    else {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Not a valid SSID" message:@"Please enter a ssid with a maximum length of 32 characters" confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
        [lObjFieldValidation show];
        
        return NO;
    }
    
}

+(BOOL)validatePassphraseLength:(NSString *)passphraseString {
    
    if (passphraseString.length < 8 || passphraseString.length > 63) {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Not a valid Passphrase" message:@"Please enter a passphrase with a minimum length of 8 characters and maximum length of 63 characters" confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
        [lObjFieldValidation show];
        
        return NO;
        
    }
    else {
        
        return YES;
        
    }

}

+(BOOL)validateHexValue:(NSString *)lObjString {
    
    
    if ([lObjString length] != 10 && [lObjString length] != 26) {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Not a valid key" message:@"WEP key must be a 10 or a 26 digit value using numbers 0-9 and/or characters A-F." confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
        [lObjFieldValidation show];
        
        return NO;
    }
    
    for (int i = 0; i < [lObjString length]; i++) {
        
        int asciiCode = [lObjString characterAtIndex:i]; // 65
        
        if(!((asciiCode >= 48 && asciiCode <= 57) || (asciiCode >=65 && asciiCode <=70) || (asciiCode >=97 && asciiCode <=102)))
        {
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Not a valid key" message:@"Please enter hexadecimal key" confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            [lObjFieldValidation show];
            
            return NO;
        }
        
    }
    
    return YES;
    
}

+(BOOL)validateCharacters:(NSString *)lObjString {
    
    BOOL valid;
    
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[lObjString stringByReplacingOccurrencesOfString:@"." withString:@""]];
    
    valid = [alphaNums isSupersetOfSet:inStringSet];
    
    if (!valid) {
        
//        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Alphanumeric characters other than (.) is not allowed" message:nil confirmationData:[NSDictionary dictionary]];
//        info.cancelButtonTitle = @"OK";
//        info.otherButtonTitle = nil;
        
        UIAlertView *lObjFieldValidation = [[UIAlertView alloc] initWithTitle:@"Alphanumeric characters other than (.) is not allowed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [lObjFieldValidation show];
        
        return NO;
        
    }
    return YES;
}



+(BOOL)validateIPAddress:(NSString *)lObjString {
    
    NSArray *lObjIPSplit = [NSArray arrayWithArray:[lObjString componentsSeparatedByString:@"."]];
    
    if ([lObjIPSplit count] != 4) {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Invalid ip address used" message:[NSString stringWithFormat:@"please enter a valid ip address"] confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
        
        [lObjFieldValidation show];
        
        return NO;
    }
    
    for (int j=0; j < [lObjIPSplit count]; j++) {
        
        if ([[lObjIPSplit objectAtIndex:j] intValue] > 255 || [[lObjIPSplit objectAtIndex:j] intValue] < 0 || [[lObjIPSplit objectAtIndex:j] isEqualToString:@""]) {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Invalid ip address used" message:[NSString stringWithFormat:@"please enter a valid ip address"] confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            [lObjFieldValidation show];
            
            return NO;
            
        }
        
    }
    
    
    return YES;

}

+(BOOL)validateIPAddress:(NSString *)lObjString withTitle:(NSString *)title {
    
    
        NSArray *lObjIPSplit = [NSArray arrayWithArray:[lObjString componentsSeparatedByString:@"."]];
        
        if ([lObjIPSplit count] != 4) {
            
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Invalid %@",title] message:nil confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            
            [lObjFieldValidation show];
            
            return NO;
        }
        
        for (int j=0; j < [lObjIPSplit count]; j++) {
            
            if ([[lObjIPSplit objectAtIndex:j] intValue] > 255 || [[lObjIPSplit objectAtIndex:j] intValue] < 0 || [[lObjIPSplit objectAtIndex:j] isEqualToString:@""]) {
                
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Invalid %@",title] message:nil confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
                
                [lObjFieldValidation show];
                
                return NO;
                
            }
            
        }
    
    return YES;
}


@end
