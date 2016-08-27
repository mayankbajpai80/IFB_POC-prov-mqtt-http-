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
 * $RCSfile: Manual_IPSettingScreen.h,v $
 *
 * Description : Header file for Manual_IPSettingScreen functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "GS_ADK_Data.h"

/**
 *******************************************************************************
 * @file Manual_IPSettingScreen.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup Client Mode
 *******************************************************************************/


//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"

@protocol Manual_IPSettingScreen <NSObject>

-(NSString *)getSSIDStrForindex:(int)index;
-(NSString *)getSecurityTypeForindex:(int)index;
-(NSString *)getChannelNoForindex:(int)index;

-(NSString *)getManualSSIDStrForindex:(int)index;
-(NSString *)getManualSecurityTypeForindex:(int)index;
-(NSString *)getManualChannelNoForindex:(int)index;

@end

@interface Manual_IPSettingScreen : GSViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
    /**
	 *******************************************************************************
	 * UI SUFFIX Objects
	 *******************************************************************************/
    
    
	UISegmentedControl *m_cObjSegControl;
    
	UITableView *m_cObjTableView;
    
	UITableViewCell *m_cObjTableViewCell;
    
//    UINavigationBar *//lObjNavBar;
    
    /**
	 *******************************************************************************
	 * NS SUFFIX Objects
	 *******************************************************************************/
    
    
	NSArray *m_cObjConfigLabels;
    
    /**
	 *******************************************************************************
	 * Custom Objects
	 *******************************************************************************/
    
	//ProvisioningAppDelegate *appDelegate;
    
	GS_ADK_Data *sharedGsData;
    
    id <Manual_IPSettingScreen> m_cObjDelegate;
    
	
    /**
	 *******************************************************************************
	 * C Variables
	 *******************************************************************************/
    
    int currentMode;
	
	NSInteger currentIndex;
    
    BOOL ipAdressType;
}

@property(nonatomic,strong) id <Manual_IPSettingScreen> m_cObjDelegate;

@property (nonatomic, assign) int manualSettingsEAP_Type;

@property (nonatomic, assign) BOOL saveMode;

@property (nonatomic, strong) NSMutableDictionary *concurrentDataDict;

@property (nonatomic, strong) NSMutableDictionary *summaryDataDict;

@property (nonatomic, strong) UIButton *closeButton;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method passes the row index of the selected AP from AP List. 
 *
 * @param rowNo of type int is the row index of the selected AP from AP List.
 * @retval Returns void.
 *******************************************************************************/

-(void)indexOfRow:(NSInteger)rowNo;

@end
