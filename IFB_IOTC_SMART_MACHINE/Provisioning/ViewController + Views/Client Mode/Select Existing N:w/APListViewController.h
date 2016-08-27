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
 * $RCSfile: APListViewController.h,v $
 *
 * Description : Header file for APListViewController functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "ConfirmationViewController.h"
#import "Manual_IPSettingScreen.h"
#import "GS_ADK_DataManger.h"
#import "GS_ADK_Data.h"
#import "ScanParamsInputScreen.h"
#import "UniversalParser.h"
#import "GS_ADK_ConnectionManager.h"
#import "GSConnection.h"



/**
 *******************************************************************************
 * @file APListViewController.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup Client Mode
 *******************************************************************************/


@protocol APListViewController<NSObject>

//-(int)getAPCount;
//-(NSString *)getSSIDStrForindex:(int)index;
//-(NSString *)getSignalStrengthForindex:(int)index;
//-(NSString *)getSecurityTypeForindex:(int)index;
//-(NSString *)getChannelNoForindex:(int)index;

//-(void)deallocListData;

@end


@interface APListViewController : GSViewController <ScanParamsInputScreen,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ConfirmationViewController, GS_ADK_ConnectionManagerDelegate>{

	/**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
	
		ProvisioningAppDelegate *appDelegate;
	
		ScanParamsInputScreen *lObjScanParamScreen;
	
		GS_ADK_Data *sharedGsData;
	
		GS_ADK_DataManger *m_cObjProvData;
	
		GS_ADK_ConnectionManager *m_cObjConnectionManager;
	
		UniversalParser *m_cObjUniversalParser;
	
		ConfirmationViewController *lObjConfirmationPage;
	
		id <APListViewController> m_cObjDelegate;
    
        GSUIAlertView *m_cObjAlertView;
    
   
	
	/**
	 *******************************************************************************
	 * UIKit objects
	 *******************************************************************************/
	
		//UINavigationBar *//lObjNavBar;

		UITableView *m_cObjTable;
	
		UISegmentedControl *m_cObjSegControl;
	
	
	/**
	 *******************************************************************************
	 * NS suffix objects
	 *******************************************************************************/
	
		NSArray *m_cObjInfoArray;
	
	
	/**
	 *******************************************************************************
	 * C type variables
	 *******************************************************************************/
	
		BOOL ipAdressType;
	
		NSInteger currentSelection;
		
		BOOL refreshMode;
	
	}


//@property (nonatomic, assign) BOOL  isRequestDone;

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
 * @brief 
 *******************************************************************************/

@property(nonatomic,strong)ScanParamsInputScreen *lObjScanParamScreen;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,strong)GS_ADK_Data *sharedGsData;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief It is a shared instance of singleton GS_ADK_Data class,where all the
 *		  application data is stored in its variables.
 *******************************************************************************/

@property(nonatomic,strong)GS_ADK_DataManger *m_cObjProvData;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,strong)GS_ADK_ConnectionManager *m_cObjConnectionManager;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief Its a parser class where data is parsed and stored in a dictionary. 
 *******************************************************************************/

@property(nonatomic,strong)UniversalParser *m_cObjUniversalParser;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,strong)ConfirmationViewController *lObjConfirmationPage;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,strong)id <APListViewController> m_cObjDelegate;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

//@property(nonatomic,retain)UINavigationBar *//lObjNavBar;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,strong)UITableView *m_cObjTable;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,strong)UISegmentedControl *m_cObjSegControl;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,strong)NSArray *m_cObjInfoArray;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,assign)BOOL ipAdressType;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,assign)NSInteger currentSelection;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief 
 *******************************************************************************/

@property(nonatomic,assign)BOOL refreshMode;

@property (nonatomic, assign) BOOL saveMode;

@property (nonatomic, strong) NSMutableDictionary *concurrentDataDict;


/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method is to dismiss the confirmation screen.
 *
 * @retval Returns void.
 *******************************************************************************/

//-(void)dismissViewController;



/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method is called once Provisioning details are POSTed 
 * successfully. 
 *
 * @retval Returns void.
 *******************************************************************************/

//-(void)didConfigureSuccessfully;



///**
// *******************************************************************************
// * @ingroup Client Mode
// * @brief This method is called once Provisioning details faile to be POSTed 
// * successfully.
// *
// * @retval Returns void.
// *******************************************************************************/
//
//-(void)didFailToConfigure;

@end
