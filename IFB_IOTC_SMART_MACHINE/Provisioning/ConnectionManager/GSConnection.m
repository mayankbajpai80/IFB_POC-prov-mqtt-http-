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
 * $RCSfile: GSConnection.m,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import "GSConnection.h"

@implementation GSConnection


@synthesize m_cObjDelegate,m_cObjTag,m_cObjData,connection;


-(void)startWithTag:(NSString *)pObjTag
{
    
	self.m_cObjTag = pObjTag;
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:pObjTag]];
    
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}


-(void)abortConnection
{
    [self.connection cancel];
    self.connection=nil;
}


- (void)connection:(NSURLConnection *)pObjConnection didReceiveResponse:(NSURLResponse *)response
{
	[self.m_cObjDelegate connection:self didReceiveResponse:response];
	
    self.m_cObjData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)pObjConnection didReceiveData:(NSData *)data
{
	[self.m_cObjData appendData:data];
}


- (void)connection:(NSURLConnection *)pObjConnection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)chg {
	
	/*
	 Start authentication for a given challenge.Calls useCredential:forAuthenticationChallenge:,
	 continueWithoutCredentialForAuthenticationChallenge: or cancelAuthenticationChallenge: on
	 the challenge sender when done.
	 */
	
	[self.m_cObjDelegate didReceiveAuthenticationChallenge:chg forConnection:self];
	
}


-(void)proceedWithCredential:(NSURLCredential *)pObjCredential forChallenge:(NSURLAuthenticationChallenge *)pObjChg
{
	
    [[pObjChg sender] useCredential:pObjCredential forAuthenticationChallenge:pObjChg];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)pObjConnection
{
	
    [self.m_cObjDelegate connectionFinished:self withData:m_cObjData];
    
    self.m_cObjData=nil;
    
    pObjConnection = nil;
}


- (void)connection:(NSURLConnection *)pObjConnection didFailWithError:(NSError *)error
{
	
	[self.m_cObjDelegate connectionFailed:self withError:error];
    
    self.m_cObjData=nil;
    
    pObjConnection = nil;
    
}


//-(void)dealloc {
//    
//    self.m_cObjData = nil;
//    
//    if (self.connection) {
//        
//       // [self.connection cancel];
//        
//        self.m_cObjTag = nil;
//        
//    }
//    
//	[super dealloc];
//    
//}

@end
