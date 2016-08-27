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
 * $RCSfile: GS_ADK_DataManger.h,v $
 *
 * Description : Header file for GS_ADK_DataManger functions and data structures
 *******************************************************************************/
#import <Foundation/Foundation.h>


/**
 *******************************************************************************
 * @file GS_ADK_DataManger.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup App Data
 *******************************************************************************/



@interface GS_ADK_DataManger : NSObject {

}




/**
 *******************************************************************************
 * @ingroup App Data
 * @brief This method returns the NSDictionary equivalent for xml Data
 *
 * @param pObjData of type NSData should be an xml data
 * @param pObjParser of type id should be an xml Parser.
 *        Ex: UniversalParser for parsing xml
 *
 * @retval Returns NSMutableDictionary.
 *******************************************************************************/

-(NSMutableDictionary *)processData:(NSData *)pObjData withParser:(id)pObjParser;


@end
