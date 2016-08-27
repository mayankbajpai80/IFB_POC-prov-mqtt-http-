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
 * $RCSfile: ServiceData.m,v $
 *
 * Description : Header file for ServiceData functions and data structures
 *******************************************************************************/

#import "ServiceData.h"

@interface ServiceData (privateMethods)

@end

@implementation ServiceData

-(id)init {
	
    if (self = [super init]) {
	
		m_cObjDictionary = [[NSMutableDictionary alloc] init];
	}
	
    return self;
	
}

-(void)setDetails:(NSDictionary *)pObjDictionary forServiceName:(NSString *)pObjServiceName;
{
    [m_cObjDictionary setObject:pObjDictionary forKey:pObjServiceName];
}

-(void)removeService:(NSString *)pObjServiceName
{
	
	[m_cObjDictionary removeObjectForKey:pObjServiceName];
	
}

-(NSInteger)serviceCount
{
	
	return [[m_cObjDictionary allKeys] count];
	
}

-(NSDictionary *)getServiceInfo
{
	
	return m_cObjDictionary;
	
}

-(void)dealloc
{
	   
    
	m_cObjDictionary = nil;
    
    
}

@end
