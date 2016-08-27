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
 * $RCSfile: InfoScreen.h,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "GS_ADK_Data.h"
#import "GSViewController.h"
/**
 *******************************************************************************
 * @file InfoScreen.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup InfoScreen
 *******************************************************************************/


@interface InfoScreen : GSViewController <UITableViewDataSource,UITableViewDelegate>{

	/**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
	
		GS_ADK_Data *sharedGsData;
	
	/**
	 *******************************************************************************
	 * UIKit objects
	 *******************************************************************************/
		
//		UINavigationBar *//lObjNavBar;
		
	    UITableView *m_cObjTable;

	/**
	 *******************************************************************************
	 * NS suffix objects
	 *******************************************************************************/
	
		NSArray *m_cObjTitles;
		
	    NSArray *m_cObjValues;
		
	

}

/**
 *******************************************************************************
 * @ingroup InfoScreen
 * @brief It is a shared instance of singleton GS_ADK_Data class,where all
 *		  application data is stored in its variables.
 *******************************************************************************/

@property(nonatomic,strong)GS_ADK_Data *sharedGsData;

/**
 *******************************************************************************
 * @ingroup InfoScreen
 * @brief Its a custom navigationbar where the backbutton and info header is placed
          on top of the view.
 *******************************************************************************/

//@property(nonatomic,retain)UINavigationBar *//lObjNavBar;

/**
 *******************************************************************************
 * @ingroup InfoScreen
 * @brief Its a tableview object which is showing System Identification,Firmware 
          Info,iOS app info,IP Settings Data.
 *******************************************************************************/

@property(nonatomic,strong)UITableView *m_cObjTable;

/**
 *******************************************************************************
 * @ingroup InfoScreen
 * @brief Its an array which is holding different array objects, which are 
 *        holding diffent titles.
 *******************************************************************************/

@property(nonatomic,strong)NSArray *m_cObjTitles;


@end
