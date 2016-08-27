//
//  CommonParsing.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 18/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "CommonParsing.h"

@implementation CommonParsing

-(NSString *)getStateString:(NSInteger)value {
    
    switch (value) {
        case 0:
            return @"Idle State";
            break;
        case 1:
            return @"Stand by";
            break;
        case 2:
            return @"Start";
            break;
        case 3:
            return @"Pre-Wash";
            break;
        case 4:
            return @"Main Wash";
            break;
        case 5:
            return @"Extra Rinse1";
            break;
        case 6:
            return @"Extra Rinse2";
            break;
        case 7:
            return @"Extra Rinse2";
            break;
        case 8:
            return @"First rinse";
            break;
        case 9:
            return @"Second Rinse";
            break;
        case 10:
            return @"Final Rinse";
            break;
        case 11:
            return @"Final Spin";
            break;
        case 12:
            return @"Anti-crease";
            break;
        case 13:
            return @"End";
            break;
        case 14:
            return @"Pause";
            break;
        case 15:
            return @"Soak";
            break;
        case 16:
            return @"Rinse Hold";
            break;
        case 17:
            return @"Heating";
            break;
        case 18:
            return @"Drain";
            break;
        case 19:
            return @"Intermediate Spin";
            break;
        case 20:
            return @"Delay Start";
            break;
        default:
            return @"Unknwon State";
    }
}

-(NSString *)getProgramString:(NSInteger)value {
    
    switch (value) {
        case 0:
            return @"No Program";
            break;
        case 1:
            return @"Mixed Soiled";
            break;
        case 2:
            return @"Mixed Soiled Plus";
            break;
        case 3:
            return @"SYNTHETIC";
            break;
        case 4:
            return @"COTTON";
            break;
        case 5:
            return @"COTTON ECO";
            break;
        case 6:
            return @"DRAIN SPIN PLUS";
            break;
        case 7:
            return @"Tub Clean";
            break;
        case 8:
            return @"RINSE SPIN";
            break;
        case 9:
            return @"WOOL";
            break;
        case 10:
            return @"CRADLE WASH";
            break;
        case 11:
            return @"QUICK WASH";
            break;
        case 12:
            return @"More";
            break;
        case 13:
            return @"Baby Wear";
            break;
        case 14:
            return @"Hygiene";
            break;
        case 15:
            return @"Curtains";
            break;
        default:
            return @"No Program";
    }
}

-(NSString *)getError1String:(NSInteger)value {
    
    switch (value) {
        case 1:
            return @"Door Unlock fault";
            break;
        case 2:
            return @"triac short";
            break;
        case 4:
            return @"Motor Failure";
            break;
        case 5:
            return @"Overflow";
            break;
        case 6:
            return @"Overheat error";
            break;
        case 7:
            return @"Presure switch failure";
            break;
        case 8:
            return @"door lock failure";
            break;
        default:
            return @"No Error";
            break;
    }
}

-(NSString *)getError2String:(NSInteger)value {
    
    switch (value) {
        case 1:
            return @"No water";
            break;
        case 2:
            return @"low water pressure";
            break;
        case 3:
            return @"heater failure";
            break;
        case 4:
            return @"NTC Error";
            break;
        case 5:
            return @"drain pump failure";
            break;
        case 6:
            return @"low voltage error";
            break;
        case 7:
            return @"high voltage error";
            break;
        case 8:
            return @"unbalnce error";
            break;
        default:
            return @"No Error";
            break;
    }
}

@end
