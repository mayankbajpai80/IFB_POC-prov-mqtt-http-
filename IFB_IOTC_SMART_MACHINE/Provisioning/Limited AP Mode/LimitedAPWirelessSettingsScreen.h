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
 * $RCSfile: LimitedAPWirelessSettingsScreen.h,v $
 *
 * Description : Header file for LimitedAPWirelessSettingsScreen functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "GS_ADK_Data.h"
#import "LimitedAPIPSettingsScreen.h"
#import "CustomPickerView.h"
/**
 *******************************************************************************
 * @defgroup Limited AP Mode
 *******************************************************************************/

/**
 *******************************************************************************
 * @file LimitedAPWirelessSettingsScreen.h
 * @ingroup Limited AP Mode
 * @brief This is the interface for ServiceList implementation class. This class
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/




@class ProvisioningAppDelegate;

@interface LimitedAPWirelessSettingsScreen : GSViewController <UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
	/**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
	
    ProvisioningAppDelegate *appDelegate;
    
    GS_ADK_Data *sharedGsData;
    
    LimitedAPIPSettingsScreen *m_cObjIPSettingsScreen;
	
	
	/**
	 *******************************************************************************
	 * UIKit objects
	 *******************************************************************************/
	
//    UINavigationBar *//lObjNavBar;
	
    UISegmentedControl *m_cObjSegControl;
	
    UITableView *m_cObjTableView;
	
    UISlider *m_cObjChannelSelector;
	
    UILabel *m_cObjChannelInfo;
	
    CustomPickerView *m_cObjChannelPicker;
	
    UIButton *m_cObjKeyboardRemoverButton;
	
    UILabel *m_cObjModeDescriptionLabel;
	
	
	/**
	 *******************************************************************************
	 * NS suffix objects
	 *******************************************************************************/
	
    NSString *m_cObjPasswordBackup;
    
    NSString *security_string;
	
    NSString *m_cObjKeyBackup;
	
    NSMutableArray *m_cObjAPCredentails;
	
    NSMutableArray *m_cObjFieldCredentails;
	
    NSArray *m_cObjPickerContentArray;
	
    NSString *m_cObjModeDescription;
    
    /**
	 *******************************************************************************
	 * C type variables
	 *******************************************************************************/
	
    BOOL ipAdressType;
	
    BOOL passwordSecurityStatus;
    
    
    int chip_version_correction;
    int bandSelectionIndex;
    float bandValue;
    NSMutableDictionary *m_cObjChannelData ;
    
    BOOL pickerMode;
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
 * @brief It is a uiview controller class, showing the information like ipaddress,
 subnet mask,gateway etc.
 *******************************************************************************/

@property(nonatomic,strong)LimitedAPIPSettingsScreen *m_cObjIPSettingsScreen;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a custom navigationbar where the info button,set mode
 *        button , mode label showing mode information and info header is placed.
 *******************************************************************************/

//@property(nonatomic,retain)UINavigationBar *//lObjNavBar;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a segment control,showing different security options ,which enables
 *	      to know what the security is ap is having,and what we can select
 *        among none,WEP,WPA.
 *******************************************************************************/

@property(nonatomic,strong)UISegmentedControl *m_cObjSegControl;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a table showing the information like SSID,Channel,Beacon,Security.
 *******************************************************************************/

@property(nonatomic,strong)UITableView *m_cObjTableView;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief
 *******************************************************************************/

@property(nonatomic,strong)UISlider *m_cObjChannelSelector;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief
 *******************************************************************************/

@property(nonatomic,strong)UILabel *m_cObjChannelInfo;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a PickerView to select the channel to make the ap run in a particular
 channel.
 *******************************************************************************/

@property(nonatomic,strong)CustomPickerView *m_cObjChannelPicker;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief It is a button used for removing the keyboard.
 *******************************************************************************/

@property(nonatomic,strong)UIButton *m_cObjKeyboardRemoverButton;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a label showing the Mode Description i.e,either limited ap mode or
 *        client mode.
 *******************************************************************************/

@property(nonatomic,strong)UILabel *m_cObjModeDescriptionLabel;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief
 *******************************************************************************/

@property(nonatomic,strong)NSString *m_cObjPasswordBackup;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief
 *******************************************************************************/

@property(nonatomic,strong)NSString *m_cObjKeyBackup;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief
 *******************************************************************************/

@property(nonatomic,strong)NSMutableArray *m_cObjAPCredentails;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief
 *******************************************************************************/

@property(nonatomic,strong)NSMutableArray *m_cObjFieldCredentails;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its an array having values from 1-14 to set in the picker.
 *******************************************************************************/

@property(nonatomic,strong)NSArray *m_cObjPickerContentArray;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a string which is being set as client mode or limited-ap corresponding
 *        to the mode i.e,whether ap is in client mode or limited ap
 *        mode.
 *******************************************************************************/

@property(nonatomic,strong)NSString *m_cObjModeDescription;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief
 *******************************************************************************/

@property(nonatomic,assign)BOOL ipAdressType;

/**
 *******************************************************************************
 * @ingroup Limited AP Mode
 * @brief Its a boolean variable ,checking whether password security is enabled
 * or not.
 *******************************************************************************/

@property(nonatomic, assign) BOOL passwordSecurityStatus;

@property (nonatomic, assign) int chip_version_correction;

@property (nonatomic, assign) float bandValue;


/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method is called when configuration is set and next button is clicked
 * it checks the given SSID value is a valid or not if valid, it returns YES.
 * @retval Returns BOOL.
 *******************************************************************************/

-(BOOL)checkForSSIDLength;

@end
