//
//  AppUtils.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 27/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtils : NSObject

/**
 *  Fetch connected network SSID.
 *
 *  @return return SSID.
 */
- (NSString *)fetchSSIDInfo;

/**
 *  Get connected network ip address.
 *
 *  @return return ip Address.
 */
- (NSString *)getIPAddress;
@end
