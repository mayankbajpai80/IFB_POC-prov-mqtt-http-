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
 * $RCSfile: ManualClientModeConfig.m,v $
 *
 * Description : Header file for ManualClientModeConfig functions and data structures
 *******************************************************************************/

#import "ManualClientModeConfig.h"
#import "Manual_IPSettingScreen.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "InfoScreen.h"
#import "Identifiers.h"
#import "GS_ADK_Data.h"
#import "WPAModeButtonView.h"
#import "CertificateBrowser.h"
#import "ChannelFilter.h"
#import "UINavigationBar+TintColor.h"
#import "UITableView+SpecificFrame.h"
#import "ResetFrame.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"
#import "GSNavigationBar.h"

#import "ConcurrentModeInfoViewController.h"
#import "ModeController.h"
#import "PostSummaryController.h"
#import "CommonProvMethods.h"
#import "ValidationUtils.h"




#define CHANNEL_PICKER_MODE                     0
#define INDEX_PICKER_MODE                       1

#define SECURITY_TYPE                           10001
#define WPA_PERSONAL_SECURITY_TYPE              10002

#define CHIP_VERSION_1550                       1
#define CHIP_VERSION_1500                       0


static const NSInteger cnTextFieldTag = 91;
static const NSInteger ouTextFieldTag = 92;



static const NSInteger channelPickerTag = 3001;
static const NSInteger securityPickerTag = 2001;

static const NSInteger textField_Tag = 100001;
static const NSInteger utcSwitchTag = 10000000;
static const NSInteger anonymousIDSwitchTag = 10000001;
static const NSInteger cnouSwitchTag = 10000002;


static NSString *const Use_Anonymous_ID = @"Use Anonymous ID"; //
static NSString *const Configure_CNOU = @"Configure CNOU";
static NSString *const Set_Node_Time_To_Current_UTC_Time = @"Set node time to current UTC time";
static NSString *const EAP_Username = @"EAP Username";
static NSString *const EAP_Password = @"EAP Password";
static NSString *const EAP_Type = @"EAP Type";
static NSString *const WEP_Key = @"WEP Key";
static NSString *const WEP_Key_Index = @"WEP Key Index";
static NSString *const Wep_Auth = @"Wep Auth";
static NSString *const SSID = @"SSID";
static NSString *const Channel = @"Channel";
static NSString *const Security = @"Security";
static NSString *const Passphrase = @"Passphrase";
static NSString *const Eap_CN = @"CN Value";
static NSString *const Eap_OU = @"OU Value";

//----------- EAP TYPE -------------
static NSString *const Eap_Fast_Gtc = @"eap_fast_gtc";
static NSString *const Eap_Fast_Mschap = @"eap_fast_mschap";
static NSString *const Eap_Ttls = @"eap_ttls";
static NSString *const Eap_Peap0 = @"eap_peap0";
static NSString *const Eap_Peap1 = @"eap_peap1";
static NSString *const Eap_Tls = @"eap_tls";

static NSString *const Eap_Fast = @"eap_fast";
static NSString *const Eap_Peap = @"eap_peap";

//------------ EAP TYPE DISPLAY STRING -----------

//static NSString *const eap-tls = @"eap-tls";
//static NSString *const Eap_Peap = @"eap_peap";
//static NSString *const Eap_Fast = @"eap_fast";
//static NSString *const Eap_Peap = @"eap_peap";
//static NSString *const Eap_Fast = @"eap_fast";
//static NSString *const Eap_Peap = @"eap_peap";




@interface ManualClientModeConfig (privateMethods)<CustomUIAlertViewDelegate>

-(BOOL)checkForEmptyFields;
-(BOOL)checkForHexValue;

-(BOOL)checkPassphraseLength;

-(void)addManualEntryPage;
-(void)launchIPConfigScreen;
-(BOOL)checkAttachedCertificates;
-(BOOL)checkForHexValueAndPassphrase;

-(void)showConfirmationForManualConfigWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray;
-(void)replaceStringAtRow:(NSInteger)pObjRow withString:(NSString *)pObjString;

@end


@implementation ManualClientModeConfig

@synthesize m_cObjDelegate, passwordSecurityStatus, chip_version_correction, bandValue;

#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */



-(NSString *)getSSIDStrForindex:(int)index
{
    return @"";
}
-(NSString *)getSecurityTypeForindex:(int)index
{
    return @"";
    
}
-(NSString *)getChannelNoForindex:(int)index
{
    return @"";
    
}


-(NSString *)getManualSSIDStrForindex:(int)index
{
	return [m_cObjInfoArray objectAtIndex:0];
}

-(NSString *)getManualSecurityTypeForindex:(int)index
{
	
	return [m_cObjInfoArray objectAtIndex:2];
}

-(NSString *)getManualChannelNoForindex:(int)index
{
	
	return [m_cObjInfoArray objectAtIndex:1];
}

#pragma mark -
#pragma mark View lifecycle


-(void)selectCertificate:(NSString *)pObjNameString path:(NSString *)pObjPathString withTag:(int)pObjTag {
    
    [self resignKeyPad];
    
    switch (pObjTag) {
            
        case 1:
            
            globalValues.provisionSharedDelegate.m_cObjRootCertName = [[NSString alloc] initWithString:pObjNameString];
            
            globalValues.provisionSharedDelegate.m_cObjRootCertPath = [[NSString alloc] initWithString:globalValues.provisionSharedDelegate];
			
            [m_cObjRootCertButton setTitle:globalValues.provisionSharedDelegate.m_cObjRootCertName forState:UIControlStateNormal];
            
            break;
        case 2:
            
            globalValues.provisionSharedDelegate.m_cObjClientCertName = [[NSString alloc] initWithString:pObjNameString];
			
            globalValues.provisionSharedDelegate.m_cObjClientCertPath = [[NSString alloc] initWithString:pObjPathString];
			
            [m_cObjClientCertButton setTitle:globalValues.provisionSharedDelegate.m_cObjClientCertName forState:UIControlStateNormal];
            
            break;
        case 3:
                    
            globalValues.provisionSharedDelegate.m_cObjClientKeyName = [[NSString alloc] initWithString:pObjNameString];
			
            globalValues.provisionSharedDelegate.m_cObjClientKeyPath = [[NSString alloc] initWithString:pObjPathString];
			
            [m_cObjClientKeyButton setTitle:globalValues.provisionSharedDelegate.m_cObjClientKeyName forState:UIControlStateNormal];
            
            break;
        default:
            
            break;
            
    }
}

