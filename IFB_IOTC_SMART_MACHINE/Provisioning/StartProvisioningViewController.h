//
//  StartProvisioningViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 16/08/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GS_ADK_ConnectionManager.h"
#import "GS_ADK_DataManger.h"
#import "UniversalParser.h"
#import "GS_ADK_Data.h"
#import "ServiceList.h"
#import "GS_ADK_ServiceManager.h"
#import "Auth_Check.h"
#import "LimitedAPWirelessSettingsScreen.h"
#import "GSAlertInfo.h"
#import "GSUIAlertView.h"
#import "GSNavigationBar.h"
#import "WifiInfoController.h"

@class ProvisioningViewController;
@class ClientModeViewController;
@class Manual_IP_Entry;
@class ActivationScreen;
@class WifiInfoController;

@interface StartProvisioningViewController : UIViewController
{
    ProvisioningViewController *viewController;
    
    GS_ADK_ConnectionManager *m_cObjConnectionManager;
    
    ClientModeViewController *m_gObjClientMode;
    
    LimitedAPWirelessSettingsScreen *m_gObjLimitedAPWirelessSettingsScreen;
    
    UniversalParser *m_cObjUniversalParser;
    
    GS_ADK_DataManger *m_cObjProvData;
    
    GS_ADK_Data *sharedGsData;
    
    NSArray *m_cObjURLs;
    
    UIWindow *window;
    
    int successCount;
    
    GS_ADK_ServiceManager *m_gObjServiceManager;
    
    ServiceList *m_cObjServiceList;
    
    UIActivityIndicatorView *m_cObjActivity;
    
    UIImageView *m_cObjLogo;
    
    UITabBarController *m_gObjTabController;
    
    BOOL ipAdressType;
    
    BOOL securedMode;
    
    BOOL UTC_Time_Supported;
    
    GSUIAlertView *m_cObjAlertView;
    
    int clientSecurityType;
    
    int apSecurityType;
    
    int wpaType;
    
    NSInteger m_cObjSetMode;
    
    NSArray *m_cObjConnParameters;
    
    NSString *username;
    
    NSString *password;
    
    Manual_IP_Entry *m_cObjManualIPEntry;
    
    ActivationScreen *m_jObjActivationScreen;
    
    // BOOL connectionStatus;
    
    BOOL connectionFailurePromptDone;
    
    Auth_Check *check;
    
    NSURLAuthenticationChallenge *m_cObjAuthChallenge;
    
    UIView *m_cObjView;
    
    
    
}

@property (nonatomic, strong) WifiInfoController *m_cObjWifiInfoController;

@property (nonatomic, strong) UINavigationController *m_cObjNavigationController;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) UITabBarController *m_gObjTabController;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSDictionary *concurrentModeResponseDict;

@property (nonatomic, assign) BOOL ipAdressType;
@property (nonatomic, assign) BOOL securedMode;
@property (nonatomic, assign) BOOL UTC_Time_Supported;
@property (nonatomic, assign) BOOL appRunningInBackground;

@property (nonatomic, assign) int clientSecurityType;
@property (nonatomic, assign) int apSecurityType;
@property (nonatomic, assign) int wpaType;

@property (nonatomic, assign) BOOL utcSwitchState;

//=================== modification =======================

@property (nonatomic, strong) NSString *m_cObjRootCertName ;

@property (nonatomic, strong) NSString *m_cObjClientCertName ;

@property (nonatomic, strong) NSString *m_cObjClientKeyName ;

@property (nonatomic, strong) NSString *m_cObjRootCertPath ;

@property (nonatomic, strong) NSString *m_cObjClientCertPath;

@property (nonatomic, strong) NSString *m_cObjClientKeyPath ;

//@property (nonatomic, assign) int eapTypeForStatic;

//@property (nonatomic, assign) int eapTypeForStatic;


//===================================================================================

//@property (nonatomic, assign) BOOL doesSupportConcurrentMode;



/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method is called once a particular service in the service list
 *        is selected or an IP address or a domain name is entered.
 *
 * @param pObjURLString of type NSString which is a string representation of
 * requested URL. This is unused in this app.
 *
 * @retval Returns void.
 *******************************************************************************/

//-(void)requestURLString:(NSString *)pObjURLString;



/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method is called when discovery fails to find any services in the
 *        given period of time.
 *
 * @retval Returns void.
 *******************************************************************************/

//-(void)discoveryDidFail;



/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method shows an alert View for a given Title, message, and a
 * responder button title.
 *
 * @param aObjtitle is the title of the alert view.
 *
 * @param aObjmessage is detailed message to be displayed on the alert view.
 *
 * @param aObjresponder is title for the Button of the alert view.
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)showActivityIndicatorWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder;



/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method shows a confirmation the manual configuration details
 *        before POSTing to the server. It uses a UIAlertView to do so.
 *
 * @param aObjtitle is the title of the alert view.
 *
 * @param aObjmessage is detailed message to be displayed on the alert view.
 *
 * @param aObjresponder is title for the Button of the alert view.
 *
 * @param info conatins the details that need to be POSTed.
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)showConfirmationForManualConfigWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray;



/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method shows a confirmation for the configuration details
 *        before POSTing to the server. It uses a UIAlertView to do so.
 *
 * @param aObjtitle is the title of the alert view.
 *
 * @param aObjmessage is detailed message to be displayed on the alert view.
 *
 * @param aObjresponder is title for the Button of the alert view.
 *
 * @param info conatins the details that need to be POSTed.
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)showConfirmationWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray;



/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method shows a confirmation for the configuration details with
 *        manual IP Settings before POSTing to the server. It uses a UIAlertView
 *        to do so.
 *
 * @param aObjtitle is the title of the alert view.
 *
 * @param aObjmessage is detailed message to be displayed on the alert view.
 *
 * @param aObjresponder is title for the Button of the alert view.
 *
 * @param info conatins the details that need to be POSTed.
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)showConfirmationForManualIPEntryWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray manualEntry:(NSArray *)aObjManualInfo;




/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method is called when HTTP Authentication is successfully
 * complete.
 *
 * @retval Returns void.
 *******************************************************************************/

//-(void)authentictionDone;



/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method does an HTTP POST to set the mode to the device.
 *
 * @param mode of type int holds mode index.
 * @retval Returns void.
 *******************************************************************************/

-(void)setMode:(NSInteger)mode;



/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method hides activity indicator.
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)hideActivityIndicator;

/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method is called when Activation Code is successfully entered.
 *
 * @retval Returns void.
 *******************************************************************************/

-(void)activationDone;



/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method is called when an HTTP authentication callenge is recieved.
 *        This method promts the user for username and password entry.
 *
 * @param pObjChg of type NSURLAuthenticationChallenge is HTTP authentication
 *        challenge reveived.
 * @retval Returns void.
 *******************************************************************************/

//-(void)promptForUserInputForAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg;

/**
 *******************************************************************************
 * @ingroup App Config
 * @brief This method is called to create a path in the Document , were the
 * documents are used to store from one path to this path
 * @param _fileName is the NSString
 * @retval Returns NSString.
 *******************************************************************************/

- (NSString *)getBinaryPathForFileName:(NSString *)_fileName;

-(void)activityIndicator:(BOOL)show;


@end
