//
//  MQTTViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 23/08/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "MQTTViewController.h"

@interface MQTTViewController ()


#pragma mark - C Private prototypes
void mqttConnectionSucceeded(void* context, MQTTAsync_successData* response);
void mqttConnectionFailed(void* context, MQTTAsync_failureData* response);
void mqttConnectionLost(void* context, char* cause);

void mqttSubscriptionSucceeded(void* context, MQTTAsync_successData* response);
void mqttSubscriptionFailed(void* context, MQTTAsync_failureData* response);
int mqttMessageArrived(void* context, char* topicName, int topicLen, MQTTAsync_message* message);
void mqttUnsubscriptionSucceeded(void* context, MQTTAsync_successData* response);
void mqttUnsubscriptionFailed(void* context, MQTTAsync_failureData* response);

void mqttPublishSucceeded(void* context, MQTTAsync_successData* response);
void mqttPublishFailed(void* context, MQTTAsync_failureData* response);

void mqttDisconnectionSucceeded(void* context, MQTTAsync_successData* response);
void mqttDisconnectionFailed(void* context, MQTTAsync_failureData* response);

@end

@implementation MQTTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)connectMQTT
{
    _mqttClient = NULL;
    _mqttClientID = @"123";
    NSString *brokerAddr = @"52.32.88.197";
    int status;
    [self.view endEditing:YES];
    __weak MQTTViewController* weakSelf = self;
    
    if (_mqttClient == NULL)
    {
        if (!brokerAddr.length || !_mqttClientID.length) { return; }
        
        status = MQTTAsync_create(&_mqttClient, brokerAddr.UTF8String, _mqttClientID.UTF8String, MQTTCLIENT_PERSISTENCE_NONE, NULL);
        if (status != MQTTASYNC_SUCCESS) { return; }
        
        status = MQTTAsync_setCallbacks(_mqttClient, (__bridge void*)weakSelf, mqttConnectionLost, mqttMessageArrived, NULL);
        if (status != MQTTASYNC_SUCCESS) { mqttDestroy((__bridge void*)weakSelf); }
        
        MQTTAsync_connectOptions connOptions = MQTTAsync_connectOptions_initializer;
        connOptions.onSuccess = mqttConnectionSucceeded;
        connOptions.onFailure = mqttConnectionFailed;
        connOptions.context = (__bridge void*)weakSelf;        
        
        status = MQTTAsync_connect(_mqttClient, &connOptions);
        if (status != MQTTASYNC_SUCCESS) { mqttDestroy((__bridge void*)weakSelf); }
         
    }
    else
    {
        MQTTAsync_disconnectOptions disconnOptions = MQTTAsync_disconnectOptions_initializer;
        disconnOptions.onSuccess = mqttDisconnectionSucceeded;
        disconnOptions.onFailure = mqttDisconnectionFailed;
        disconnOptions.context = (__bridge void*)weakSelf;
        status = MQTTAsync_disconnect(_mqttClient, &disconnOptions);
    }
}

- (void)subscribeForTopic: (NSString *)subscriptionTopic
{
    //NSString *_subscriptionField = @"Response/20:f8:5e:dd:8:ce";
    NSLog(@"subscribe topic : %@", subscriptionTopic);
    if (_mqttClient==NULL) { return; }
    if (!subscriptionTopic.length) { printf("You need to write a subscription topic.\n"); return; }
    
    int status;
    [self.view endEditing:YES];
    __weak MQTTViewController* weakSelf = self;

    
        MQTTAsync_responseOptions subOptions = MQTTAsync_responseOptions_initializer;
        subOptions.onSuccess = mqttSubscriptionSucceeded;
        subOptions.onFailure = mqttSubscriptionFailed;
        subOptions.context = (__bridge void*)weakSelf;
        status = MQTTAsync_subscribe(_mqttClient, subscriptionTopic.UTF8String, 0, &subOptions);
        if (status != MQTTASYNC_SUCCESS) { }

}

- (void)unsubscribeForTopic: (NSString *)unsubscriptionTopic
{
    //NSString *_subscriptionField = @"Response/20:f8:5e:dd:8:ce";
    NSLog(@"unsubscribe topic : %@", unsubscriptionTopic);
    if (_mqttClient==NULL) { return; }
    if (unsubscriptionTopic.length) { printf("You need to write a subscription topic.\n"); return; }
    
    int status;
    [self.view endEditing:YES];
    __weak MQTTViewController* weakSelf = self;
   
    
    MQTTAsync_responseOptions unsubOptions = MQTTAsync_responseOptions_initializer;
    unsubOptions.onSuccess = mqttUnsubscriptionSucceeded;
    unsubOptions.onFailure = mqttUnsubscriptionFailed;
    unsubOptions.context = (__bridge void*)weakSelf;
    status = MQTTAsync_unsubscribe(_mqttClient, unsubscriptionTopic.UTF8String, &unsubOptions);
    if (status != MQTTASYNC_SUCCESS) { }
}