- (void)navigationItemTapped:(NavigationItem)item {
    
    switch (item) {
        case NavigationItemBack:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case NavigationItemCancel:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case NavigationItemInfo:
            
            [self showInfo];
            
            break;
            
        case NavigationItemMode:
            
        {
            ModeController *modeController = [[ModeController alloc] initWithControllerType:5];
            [self.navigationController pushViewController:modeController animated:YES];
            
        }
            
            break;
            
        default:
            break;
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
	self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem=nil;
    
    self.navigationItem.hidesBackButton=YES;
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
	
    sharedGsData.manualConfigMode = YES;
		
	m_cObjKeyBackup  = @"";
    
	m_cObjPasswordBackup  = @"";
		
	
	NSArray *keys = [NSArray arrayWithObjects:@"ssid",@"channel",@"security",@"password",@"eap_username",@"eap_password",@"wepKeyIndex",@"wepKey",@"eap_type",@"eap_cn",@"eap_ou",nil];
	
	NSArray *objects = [NSArray arrayWithObjects:SSID,Channel,Security,Passphrase,EAP_Username,EAP_Password,WEP_Key_Index,WEP_Key,EAP_Type,Eap_CN,Eap_OU, nil];
	
	FieldTitles = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	
    m_cObjSecurityTypes = [[NSMutableArray alloc] initWithObjects:@"No Security", @"WEP",@"WPA/WPA2 Personal",@"WPA/WPA2 Enterprise",nil];
    
	if ([[m_cObjInfoArray objectAtIndex:2] isEqualToString:@"none"]) {
		
		[m_cObjInfoArray replaceObjectAtIndex:3 withObject:@""];
		[m_cObjInfoArray replaceObjectAtIndex:4 withObject:@""];
		[m_cObjInfoArray replaceObjectAtIndex:5 withObject:@""];
		
	}
    
    NSString *lObjSecurityValue = [self securityTypeValue];
    
	if ([lObjSecurityValue isEqualToString:@"none"]) {
		
		globalValues.provisionSharedDelegate.clientSecurityType = 0;
		globalValues.provisionSharedDelegate.securedMode = NO;
        
        m_cObjTextFieldValues = [[NSMutableArray alloc] initWithObjects:SSID,Channel,Security,Passphrase,@"new",@"new",@"new",nil];
        
	}
	else if ([lObjSecurityValue isEqualToString:@"wpa-personal"]) {
		
		globalValues.provisionSharedDelegate.clientSecurityType = 1;
		globalValues.provisionSharedDelegate.securedMode = YES;
        
        m_cObjTextFieldValues = [[NSMutableArray alloc] initWithObjects:SSID,Channel,Security,Passphrase,WEP_Key,@"WPA mode",@"WPA mode",nil];
        
	}
	else {
		
		globalValues.provisionSharedDelegate.clientSecurityType = 2;
		globalValues.provisionSharedDelegate.securedMode = YES;
        
        m_cObjTextFieldValues = [[NSMutableArray alloc] initWithObjects:SSID,Channel,Security,WEP_Key_Index,WEP_Key,Wep_Auth,@"new",nil];
        
	}
	
    
    if  ([sharedGsData.firmwareVersion.chip rangeOfString:@"gs1550m" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        [m_cObjTextFieldValues insertObject:@"Band" atIndex:1];
        
        chip_version_correction = CHIP_VERSION_1550;
    }
    
    
    m_cObjChannelData = [[NSMutableDictionary alloc] init];
    
    NSString *lObjStr =  [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"];
    
    
    if([lObjStr intValue] >14)
    {
        bandSelectionIndex = 1;
        bandValue = 5.0;
        [m_cObjChannelData setValue:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"] forKey:@"5.0GHz"];
        
    }
    else {
        bandSelectionIndex = 0;
        bandValue = 2.4;
        [m_cObjChannelData setValue:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"] forKey:@"2.4GHz"];
        
    }
    
    
    m_cObjPickerContentArray = [[NSArray alloc] initWithArray:[ChannelFilter getChannelListForFrequency:bandValue firmwareVersion:sharedGsData.firmwareVersion.chip regulatoryDomain:[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"reg_domain"] objectForKey:@"text"] ClientMode:YES]];
    
	
	
   
    
    self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"]];
    
    self.navigationBar.title = @"Manual Settings";

	
	
	[self addManualEntryPage];
    
    
    m_cObjSecurityPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 216) delegate:self withTag:securityPickerTag];
    m_cObjSecurityPicker.backgroundColor = [UIColor whiteColor];
    [m_cObjSecurityPicker.lObjPicker selectRow:globalValues.provisionSharedDelegate.clientSecurityType inComponent:0 animated:NO];
    [self.view addSubview:m_cObjSecurityPicker];
    
    
    m_cObjChannelPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 216) delegate:self withTag:channelPickerTag];
    m_cObjChannelPicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_cObjChannelPicker];
    
    
    
	m_cObjKeyboardRemoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[m_cObjKeyboardRemoverButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake(305-40-5,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
	[m_cObjKeyboardRemoverButton addTarget:self action:@selector(resignKeyPad) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:m_cObjKeyboardRemoverButton];
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)showInfo
{
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
	[self presentViewController:lObjInfoScreen animated:YES completion:nil];
}

#pragma mark - UIActionSheet Methods :

-(void)addManualEntryPage {

    passwordSecurityStatus = NO;
    
    NSString *lObjScurityType = [self securityTypeValue];
    
	if ([lObjScurityType isEqualToString:@"wep"] || [lObjScurityType isEqualToString:@"WEP"]){
		
		globalValues.provisionSharedDelegate.clientSecurityType = WEP_SECURITY;
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wep" forKey:@"text"];
        
	}
	else if ([lObjScurityType isEqualToString:@"wpa-enterprise"] || [lObjScurityType isEqualToString:@"WPA/WPA2 Enterprise"]){
		
		globalValues.provisionSharedDelegate.clientSecurityType = WPA_ENTERPRISE_SECURITY;
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-enterprise" forKey:@"text"];
        
        /// change here
        
        
        if(chip_version_correction == CHIP_VERSION_1550)
        {
            [m_cObjTextFieldValues replaceObjectAtIndex:1 withObject:@"Band"];
            
        }
        
        
		[m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:EAP_Username];
		[m_cObjTextFieldValues replaceObjectAtIndex:4+chip_version_correction withObject:EAP_Password];
		[m_cObjTextFieldValues replaceObjectAtIndex:5+chip_version_correction withObject:EAP_Type];
		[m_cObjTextFieldValues replaceObjectAtIndex:6+chip_version_correction withObject:Set_Node_Time_To_Current_UTC_Time];
        
        if (sharedGsData.supportAnonymousID) {
            
            [m_cObjTextFieldValues addObject:Use_Anonymous_ID];
            
            if ([[self eapTypeValue] isEqualToString:@"eap-tls"]) {
                
                [m_cObjTextFieldValues addObject:Configure_CNOU];

            }
        }
        
	}
    else if ([lObjScurityType isEqualToString:@"wpa-personal"] || [lObjScurityType isEqualToString:@"WPA/WPA2 Personal"])
    {
        
        globalValues.provisionSharedDelegate.clientSecurityType = WPA_PERSONAL_SECURITY;
		
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-personal" forKey:@"text"];
        
        
        
        if(chip_version_correction == CHIP_VERSION_1550)
        {
            [m_cObjTextFieldValues replaceObjectAtIndex:1 withObject:@"Band"];
            
        }
        
        [m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:Passphrase];
		[m_cObjTextFieldValues replaceObjectAtIndex:4+chip_version_correction withObject:EAP_Password];
		[m_cObjTextFieldValues replaceObjectAtIndex:5+chip_version_correction withObject:EAP_Type];
		//[m_cObjTextFieldValues replaceObjectAtIndex:6 withObject:@"EAP Mode"];
    }
	else
    {
        globalValues.provisionSharedDelegate.clientSecurityType = OPEN_SECURITY;
        
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"none" forKey:@"text"];
    }
    
    
	if (lObjScurityType != nil) {
		
		
		if ([lObjScurityType isEqualToString:@"wpa-enterprise"]) {
			
			wpaAuthType = 1;
			
		}
		else {
			
			wpaAuthType = 0;
			
		}
		
		
	}
	else {
		
		wpaAuthType = 0;
		
	}
    
    NSString *lObjEapType = [self eapTypeValue];
	
	if (lObjEapType != nil) {
		
		
		if(sharedGsData.isSupportsEAP_Option >= 1)
        {
            if ([lObjEapType isEqualToString:Eap_Fast_Gtc]) {
                
                eapType = 0;
            }
            else if ([lObjEapType isEqualToString:Eap_Fast_Mschap]) {
                
                eapType = 1;
                
            }
            else if ([lObjEapType isEqualToString:Eap_Ttls]) {
                
                eapType = 2;
                
            }
            else if ([lObjEapType isEqualToString:Eap_Peap0]) {
                
                eapType = 3;
                
            }
            else if ([lObjEapType isEqualToString:Eap_Peap1]) {
                
                eapType = 4;
                
            }
            else if ([lObjEapType isEqualToString:Eap_Tls]) {
                
                eapType = 5;
                
            }
            else {
                
                eapType = 0;
                
            }
            
        }
        else {
            
            if ([lObjEapType isEqualToString:Eap_Fast]) {
                
                eapType = 0;
            }
            else if ([lObjEapType isEqualToString:Eap_Ttls]) {
                
                eapType = 1;
                
            }
            else if ([lObjEapType isEqualToString:Eap_Peap]) {
                
                eapType = 2;
                
            }
            else if ([lObjEapType isEqualToString:Eap_Tls]) {
                
                eapType = 3;
                
            }
            else {
                
                eapType = 0;
                
            }
            
        }
	}
	
    
    
    m_cObjtableView = [[UITableView alloc]initWithiOSVersionSpecificMargin:STATUS_BAR_HEIGHT withAdjustment:(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT) style:UITableViewStyleGrouped];
    
	[m_cObjtableView setDataSource:self];
	[m_cObjtableView setDelegate:self];
	[self.view addSubview:m_cObjtableView];
}

#pragma mark - Returns Network Values

-(NSString *)eapTypeValue {
    
    return [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_type"] objectForKey:@"text"];
}

-(NSString *)securityTypeValue {
    
    return [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"];
}


-(void)goBackToPriousPage {
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)resignKeyPad {
    
	for (int i=textField_Tag; i<=100006; i++) {
		
        
		UITextField *lObjTextField = (UITextField *)[m_cObjtableView viewWithTag:i];
        
		if (lObjTextField) {
			
			[lObjTextField resignFirstResponder];
		}
	}
    
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
    
    [ResetFrame resignKeyPad:m_cObjKeyboardRemoverButton ChannelPicker:m_cObjChannelPicker SecurityPicker:m_cObjSecurityPicker andTableView:m_cObjtableView];
    
	[UIView commitAnimations];
	
}


-(void)switchToggled:(id)sender {
    
	UISwitch *lObjSwitch = (UISwitch *)sender;
    
    int tag = 00;
    
    switch (globalValues.provisionSharedDelegate.clientSecurityType) {
        case 0:
            
            tag = 0;
            
            break;
            
        case WEP_SECURITY:
            
            tag = 100005;
			
            break;
            
        case WPA_PERSONAL_SECURITY:
            
            tag = 100004;
			
            break;
            
        case WPA_ENTERPRISE_SECURITY:
            
            tag = 100005;
			
            break;
            
        default:
            break;
    }
    
	UITextField *lObjTextField = (UITextField *)[m_cObjtableView viewWithTag:tag+chip_version_correction];
    
	if (lObjSwitch.on) {
		
		passwordSecurityStatus=NO;
		
		if (globalValues.provisionSharedDelegate.clientSecurityType == 2 || globalValues.provisionSharedDelegate.clientSecurityType == 1 || globalValues.provisionSharedDelegate.clientSecurityType == 3) {
			
			lObjTextField.enabled = NO;
			[lObjTextField setSecureTextEntry:NO];
			lObjTextField.enabled = YES;
			
		}
		
	}
	else {
		passwordSecurityStatus = YES;
		
		if (globalValues.provisionSharedDelegate.clientSecurityType == 2 || globalValues.provisionSharedDelegate.clientSecurityType == 1 || globalValues.provisionSharedDelegate.clientSecurityType == 3) {
			
			lObjTextField.enabled = NO;
			[lObjTextField setSecureTextEntry:YES];
			lObjTextField.enabled = YES;
            
		}
	}
    
    [self resignKeyPad];
}


#pragma mark -
#pragma mark Table view data source

-(UIView *)getSectionHeader:(NSInteger)index {
	
	UIView *lObjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[lObjView setBackgroundColor:[UIColor clearColor]];
		
	UILabel *lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11-4+10, 280, 20)];
	lObjHeaderLabel.backgroundColor = [UIColor clearColor];
	[lObjHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
	lObjHeaderLabel.textColor = [UIColor colorWithRed:0.35 green:0.40 blue:0.50 alpha:1];
	lObjHeaderLabel.text = @"Show Password";
	[lObjView addSubview:lObjHeaderLabel];
    lObjHeaderLabel.shadowColor = [UIColor whiteColor];
    lObjHeaderLabel.shadowOffset = CGSizeMake(0, 1);
	
	UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 100, 20)];
    [lObjSwitch setOn:!passwordSecurityStatus];
	[lObjSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
	[lObjView addSubview:lObjSwitch];
	
	
	return lObjView;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 1) {
		
		return 66.0;
	}
	else {
		
		return 0;
	}
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}// fixed font style. use custom view (UILabel) if you want something different



