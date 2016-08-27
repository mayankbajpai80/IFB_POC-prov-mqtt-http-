//
//  SharedPrefrenceUtil.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 12/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TCPConnection.h"

@interface SharedPrefrenceUtil : NSObject

-(BOOL)saveNSObject: (NSObject *)nsObject forKey: (NSString *)key;
-(NSObject *)getNSObject: (NSString *)key;
-(void)saveBoolValueInUserDefaults: (BOOL)boolValue forKey:(NSString *)key ;
-(BOOL)getBoolValuesFromUserDefaults: (NSString *)key;
-(void)removeObject:(NSString *)key;

@end
