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
 * $RCSfile: ConfirmationViewController.h,v $
 *
 * Description : Header file for ConfirmationViewController functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "GS_ADK_Data.h"
#import "WPAModeButtonView.h"
#import "CertificateBrowser.h"
#import "CustomPickerView.h"

/**
 *******************************************************************************
 * @file ConfirmationViewController.h
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

@protocol ConfirmationViewController <NSObject>

//-(NSString *)getSSIDStrForindex:(int)index;
//-(NSString *)getSignalStrengthForindex:(int)index;
//-(NSString *)getSecurityTypeForindex:(int)index;
//-(NSString *)getChannelNoForindex:(int)index;

-(NSString *)refreshSSIDStrForindex:(int)index;
-(NSString *)refreshSignalStrengthForindex:(int)index;
-(NSString *)refreshSecurityTypeForindex:(int)index;
-(NSString *)refreshChannelNoForindex:(int)index;

-(BOOL)refreshMode;

-(void)goToIPSettingsScreen;
@end

@interface ConfirmationViewController : GSViewController <CertificateBrowserDelegate,WPAModeButtonDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>{

	UIView *lObjView;
    
    WPAModeButtonView *eapOptionsView;
    
	ProvisioningAppDelegate *appDelegate;
	UITextField *lObjPassField;
	NSInteger currentIndex;
    int eapType;
    
    int GS2000_height;
    int GS2000_eapType;
    
    
    BOOL ipAdressType;
	
    id <ConfirmationViewController> m_cObjDelegate;
	
	GS_ADK_Data *sharedGsData;
	
    BOOL passwordSecurityStatus;
    
    UITableView *eapTableView;
    
   // NSMutableArray *eapCredentials;
    
    CertificateBrowser *m_cObjBrowser;

    UIButton *m_cObjRootCertButton,*m_cObjClientCertButton,*m_cObjClientKeyButton;
    
    NSMutableDictionary *enterpriseInfoDictionary;
    
    NSArray *ConfigEntrys;
    
    UIButton *m_cObjKeyboardRemoverButton;
    
    CustomPickerView *m_cObjKeyPicker;
    
    
}

@property (nonatomic,strong)id <ConfirmationViewController> m_cObjDelegate;
@property (nonatomic,strong) UITextField *lObjPassField;

@property (nonatomic,assign)int wepAuthType;

@property (nonatomic,assign) int statusBarHeightForIOS_7;
@property (nonatomic,assign) int viewStartsFrom;

@property (nonatomic, strong) NSMutableDictionary *concurrentDataDict;

@property (nonatomic, assign) BOOL saveMode;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method passes the row index of the selected AP from AP List. 
 *
 * @param rowNo of type int is the row index of the selected AP from AP List.
 * @retval Returns void.
 *******************************************************************************/

-(void)indexOfRow:(NSInteger)rowNo;


/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method adds text Fields for Passphrase for the selected AP. 
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)addTextField;



/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method adds the adds the allocated Text Field for entering 
 * Passphrase on the View.
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)showTextField;



/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method adds text Fields for Key and Index for the selected AP. 
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)addKeyPairTextField;



/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method adds the adds the allocated Key and Index Text Fields for
 * entering Passphrase on the View.
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)showKeyPairTextField;



/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method is used Post the Given Input and Get Response and Save the 
 * Configuration , if succesfull Response .
 * @retval Returns void.
 *******************************************************************************/

//-(void)saveConfiguration;



/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method is called ,to create a Interface for EAP Credential 
 * in the TableView to enter the Inputs.
 * @retval Returns void.
 *******************************************************************************/

-(void)addInterfaceForEAPCredentialsInput;

/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method is called ,alert the User Limited Ap Configuration , when
 * next button is clicked , it prompts the alertview with the selected Configuration
 * and Option to save and Cancel.
 * @params aObjtitle is NSString, which is used to display the AlertView's Title
 * @params aObjmessage is NSString , which is used to display the AlertView's
 * Message (The Configuration Selected)
 * @params aObjresponder is the NSString ,which is used to display the Responder's
 * Title.
 * @params aObjinfoArray is a NSArray, which is used to hold the Configuration selected 
 * the user to display in the AlertView.
 * @retval Returns void.
 *******************************************************************************/


-(void)showConfirmationForManualConfigWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray;

-(BOOL)checkAttachedCertificates;





@end
