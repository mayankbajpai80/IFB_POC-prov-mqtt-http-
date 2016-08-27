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
 * $RCSfile: ServiceList.h,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>

/**
 *******************************************************************************
 * @file ServiceList.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/


@class ProvisioningAppDelegate;
@class GS_ADK_Data;

/**
 *******************************************************************************
 * @ingroup ServiceList
 *******************************************************************************/

@interface ServiceList : UIView <UITableViewDataSource,UITableViewDelegate>{

	/**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
	
		ProvisioningAppDelegate *appDelegate;

	/**
	 *******************************************************************************
	 * UIKit Objects
	 *******************************************************************************/
	
		UIActivityIndicatorView *m_cObjActivity;
		
	    UITableView *lObjTableView;
		
	    UILabel *lObjSuggestionLabel;
	
	/**
	 *******************************************************************************
	 * NS suffix objects
	 *******************************************************************************/
	
		NSMutableDictionary *m_cObjDict;
		
	    NSTimer *m_cObjTimer;


}


/**
 *******************************************************************************
 * @ingroup ServiceList
 * @brief Its an shared instance of singleton ProvisioningAppDelegate class which
 *        is a subclass of UIApplication class ,having different application related
 *        methods.These methods providing the information about key events in
 *        an application’s execution such as when it finished launching, when it 
 *        is about to be terminated, when memory is low, and when important changes
 *        occur.
 *******************************************************************************/

@property(nonatomic,strong) ProvisioningAppDelegate *appDelegate;

/**
 *******************************************************************************
 * @ingroup ServiceList
 * @brief Its a dictionary holding data contains updated information about
 *        the services discovered.
 *******************************************************************************/

@property(nonatomic,strong) NSMutableDictionary *m_cObjDict;

/**
 *******************************************************************************
 * @ingroup ServiceList
 * @brief Its a timer for calling a method to stop the acitivity indicator to stop.
 *******************************************************************************/

@property(nonatomic,strong) NSTimer *m_cObjTimer;

/**
 *******************************************************************************
 * @ingroup ServiceList
 * @brief Its an activity indicator which keeps on animating till we didnot get 
 *        the information about the service discovered.
 *******************************************************************************/

@property(nonatomic,strong) UIActivityIndicatorView *m_cObjActivity;

/**
 *******************************************************************************
 * @ingroup ServiceList
 * @brief Its a tableview which shows the data stored in m_cObjDict,which holds
 *		  updated information about the services discovered.
 *******************************************************************************/

@property(nonatomic,strong) UITableView *lObjTableView;

@property (nonatomic,weak) id delegate;

@property (nonatomic, strong) GS_ADK_Data *sharedGsData;

/**
 *******************************************************************************
 * @ingroup ServiceList
 * @brief This method refreshes the discovered service list each time there is 
 * an update from bonjour-based discovery services
 *
 * @param data contains updated information about the services discovered / lost
 * @retval Returns void.
 *******************************************************************************/

-(void)refreshTableWithData:(NSMutableDictionary *)data;


- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;

@end
