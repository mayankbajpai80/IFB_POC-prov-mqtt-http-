//
//  MQTTViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 23/08/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTClient.h"
#import "MQTTAsync.h"


@interface MQTTViewController : UIViewController

@property (unsafe_unretained,nonatomic) MQTTAsync mqttClient;
@property (strong,nonatomic) NSString* mqttClientID;
@property (strong,nonatomic) NSString* mqttUsername;
@property (strong,nonatomic) NSString* mqttPassword;

-(void)connectMQTT;
- (void)subscribeForTopic: (NSString *)subscriptionTopic;
- (void)unsubscribeForTopic: (NSString *)unsubscriptionTopic;

- (void)publish: (NSString *)publishTopic withCommand:(NSArray *)command;
@end
