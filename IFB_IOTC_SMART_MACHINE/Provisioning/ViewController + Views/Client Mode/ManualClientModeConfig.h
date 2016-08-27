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
 * $RCSfile: ManualClientModeConfig.h,v $
 *
 * Description : Header file for ManualClientModeConfig functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "Manual_IPSettingScreen.h"
#import "GS_ADK_Data.h"
#import "WPAModeButtonView.h"
#import "CertificateBrowser.h"
#import "CustomPickerView.h"
#import "ConcurrentModeInfoViewController.h"

/**
 *******************************************************************************
 * @file ManualClientModeConfig.h
 * @brief This is the interface for ServiceList implementation class. This class
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup Client Mode
 *******************************************************************************/


@class ProvisioningAppDelegate;
//@class ConfirmationViewController;

@protocol ManualClientModeConfig <NSObject>

//-(NSArray *)getManualConfigData;

@end


@interface ManualClientModeConfig : GSViewController <CertificateBrowserDelegate,WPAModeButtonDelegate,UIActionSheetDelegate,Manual_IPSettingScreen,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>{
	
    /**
	 *******************************************************************************
	 * UI suffix objects
	 *******************************************************************************/
    
	
	UITableView *m_cObjtableView;
	
	UISegmentedControl *m_cObjSegControl;
	
	UILabel *m_cObjChannelInfo;
	
	CustomPickerView *m_cObjChannelPicker;
    
	UIButton *m_cObjKeyboardRemoverButton;
	
    UILabel *m_cObjModeDescriptionLabel;
    
	UIButton *m_cObjRootCertButton;
    
    UIButton *m_cObjClientCertButton;
	
    UIButton *m_cObjClientKeyButton;
	
    CustomPickerView *m_cObjSecurityPicker;
    
    
    
    
    /**
	 *******************************************************************************
	 * NS suffix objects
	 *******************************************************************************/
    
	//NSMutableArray *m_cObjCredentails;
	
    NSArray *m_cObjPickerContentArray;
	
    NSMutableArray *m_cObjTextFieldValues;
    
	NSMutableArray *m_cObjInfoArray;
    
	NSString *m_cObjPasswordBackup;
    
	NSString *m_cObjKeyBackup;
    
	NSMutableArray *m_cObjManualConfiguration;
	
    NSMutableDictionary *m_cObjChannelData;
    
	NSDictionary *FieldTitles;
    
    NSMutableArray *m_cObjSecurityTypes;
    
    
    NSURLConnection *fileUploadConnection;
    
    NSURLConnection *utcTimeConnection;
	
    
    /**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
    
	ProvisioningAppDelegate *appDelegate;
	
	GS_ADK_Data *sharedGsData;
	
	Manual_IPSettingScreen *m_cObjManual_IPSettingScreen;
    
    CertificateBrowser *m_cObjBrowser;
    
	id <ManualClientModeConfig> m_cObjDelegate;
    
    ConcurrentModeInfoViewController *concurrentInfoController;
    
	
    
    /**
	 *******************************************************************************
	 * C Variables
	 *******************************************************************************/
    
    
    int  chip_version_correction;
    
    float bandValue;
	
    int bandSelectionIndex;
    
   // BOOL ipAdressType;
	
	BOOL pickerMode;
	
	int wepAuthType;
	
	int wpaAuthType;
	
	int eapType;
		
	BOOL passwordSecurityStatus;
    
    
}

@property(nonatomic,strong)id <ManualClientModeConfig> m_cObjDelegate;

@property(nonatomic,assign)BOOL passwordSecurityStatus;

@property (nonatomic,assign)    int  chip_version_correction;

@property (nonatomic,assign)    float bandValue;


/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method is called when configuration is set and next button is clicked
 * it checks the given SSID value is a valid or not if valid, it returns YES.
 * @retval Returns BOOL.
 *******************************************************************************/


-(BOOL)checkForSSIDLength;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method is called to resign the textfield's keyboard
 * @retval Returns void.
 *******************************************************************************/

-(void)resignKeyPad;



@end
