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
 * $RCSfile: APSettingsViewController.h,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "GS_ADK_Data.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"

/**
 *******************************************************************************
 * @file APSettingsViewController.h
 * @ingroup Server_Setting_Mode
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/



@interface APSettingsViewController : GSViewController <UIActionSheetDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

	/**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
	
		//ProvisioningAppDelegate *appDelegate;
	
		GS_ADK_Data *sharedGsData;

	/**
	 *******************************************************************************
	 * UIKit objects
	 *******************************************************************************/
	
		//UINavigationBar *//lObjNavBar;
	
		UISegmentedControl *m_cObjSegControl;
	
		UITableView *lObjTableView;
	
		UILabel *m_cObjSecurityWarningLabel;
    
        UIButton *m_cObjConfirmButton;
	
	/**
	 *******************************************************************************
	 * NS suffix objects
	 *******************************************************************************/
	
		NSArray *m_cObjInputLabels;
	
	/**
	 *******************************************************************************
	 * C type variables
	 *******************************************************************************/
	
		BOOL postDone;
	
		BOOL checkForEmptyFields;
		
    
        float statusBar_Height;
}

/**
 *******************************************************************************
 * @ingroup Server_Setting_Mode
 * @brief Its an shared instance of singleton ProvisioningAppDelegate class which
 *        is a subclass of UIApplication class ,having different application related
 *        methods.These methods providing the information about key events in
 *        an application’s execution such as when it finished launching, when it 
 *        is about to be terminated, when memory is low, and when important changes
 *        occur.
 *******************************************************************************/

//@property(nonatomic,strong)ProvisioningAppDelegate *appDelegate;

/**
 *******************************************************************************
 * @ingroup Server_Setting_Mode
 * @brief It is a shared instance of singleton GS_ADK_Data class,where all the
 *		  application data is stored in its variables.
 *******************************************************************************/

@property(nonatomic,strong)GS_ADK_Data *sharedGsData;

/**
 *******************************************************************************
 * @ingroup Server_Setting_Mode
 * @brief Its a custom navigationbar where the back button,info button,set mode 
 *        button , mode label showing mode information and info header is placed.
 *******************************************************************************/

//@property(nonatomic,retain)UINavigationBar *//lObjNavBar;

/**
 *******************************************************************************
 * @ingroup Server_Setting_Mode
 * @brief Its a custom segment control having a options of enabling/disabling
 *        authentication.
 *******************************************************************************/

@property(nonatomic,strong)UISegmentedControl *m_cObjSegControl;

/**
 *******************************************************************************
 * @ingroup Server_Setting_Mode
 * @brief Its a table showing information like username,password,confirm password
          in its cells.
 *******************************************************************************/

@property(nonatomic,strong)UITableView *lObjTableView;

/**
 *******************************************************************************
 * @ingroup Server_Setting_Mode
 * @brief Its a label,which is used to show the warning.
 *******************************************************************************/

@property(nonatomic,strong)UILabel *m_cObjSecurityWarningLabel;

/**
 *******************************************************************************
 * @ingroup Server_Setting_Mode
 * @brief Its an array of string objects for showing in different cells of table.
 *******************************************************************************/

@property(nonatomic,strong)NSArray *m_cObjInputLabels;

/**
 *******************************************************************************
 * @ingroup Server_Setting_Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,assign)BOOL postDone;

@end