-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section != 0 && globalValues.provisionSharedDelegate.clientSecurityType != 0) {
		
		return [self getSectionHeader:section];
	}
	
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	if (section == 0) {
        
		if (globalValues.provisionSharedDelegate.clientSecurityType == OPEN_SECURITY) {
            
			return 3 + chip_version_correction;
			
        }
		else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_PERSONAL_SECURITY){
			
			return 4 + chip_version_correction;
			
		}
        else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY){
            
            if (sharedGsData.supportAnonymousID && [[self eapTypeValue] isEqualToString:@"eap-tls"]) {
                
                return 9;
            }
            else if (sharedGsData.supportAnonymousID) {
                
                return 8;
            }
            else {
                return (7 + chip_version_correction);
            }
		}
		else {
			
            return 6 + chip_version_correction;
        }
	}
	else {
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell!=nil)
        cell=nil;
	
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    
	if (indexPath.section == 0) {
		cell.tag = indexPath.row + 1;
        
        NSLog(@"textfield value count = %zd || rowCount = %zd",m_cObjTextFieldValues.count, indexPath.row);

		
		UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 110+90, 44)];
		[lObjLabel setBackgroundColor:[UIColor clearColor]];
		[lObjLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
		//[lObjLabel setText:[m_cObjTextFieldValues objectAtIndex:indexPath.row]];
		[lObjLabel setFont:[UIFont systemFontOfSize:12]];
		[lObjLabel setTextColor:[UIColor grayColor]];
		[cell.contentView addSubview:lObjLabel];
        [lObjLabel setText:[m_cObjTextFieldValues objectAtIndex:indexPath.row]];
        
		
		if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:SSID]) {
			
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			lObjTextField.tag = indexPath.row + textField_Tag;
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
			[lObjTextField setDelegate:self];
			
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]];
			
			[cell.contentView addSubview:lObjTextField];
			
		}
		else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:Channel]){
            
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			lObjTextField.tag = indexPath.row + textField_Tag;
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDone];
			[lObjTextField setDelegate:self];
			[lObjTextField setUserInteractionEnabled:NO];
            
			
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]];
			
			[cell.contentView addSubview:lObjTextField];
            
			UIButton *lObjButton = [UIButton buttonWithType:UIButtonTypeCustom];
			lObjButton.tag = indexPath.row + 1001;
			[lObjButton setFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjButton addTarget:self action:@selector(bringUpKeySelector:) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:lObjButton];
			
		}
		else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:Security]){
			
            
            UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5-20, 0, 160+20, 44)];
			lObjTextField.tag = indexPath.row + textField_Tag;
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDone];
			[lObjTextField setDelegate:self];
			[lObjTextField setUserInteractionEnabled:NO];
            
            NSMutableString *tempSecurityString=[[NSMutableString alloc]init];
            
            NSString *lObjSecurityValue = [self securityTypeValue];
            
            if([lObjSecurityValue isEqualToString:@"none"])
            {
                [tempSecurityString setString:@"none"];
                
            }
            else if([lObjSecurityValue isEqualToString:@"wep"])
            {
                [tempSecurityString setString:@"WEP"];
                
            }
            else if([lObjSecurityValue isEqualToString:@"wpa-personal"])
            {
                [tempSecurityString setString:@"WPA/WPA2 Personal"];
                
            }
            else if([lObjSecurityValue isEqualToString:@"wpa-enterprise"])
            {
                [tempSecurityString setString:@"WPA/WPA2 Enterprise"];
                
            }
			
			[lObjTextField setText:tempSecurityString];
            
            
			[cell.contentView addSubview:lObjTextField];
            
            
            UIButton *lObjSecuritySelectorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [lObjSecuritySelectorButton addTarget:self action:@selector(bringUpSecuritySelector) forControlEvents:UIControlEventTouchUpInside];
            [lObjSecuritySelectorButton setFrame:CGRectMake(100, 0, 200, 44)];
            [cell.contentView addSubview:lObjSecuritySelectorButton];
            
            
		}
        
        else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:@"Band"]){
            
            NSArray *lObjArray = [NSArray arrayWithObjects:@"2.4 GHz",@"5 GHz", nil];
            
            UISegmentedControl	*m_cObjBandSegControl = [[UISegmentedControl alloc] initWithItems:lObjArray];
            //m_cObjBandSegControl.segmentedControlStyle = UISegmentedControlStylePlain;
            m_cObjBandSegControl.frame = CGRectMake(135,7,160, 30);//(110, 7, 185, 30)
            m_cObjBandSegControl.selectedSegmentIndex = bandSelectionIndex;
            m_cObjBandSegControl.tag=4;
            [m_cObjBandSegControl addTarget:self action:@selector(BandsegmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:m_cObjBandSegControl];
            
            
        }
		else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:EAP_Type]){
			
            
			NSString *lObjString = [self eapTypeValue];
            
            
            if(sharedGsData.isSupportsEAP_Option >= 1) {
                
                if (nil != lObjString) {
                    
                    if ([lObjString isEqualToString:@"eap-fast-gtc"]) {
                        
                        eapType = 0;
                    }
                    if ([lObjString isEqualToString:@"eap-fast-mschap"]) {
                        
                        eapType = 1;
                    }
                    if ([lObjString isEqualToString:@"eap-ttls"]) {
                        
                        eapType = 2;
                    }
                    if ([lObjString isEqualToString:@"eap-peap0"]) {
                        
                        eapType = 3;
                    }
                    if ([lObjString isEqualToString:@"eap-peap1"]) {
                        
                        eapType = 4;
                    }
                    if ([lObjString isEqualToString:@"eap-tls"]) {
                        
                        eapType = 5;
                    }
                    
                }
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_type"] setObject:[CommonProvMethods getStringForEAPType:eapType] forKey:@"text"];
                
                for (int i=0; i<6; i++) {
                    
                    WPAModeButtonView *lObjView = [[WPAModeButtonView alloc] initWithFrame:CGRectMake(30+20, 10*(i+1) + 40*i + 40, 200, 40)];
                    [lObjView setBackgroundColor:[UIColor clearColor]];
                    [lObjView.layer setCornerRadius:5.0];
                    [lObjView.layer setBorderWidth:1];
                    [lObjView.layer setBorderColor:[[UIColor clearColor] CGColor]];
                    [lObjView setClipsToBounds:YES];
                    
                    if (i==eapType) {
                        
                        [lObjView.m_cObjImageView setImage:[UIImage imageNamed:@"blue-button-selected.png"]];
                        
                    }
                    else {
                        
                        [lObjView.m_cObjImageView setImage:[UIImage imageNamed:@"blue-button.png"]];
                        
                    }
                    
                    [lObjView addSubview:lObjView.m_cObjImageView];
                    lObjView.m_cObjImageView = nil;
                    [lObjView setM_cObjDelegate:self];
                    [lObjView setTag:i+10000];
                    [lObjView setTextWithEAPTypeForVersionIsGreaterThenOne:eapType];
                    [lObjView addSubview:lObjView.m_cObjLabel];
                    lObjView.m_cObjLabel = nil;
                    [cell.contentView addSubview:lObjView];
                    
                    
                }
                
                if (eapType == 5) {
                    
                    int height = 90;
                    
                    m_cObjRootCertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [m_cObjRootCertButton setFrame:CGRectMake(20, 320-10-44-10+height, 260, 44)];
                    [m_cObjRootCertButton setTitle:@"Attach Root Certificate" forState:UIControlStateNormal];
                    [m_cObjRootCertButton addTarget:self action:@selector(openRootCertificateBrowser) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:m_cObjRootCertButton];
                    
                    m_cObjClientCertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [m_cObjClientCertButton setFrame:CGRectMake(20, 320-10-44-10 + 54+height, 260, 44)];
                    [m_cObjClientCertButton setTitle:@"Attach Client Certificate" forState:UIControlStateNormal];
                    [m_cObjClientCertButton addTarget:self action:@selector(openClientCertificateBrowser) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:m_cObjClientCertButton];
                    
                    m_cObjClientKeyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [m_cObjClientKeyButton setFrame:CGRectMake(20, 320-10-44-10 + 110+height, 260, 44)];
                    [m_cObjClientKeyButton setTitle:@"Attach Client Key" forState:UIControlStateNormal];
                    [m_cObjClientKeyButton addTarget:self action:@selector(openClientKeyBrowser) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:m_cObjClientKeyButton];
                    
                }
                else {
                    
                    m_cObjRootCertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [m_cObjRootCertButton setFrame:CGRectMake(20, 320-10-44-10+90, 260, 44)];
                    [m_cObjRootCertButton setTitle:@"Attach Root Certificate" forState:UIControlStateNormal];
                    [m_cObjRootCertButton addTarget:self action:@selector(openRootCertificateBrowser) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:m_cObjRootCertButton];
                    
                }
                
            }
            else {
                
                
                if (nil != lObjString) {
                    
                    if ([lObjString isEqualToString:@"eap-fast"]) {
                        
                        eapType = 0;
                    }
                    if ([lObjString isEqualToString:@"eap-ttls"]) {
                        
                        eapType = 1;
                    }
                    if ([lObjString isEqualToString:@"eap-peap"]) {
                        
                        eapType = 2;
                    }
                    if ([lObjString isEqualToString:@"eap-tls"]) {
                        
                        eapType = 3;
                    }
                    
                }
                
                
                for (int i=0; i<4; i++) {
                    
                    WPAModeButtonView *lObjView = [[WPAModeButtonView alloc] initWithFrame:CGRectMake(30+20, 10*(i+1) + 40*i + 40, 200, 40)];
                    [lObjView setBackgroundColor:[UIColor clearColor]];
                    [lObjView.layer setCornerRadius:5.0];
                    [lObjView.layer setBorderWidth:1];
                    [lObjView.layer setBorderColor:[[UIColor clearColor] CGColor]];
                    [lObjView setClipsToBounds:YES];
                    
                    if (i==eapType) {
                        
                        [lObjView.m_cObjImageView setImage:[UIImage imageNamed:@"blue-button-selected.png"]];
                        
                    }
                    else {
                        
                        [lObjView.m_cObjImageView setImage:[UIImage imageNamed:@"blue-button.png"]];
                        
                    }
                    
                    [lObjView addSubview:lObjView.m_cObjImageView];
                    lObjView.m_cObjImageView = nil;
                    [lObjView setM_cObjDelegate:self];
                    [lObjView setTag:i+10000];
                    [lObjView setTextWithEAPType:eapType];
                    [lObjView addSubview:lObjView.m_cObjLabel];
                    lObjView.m_cObjLabel = nil;
                    [cell.contentView addSubview:lObjView];
                    
                }
                
                
                if (eapType == 3) {
                    
                    
                    m_cObjRootCertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [m_cObjRootCertButton setFrame:CGRectMake(20, 320-10-44-10, 260, 44)];
//                    [m_cObjRootCertButton setTitle:@"Attach Root Certificate" forState:UIControlStateNormal];
                    [m_cObjRootCertButton addTarget:self action:@selector(openRootCertificateBrowser) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:m_cObjRootCertButton];
                    
                    if (globalValues.provisionSharedDelegate.m_cObjRootCertName.length > 0) {
                       
                        [m_cObjRootCertButton setTitle:globalValues.provisionSharedDelegate.m_cObjRootCertName forState:UIControlStateNormal];
                    }
                    else {
                        [m_cObjRootCertButton setTitle:@"Attach Root Certificate" forState:UIControlStateNormal];
                    }
                    
                    m_cObjClientCertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [m_cObjClientCertButton setFrame:CGRectMake(20, 320-10-44-10 + 54, 260, 44)];
                    [m_cObjClientCertButton addTarget:self action:@selector(openClientCertificateBrowser) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:m_cObjClientCertButton];
                    
                    if (globalValues.provisionSharedDelegate.m_cObjClientCertName.length > 0) {
                        
                        [m_cObjClientCertButton setTitle:globalValues.provisionSharedDelegate.m_cObjClientCertName forState:UIControlStateNormal];
                    }
                    else {
                        [m_cObjClientCertButton setTitle:@"Attach Client Certificate" forState:UIControlStateNormal];
                    }
                    
                    m_cObjClientKeyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [m_cObjClientKeyButton setFrame:CGRectMake(20, 320-10-44-10 + 110, 260, 44)];
                    [m_cObjClientKeyButton addTarget:self action:@selector(openClientKeyBrowser) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:m_cObjClientKeyButton];
                    
                    if (globalValues.provisionSharedDelegate.m_cObjClientKeyName.length > 0) {
                        
                        [m_cObjClientKeyButton setTitle:globalValues.provisionSharedDelegate.m_cObjClientKeyName forState:UIControlStateNormal];
                    }
                    else {
                        [m_cObjClientKeyButton setTitle:@"Attach Client Key" forState:UIControlStateNormal];
                    }
                    
                }
                else {
                    
                    m_cObjRootCertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [m_cObjRootCertButton setFrame:CGRectMake(20, 320-10-44-10, 260, 44)];
                    [m_cObjRootCertButton addTarget:self action:@selector(openRootCertificateBrowser) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:m_cObjRootCertButton];
                    
                    if (globalValues.provisionSharedDelegate.m_cObjRootCertName.length > 0) {
                        
                        [m_cObjRootCertButton setTitle:globalValues.provisionSharedDelegate.m_cObjRootCertName forState:UIControlStateNormal];
                    }
                    else {
                        [m_cObjRootCertButton setTitle:@"Attach Root Certificate" forState:UIControlStateNormal];
                    }
                    
                }
                
            }
			
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_type"] setObject:[CommonProvMethods getStringForEAPType:eapType] forKey:@"text"];
            
			
		}
		else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:Passphrase]){
            
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			lObjTextField.tag = indexPath.row + textField_Tag;
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
			[lObjTextField setDelegate:self];
            
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"password"] objectForKey:@"text"]];
			[lObjTextField setSecureTextEntry:passwordSecurityStatus];
			[cell.contentView addSubview:lObjTextField];
			
		}
		else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:WEP_Key_Index]){
            
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			lObjTextField.tag = indexPath.row + textField_Tag;
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
            [lObjTextField setUserInteractionEnabled:NO];
			[lObjTextField setDelegate:self];
			[cell.contentView addSubview:lObjTextField];
            
            if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"] length] > 0) {
                NSLog(@"wep key index= %@",[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"]);
                
                [lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"]];
            }
            else {
                [lObjTextField setText:@"1"];
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] setObject:@"1" forKeyedSubscript:@"text"];
            }
            
            
            UIButton *lObjButton = [UIButton buttonWithType:UIButtonTypeCustom];
			lObjButton.tag = indexPath.row + 1001;
			[lObjButton setFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjButton addTarget:self action:@selector(bringUpKeySelector:) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:lObjButton];
			
			
		}
		else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:WEP_Key]){
            
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
            lObjTextField.tag = indexPath.row + textField_Tag;
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
			[lObjTextField setDelegate:self];
            [lObjTextField setSecureTextEntry:passwordSecurityStatus];
            
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKey"] objectForKey:@"text"]];
			
			[cell.contentView addSubview:lObjTextField];
			
			
		}
		else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:Wep_Auth]){
			
			NSMutableArray *lObjArray = [[NSMutableArray alloc] initWithObjects:@"open",@"shared", nil];
            
            NSString *wepauthString = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepauth"] objectForKey:@"text"];
            
            if([wepauthString isEqualToString:@"shared"]) {
                
                wepAuthType = 1;
            }
            else {
                
                wepAuthType = 0;
            }
			
			m_cObjSegControl = [[UISegmentedControl alloc] initWithItems:lObjArray];
			//m_cObjSegControl.segmentedControlStyle = UISegmentedControlStylePlain;
			m_cObjSegControl.frame = CGRectMake(110, 7, 185, 30);
			m_cObjSegControl.selectedSegmentIndex = wepAuthType;
			
			[m_cObjSegControl setTag:7];
			
			[m_cObjSegControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
			
			[cell.contentView addSubview:m_cObjSegControl];
			
			
		}
        
        
        else if([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:Set_Node_Time_To_Current_UTC_Time] && globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
            
            UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 85), 5, 50, 40)];
            lObjSwitch.backgroundColor=[UIColor clearColor];
            lObjSwitch.tag = utcSwitchTag;
            [lObjSwitch addTarget:self action:@selector(timeSwitchOnOff:) forControlEvents:UIControlEventValueChanged];
            [lObjSwitch setOn:globalValues.provisionSharedDelegate.utcSwitchState];
            [cell.contentView addSubview:lObjSwitch];
            
            if (globalValues.provisionSharedDelegate.UTC_Time_Supported == NO) {
                
                [lObjSwitch setAlpha:0.3];
                [lObjSwitch setUserInteractionEnabled:NO];
                
            }
            
        }
		else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:EAP_Username]){
			
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			lObjTextField.tag = indexPath.row + textField_Tag;
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
			[lObjTextField setDelegate:self];
			
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_username"] objectForKey:@"text"]];
			
			[cell.contentView addSubview:lObjTextField];
			
		}
		else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:EAP_Password]){
            
            
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			lObjTextField.tag = indexPath.row + textField_Tag;
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
			[lObjTextField setDelegate:self];
			
            [lObjTextField setSecureTextEntry:passwordSecurityStatus];
            
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_password"] objectForKey:@"text"]];
			
			[cell.contentView addSubview:lObjTextField];
			
		}
        
        else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:Use_Anonymous_ID]){
            
            
            UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 85), 5, 50, 40)];
            lObjSwitch.backgroundColor=[UIColor clearColor];
            lObjSwitch.tag = anonymousIDSwitchTag;
            [lObjSwitch addTarget:self action:@selector(anonymousSwitchValueChange) forControlEvents:UIControlEventValueChanged];
            [lObjSwitch setOn:sharedGsData.enableAnonymousSwitch];
            [cell.contentView addSubview:lObjSwitch];
        }

        else if ([[m_cObjTextFieldValues objectAtIndex:indexPath.row] isEqualToString:Configure_CNOU] && [[self eapTypeValue] isEqualToString:@"eap-tls"]) {
            
            UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-85), 5, 50, 40)];
            lObjSwitch.backgroundColor=[UIColor clearColor];
            lObjSwitch.tag = cnouSwitchTag;
            [lObjSwitch addTarget:self action:@selector(cnouSwitchValueChange) forControlEvents:UIControlEventValueChanged];
            [lObjSwitch setOn:sharedGsData.enableCNOUSwitch];
            [cell.contentView addSubview:lObjSwitch];
            
            if (sharedGsData.enableCNOUSwitch) {
                
                UILabel *cnLable = [[UILabel alloc] initWithFrame:CGRectMake(10, lObjSwitch.frame.origin.y+lObjSwitch.frame.size.height + 5, 110, 30)];
                [cnLable setBackgroundColor:[UIColor clearColor]];
                [cnLable setText:@"CN"];
                [cnLable setFont:[UIFont boldSystemFontOfSize:12]];
                [cnLable setBaselineAdjustment:UIBaselineAdjustmentNone];
                [cnLable setTextAlignment:NSTextAlignmentCenter];
                [cnLable setTextColor:[UIColor grayColor]];
                [cell.contentView addSubview:cnLable];
                
                UITextField *lObjCNTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, lObjSwitch.frame.origin.y+lObjSwitch.frame.size.height + 5, 160, 30)];
                lObjCNTextField.tag = cnTextFieldTag+textField_Tag;
                [lObjCNTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
                lObjCNTextField.borderStyle = UITextBorderStyleBezel;
                lObjCNTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [lObjCNTextField setTextAlignment:NSTextAlignmentRight];
                [lObjCNTextField setFont:[UIFont systemFontOfSize:16]];
                [lObjCNTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
                [lObjCNTextField setBackgroundColor:[UIColor clearColor]];
                [lObjCNTextField setReturnKeyType:UIReturnKeyDefault];
                [lObjCNTextField setDelegate:self];
                [cell.contentView addSubview:lObjCNTextField];
                
                lObjCNTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_cn"] objectForKey:@"text"];

                
                
                UILabel *ouLable = [[UILabel alloc] initWithFrame:CGRectMake(10, (cnLable.frame.origin.y + cnLable.frame.size.height + 5), 110, 30)];
                [ouLable setBackgroundColor:[UIColor clearColor]];
                [ouLable setText:@"OU"];
                [ouLable setFont:[UIFont boldSystemFontOfSize:12]];
                [ouLable setBaselineAdjustment:UIBaselineAdjustmentNone];
                [ouLable setTextAlignment:NSTextAlignmentCenter];
                [ouLable setTextColor:[UIColor grayColor]];
                [cell.contentView addSubview:ouLable];
                
                UITextField *lObjOUTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, (cnLable.frame.origin.y + cnLable.frame.size.height + 5), 160, 30)];
                lObjOUTextField.tag = ouTextFieldTag+textField_Tag;
                lObjOUTextField.borderStyle = UITextBorderStyleBezel;
                [lObjOUTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
                lObjOUTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [lObjOUTextField setTextAlignment:NSTextAlignmentRight];
                [lObjOUTextField setFont:[UIFont systemFontOfSize:16]];
                [lObjOUTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
                [lObjOUTextField setBackgroundColor:[UIColor clearColor]];
                [lObjOUTextField setReturnKeyType:UIReturnKeyDefault];
                [lObjOUTextField setDelegate:self];
                [cell.contentView addSubview:lObjOUTextField];
                
                lObjOUTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_ou"] objectForKey:@"text"];

            }

        }

		else {
			
			
		}
		
		
		
	}
	else {
		
		UIButton *lObjButtonNext = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[lObjButtonNext setFrame:CGRectMake(-1, -1, 300+2, 66)];
		[lObjButtonNext setTitle:@"Next" forState:UIControlStateNormal];
		[lObjButtonNext addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:lObjButtonNext];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.row == 0 && indexPath.section == 1) {
		
		return 66.0;
		
	}
    else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY && indexPath.section == 0 && sharedGsData.supportAnonymousID && [[self eapTypeValue] isEqualToString:@"eap-tls"] && indexPath.row == 8) {
        
        return (sharedGsData.enableCNOUSwitch?120:44);
        
    }
    
    else if (indexPath.row == 5+chip_version_correction && indexPath.section == 0){
        
        if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
            
            if(sharedGsData.isSupportsEAP_Option >=1)
            {
                
                if (eapType == 5) {
                    
                    return 320.0 + 110 + 80;
                    
                }
                else
                {
                    return 320.0 + 80;
                    
                }
                
            }
            else {
                
                if (eapType == 3) {
                    
                    return 320.0 + 110 ;
                    
                }
                else
                {
                    return 320.0 ;
                    
                }
                
            }
            
        } else {
            
            return 44.0;
            
        }
    }
    
	else {
		
		return 44.0;
		
	}
	
}


