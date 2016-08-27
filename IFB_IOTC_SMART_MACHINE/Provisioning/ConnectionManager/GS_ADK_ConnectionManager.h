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
 * $RCSfile: GS_ADK_ConnectionManager.h,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import <Foundation/Foundation.h>

/**
 *******************************************************************************
 * @file GS_ADK_ConnectionManager.h
 * @brief This is the interface for ServiceList implementation class. This class
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup HTTP
 *******************************************************************************/


#import "GSConnection.h"

@protocol GS_ADK_ConnectionManagerDelegate <NSObject>

/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method will be called once a class implements
 * GS_ADK_ConnectionManager delegate.
 *
 * @param pObjAutoUpdate of type BOOL determines whether the connections need to
 * be established repeatedly or not.
 * @retval Returns void.
 *******************************************************************************/

-(void)connection:(GSConnection *)pObjConnection didReceiveResponse:(NSURLResponse *)pObjResponse;



/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method establishes NSURLConnection objects for given URLs. It also
 * sets other parameters such as pObjAutoUpdate and pObjUpdateInterval.
 *
 * @param pObjAutoUpdate of type BOOL determines whether the connections need to
 * be established repeatedly or not.
 * @retval Returns void.
 *******************************************************************************/

-(void)connection:(GSConnection *)pObjConnection endedWithData:(NSData *)pObjData;



/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method establishes NSURLConnection objects for given URLs. It also
 * sets other parameters such as pObjAutoUpdate and pObjUpdateInterval.
 *
 * @param pObjAutoUpdate of type BOOL determines whether the connections need to
 * be established repeatedly or not.
 * @retval Returns void.
 *******************************************************************************/

-(void)connectionFailed:(GSConnection *)pObjConnection withError:(NSError *)pObjError;



/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method establishes NSURLConnection objects for given URLs. It also
 * sets other parameters such as pObjAutoUpdate and pObjUpdateInterval.
 *
 * @param pObjAutoUpdate of type BOOL determines whether the connections need to
 * be established repeatedly or not.
 * @retval Returns void.
 *******************************************************************************/

-(void)didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg forConnection:(GSConnection *)pObjConnection;

@end

@interface GS_ADK_ConnectionManager : NSObject {
    
    BOOL m_cObjAutoUpdate;
    
    float m_cObjUpdateInterval;
    
    NSArray *m_cObjServiceURLs;
    
    GSConnection *lObjConnection;
    
   // id <GS_ADK_ConnectionManagerDelegate> m_cObjDelegate;
    
}

@property (nonatomic, assign) BOOL m_cObjAutoUpdate;

@property (nonatomic, assign) float m_cObjUpdateInterval;

@property (nonatomic, retain) NSArray *m_cObjServiceURLs;

@property (nonatomic, retain) GSConnection *lObjConnection;

//@property (nonatomic, retain) NSMutableDictionary *m_cObjDictionary;

@property (nonatomic, weak) id <GS_ADK_ConnectionManagerDelegate> m_cObjDelegate;




/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method establishes NSURLConnection objects for given URLs. It also
 * sets other parameters such as pObjAutoUpdate and pObjUpdateInterval.
 *
 * @param pObjAutoUpdate of type BOOL determines whether the connections need to
 * be established repeatedly or not.
 * @retval Returns void.
 *******************************************************************************/

-(void)connectWithURLStrings:(NSArray *)pObjURLStrs autoUpdate:(BOOL)pObjAutoUpdate updateInterval:(float)pObjUpdateInterval;



/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method refreshes the discovered service list each time there is
 * an update from bonjour-based discovery services
 *
 * @param data contains updated information about the services discovered / lost
 * @retval Returns void.
 *******************************************************************************/

-(void)setUpdateInterval:(float)pObjUpdateInterval;



/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method refreshes the discovered service list each time there is
 * an update from bonjour-based discovery services
 *
 * @param data contains updated information about the services discovered / lost
 * @retval Returns void.
 *******************************************************************************/

-(void)setAutoUpdate:(BOOL)pObjAutoUpdate;



/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method refreshes the discovered service list each time there is
 * an update from bonjour-based discovery services
 *
 * @param data contains updated information about the services discovered / lost
 * @retval Returns void.
 *******************************************************************************/

-(void)proceedWithCredential:(NSURLCredential *)pObjCredential forChallenge:(NSURLAuthenticationChallenge *)pObjChg forConnection:(GSConnection *)pObjConnection;



/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method refreshes the discovered service list each time there is
 * an update from bonjour-based discovery services
 *
 * @param data contains updated information about the services discovered / lost
 * @retval Returns void.
 *******************************************************************************/

-(void)abortConnection:(GSConnection *)pObjConnection;

@end
