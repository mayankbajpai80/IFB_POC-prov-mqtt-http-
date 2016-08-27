//
//  SharedPrefrenceUtil.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 12/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "SharedPrefrenceUtil.h"

@implementation SharedPrefrenceUtil
{
    TCPConnection *tcpConnection;
    NSOutputStream *outputStreams;
}

-(BOOL)saveNSObject: (NSObject *)nsObject forKey: (NSString *)key {
    if (nsObject != nil) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:nsObject];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

-(NSObject *)getNSObject: (NSString *)key {
    
    NSObject *nsObject;
    if (key != nil) {
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *nsData = [currentDefaults objectForKey:key];
        if (nsData != nil) {
            nsObject = [NSKeyedUnarchiver unarchiveObjectWithData:nsData];
            return nsObject;
        }
    }
    return nsObject;
}

-(void)saveBoolValueInUserDefaults: (BOOL)boolValue forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:boolValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)getBoolValuesFromUserDefaults: (NSString *)key {
    BOOL value = NO;
    if (key != nil) {
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        value = [currentDefaults boolForKey:key];
    }
    return value;
}

-(void)removeObject:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
@end