#pragma mark - methods

-(void)BandsegmentedControlIndexChanged :(id)sender {
    
    UITextField *lObjTextField = (UITextField *)[self.view viewWithTag:chip_version_correction+100002];
    
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    
    switch (segControl.selectedSegmentIndex) {
            
        case 0:
            
            bandSelectionIndex = 0;
            
            bandValue = 2.4;
            
            if([[m_cObjChannelData objectForKey:@"2.4GHz"] length] > 0)
            {
                [lObjTextField setText:[m_cObjChannelData objectForKey:@"2.4GHz"]];
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"2.4GHz"] forKey:@"text"];
                
            }
            else {
                [lObjTextField setText:[m_cObjPickerContentArray objectAtIndex:0]];
            }
            
            
            
            break;
        case 1:
            
            bandSelectionIndex = 1;
            
            bandValue = 5.0;
            
            if([[m_cObjChannelData objectForKey:@"5.0GHz"] length]>0) {
                
                [lObjTextField setText:[m_cObjChannelData objectForKey:@"5.0GHz"]];
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"5.0GHz"] forKey:@"text"];
                
            }
            else {
                
                [lObjTextField setText:[m_cObjPickerContentArray objectAtIndex:0]];
                
            }
            
            
            break;
            
        default:
            break;
            
    }
    
}

