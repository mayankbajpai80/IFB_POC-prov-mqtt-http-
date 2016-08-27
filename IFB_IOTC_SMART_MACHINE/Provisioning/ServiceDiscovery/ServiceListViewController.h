//
//  ServiceListViewController.h
//  Provisioning
//
//  Created by GainSpan India on 03/02/14.
//
//

#import <UIKit/UIKit.h>
#import "ServiceList.h"
#import "GS_ADK_ServiceManager.h"
#import "Auth_Check.h"
#import "GS_ADK_Data.h"
#import "GS_ADK_DataManger.h"
#import "UniversalParser.h"
#import "GS_ADK_ConnectionManager.h"
#import "ClientModeViewController.h"
#import "Manual_IP_Entry.h"
#import "GSViewController.h"


@interface ServiceListViewController : UIViewController <GS_ADK_ServiceManagerDelegate,GS_ADK_ConnectionManagerDelegate>{
    
    GS_ADK_ServiceManager *m_gObjServiceManager;
 
    UIImageView *m_cObjLogo;
    
    UIActivityIndicatorView *m_cObjActivity;
    
    Auth_Check *check;

    GS_ADK_Data *sharedGsData;
    
    UIAlertView *m_cObjAlertView;
    
     NSURLAuthenticationChallenge *m_cObjAuthChallenge;
    
    GS_ADK_DataManger *m_cObjProvData;
    
    UniversalParser *m_cObjUniversalParser;
    
    NSArray *m_cObjURLs;
    
    GS_ADK_ConnectionManager *m_cObjConnectionManager;
    
    int successCount;
    
    // BOOL UTC_Time_Supported;
    
     BOOL connectionFailurePromptDone;
    
    Manual_IP_Entry *m_cObjManualIPEntry;
    
    ProvisioningAppDelegate *appDelegate;
    
}

@property (nonatomic,strong) ServiceList *m_cObjServiceList;

@property (nonatomic,strong) ClientModeViewController *m_gObjClientMode;

@property (nonatomic,strong) 	LimitedAPWirelessSettingsScreen *m_gObjLimitedAPWirelessSettingsScreen;

@property (nonatomic, strong) UITabBarController *m_gObjTabController;


@property (nonatomic, assign) BOOL connectionStatus;


@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) UIButton *backButton;


@end