- (void)publish: (NSString *)publishTopic withCommand:(NSArray *)command
{
    Byte myByteArray[25];
    for (int i = 0; i < command.count; i++) {
        myByteArray[i] = strtoul([command[i] UTF8String], NULL, 16);
    }
    
    
    __weak MQTTViewController* weakSelf = self;
    [self.view endEditing:YES];
    
    MQTTAsync_message message = MQTTAsync_message_initializer;
    message.payloadlen = (int)[command count];
    //char payload[message.payloadlen];
    //[_publishBodyField.text getCString:payload maxLength:message.payloadlen encoding:NSUTF8StringEncoding];
    message.payload = myByteArray;
    
    
    MQTTAsync_responseOptions pubOptions = MQTTAsync_responseOptions_initializer;
    pubOptions.onSuccess = mqttPublishSucceeded;
    pubOptions.onFailure = mqttPublishFailed;
    pubOptions.context = (__bridge void*)weakSelf;
    int status = MQTTAsync_sendMessage(_mqttClient, publishTopic.UTF8String, &message, &pubOptions);
    NSLog(@"%d",status);
}

#pragma mark MQTT functions

void mqttConnectionSucceeded(void* context, MQTTAsync_successData* response)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        printf("MQTT connection to broker succeeded.\n");
        
    });
}

void mqttConnectionFailed(void* context, MQTTAsync_failureData* response)
{
    printf("MQTT connection to broker failed.\n");
    mqttDestroy(context);
}

void mqttConnectionLost(void* context, char* cause)
{
    printf("MQTT connection was lost with cause: %s\n", cause);
    mqttDestroy(context);
}

void mqttSubscriptionSucceeded(void* context, MQTTAsync_successData* response)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        printf("MQTT subscription succeeded");

    });
}

void mqttSubscriptionFailed(void* context, MQTTAsync_failureData* response)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        printf("MQTT subscription failed");

    });
}

int mqttMessageArrived(void* context, char* topicName, int topicLen, MQTTAsync_message* message)
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData *data = [NSData dataWithBytes:message->payload length:message->payloadlen];
        uint8_t *bytes = (uint8_t *)[data bytes];
        
        for (NSUInteger i = 0; i < message->payloadlen; i++) {
            [dataArray addObject:[NSString stringWithFormat:@"%hhu",bytes[i]]];
        }
        NSDictionary *theInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:dataArray,@"myArray", nil];
        if (dataArray.count > 37) {
            MQTTViewController* strongSelf = (__bridge __weak MQTTViewController*)context;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getCurrentStatus" object:strongSelf userInfo:theInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getRunningProgram" object:strongSelf userInfo:theInfo];
        }
    });
    return true;}

void mqttUnsubscriptionSucceeded(void* context, MQTTAsync_successData* response)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        printf("MQTT unsubscription succeeded.\n");
        
    });
}

void mqttUnsubscriptionFailed(void* context, MQTTAsync_failureData* response)
{
    dispatch_async(dispatch_get_main_queue(), ^{
                printf("MQTT unsubscription failed.\n");
    });
}

void mqttPublishSucceeded(void* context, MQTTAsync_successData* response)
{
    dispatch_async(dispatch_get_main_queue(), ^{
                printf("MQTT publish message succeeded.\n");
           });
}

void mqttPublishFailed(void* context, MQTTAsync_failureData* response)
{
    dispatch_async(dispatch_get_main_queue(), ^{
                printf("MQTT publish message failed.\n");
       
    });
}

void mqttDisconnectionSucceeded(void* context, MQTTAsync_successData* response)
{
    printf("MQTT disconnection succeeded.\n");
    mqttDestroy(context);
}

void mqttDisconnectionFailed(void* context, MQTTAsync_failureData* response)
{
    printf("MQTT disconnection failed.\n");
    mqttDestroy(context);
}

void mqttDestroy(void* context)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        printf("MQTT handler destroyed.\n");
        
        MQTTViewController* strongSelf = (__bridge __weak MQTTViewController*)context;
        if (!strongSelf) { return; }
        
        MQTTAsync mqttClient = strongSelf.mqttClient;
        MQTTAsync_destroy(&mqttClient);
        strongSelf.mqttClient = NULL;
    });
}


@end