-(void)cnouSwitchValueChange {
   
    sharedGsData.enableCNOUSwitch = !sharedGsData.enableCNOUSwitch;
    
        [m_cObjtableView reloadData];
}

-(void)anonymousSwitchValueChange {
    sharedGsData.enableAnonymousSwitch = !sharedGsData.enableAnonymousSwitch;
}
-(void)timeSwitchOnOff:(id)sender {
    
    globalValues.provisionSharedDelegate.utcSwitchState = !globalValues.provisionSharedDelegate.utcSwitchState;
}

-(void)bringUpSecuritySelector {
    
	[UIView beginAnimations:nil context:NULL];
	
    [UIView setAnimationDuration:0.35];
    
	[ResetFrame bringUpPicker:m_cObjSecurityPicker KeyBoardResignButton:m_cObjKeyboardRemoverButton andUITableView:m_cObjtableView];
    
	[UIView commitAnimations];
	
    [m_cObjtableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	
}
-(void)bringUpKeySelector:(id)sender {
	
	UIButton *lObjButton = (UIButton *)sender;
	
	for (int i=101; i<=3+ globalValues.provisionSharedDelegate.clientSecurityType; i++) {
		
		if (i != 104) {
			
			UITextField *lObjTextField = (UITextField *)[m_cObjtableView viewWithTag:i];
			
			[lObjTextField resignFirstResponder];
			
		}
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];

    
    [ResetFrame bringUpPicker:m_cObjChannelPicker KeyBoardResignButton:m_cObjKeyboardRemoverButton andUITableView:m_cObjtableView];
	
    [UIView commitAnimations];
	
	
	if (lObjButton.tag == 1002+chip_version_correction) {
        
        pickerMode = CHANNEL_PICKER_MODE;
        
        
        
        m_cObjPickerContentArray = [[NSArray alloc] initWithArray:[ChannelFilter getChannelListForFrequency:bandValue firmwareVersion:sharedGsData.firmwareVersion.chip regulatoryDomain:[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"reg_domain"] objectForKey:@"text"] ClientMode:YES]];
        
        NSInteger selectedRow;
        
        if([m_cObjPickerContentArray containsObject:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]])
        {
            selectedRow = [m_cObjPickerContentArray indexOfObject:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]];
            
        }
        else {
            
            selectedRow = 0;
        }
        
        
        [m_cObjChannelPicker.lObjPicker reloadComponent:0];
        
        
        [m_cObjChannelPicker.lObjPicker selectRow:selectedRow inComponent:0 animated:NO];
		
		[m_cObjtableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
	}
	else {
        
		pickerMode = INDEX_PICKER_MODE;
        
        
        m_cObjPickerContentArray = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",nil];
        
        
        NSInteger selectedRow;
        
        
        /* -----------------------------------------------------------------------------------------
         if the wepkeyIndex is nil or zero then it select 1st value.
         --------------------------------------------------------------.----------------------------------------*/
        
        if([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"] isEqualToString:@""] || [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"] == nil || [[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"] intValue] == 0)
        {
            selectedRow = 0;
        }
        else if([m_cObjPickerContentArray containsObject:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"]]) {
            
            selectedRow  = [m_cObjPickerContentArray indexOfObject:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"]];
            
        }
        else {
            
            selectedRow = 0;
        }
        
        [m_cObjChannelPicker.lObjPicker reloadComponent:0];
        
        [m_cObjChannelPicker.lObjPicker selectRow:selectedRow inComponent:0 animated:NO];
		
		[m_cObjtableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
	}
	
}

-(void)openRootCertificateBrowser
{
	m_cObjBrowser = [[CertificateBrowser alloc] initWithControllerType:2];
    [m_cObjBrowser setTag:1];
    [m_cObjBrowser setM_cObjDelegate:self];
    [self presentViewController:m_cObjBrowser animated:YES completion:nil];
	
}

-(void)openClientCertificateBrowser
{
	m_cObjBrowser = [[CertificateBrowser alloc] initWithControllerType:2];
    [m_cObjBrowser setTag:2];
    [m_cObjBrowser setM_cObjDelegate:self];
    [self presentViewController:m_cObjBrowser animated:YES completion:nil];
    
}

-(void)openClientKeyBrowser
{
    m_cObjBrowser = [[CertificateBrowser alloc] initWithControllerType:2];
    [m_cObjBrowser setTag:3];
    [m_cObjBrowser setM_cObjDelegate:self];
    [self presentViewController:m_cObjBrowser animated:YES completion:nil];
    
}


-(void)selectedWPAMode:(NSInteger)pObjTag {
    
    globalValues.provisionSharedDelegate.m_cObjClientKeyName = @"";
    globalValues.provisionSharedDelegate.m_cObjClientKeyPath = @"";
    
    globalValues.provisionSharedDelegate.m_cObjClientCertName = @"";
    globalValues.provisionSharedDelegate.m_cObjClientCertPath = @"";
    
    globalValues.provisionSharedDelegate.m_cObjRootCertName = @"";
    globalValues.provisionSharedDelegate.m_cObjRootCertPath = @"";
    
	eapType = pObjTag%10000;
    
    NSString *lObjString = nil;
    
    int eapTypeTag;
    
    if(sharedGsData.isSupportsEAP_Option >= 1)
    {
        eapTypeTag =10006;
        
        switch (eapType) {
            case 0:
                
                lObjString = @"eap-fast-gtc";
                
                break;
            case 1:
                
                lObjString = @"eap-fast-mschap";
                
                break;
            case 2:
                
                lObjString = @"eap-ttls";
                
                break;
            case 3:
                
                lObjString = @"eap-peap0";
                
                break;
            case 4:
                
                lObjString = @"eap-peap1";
                
                break;
                
            case 5:
                
                lObjString = @"eap-tls";
                
                break;
                
            default:
                break;
        }
        
    }
    else {
        
        eapTypeTag =10004;
        
        switch (eapType) {
            case 0:
                
                lObjString = @"eap-fast";
                
                break;
            case 1:
                
                lObjString = @"eap-ttls";
                
                break;
            case 2:
                
                lObjString = @"eap-peap";
                
                break;
            case 3:
                
                lObjString = @"eap-tls";
                
                break;
                
            default:
                break;
        }
        
    }
    
   	
    [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_type"] setObject:lObjString forKey:@"text"];
    
	for (int i=10000; i< eapTypeTag; i++) {
		
		WPAModeButtonView *lObjView = (WPAModeButtonView *)[self.view viewWithTag:i];
		
		if (i == pObjTag) {
			
			[[lObjView m_cObjLabel] setTextColor:[UIColor whiteColor]];
			[[lObjView m_cObjImageView] setImage:[UIImage imageNamed:@"blue-button-selected.png"]];
			
		}
		else {
			
			[[lObjView m_cObjLabel] setTextColor:[UIColor darkGrayColor]];
			[[lObjView m_cObjImageView ]setImage:[UIImage imageNamed:@"blue-button.png"]];
			
		}
		
	}
    
    if ([[self eapTypeValue] isEqualToString:@"eap-tls"]) {

        if ([m_cObjTextFieldValues containsObject:Configure_CNOU]) {
            
            [m_cObjTextFieldValues replaceObjectAtIndex:8 withObject:Configure_CNOU];
        }
        else {
            [m_cObjTextFieldValues addObject:Configure_CNOU];
        }
        
    }
	
    //NSIndexPath *lIndxPath = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
    
    //[m_cObjtableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    NSLog(@">>>>>> textField array count = %zd \n %@",m_cObjTextFieldValues.count,m_cObjTextFieldValues);
    
    [m_cObjtableView reloadData];
	
}

-(void)wepModeSelected:(id)sender
{
	
}

-(void)goToNextPage {
	
	if (YES == [self checkForEmptyFields] && YES == [self checkAttachedCertificates] && YES == [self checkForHexValue] && YES == [self checkPassphraseLength] && YES == [self checkForSSIDLength] && YES == [self checkEAPUsername] && YES == [self checkEAPPassword]) {
		
		[self resignKeyPad];
		
		[self launchIPConfigScreen];
		
	}
	
}

-(BOOL)checkEAPPassword {
    
    if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
       
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_password"] objectForKey:@"text"] == nil) {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"EAP Password should not be empty" message:@"Please enter a EAP Password" confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            [lObjFieldValidation show];
            
            return NO;
            
        }
    }
    
    return YES;
}

-(BOOL)checkEAPUsername {
    
    if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
        
        NSString *eapUsernameText = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_username"] objectForKey:@"text"];
        
        if (eapUsernameText == nil ) {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"EAP Username should not be empty" message:@"Please enter a EAP Username" confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            [lObjFieldValidation show];
            
            return NO;
            
        }
    }
  
    
    return YES;
}

-(BOOL)checkForSSIDLength {
    
    return [ValidationUtils validateSSIDLength:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]];
}


-(BOOL)checkPassphraseLength {
	
	if (globalValues.provisionSharedDelegate.clientSecurityType == 2) {
        
        return [ValidationUtils validatePassphraseLength:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"password"] objectForKey:@"text"]];

	}
	else {
        
		return YES;
	}
	
}

