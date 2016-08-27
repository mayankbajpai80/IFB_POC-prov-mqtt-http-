//
//  MySingleton.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 13/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPConnection.h"
#import "StartProvisioningViewController.h"
#import "MQTTViewController.h"

@interface MySingleton : NSObject

#define globalValues ((MySingleton *)[MySingleton parser])

@property (nonatomic, retain) StartProvisioningViewController *provisionSharedDelegate;

@property (nonatomic, retain) NSString *isLocal;

@property (nonatomic, retain) NSOutputStream *outputStream;
@property (nonatomic, retain) TCPConnection *tcpConnection;
@property (nonatomic, retain) MQTTViewController *mqtt;
+ (MySingleton*)sharedInstance;
+ (id)parser;
@end
