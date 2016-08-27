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
 * $RCSfile: GS_ADK_ServiceManager.h,v $
 *
 * Description : Header file for GS_ADK_ServiceManager functions and data structures
 *******************************************************************************/

#import <Foundation/Foundation.h>
#import "GS_ADK_Service.h"

@protocol GS_ADK_ServiceManagerDelegate <NSObject>

@required

-(void)didUpdateSeriveInfo:(NSDictionary *)pObjServiceInfo;

-(void)discoveryDidFail;

@end


/**
 *******************************************************************************
 * @defgroup Discovery
 * @brief This module find the service.
 * 
 *******************************************************************************/


@interface GS_ADK_ServiceManager : NSObject {
	
	float m_cObjTimeOut;
		
	NSNetServiceBrowser *bonjourBrowser;
	
	NSTimer *m_cObjTimer;
    
    NSString *m_cObjServiceType;
    
    NSString *m_cObjDomainName;
    
}

@property (nonatomic,weak) id <GS_ADK_ServiceManagerDelegate> m_cObjDelegate;

@property (nonatomic, strong) GS_ADK_Service *m_cObjService;

@property (nonatomic, strong) NSMutableArray *serviceArray;

@property (nonatomic, assign) NSInteger serviceCount;


-(id)initWithTimeOut:(float)pObjTimeOut namePattern:(NSArray *)pObjNamePatterns textRecordPattern:(NSArray *)pObjTextRecordPatterns serviceType:(NSString *)pObjServiceType domainName:(NSString *)pObjDomainName;


-(void)startDiscovery;

-(void)stopDiscovery;

@end