-(BOOL)checkForHexValue {
    
    if (globalValues.provisionSharedDelegate.clientSecurityType == 1) {
        
        return [ValidationUtils validateHexValue:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKey"] objectForKey:@"text"]];
    }
	
	return YES;
}

-(BOOL)checkForEmptyFields {
	
	NSArray *lOBjArray = [NSArray arrayWithArray:[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] allKeys]];
    
	for (int i = 0; i < [lOBjArray count]; i++) {
		
        if ([[lOBjArray objectAtIndex:i] isEqualToString:@"wepauth"]) {
            
            continue;
        }
        
		if (globalValues.provisionSharedDelegate.clientSecurityType == OPEN_SECURITY) {
            
            if ([[lOBjArray objectAtIndex:i] isEqualToString:@"wepKey"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"wepKeyIndex"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"password"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_username"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"wepauth"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_password"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_type"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_cn"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_ou"]) {
                
                continue;
            }
        }
		if (globalValues.provisionSharedDelegate.clientSecurityType == WEP_SECURITY) {
            
            if ([[lOBjArray objectAtIndex:i] isEqualToString:@"password"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_username"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_password"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_type"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_cn"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_ou"]) {
                
                continue;
            }
        }
        if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_PERSONAL_SECURITY) {
            
            if ([[lOBjArray objectAtIndex:i] isEqualToString:@"wepKey"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"wepKeyIndex"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_password"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_username"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"wepauth"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_password"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_type"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_cn"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_ou"]) {
                
                continue;
            }
			
        }
        if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
            
            if ([[lOBjArray objectAtIndex:i] isEqualToString:@"wepKey"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"wepKeyIndex"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"password"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"wepauth"]) {
                
                continue;
            }
            else if (!(sharedGsData.supportAnonymousID && [[self eapTypeValue] isEqualToString:@"eap-tls"] && sharedGsData.enableCNOUSwitch)) {
                
                if ([[lOBjArray objectAtIndex:i] isEqualToString:@"eap_cn"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"eap_ou"]) {
                    
                    continue;
                }
            }
			
        }
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:[lOBjArray objectAtIndex:i]] objectForKey:@"text"]) {
            
            NSString *lObjStr = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:[lOBjArray objectAtIndex:i]] objectForKey:@"text"]];
            
            if ([[lOBjArray objectAtIndex:i] isEqualToString:@"eap_type"] && [lObjStr isEqualToString:@"(null)"]) {
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_type"] setObject:[CommonProvMethods getBoldStringForEAPType:eapType] forKey:@"text"];
                
                lObjStr = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:[lOBjArray objectAtIndex:i]] objectForKey:@"text"]];
                
            }
            
            if ([[lObjStr stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [lObjStr isEqualToString:@"(null)"]) {
                
				NSString *lObjString = [NSString stringWithString:[FieldTitles objectForKey:[lOBjArray objectAtIndex:i]]];
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Fill up all the fields to continue" message:[NSString stringWithFormat:@"please enter %@",lObjString] confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
                [lObjFieldValidation show];
                
                return NO;
				
            }
			
        }
        else
        {
            
            continue;
        }
        
	}
	
	return YES;
    
}

-(BOOL)checkAttachedCertificates {
	
    if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
        
        int eapTypeCheck = (sharedGsData.isSupportsEAP_Option >= 1 ? 5 : 3);
        
        if (eapType == eapTypeCheck) {
            
            if ([globalValues.provisionSharedDelegate.m_cObjRootCertName isEqualToString:@"Attach Root Certificate"] || globalValues.provisionSharedDelegate.m_cObjRootCertName.length == 0) {
                
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Attachment missing" message:[NSString stringWithFormat:@"please attach Root Certificate to proceed"] confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
                [lObjFieldValidation show];
                
                return NO;
                
            }
            else if ([globalValues.provisionSharedDelegate.m_cObjClientCertName isEqualToString:@"Attach Client Certificate"] || globalValues.provisionSharedDelegate.m_cObjClientCertName.length == 0) {
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Attachment missing" message:[NSString stringWithFormat:@"please attach Client Certificate to proceed"] confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
                [lObjFieldValidation show];
                
                return NO;
                
            }
            else if ([globalValues.provisionSharedDelegate.m_cObjClientKeyName isEqualToString:@"Attach Client Key"] || globalValues.provisionSharedDelegate.m_cObjClientKeyName.length == 0) {
                
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Attachment missing" message:[NSString stringWithFormat:@"please attach Client Key to proceed"] confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
                [lObjFieldValidation show];
                
                return NO;
                
            }
            
        }
        else {
            
            return YES;
        }
        
    }
    else
    {
        return YES;
    }
    
    
    
    return YES;
}

-(void)launchIPConfigScreen {
 
    NSString *ipType = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"ip_type"] objectForKey:@"text"];
    
    if ([ipType isEqualToString:@"static"]) {
        
        globalValues.provisionSharedDelegate.ipAdressType = IP_TYPE_MANUAL;
    }
    else {
        
        globalValues.provisionSharedDelegate.ipAdressType = IP_TYPE_DHCP;
    }
    
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Network Settings" message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"Cancel";
    info.otherButtonTitle = @"Next";
    
    GSUIAlertView *m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleIPSetting delegate:self];
    
    m_cObjAlertView.tag = 201;
    
    m_cObjAlertView.m_cObjIPSettingsView.segmentControl.tag = 101;
    
    m_cObjAlertView.m_cObjIPSettingsView.segmentControl.selectedSegmentIndex = globalValues.provisionSharedDelegate.ipAdressType;
    
	[m_cObjAlertView.m_cObjIPSettingsView.segmentControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    [m_cObjAlertView show];
    
    
}


-(void)segmentedControlIndexChanged:(id)sender {
	
	UISegmentedControl *lObjSegmentedControl = (UISegmentedControl *)sender;
	
	[self resignKeyPad];
	
	if (lObjSegmentedControl.tag == 101) {
		
		switch (lObjSegmentedControl.selectedSegmentIndex) {
				
			case 0:
			{
				globalValues.provisionSharedDelegate.ipAdressType = IP_TYPE_DHCP;
			}
				break;
			case 1:
            {
                globalValues.provisionSharedDelegate.ipAdressType = IP_TYPE_MANUAL;
            }
				break;
		}
		
	}
	else if (lObjSegmentedControl.tag == 7){
		
		switch (lObjSegmentedControl.selectedSegmentIndex) {
			case 0:
            {
				wepAuthType = 0;
				
				[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepauth"] setValue:@"open" forKey:@"text"];
				
            }
				break;
			case 1:
            {
				wepAuthType = 1;
				
				[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepauth"] setValue:@"shared" forKey:@"text"];
				
            }
				break;
		}
		
	}
	else if (lObjSegmentedControl.tag == WPA_PERSONAL_SECURITY_TYPE){
		
        NSIndexPath *lIndxPath1;
        NSIndexPath *lIndxPath2;
        NSIndexPath *lIndxPath3;
        
        
		switch (lObjSegmentedControl.selectedSegmentIndex) {
                
			case 0:
            {
				[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-personal" forKey:@"text"];
				
				[m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:Passphrase];
				
				lIndxPath1 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
				
				lIndxPath2 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
				
				lIndxPath3 = [NSIndexPath indexPathForRow:6+chip_version_correction inSection:0];
				
				[m_cObjtableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
				
				wpaAuthType = 0;
				
				[m_cObjtableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath2,lIndxPath3,nil] withRowAnimation:UITableViewRowAnimationFade];
            }
				break;
				
			case 1:
            {
				[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-enterprise" forKey:@"text"];
				
				[m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:EAP_Username];
				[m_cObjTextFieldValues replaceObjectAtIndex:4+chip_version_correction withObject:EAP_Password];
				[m_cObjTextFieldValues replaceObjectAtIndex:5+chip_version_correction withObject:EAP_Type];
				[m_cObjTextFieldValues replaceObjectAtIndex:6+chip_version_correction withObject:Set_Node_Time_To_Current_UTC_Time];
				
				lIndxPath1 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
				
				lIndxPath2 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
				
				lIndxPath3 = [NSIndexPath indexPathForRow:6+chip_version_correction inSection:0];
				
				[m_cObjtableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
				
				wpaAuthType = 1;
				
				[m_cObjtableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath2,lIndxPath3,nil] withRowAnimation:UITableViewRowAnimationFade];
            }
				break;
				
		}
		
	}
	else {
        
        NSIndexPath *lIndxPath1;
        NSIndexPath *lIndxPath2;
        NSIndexPath *lIndxPath3;
        NSIndexPath *lIndxPath4;
		
		switch (lObjSegmentedControl.selectedSegmentIndex) {
				
			case 0:
            {
				
				[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"none" forKey:@"text"];
				
				globalValues.provisionSharedDelegate.securedMode = NO;
				
				if (globalValues.provisionSharedDelegate.clientSecurityType == OPEN_SECURITY) {
					
					globalValues.provisionSharedDelegate.clientSecurityType = 0;
				}
				else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_PERSONAL_SECURITY){
					
					globalValues.provisionSharedDelegate.clientSecurityType = 0;
					
					if (wpaAuthType == 0) {
						
						lIndxPath1 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
						lIndxPath2 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
						
						[m_cObjtableView  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,nil] withRowAnimation:UITableViewRowAnimationFade];
						
						[m_cObjtableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
						
					}
					else {
						
						lIndxPath1 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
						lIndxPath2 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
						lIndxPath3 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
						lIndxPath4 = [NSIndexPath indexPathForRow:6+chip_version_correction inSection:0];
						
						[m_cObjtableView  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,lIndxPath3,lIndxPath4,nil] withRowAnimation:UITableViewRowAnimationFade];
						
					}
					
					
				}
				else {
					
					lIndxPath1 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
					lIndxPath2 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
					lIndxPath3 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
					
					globalValues.provisionSharedDelegate.clientSecurityType = 0;
					
					[m_cObjtableView  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,lIndxPath3,nil] withRowAnimation:UITableViewRowAnimationFade];
					
				}
				
				[m_cObjtableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
				
            }
				break;
                
			case 1:
            {
				globalValues.provisionSharedDelegate.securedMode = YES;
				
				if (wpaAuthType == 0) {
					
					[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-enterprise" forKey:@"text"];
					
					[m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:Passphrase];
					[m_cObjTextFieldValues replaceObjectAtIndex:4+chip_version_correction withObject:EAP_Type];
					
				}
				else {
					
					[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-personal" forKey:@"text"];
					
					[m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:EAP_Username];
					[m_cObjTextFieldValues replaceObjectAtIndex:4+chip_version_correction withObject:EAP_Password];
					[m_cObjTextFieldValues replaceObjectAtIndex:5+chip_version_correction withObject:EAP_Type];
					[m_cObjTextFieldValues replaceObjectAtIndex:6+chip_version_correction withObject:@"EAP Mode"];
					
				}
				
				
				if (globalValues.provisionSharedDelegate.clientSecurityType == OPEN_SECURITY) {
					
					globalValues.provisionSharedDelegate.clientSecurityType = WPA_PERSONAL_SECURITY;
					
					
					if (wpaAuthType == 0) {
						
						lIndxPath1 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
						lIndxPath2 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
						
						[m_cObjtableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,nil] withRowAnimation:UITableViewRowAnimationFade];
						
						
					}
					else {
						
						lIndxPath1 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
						lIndxPath2 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
						lIndxPath3 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
						lIndxPath4 = [NSIndexPath indexPathForRow:6+chip_version_correction inSection:0];
						
						[m_cObjtableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,lIndxPath3,lIndxPath4,nil] withRowAnimation:UITableViewRowAnimationFade];
						
					}
					
					[m_cObjtableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
					
				}
				else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_PERSONAL_SECURITY){
					
				}
				else {
					
					globalValues.provisionSharedDelegate.clientSecurityType = WPA_PERSONAL_SECURITY;
					
					
					if (wpaAuthType == 0) {
                        
                        
                        lIndxPath1 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
                        
						lIndxPath2 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
                        
						
						[m_cObjtableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath2,nil] withRowAnimation:UITableViewRowAnimationFade];
						
						[m_cObjtableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath2,lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
						
					}
					else {
						
						lIndxPath1 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
						
						lIndxPath2 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
						
						lIndxPath3 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
						
						lIndxPath4 = [NSIndexPath indexPathForRow:6+chip_version_correction inSection:0];
						
						[m_cObjtableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath3,nil] withRowAnimation:UITableViewRowAnimationFade];
						
						[m_cObjtableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,lIndxPath4,nil] withRowAnimation:UITableViewRowAnimationFade];
						
					}
					
					
				}
            }
				break;
                
			case 2:
            {
				[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wep" forKey:@"text"];
				
				globalValues.provisionSharedDelegate.securedMode = YES;
				
				[m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:WEP_Key_Index];
				[m_cObjTextFieldValues replaceObjectAtIndex:4+chip_version_correction withObject:WEP_Key];
				[m_cObjTextFieldValues replaceObjectAtIndex:5+chip_version_correction withObject:Wep_Auth];
				
				[m_cObjtableView reloadData];
				
				if (globalValues.provisionSharedDelegate.clientSecurityType == OPEN_SECURITY) {
					
					lIndxPath1 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
					lIndxPath2 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
					lIndxPath3 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
					
					globalValues.provisionSharedDelegate.clientSecurityType = WEP_SECURITY;
					
					[m_cObjtableView  insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,lIndxPath3,nil] withRowAnimation:UITableViewRowAnimationFade];
					
				}
				else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_PERSONAL_SECURITY){
					
					
					globalValues.provisionSharedDelegate.clientSecurityType = WEP_SECURITY;
					
					if (wpaAuthType == 0) {
						
						lIndxPath1 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
						
						
						[m_cObjtableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
						
					}
					else {
						
						lIndxPath2 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
						
						
						[m_cObjtableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath2,nil] withRowAnimation:UITableViewRowAnimationFade];
						
					}
					
					
					
				}
				else {
					
					
					globalValues.provisionSharedDelegate.clientSecurityType = WEP_SECURITY;
					
				}
                
            }
				break;
				
		}
		
	}
    
	
}


