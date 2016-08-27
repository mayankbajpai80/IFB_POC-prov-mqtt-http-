/*******************************************************************************
 *
 *               COPYRIGHT (c) 2009-2010 GainSpan Corporation
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
 * $RCSfile: GS_ADK_ConnectionManager.m,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import "GS_ADK_ConnectionManager.h"
#import "GSConnection.h"


@interface GS_ADK_ConnectionManager (privateMethods) <GSConnectionDelegate>

-(void)repeatConnection;

@end

@implementation GS_ADK_ConnectionManager



@synthesize m_cObjAutoUpdate,m_cObjServiceURLs,m_cObjUpdateInterval,m_cObjDelegate, lObjConnection;

-(id)init
{
    self = [super init];
    
    if (self) {
        
        //
    }
    
    return self;
}

-(void)connectWithURLStrings:(NSArray *)pObjURLStrs autoUpdate:(BOOL)pObjAutoUpdate updateInterval:(float)pObjUpdateInterval
{
    
    if (m_cObjServiceURLs) {
        
        m_cObjServiceURLs = nil;
    }
    
	m_cObjServiceURLs = [[NSArray alloc] initWithArray:pObjURLStrs];
	
	m_cObjAutoUpdate = pObjAutoUpdate;
	
	m_cObjUpdateInterval = pObjUpdateInterval;
    
    
	for (int tempCount=0; tempCount < [m_cObjServiceURLs count]; tempCount++) {
        
        lObjConnection = [[GSConnection alloc] init];
        
		[lObjConnection setM_cObjDelegate:self];
        
		[lObjConnection startWithTag:[pObjURLStrs objectAtIndex:tempCount]];
		
	}
}

-(void)connectWithURLString:(NSString *)pObjStr
{
    
    lObjConnection = [[GSConnection alloc] init];
	[lObjConnection setM_cObjDelegate:self];
	[lObjConnection startWithTag:pObjStr];
    
}

-(void)abortConnection:(GSConnection *)connection
{
    //    GSConnection *lObjConnection = (GSConnection *)[m_cObjDictionary objectForKey:pObjConnectionTag];
    
    [connection abortConnection];
}

-(void)setUpdateInterval:(float)pObjUpdateInterval
{
	
	m_cObjUpdateInterval = pObjUpdateInterval;
	
}

-(void)setAutoUpdate:(BOOL)pObjAutoUpdate
{
	
	if (m_cObjAutoUpdate == NO && pObjAutoUpdate == YES) {
		
		[self repeatConnection];
		
	}
    
	m_cObjAutoUpdate = pObjAutoUpdate;
    
}

-(void)repeatConnection
{
    
	for (int tempCount=0; tempCount < [m_cObjServiceURLs count]; tempCount++) {
		
        
        lObjConnection = [[GSConnection alloc] init];
		[lObjConnection setM_cObjDelegate:self];
		[lObjConnection startWithTag:[m_cObjServiceURLs objectAtIndex:tempCount]];
		
	}
}


-(void)connection:(GSConnection *)pObjConnection didReceiveResponse:(NSURLResponse *)pObjResponse
{
    
    [m_cObjDelegate connection:pObjConnection didReceiveResponse:pObjResponse];
    
}

-(void)connectionFinished:(GSConnection *)pObjConnection withData:(NSData *)pObjData
{
	
	if (m_cObjAutoUpdate == YES) {
		
		[self performSelector:@selector(repeatConnection) withObject:nil afterDelay:m_cObjUpdateInterval];
		
	}else {
		
		
	}
    
	[m_cObjDelegate connection:pObjConnection endedWithData:pObjData];
    
}

-(void)connectionFailed:(GSConnection *)pObjConnection withError:(NSError *)pObjError
{
	
	if (m_cObjAutoUpdate == YES) {
		
		[self performSelector:@selector(repeatConnection) withObject:self afterDelay:0];
		
	}
	else {
		
	}
	
	[m_cObjDelegate connectionFailed:pObjConnection withError:(NSError *)pObjError];
    
}

-(void)didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg forConnection:(GSConnection *)pObjConnection;
{
	
	[m_cObjDelegate didReceiveAuthenticationChallenge:pObjChg forConnection:pObjConnection];
    
    
}

-(void)proceedWithCredential:(NSURLCredential *)pObjCredential forChallenge:(NSURLAuthenticationChallenge *)pObjChg forConnection:(GSConnection *)pObjConnection
{
    
    [pObjConnection proceedWithCredential:pObjCredential forChallenge:pObjChg];
    
}

//-(void)dealloc
//{
//    
//    if (m_cObjServiceURLs) {
//        
//        [m_cObjServiceURLs release];
//        
//    }
//    
//    if (lObjConnection) {
//        
//        [lObjConnection release];
//    }
//    
//	m_cObjDelegate=nil;
//	
//	[super dealloc];
//	
//}

@end

