//
//  CommonParsing.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 18/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonParsing : NSObject

/**
*  Get current state of Machine i.e. Start, pause.
*
*  @param value integer value.
*
*  @return return machine state.
*/
-(NSString *)getStateString:(NSInteger)value;

/**
 *  Get Running program String i.e. Cotton Normal, Mixed Soiled.
 *
 *  @param value integer value.
 *
 *  @return return running wash program.
 */
-(NSString *)getProgramString:(NSInteger)value;

/**
 *  Get Error of type 1 i.e.Door Lock, triac short.
 *
 *  @param value integer value.
 *
 *  @return return error.
 */
-(NSString *)getError1String:(NSInteger)value;

/**
 *  Get Error of type 2 i.e. No water, Low water pressure.
 *
 *  @param value integer value.
 *
 *  @return return error.
 */
-(NSString *)getError2String:(NSInteger)value;

@end
