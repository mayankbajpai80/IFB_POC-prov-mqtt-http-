//
//  TCPConnection.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 13/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCPConnection : NSObject <NSStreamDelegate>
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream   *inputStream;
    NSOutputStream  *outputStream;
    
    NSMutableArray  *messages;
}

/**
 *  Establish Connection
 *
 *  @param ipAddress ipAddress
 *  @param port      port no.
 */
-(void)connectToServer: (NSString *)ipAddress :(NSString *)port;

/**
 *  Close Connection
 */
- (void)close;

#pragma mark - Machine Actions.
/**
 *  perform basic actions i.e. register, deregister.
 *
 *  @param myByteArray command TO BE SEND
 */
-(void)performAction: (NSString *)dataString;

/**
 *  Opration to be performed on Machine i.e. start/pause.
 *
 *  @param myByteArray command TO BE SEND
 */
-(void)performOprations: (NSArray *)byteArray;

/**
 *  perform wash programs i.e. cotton, eco.
 *
 *  @param byteDataArray command TO BE SEND
 */
-(void)performProgram: (NSArray *)byteDataArray;
@end
