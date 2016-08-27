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
 * $RCSfile: GS_ADK_Service.h,v $
 *
 * Description : Header file for GS_ADK_Service functions and data structures
 *******************************************************************************/

#import <Foundation/Foundation.h>
#import "ServiceData.h"

@protocol GS_ADK_ServiceDelegate <NSObject>

-(void)didUpdateSeriveInfo:(NSDictionary *)pObjServiceInfo;

-(void)isResolveService;

@end

@interface GS_ADK_Service : NSObject <NSNetServiceDelegate>{

//	ServiceData *m_cObjServiceData;
	
	//id <GS_ADK_ServiceDelegate> m_cObjDelegate;
	
	//NSArray *nameIdentifiers;
    
    //NSArray *textRecordIdentifiers;
    
//    NSNetService *m_cObjNetService;

}

@property (nonatomic,weak) id <GS_ADK_ServiceDelegate> m_cObjDelegate;

@property (nonatomic, strong) NSNetService *m_cObjNetService;

@property (nonatomic, strong) ServiceData *m_cObjServiceData;

@property (nonatomic,strong) NSArray *nameIdentifiers;

@property (nonatomic,strong) NSArray *textRecordIdentifiers;

- (void)serviceWithDomain:(NSString *)domain type:(NSString *)type name:(NSString *)name timeOut:(float)pObjTimeOut;

- (void)removeService:(NSNetService *)pObjNetService;

- (NSInteger)serviceCount;

- (NSDictionary *)getServiceInfo;

- (id)initWithNamePattern:(NSArray *)pObjNamePatterns textRecordPattern:(NSArray *)pObjTextRecordPatterns;

@end