#pragma mark - UIAlertView Delegate Method

- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
		
    if (alertView.tag == 201) {
		
		if (buttonIndex == 1) {
			
			if (globalValues.provisionSharedDelegate.ipAdressType == IP_TYPE_DHCP) {
				
				NSString *SSID_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]];
				
				NSString *Channel_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]];
				
				NSString *Security_Str = [self securityTypeValue];
				
				
				if (globalValues.provisionSharedDelegate.clientSecurityType == 0) {
					
					m_cObjManualConfiguration = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:SSID_Str forKey:@"SSID"],[NSDictionary dictionaryWithObject:Security_Str forKey:@"Security"],[NSDictionary dictionaryWithObject:Channel_Str forKey:@"Channel"],nil];
					
				}
				else if (globalValues.provisionSharedDelegate.clientSecurityType == 1){
                    
                     NSLog(@"clientSecurityType %i",globalValues.provisionSharedDelegate.clientSecurityType);
					
                    if (wepAuthType == 0) {
						
						m_cObjManualConfiguration = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:SSID_Str forKey:@"SSID"],[NSDictionary dictionaryWithObject:Security_Str forKey:@"Security"],[NSDictionary dictionaryWithObject:Channel_Str forKey:@"Channel"],[NSDictionary dictionaryWithObject:@"open" forKey:Wep_Auth],nil];
						
					}
					else {
						
						m_cObjManualConfiguration = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:SSID_Str forKey:@"SSID"],[NSDictionary dictionaryWithObject:Security_Str forKey:@"Security"],[NSDictionary dictionaryWithObject:Channel_Str forKey:@"Channel"],[NSDictionary dictionaryWithObject:@"shared" forKey:Wep_Auth],nil];
						
					}
                    
				}
				else {
                    
					if (wpaAuthType == 0) {
						
						m_cObjManualConfiguration = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:SSID_Str forKey:@"SSID"],[NSDictionary dictionaryWithObject:Security_Str forKey:@"Security"],[NSDictionary dictionaryWithObject:Channel_Str forKey:@"Channel"],nil];
						
					}
					else {
                        
                        m_cObjManualConfiguration = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:SSID_Str forKey:@"SSID"],[NSDictionary dictionaryWithObject:Security_Str forKey:@"Security"],[NSDictionary dictionaryWithObject:Channel_Str forKey:@"Channel"],[NSDictionary dictionaryWithObject:[CommonProvMethods getBoldStringForEAPType:eapType] forKey:EAP_Type],nil];
                        
					}
					
				}
				
				[self showConfirmationForManualConfigWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:m_cObjManualConfiguration];
				
			}
			
			else {
                
				m_cObjManual_IPSettingScreen = [[Manual_IPSettingScreen alloc] initWithControllerType:2];
				m_cObjManual_IPSettingScreen.m_cObjDelegate = self;
                [self presentViewController:m_cObjManual_IPSettingScreen animated:YES completion:nil];
				
			}
            
		}
		
	}
	
}





-(void)showConfirmationForManualConfigWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray {
    
    PostSummaryController *summaryController = [[PostSummaryController alloc] initWithControllerType:6];
    summaryController.postDictionary = [self returnPostManualConfiguration];
    [self.navigationController pushViewController:summaryController animated:YES];
    
}

-(NSDictionary *)returnPostManualConfiguration {
   
 NSMutableDictionary *postDataDictionary = [NSMutableDictionary dictionary];
    
    postDataDictionary[@"channel"] = [NSString stringWithFormat:@"%d",[[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"] intValue]];
    
    postDataDictionary[@"ssid"] = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"];


    NSString *tempSecurity=[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"]  objectForKey:@"text"];

    if([tempSecurity isEqualToString:@"none"])
    {
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"none" forKey:@"text"];
    }
    else if([tempSecurity isEqualToString:@"WEP"])
    {
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wep" forKey:@"text"];
    }
    else if([tempSecurity isEqualToString:@"WPA/WPA2 Personal"])
    {
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-personal" forKey:@"text"];
    }
    else if([tempSecurity isEqualToString:@"WPA/WPA2 Enterprise"])
    {
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-enterprise" forKey:@"text"];
    }

    postDataDictionary[@"security"] = [self securityTypeValue];


	if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {

        NSString *eap_typeValue = [CommonProvMethods getStringForEAPType:eapType];
        
        postDataDictionary[@"eap_type"] = eap_typeValue;

        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_type"] setValue:eap_typeValue forKey:@"text"];


	}

    NSString *lObjSecurityValue = [self securityTypeValue];

    if ([lObjSecurityValue isEqualToString:@"WPA/WPA2 Enterprise"] || [lObjSecurityValue isEqualToString:@"wpa/wpa2 enterprise"] || [lObjSecurityValue isEqualToString:@"WPA-Enterprise"] || [lObjSecurityValue isEqualToString:@"wpa-enterprise"]) {

        postDataDictionary[@"eap_username"] = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_username"] objectForKey:@"text"];
        
        postDataDictionary[@"eap_password"] = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_password"] objectForKey:@"text"];
        
        if (sharedGsData.supportAnonymousID) {
            
            postDataDictionary[@"anon"] = (sharedGsData.enableAnonymousSwitch ? @"true" : @"false");
            
            if ([[self eapTypeValue] isEqualToString:@"eap-tls"]) {
                
                postDataDictionary[@"cnou"] = (sharedGsData.enableCNOUSwitch ? @"true" : @"false");
                
                if (sharedGsData.enableCNOUSwitch) {
                    
                    postDataDictionary[@"eap_cn"] = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_cn"] objectForKey:@"text"];
                    
                    postDataDictionary[@"eap_ou"] = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_ou"] objectForKey:@"text"];
                }
            }
        }
        
	}
	else if ([lObjSecurityValue isEqualToString:@"WPA/WPA2 Personal"] || [lObjSecurityValue isEqualToString:@"wpa/wpa2 personal"] || [lObjSecurityValue isEqualToString:@"WPA-Personal"] || [lObjSecurityValue isEqualToString:@"wpa-personal"]){

        postDataDictionary[@"password"] = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"password"] objectForKey:@"text"];
        
	}
	else if ([lObjSecurityValue isEqualToString:@"WEP"] || [lObjSecurityValue isEqualToString:@"wep"]){

        postDataDictionary[@"wepKeyIndex"] = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"];
        
        postDataDictionary[@"wepKey"] = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKey"] objectForKey:@"text"];
        
	}

    if (globalValues.provisionSharedDelegate.clientSecurityType == WEP_SECURITY) {

        if (wepAuthType == 0) {

            postDataDictionary[@"wepauth"] = @"open";
            

        }
        else {

            postDataDictionary[@"wepauth"] = @"shared";

        }

    }

	if (globalValues.provisionSharedDelegate.ipAdressType == IP_TYPE_DHCP) {

        postDataDictionary[@"ip_type"] = @"dhcp";
        
	}
	else {

        postDataDictionary[@"ip_type"] = @"static";

	}
    
    postDataDictionary[@"viewControllerMode"] = @"NavigationController";
    
    return postDataDictionary;
}

-(BOOL)checkForHexValueAndPassphrase {
	
	if (globalValues.provisionSharedDelegate.clientSecurityType == 2) {
		
		UITextField *lObjLabel = (UITextField *)[m_cObjtableView viewWithTag:100004];
        
        return [ValidationUtils validatePassphraseLength:lObjLabel.text];
				
	}
	else if (globalValues.provisionSharedDelegate.clientSecurityType == 1 ) {
		
		UITextField *lObjLabel = (UITextField *)[m_cObjtableView viewWithTag:100005];
        
        return [ValidationUtils validateHexValue:lObjLabel.text];
	}
	
	return YES;
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
	    
    [ResetFrame EditTextFieldToBringKeyPad:nil andTableView:m_cObjtableView];
    
	[UIView commitAnimations];
    
    NSInteger lObjTextFieldTag = (textField.tag-textField_Tag);
    
    if (lObjTextFieldTag > 90) {
        
        [m_cObjtableView setContentOffset:CGPointMake(0, 570) animated:YES];
    }
    else {
        
        [m_cObjtableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(textField.tag-textField_Tag) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
	
	return YES;
	
}// return NO to disallow editing.



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *lObjCurrentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger row = textField.tag - textField_Tag;
    
    if (row > 90) {
        
        [self replaceCNOUvalueAtRow:row withString:lObjCurrentString];
    }
    else {
       	[self replaceStringAtRow:row withString:lObjCurrentString];
    }

    return YES;
}

-(void)replaceCNOUvalueAtRow:(NSInteger)lObjRow withString:(NSString *)lObjString {
    
    if (lObjRow == cnTextFieldTag) {
        
        [[[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_cn"] setValue:lObjString forKey:@"text"]; //eap_cn
        
    }
    else if (lObjRow == ouTextFieldTag) {
        
        [[[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_ou"] setValue:lObjString forKey:@"text"]; //eap_ou
    }
    else {
        
    }
}

-(void)replaceStringAtRow:(NSInteger)pObjRow withString:(NSString *)pObjString {
    
	if ([[m_cObjTextFieldValues objectAtIndex:pObjRow] isEqualToString:SSID]) {
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[m_cObjTextFieldValues objectAtIndex:pObjRow] isEqualToString:Channel]){
        
        if (bandSelectionIndex == 0) {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"2.4GHz"] forKey:@"text"];
        }
        else {
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"5.0GHz"] forKey:@"text"];
        }
    }
	else if ([[m_cObjTextFieldValues objectAtIndex:pObjRow] isEqualToString:Passphrase]){
        
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"password"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[m_cObjTextFieldValues objectAtIndex:pObjRow] isEqualToString:WEP_Key]){
		
        
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKey"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[m_cObjTextFieldValues objectAtIndex:pObjRow] isEqualToString:WEP_Key_Index]){
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[m_cObjTextFieldValues objectAtIndex:pObjRow] isEqualToString:@"Beacon Interval (ms)"]){
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"beacon_interval"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[m_cObjTextFieldValues objectAtIndex:pObjRow] isEqualToString:EAP_Username]){
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_username"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[m_cObjTextFieldValues objectAtIndex:pObjRow] isEqualToString:EAP_Password]){
        
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_password"] setValue:pObjString forKey:@"text"];
		
	}
	else {
		
		
	}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
	   
    [ResetFrame resignKeyPad:m_cObjKeyboardRemoverButton ChannelPicker:Nil SecurityPicker:nil andTableView:m_cObjtableView];
	
	[UIView commitAnimations];
	
	[textField resignFirstResponder];
	
	return YES;
	
}// called when 'return' key pressed. return NO to ignore.

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	
	return YES;
}
// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end



