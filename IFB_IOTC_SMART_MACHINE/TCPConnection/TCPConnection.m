//
//  TCPConnection.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 13/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "TCPConnection.h"
#import "MySingleton.h"
#import "SharedPrefrenceUtil.h"
#import "SocketConstant.h"

@implementation TCPConnection
{
    NSMutableArray *byteArray;
    SharedPrefrenceUtil *sharedPrefrenceUtil;
}
#pragma mark - Connect to server

/**
 *  ESTABLISH Connection
 */
-(void)connectToServer:(NSString *)ipAddress :(NSString *)port {
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) ipAddress, [port intValue], &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
    
    [self open];
    byteArray = [[NSMutableArray alloc] init];
}

/**
 *  OPEN Connection
 */
- (void)open {
    
    NSLog(@"Opening streams....");
    outputStream = (__bridge NSOutputStream *)writeStream;
    inputStream = (__bridge NSInputStream *)readStream;
    
    [outputStream setDelegate:self];
    [inputStream setDelegate:self];
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType] ;
    
    [outputStream  setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType] ;
    
    [outputStream open];
    [inputStream open];
    globalValues.outputStream = outputStream;
}

/**
 *  CLOSE Connection.
 */
- (void)close {
    NSLog(@"Closing streams.");
    [inputStream close];
    [outputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    inputStream = nil;
    outputStream = nil;
    [sharedPrefrenceUtil saveBoolValueInUserDefaults:NO forKey:CONNECTION_STATUS];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMenuTable"
                                                        object:self
                                                      userInfo:nil];
}

#pragma mark - Machine Actions.
/**
 *  Action to be performed on Machine i.e. start/pause
 *
 *  @param myByteArray command TO BE SEND
 */
-(void)performOprations: (NSArray *)byteDataArray {
    Byte myByteArray[16];
    for (int i = 0; i < 12; i++) {
        myByteArray[i] = strtoul([byteDataArray[i] UTF8String], NULL, 16);
    }
    [outputStream write:myByteArray maxLength:12];
}

/**
 *  perform basic action i.e. register, deregister.
 *
 *  @param dataString message to be send.
 */
-(void)performAction:(NSString *)dataString {
    NSData *data = [[NSData alloc] initWithData:[dataString dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

/**
 *  perform wash programs i.e. cotton, eco.
 *
 *  @param byteArray command to be send
 */
-(void)performProgram: (NSArray *)byteDataArray {
    Byte myByteArray[25];
    for (int i = 0; i < 21; i++) {
        myByteArray[i] = strtoul([byteDataArray[i] UTF8String], NULL, 16);
    }
    [outputStream write:myByteArray maxLength:21];
}

#pragma mark - streamer delegate method

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    //NSLog(@"stream event %lu", (unsigned long)streamEvent);
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            [sharedPrefrenceUtil saveBoolValueInUserDefaults:YES forKey:CONNECTION_STATUS];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMenuTable"
                                                                object:self
                                                              userInfo:nil];
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == inputStream)
            {
                uint8_t buffer[1024];
                NSInteger len;
                [byteArray removeAllObjects];
                len = [inputStream read:buffer maxLength:1024];
                for (int i=0; i<len; i++) {
                    [byteArray addObject:[NSString stringWithFormat:@"%hhu",buffer[i]]];
                }
                NSDictionary *theInfo =
                [NSDictionary dictionaryWithObjectsAndKeys:byteArray,@"myArray", nil];
                if (byteArray.count > 37) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getCurrentStatus" object:self userInfo:theInfo];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getRunningProgram" object:self userInfo:theInfo];
                }
                else // error cases
                {
                    
                    while ([inputStream hasBytesAvailable])
                    {
                        len = [inputStream read:buffer maxLength:sizeof(buffer)];
                        if (len > 0)
                        {
                            NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                            
                            if (nil != output)
                            {
                                [self messageReceived:output];
                            }
                        }
                    }
                }
                
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"%@",[theStream streamError].localizedDescription);
            break;
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [sharedPrefrenceUtil saveBoolValueInUserDefaults:NO forKey:CONNECTION_STATUS];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMenuTable"
                                                                object:self
                                                              userInfo:nil];
            NSLog(@"close stream");
            break;
        default:
            NSLog(@"Unknown event");
    }
}

- (void) messageReceived:(NSString *)message {
    
    //NSDictionary *status = [NSDictionary dictionaryWithObjectsAndKeys:message,@"status", nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"checkRegistration" object:self userInfo:status];

    [messages addObject:message];
    
    NSLog(@"%@", message);
}

@end
