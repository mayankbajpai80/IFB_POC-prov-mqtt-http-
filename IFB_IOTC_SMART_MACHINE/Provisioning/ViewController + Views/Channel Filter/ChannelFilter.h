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
 * $RCSfile: ChannelFilter.h,v $
 *
 * Description : Header file for ChannelFilter functions and data structures    
 *******************************************************************************/
#import <Foundation/Foundation.h>

@interface ChannelFilter : NSObject



/**
 *******************************************************************************
 * @ingroup Parser
 * @brief This method returns the NSArray equivalent for list of Frequency Channel
 * @param freq is the float value of the list of frequencys
 * @param version is the NSString , which shows the firmware version
 * @param regDomain is the NSString, which shows the regulatoryDonain Value
 * @param mode is the BOOL value, which is to set if client mode or AP mode id selected
 * @retval Returns NSArray.
 *******************************************************************************/

+(NSArray *)getChannelListForFrequency:(float)freq firmwareVersion:(NSString *)version regulatoryDomain:(NSString *)regDomain ClientMode:(BOOL)mode;

@end
