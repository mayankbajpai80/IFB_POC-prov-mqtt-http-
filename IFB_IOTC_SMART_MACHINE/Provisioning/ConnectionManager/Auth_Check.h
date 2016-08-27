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
 * $RCSfile: Auth_Check.h,v $
 *
 * Description : Header file for Auth_Check functions and data structures
 *******************************************************************************/


#import <Foundation/Foundation.h>

/**
 *******************************************************************************
 * @file Auth_Check.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup HTTP
 *******************************************************************************/

@interface Auth_Check : NSObject {
    
    /**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
    
    /**
	 *******************************************************************************
	 * NS suffix objects
	 *******************************************************************************/
    
    NSString *currentURL_Str;
	
	NSURLAuthenticationChallenge *m_cObjAuthChg;
	
    /**
	 *******************************************************************************
	 * C Variables
	 *******************************************************************************/
    
	int count;
    
	
}

@property (nonatomic,weak) id delegate;



/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method starts an NSURLConnection and allocates and initialzes
 * the currentURL_Str NSString object.
 *
 * @param url of type NSURL contains the URL on which is used to check HTTP 
 * authentication.
 * @retval Returns void.
 *******************************************************************************/

//-(void)checkWithURL:(NSURL *)url;

- (void)checkWithURL:(NSURL *)url withDelegate:(id)delegate;


/**
 *******************************************************************************
 * @ingroup HTTP
 * @brief This method refreshes the discovered service list each time there is 
 * an update from bonjour-based discovery services
 *
 * @param pObjCredential of Type NSURLCredential contains user's credentials 
 *        using which HTTP authentication is tried.
 *
 * @param pObjChg of Type NSURLAuthenticationChallenge is the Authentication
 * challenge for which the credentials will be sent.
 * @retval Returns void.
 *******************************************************************************/

-(void)proceedWithCredential:(NSURLCredential *)pObjCredential forChallenge:(NSURLAuthenticationChallenge *)pObjChg;


/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method is called when HTTP Authentication is successfully
 * complete.
 *
 * @retval Returns void.
 *******************************************************************************/

//-(void)authentictionDone;




@end