#pragma mark - UIPickerView Delegate Methods.

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (pickerView.tag == channelPickerTag) {
        
        return [m_cObjPickerContentArray count];
		
    } else {
        
        return [m_cObjSecurityTypes count];
        
    }
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == channelPickerTag) {
        
        return [m_cObjPickerContentArray objectAtIndex:row];
        
    } else {
        
        return [m_cObjSecurityTypes objectAtIndex:row];
        
    }
	
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
    int sectionWidth;
	
    if (pickerView.tag == securityPickerTag) {
        
        sectionWidth = 260;
        
    } else {
        
        sectionWidth = 100;
    }
    
	return sectionWidth;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
	
    if (pickerView.tag == channelPickerTag) {
        
        if (  pickerMode == CHANNEL_PICKER_MODE) {
            
            if (bandSelectionIndex == 0) {
                
                [m_cObjChannelData setValue:[m_cObjPickerContentArray objectAtIndex:row] forKey:@"2.4GHz"];
                
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"2.4GHz"] forKey:@"text"];
            }
            else
            {
                [m_cObjChannelData setValue:[m_cObjPickerContentArray objectAtIndex:row] forKey:@"5.0GHz"];
                
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"5.0GHz"] forKey:@"text"];
            }
        }
        else {
			
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] setValue:[m_cObjPickerContentArray objectAtIndex:row] forKey:@"text"];
        }
    }
    else {
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:[m_cObjSecurityTypes objectAtIndex:row] forKey:@"text"];
		
        NSIndexPath *lIndxPath1;
        NSIndexPath *lIndxPath2;
        NSIndexPath *lIndxPath3;
        NSIndexPath *lIndxPath4;
        
        switch (row) {
            
            case 0: {
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"none" forKey:@"text"];
                
                globalValues.provisionSharedDelegate.securedMode = NO;
                
                if (globalValues.provisionSharedDelegate.clientSecurityType == OPEN_SECURITY) {
                    
                    globalValues.provisionSharedDelegate.clientSecurityType = 0;
                }
				else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_PERSONAL_SECURITY){
					
					globalValues.provisionSharedDelegate.clientSecurityType = 0;
					
					lIndxPath1 = [NSIndexPath indexPathForRow:3 inSection:0];
					
					[m_cObjtableView  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
					
					[m_cObjtableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
					
					
				}
                else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY){
                    
                    globalValues.provisionSharedDelegate.clientSecurityType = 0;
					
//					lIndxPath1 = [NSIndexPath indexPathForRow:3 inSection:0];
//					lIndxPath2 = [NSIndexPath indexPathForRow:4 inSection:0];
//					lIndxPath3 = [NSIndexPath indexPathForRow:5 inSection:0];
//                    lIndxPath4 = [NSIndexPath indexPathForRow:6 inSection:0];
//                    
//					[m_cObjtableView  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,lIndxPath3,lIndxPath4,nil] withRowAnimation:UITableViewRowAnimationFade];
                    
                    //[m_cObjtableView reloadData];
					
                }
                else {
                    
//                    lIndxPath1 = [NSIndexPath indexPathForRow:3 inSection:0];
//                    lIndxPath2 = [NSIndexPath indexPathForRow:4 inSection:0];
//                    lIndxPath3 = [NSIndexPath indexPathForRow:5 inSection:0];
                    
                    globalValues.provisionSharedDelegate.clientSecurityType = 0;
                    
                    //[m_cObjtableView  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,lIndxPath3,nil] withRowAnimation:UITableViewRowAnimationFade];
                    
                }
                
               // [m_cObjtableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                
            }
                break;
                
            case 1: {
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wep" forKey:@"text"];
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                if(chip_version_correction == CHIP_VERSION_1550) {
                    
                    [m_cObjTextFieldValues replaceObjectAtIndex:1 withObject:@"Band"];
                }
                
                [m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:WEP_Key_Index];
                [m_cObjTextFieldValues replaceObjectAtIndex:4+chip_version_correction withObject:WEP_Key];
                [m_cObjTextFieldValues replaceObjectAtIndex:5+chip_version_correction withObject:Wep_Auth];
                
               // [m_cObjtableView reloadData];
                
                if (globalValues.provisionSharedDelegate.clientSecurityType == OPEN_SECURITY) {
                    
					
                    lIndxPath2 = [NSIndexPath indexPathForRow:3+chip_version_correction inSection:0];
                    lIndxPath3 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
                    lIndxPath4 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
                    
                    globalValues.provisionSharedDelegate.clientSecurityType = WEP_SECURITY;
                    
                   // [m_cObjtableView  insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath2,lIndxPath3,lIndxPath4,nil] withRowAnimation:UITableViewRowAnimationFade];
					
                }
                else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_PERSONAL_SECURITY){
                    
                    
                    globalValues.provisionSharedDelegate.clientSecurityType = WEP_SECURITY;
                    
                    if (wpaAuthType == 0) {
                        
                        //[m_cObjtableView reloadData];
                        
                    }
                    else {
                        
                    }
                }
                else {
                globalValues.provisionSharedDelegate.clientSecurityType = WEP_SECURITY;
                    
                }
            }
                break;
                
            case 2:
            {
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                wpaAuthType = 0;
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-personal" forKey:@"text"];
                
                
                [m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:Passphrase];
                
                if (globalValues.provisionSharedDelegate.clientSecurityType == OPEN_SECURITY) {
                    
                    globalValues.provisionSharedDelegate.clientSecurityType = WPA_PERSONAL_SECURITY;
                    
                    //[m_cObjtableView reloadData];
                    
					
                }
                else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_PERSONAL_SECURITY)
                {
                    
                }
                
                else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY){
                    
                    globalValues.provisionSharedDelegate.clientSecurityType = WPA_PERSONAL_SECURITY;
                    
                   // [m_cObjtableView reloadData];
					
                }
				
                else {
                    
                    globalValues.provisionSharedDelegate.clientSecurityType = WPA_PERSONAL_SECURITY;
					
                    //[m_cObjtableView reloadData];
                    
                }
            }
                break;
                
			case 3:
            {
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] setValue:@"wpa-enterprise" forKey:@"text"];
                
                [m_cObjTextFieldValues replaceObjectAtIndex:3+chip_version_correction withObject:EAP_Username];
                [m_cObjTextFieldValues replaceObjectAtIndex:4+chip_version_correction withObject:EAP_Password];
                [m_cObjTextFieldValues replaceObjectAtIndex:5+chip_version_correction withObject:EAP_Type];
                [m_cObjTextFieldValues replaceObjectAtIndex:6+chip_version_correction withObject:Set_Node_Time_To_Current_UTC_Time];
                
                if (sharedGsData.supportAnonymousID) {
                    
                    if ([m_cObjTextFieldValues containsObject:Use_Anonymous_ID]) {
                        
                        [m_cObjTextFieldValues replaceObjectAtIndex:7 withObject:Use_Anonymous_ID];
                    }
                    else {
                        
                        [m_cObjTextFieldValues addObject:Use_Anonymous_ID];
                    }
                    
                    
                    
                    if ([[self eapTypeValue] isEqualToString:@"eap-tls"]) {
                        
                        if ([m_cObjTextFieldValues containsObject:Configure_CNOU]) {
                            
                            [m_cObjTextFieldValues replaceObjectAtIndex:8 withObject:Configure_CNOU];
                        }
                        else {
                            
                            [m_cObjTextFieldValues addObject:Configure_CNOU];
                        }
                        
                    }

                }
                
                globalValues.provisionSharedDelegate.clientSecurityType = WPA_ENTERPRISE_SECURITY;
               
                wpaAuthType = 1;
                
                //[m_cObjtableView reloadData];
            }
                break;
                
                
        }
        
    }
    
	
	[m_cObjtableView reloadData];
	
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

