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
 * $RCSfile: ScanParamsInputScreen.h,v $
 *
 * Description : Header file for ScanParamsInputScreen functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "GS_ADK_Data.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"
#import "GSNavigationBar.h"

#import "CustomPickerView.h"

/**
 *******************************************************************************
 * @file ScanParamsInputScreen.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup Client Mode
 *******************************************************************************/


@class ProvisionAppDelegate;

@protocol ScanParamsInputScreen<NSObject>

-(void)refresh;
-(void)dismissScanParamScreen;

@end


@interface ScanParamsInputScreen : GSViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,CustomUIAlertViewDelegate>{

	/**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
	
		ProvisioningAppDelegate *appDelegate;
	
		GS_ADK_Data *sharedGsData;
	
		id<ScanParamsInputScreen> m_cObjDelegate;

	
	/**
	 *******************************************************************************
	 * UIKit objects
	 *******************************************************************************/
	
//		UINavigationBar *//lObjNavBar;
	
		CustomPickerView *m_cObjChannelPicker;
	
		UIButton *m_cObjKeyboardRemoverButton;
	
		GSUIAlertView *m_cObjWaitScreen;
	
		UIActivityIndicatorView *m_cObjActivity;
	
	
	/**
	 *******************************************************************************
	 * NS suffix objects
	 *******************************************************************************/
	
		NSMutableArray *m_cObjTextFieldValues;
	
		NSArray *m_cObjConfigLabels;
	
		NSArray *m_cObjPickerContentArray;
	
		NSMutableArray *scanParameters;
    
}

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief Its an shared instance of singleton ProvisioningAppDelegate class which
 *        is a subclass of UIApplication class ,having different application related
 *        methods.These methods providing the information about key events in
 *        an application’s execution such as when it finished launching, when it 
 *        is about to be terminated, when memory is low, and when important changes
 *        occur.
 *******************************************************************************/

@property(nonatomic,strong)ProvisioningAppDelegate *appDelegate;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief It is a shared instance of singleton GS_ADK_Data class,where all the
 *		  application data is stored in its variables.
 *******************************************************************************/

@property(nonatomic,strong)GS_ADK_Data *sharedGsData;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief Its a delegate object.
 *******************************************************************************/

@property(nonatomic,strong)id<ScanParamsInputScreen> m_cObjDelegate;


/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief It is a button used for removing the keyboard.
 *******************************************************************************/

@property(nonatomic,strong)UIButton *m_cObjKeyboardRemoverButton;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief Its a alertview.
 *******************************************************************************/

@property(nonatomic,strong)GSUIAlertView *m_cObjWaitScreen;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,strong)UIActivityIndicatorView *m_cObjActivity;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief
 *******************************************************************************/

@property(nonatomic,strong)NSMutableArray *m_cObjTextFieldValues;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief Its an array,storing different strings ,which is to be shown in labels. 
 *******************************************************************************/

@property(nonatomic,strong)NSArray *m_cObjConfigLabels;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief Its an array,storing string objects i,e any and 1 to 14,which is used
 *   	  to set data in a picker.
 *******************************************************************************/

@property(nonatomic,strong)NSArray *m_cObjPickerContentArray;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief
 *******************************************************************************/

@property(nonatomic,strong)NSMutableArray *scanParameters;


/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method refreshes the discovered service list each time there is 
 * an update from bonjour-based discovery services
 *
 * @param data contains updated information about the services discovered / lost
 * @retval Returns void.
 *******************************************************************************/

-(void)dismissScanParamScreen;

-(void)checkForRegDomain;

@end
