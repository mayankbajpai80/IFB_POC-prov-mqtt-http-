/*******************************************************************************
 *
 *               COPYRIGHT (c) 2012-2014 GainSpan GainSpan Corporation
 *                         All Rights Reserved
 *
 * The source code contained or described herein and all documents
 * related to the source code ("Material") are owned by GainSpan
 * Corporation or its licensors.  Title to the Material remains
 * with GainSpan Corporation or its suppliers and licensors.
 *
 * The Material is protected by worldwide copyright and trade secret
 * laws and treaty provisions. No part of the Material may be used,
 * copied, reproduced, modified, published, uploaded, posted, transmitted,
 * distributed, or disclosed in any way except in accordance with the
 * applicable license agreement.
 *
 * No license under any patent, copyright, trade secret or other
 * intellectual property right is granted to or conferred upon you by
 * disclosure or delivery of the Materials, either expressly, by
 * implication, inducement, estoppel, except in accordance with the
 * applicable license agreement.
 *
 * Unless otherwise agreed by GainSpan in writing, you may not remove or
 * alter this notice or any other notice embedded in Materials by GainSpan
 * or GainSpan's suppliers or licensors in any way.
 *
 * $RCSfile: GS_ADK_Service.m,v $
 *
 * Description : Header file for GS_ADK_Service functions and data structures
 *******************************************************************************/

#import "GS_ADK_Service.h"
#import "ServiceData.h"
#import "GS_ADK_ServiceManager.h"
#include <arpa/inet.h>

@interface GS_ADK_Service (privateMethods)

-(void)addService:(NSNetService *)pObjNetService;

- (NSString *)getStringFromAddressData:(NSData *)dataIn;

@end

@implementation GS_ADK_Service

//@synthesize m_cObjDelegate,nameIdentifiers,textRecordIdentifiers;

- (id)initWithNamePattern:(NSArray *)pObjNamePatterns textRecordPattern:(NSArray *)pObjTextRecordPatterns{
	
    if (self = [super init]) {
		
		_m_cObjServiceData = [[ServiceData alloc] init];
		
        _nameIdentifiers = [[NSArray alloc] initWithArray:pObjNamePatterns];
        
        _textRecordIdentifiers = [[NSArray alloc] initWithArray:pObjTextRecordPatterns];

	}
	
    return self;
	
}

-(void)serviceWithDomain:(NSString *)domain type:(NSString *)type name:(NSString *)name timeOut:(float)pObjTimeOut {

	_m_cObjNetService = [[NSNetService alloc] initWithDomain:domain type:type name:name];
    
	[_m_cObjNetService setDelegate: self];
    
	[_m_cObjNetService resolveWithTimeout: pObjTimeOut];

}

-(void)netServiceDidResolveAddress:(NSNetService *)sender {
	   
	NSNetService *service = (NSNetService *)sender;
    
    NSLog(@"netServiceDidResolveAddress = %@",service.name);
        
    NSDictionary *lObjTextRecord = [NSDictionary dictionaryWithDictionary:[NSNetService dictionaryFromTXTRecordData:[service TXTRecordData]]];
    
    
    if ([lObjTextRecord objectForKey:@"api"] != nil) {
        
        for (int i = 0; i < [_textRecordIdentifiers count]; i++) {
            

           // NSLog(@">>>>>>>>>> %@",[[lObjTextRecord objectForKey:@"api"] bytes]);
            
        //    NSString *string = [NSString stringWithUTF8String:[[lObjTextRecord objectForKey:@"api"] bytes]];
            
            NSString *string = [[NSString alloc] initWithData:[lObjTextRecord objectForKey:@"api"] encoding:NSUTF8StringEncoding];
            
            if ([string length] < [[_textRecordIdentifiers objectAtIndex:i] length]) {
                
                continue;
            }
            
            NSArray *lObjArray = [NSArray arrayWithArray:[string componentsSeparatedByString:@":"]];
            
            
            if (lObjArray.count != 3) {
                
                continue;
            }
            
            if ([[lObjArray objectAtIndex:0] isEqualToString:[_textRecordIdentifiers objectAtIndex:i]]) {
                
                [self addService:sender];
                
            }
            
        }
        
    }
    
    else {
        
                
            for (int i = 0; i < [_nameIdentifiers count]; i++) {
                
                NSRange textRange = [[service name] rangeOfString:[_nameIdentifiers objectAtIndex:i] options:NSCaseInsensitiveSearch];
                
                if(textRange.location != NSNotFound){
                    
                    [self addService:sender];
                    
                    continue;
                    
                    
                }
                
        }
    }

    [_m_cObjDelegate isResolveService];
}

-(void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	
	[_m_cObjDelegate isResolveService];
}

-(void)addService:(NSNetService *)pObjNetService {
	
    if ([pObjNetService TXTRecordData]) {
        
        NSMutableDictionary *lObjTextRecord = [NSMutableDictionary dictionaryWithDictionary:[NSNetService dictionaryFromTXTRecordData:[pObjNetService TXTRecordData]]];
        
        [lObjTextRecord setObject:[pObjNetService hostName] forKey:@"hostName"];
        
        if ([pObjNetService addresses]) {
            
            if ([[pObjNetService addresses] count] > 0) {
                
                //NSLog(@"<%@>",[self getStringFromAddressData:[[pObjNetService addresses] objectAtIndex:0]]);
                
                [lObjTextRecord setObject:[self getStringFromAddressData:[[pObjNetService addresses] objectAtIndex:0]] forKey:@"ipAddress"];
                
                [_m_cObjServiceData setDetails:lObjTextRecord forServiceName:[pObjNetService name]];

                [_m_cObjDelegate didUpdateSeriveInfo:[_m_cObjServiceData getServiceInfo]];

            }
         }
//        else
//        {
//        
//            [lObjTextRecord setObject:@"" forKey:@"ipAddress"];
//
//        }
        
    }
	else
    {
        
        NSArray *lObjObjects = [NSArray arrayWithObjects:[pObjNetService hostName],[self getStringFromAddressData:[[pObjNetService addresses] objectAtIndex:0]],nil];
        
        NSArray *lObjKeys = [NSArray arrayWithObjects:@"hostName",@"ipAddress",nil];

        NSMutableDictionary *lObjDictionary = [NSMutableDictionary dictionaryWithObjects:lObjObjects forKeys:lObjKeys];
        
        [_m_cObjServiceData setDetails:lObjDictionary forServiceName:[pObjNetService name]];
        
        [_m_cObjDelegate didUpdateSeriveInfo:[_m_cObjServiceData getServiceInfo]];
		
    }
    
}

- (NSString *)getStringFromAddressData:(NSData *)dataIn {
    
    struct sockaddr_in  *socketAddress = nil;
    
    NSString            *ipString = nil;
    
    socketAddress = (struct sockaddr_in *)[dataIn bytes];
    
    ipString = [NSString stringWithFormat: @"%s:%d",inet_ntoa(socketAddress->sin_addr),ntohs(socketAddress->sin_port)];
    
    return ipString;
    
}

-(void)removeService:(NSNetService *)pObjNetService {
	
	[_m_cObjServiceData removeService:[pObjNetService name]];
    
	[_m_cObjDelegate didUpdateSeriveInfo:[_m_cObjServiceData getServiceInfo]];
	
}

-(NSInteger)serviceCount
{
	
	return [_m_cObjServiceData serviceCount];
	
}

-(NSDictionary *)getServiceInfo
{
	
	return [_m_cObjServiceData getServiceInfo];
	
}


@end

