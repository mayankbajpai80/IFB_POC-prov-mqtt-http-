//
//  InternetUtils.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 10/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface InternetUtils : NSObject

-(BOOL)isNetworkAvailable;

-(BOOL)isWifiON;

@end
