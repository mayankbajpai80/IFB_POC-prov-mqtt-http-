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
 * $RCSfile: GSConnection.h,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import <Foundation/Foundation.h>

@class GSConnection;

@protocol GSConnectionDelegate <NSObject>

-(void)connection:(GSConnection *)pObjConnection didReceiveResponse:(NSURLResponse *)pObjResponse;

-(void)connectionFinished:(GSConnection *)pObjConnection withData:(NSData *)pObjData;

-(void)connectionFailed:(GSConnection *)pObjConnection withError:(NSError *)pObjError;

-(void)didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg forConnection:(GSConnection *)pObjConnection;

@end


@interface GSConnection : NSObject {
    
	//id <GSConnectionDelegate> m_cObjDelegate;
	
	NSString *m_cObjTag;
	
	NSMutableData *m_cObjData;
	
	NSURL *url;
	
    NSURLRequest *request;
    
	
}

@property (nonatomic, weak) id <GSConnectionDelegate> m_cObjDelegate;
@property (nonatomic, retain) NSString *m_cObjTag;
@property (nonatomic, retain) NSMutableData *m_cObjData;
@property (nonatomic, retain) NSURLConnection *connection;

-(void)startWithTag:(NSString *)pObjTag;

-(void)proceedWithCredential:(NSURLCredential *)pObjCredential forChallenge:(NSURLAuthenticationChallenge *)pObjChg;

-(void)abortConnection;

@end
