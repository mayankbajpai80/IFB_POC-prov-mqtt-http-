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
 * $RCSfile: LimitedAPIPSettingsScreen.h,v $
 *
 * Description : Header file for LimitedAPIPSettingsScreen functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "GS_ADK_Data.h"
#import "GSViewController.h"

/**
 *******************************************************************************
 * @file LimitedAPIPSettingsScreen.h
 * @ingroup Limited AP Mode
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 *******************************************************************************/


@class ProvisioningAppDelegate;

@interface LimitedAPIPSettingsScreen : GSViewController <UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
	/**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
	
    ProvisioningAppDelegate *appDelegate;
	
    GS_ADK_Data *sharedGsData;
    
	
	/**
	 *******************************************************************************
	 * UIKit objects
	 *******************************************************************************/
	
    UINavigationBar *m_cObjNavBar;
	
    UITableView *m_cObjTable;
	
    UIButton *m_cObjKeyboardRemoverButton;
	
	
	/**
	 *******************************************************************************
	 * NS suffix objects
	 *******************************************************************************/
	
    NSArray *m_cObjConnParameters;
	
    NSArray *m_cObjTitles;
	
    NSMutableArray *m_cObjFieldTitles;
	
    NSDictionary *FieldTitles;
    
    NSString *security_str;
    
	/**
	 *******************************************************************************
	 * C type variables 
	 *******************************************************************************/
	
    BOOL DHCP_Enabled;
	
    BOOL DNS_Enabled;
	
}

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
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
 * @ingroup Limited AP Mode
 * @brief It is a shared instance of singleton GS_ADK_Data class,where all the
 *		  application data is stored in its variables.
 *******************************************************************************/

@property(nonatomic,strong)GS_ADK_Data *sharedGsData;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a custom navigationbar where the back button ,info button,set mode 
 *        button and info header is placed.
 *******************************************************************************/


@property(nonatomic,strong)UINavigationBar *m_cObjNavBar;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a tableview which is showing the data like IP Settings information 
 *        in different section.
 *******************************************************************************/

@property(nonatomic,strong)UITableView *m_cObjTable;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief It is a button used for removing the keyboard.
 *******************************************************************************/

@property(nonatomic,strong)UIButton *m_cObjKeyboardRemoverButton;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its an array sotring different values like SSID , Channel information,
 Beacon interval ,security, ip address etc.   
 *******************************************************************************/

@property(nonatomic,strong)NSArray *m_cObjConnParameters;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its an array holding titles like Enable DHCP Server,Enable DNS Server.
 *******************************************************************************/

@property(nonatomic,strong)NSArray *m_cObjTitles;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its an array holding different array objects ,storing different titles.
 *******************************************************************************/

@property(nonatomic,strong)NSMutableArray *m_cObjFieldTitles;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a dictionary storing different titles with key.
 *******************************************************************************/

@property(nonatomic,strong)NSDictionary *FieldTitles;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a boolean vairiable for checking whether DHCP is enabled or disable.
 *******************************************************************************/

@property(nonatomic,assign)BOOL DHCP_Enabled;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a boolean vairiable for checking whether DNS is enabled or disable.
 *******************************************************************************/

@property(nonatomic,assign)BOOL DNS_Enabled;

@property(nonatomic,strong)NSString *security_str;

@property (nonatomic, assign) BOOL saveMode;


@end
