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
 * $RCSfile: ClientModeViewController.h,v $
 *
 * Description : Header file for ClientModeViewController functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "GS_ADK_Data.h"
#import "Options.h"
#import "ManualClientModeConfig.h"
#import "GS_ADK_ConnectionManager.h"
#import "APListViewController.h"
#import "GS_ADK_DataManger.h"
#import "UniversalParser.h"
#import "GSUIAlertView.h"
#import "WPSPINTextView.h"

/**
 *******************************************************************************
 * @file ClientModeViewController.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup Client Mode
 *******************************************************************************/


@interface ClientModeViewController : GSViewController <UITextFieldDelegate,APListViewController,GS_ADK_ConnectionManagerDelegate,UIActionSheetDelegate,OptionsDelegate>{
    
    /**
	 *******************************************************************************
	 * Custom Objects
	 *******************************************************************************/
    
	ProvisioningAppDelegate *appDelegate;
	
	GS_ADK_Data *sharedGsData;
	
	ManualClientModeConfig *m_cObjManualConfigScreen;
	
	GS_ADK_ConnectionManager *m_cObjConnectionManager;
	
	GS_ADK_DataManger *m_cObjProvData;
	
	UniversalParser *m_cObjUniversalParser;
    
    WPSPINTextView *m_cObjTextView;
    
    
    /**
	 *******************************************************************************
	 * UI suffix objects
	 *******************************************************************************/
    
    UINavigationBar *m_cObjNavBar;
    
   // UIAlertView *m_cObjAlertView;
    
    GSUIAlertView *m_cObjAlertView;
    
       UIButton *m_cObjKeyboardRemoverButton;
}

@property (nonatomic, weak) id saveConnectionObject;

@end
