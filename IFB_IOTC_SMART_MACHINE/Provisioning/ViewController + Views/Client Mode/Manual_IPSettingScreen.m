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
 * $RCSfile: Manual_IPSettingScreen.m,v $
 *
 * Description : Header file for Manual_IPSettingScreen functions and data structures
 *******************************************************************************/

#import "Manual_IPSettingScreen.h"
#import "GS_ADK_Data.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "InfoScreen.h"
#import "Identifiers.h"
#import <QuartzCore/QuartzCore.h>
#import "GSAlertInfo.h"
#import "GSUIAlertView.h"
#import "ManualClientModeConfig.h"
#import "ConcurrentModeInfoViewController.h"
#import "PostSummaryController.h"
#import "ValidationUtils.h"


#import "GSNavigationBar.h"




@interface Manual_IPSettingScreen(privateMethods)<CustomUIAlertViewDelegate>

-(void)resignSelf;
-(BOOL)checkForEmptyFields;
-(BOOL)checkForInvalidCharacters;
-(BOOL)checkForInvalidIPAdresses;
-(void)replaceStringAtRow:(NSInteger)pObjRow withString:(NSString *)pObjString;
-(void)showConfirmationForManualIPEntryWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray manualEntry:(NSArray *)aObjManualInfo;
-(void)confirmManualIPConfiguration;

@end


@implementation Manual_IPSettingScreen

@synthesize m_cObjDelegate;



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
	
	//appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    self.navigationBar.title = @"Network Settings";
	
	   
	m_cObjConfigLabels = [[NSArray alloc] initWithObjects:@"IP Address",@"Subnet Mask",@"Gateway",@"DNS",nil];
    
	m_cObjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height - 66) style:UITableViewStyleGrouped];
	[m_cObjTableView setDataSource:self];
	[m_cObjTableView setDelegate:self];
	[self.view addSubview:m_cObjTableView];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundColor:[UIColor clearColor]];
    [_closeButton setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60), ([UIScreen mainScreen].bounds.size.height + 100), 60, 30)];
    [_closeButton setImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
    [_closeButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
	
}

-(void)hideKeyboard {
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.35];
    
    _closeButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 60), ([UIScreen mainScreen].bounds.size.height + 100), 60, 30);
    
    [m_cObjTableView setFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
    [self.view endEditing:YES];
}


- (void)navigationItemTapped:(NavigationItem)item {
    
    switch (item) {
        case NavigationItemBack:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case NavigationItemCancel:
            
            [self hideKeyboard];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case NavigationItemInfo:
            
            [self showInfo];
            
            break;
            
        case NavigationItemMode:
            
            break;
            
        case NavigationItemDone:
            
            [self hideKeyboard];
            
            [self settingsDone];
            
            break;
            
        default:
            break;
    }
}

-(void)showInfo {
    
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
	[self presentViewController:lObjInfoScreen animated:YES completion:nil];
}



-(void)settingsDone {
    
    if ([self checkForEmptyFields] == YES  && [self checkForInvalidCharacters] == YES && [self checkForInvalidIPAdresses] == YES) {
		
        [self.view endEditing:YES];
        
        [self resignSelf];
        
	}
    
}

-(BOOL)checkForEmptyFields {
    
	for (int i=0; i < 4; i++) {
        
        UITextField *lObjTextField = (UITextField *)[m_cObjTableView viewWithTag:i+1];
        
		if ([[lObjTextField text] isEqualToString:@""] || [[lObjTextField text] isEqualToString:@"(null)"] || lObjTextField == nil  || lObjTextField.text == nil) {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Fill up all the fields to continue" message:[NSString stringWithFormat:@"please enter %@",[m_cObjConfigLabels objectAtIndex:i]] confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
						
            [lObjFieldValidation show];
			
			return NO;
		}
		
	}
	
	return YES;
}

-(BOOL)checkForInvalidCharacters {
	
	for (int i=0; i < 4; i++) {
		
        UITextField *lObjTextField = (UITextField *)[m_cObjTableView viewWithTag:i+1];
        
		NSString *myOriginalString = [NSString stringWithString:[lObjTextField text]];
		
		BOOL valid;
		
		NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
		
		NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[myOriginalString stringByReplacingOccurrencesOfString:@"." withString:@""]];
		
		valid = [alphaNums isSupersetOfSet:inStringSet];
		
		if (!valid) {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Alphanumeric characters other than (.) is not allowed" message:[NSString stringWithFormat:@"%@ should not contain alphanumeric characters other than (.)",[m_cObjConfigLabels objectAtIndex:i]] confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            
            [lObjFieldValidation show];
			
			return NO;
			
		}
		else {
            
		}
        
	}
	
	return YES;
}

-(BOOL)checkForInvalidIPAdresses {
    
    BOOL checkValidation;
    
    for (int i=0; i < [m_cObjConfigLabels count]; i++) {
    
        UITextField *lObjTextField = (UITextField *)[m_cObjTableView viewWithTag:i+1];
        
        checkValidation = [ValidationUtils validateIPAddress:[lObjTextField text] withTitle:[m_cObjConfigLabels objectAtIndex:i]];
        
        if(!checkValidation) {
            return NO;
        }
    }
    
    return YES;
	
}

-(void)indexOfRow:(NSInteger)rowNo {

    currentIndex = rowNo;
}

-(void)resignSelf {
    
    if (sharedGsData.securedMode == NO) {
        
        if (sharedGsData.manualConfigMode == NO) {
            
            NSArray *lObjArray = [NSArray arrayWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"dns_addr"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"],sharedGsData.confirmationScreen_Password,sharedGsData.WEP_Index,nil];
            
            
            NSArray *infoArray = [[NSArray alloc] initWithObjects:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"dns_addr"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"],@"",@"",nil];
            
            
            [self showConfirmationForManualIPEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:lObjArray manualEntry:infoArray];
            
            
        } else {
            
            NSArray *lObjArray = [[NSArray alloc] initWithObjects: [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"dns_addr"] objectForKey:@"text"], nil];
            
            
            NSArray *infoArray = [[NSArray alloc] initWithObjects:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"],@"",@"",nil];
            
            
            [self showConfirmationForManualIPEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray manualEntry:lObjArray];
            
            
        }
        
    }
    else {
        
        if (sharedGsData.manualConfigMode == NO) {
            
            NSArray *lObjArray = [NSArray arrayWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"],[m_cObjConfigLabels objectAtIndex:0],[m_cObjConfigLabels objectAtIndex:1],[m_cObjConfigLabels objectAtIndex:2],[m_cObjConfigLabels objectAtIndex:3],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"],sharedGsData.confirmationScreen_Password,sharedGsData.WEP_Index,nil];
            
            NSArray *infoArray = [[NSArray alloc] initWithObjects:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"],@"",@"",nil];
            
            [self showConfirmationForManualIPEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:lObjArray manualEntry:infoArray];
            
            
        }
        else
        {
            
            NSArray *lObjArray = [[NSArray alloc] initWithObjects: [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"], [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"dns_addr"] objectForKey:@"text"], nil];
            
            NSArray *infoArray = [[NSArray alloc] initWithObjects:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"],@"",@"",nil];
            
            [self showConfirmationForManualIPEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:lObjArray manualEntry:infoArray];
            
            
        }
        
        
    }
    
    
}

-(void)createListToShowSummary:(NSMutableDictionary *)lObjDict {
    
}

-(void)showConfirmationForManualIPEntryWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray manualEntry:(NSArray *)aObjManualInfo {
    
    PostSummaryController *summaryController = [[PostSummaryController alloc] initWithControllerType:6];
    summaryController.postDictionary = [self returnConfirmManualIPConfigurationSettings];
    [self presentViewController:summaryController animated:YES completion:nil];
}

- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
}



-(NSDictionary *)returnConfirmManualIPConfigurationSettings {
    
    NSLog(@"returnConfirmManualIPConfigurationSettings");
    
    NSMutableDictionary *postDataDictionary = [NSMutableDictionary dictionary];
    
    NSString *SSID_Str;
    
    NSString *Security_Str;
    
    NSString *Channel_Str;
    
    if ([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
    {
        if (sharedGsData.manualConfigMode == NO) {
            
            SSID_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
            
            Security_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"]];
            
            Channel_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"]];
            
        }
        else
        {
            
            SSID_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]];
            
            Security_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"]];
            
            Channel_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]];
            
        }
    }
    else
    {
        if (sharedGsData.manualConfigMode == NO) {
            
            SSID_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]];
            
            Security_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"]];
            
            Channel_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"channel"] objectForKey:@"text"]];
            
        }
        else
        {
            
            SSID_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]];
            
            Security_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"]];
            
            Channel_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]];
            
        }
    }
    

    [postDataDictionary setObject:Channel_Str forKey:@"channel"];
    [postDataDictionary setObject:Security_Str forKey:@"security"];
    [postDataDictionary setObject:SSID_Str forKey:@"ssid"];

    
    
    if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
        
        NSString *eapType = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_type"] objectForKey:@"text"];
        
        NSString *eapUsername = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_username"] objectForKey:@"text"];
        
        NSString *eapPassword = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_password"] objectForKey:@"text"];
        
        [postDataDictionary setObject:eapType forKey:@"eap_type"];
        [postDataDictionary setObject:eapUsername forKey:@"eap_username"];
        [postDataDictionary setObject:eapPassword forKey:@"eap_password"];
        
        
        
    }
    
    else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_PERSONAL_SECURITY){
        
        NSString *password = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"password"] objectForKey:@"text"];
        
        [postDataDictionary setObject:password forKey:@"password"];
        
    }
	   
    else if (globalValues.provisionSharedDelegate.clientSecurityType == WEP_SECURITY){
        
        NSString *wepKeyIndex = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"];
        
        NSString *wepKey = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKey"] objectForKey:@"text"];
        
        [postDataDictionary setObject:wepKeyIndex forKey:@"wepKeyIndex"];
        [postDataDictionary setObject:wepKey forKey:@"wepKey"];
        
        if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepauth"] objectForKey:@"text"] isEqualToString:@"open"]) {
            
            [postDataDictionary setObject:@"open" forKey:@"wepauth"];
            
        }
        else {
            
            [postDataDictionary setObject:@"shared" forKey:@"wepauth"];
            
            
        }
        
        
    }
    
    
    if (globalValues.provisionSharedDelegate.ipAdressType == IP_TYPE_DHCP) {
        
        [postDataDictionary setObject:@"dhcp" forKey:@"ip_type"];
        
    }
    else {
        
        [postDataDictionary setObject:@"static" forKey:@"ip_type"];
    }
    
    NSString *ipAddress = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"];
    
    NSString *subnetMask = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"];
    
    
    NSString *gateWay = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"];
    
    
    NSString *dnsAddress = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"dns_addr"] objectForKey:@"text"];
    
    [postDataDictionary setObject:ipAddress forKey:@"ip_addr"];
    [postDataDictionary setObject:subnetMask forKey:@"subnetmask"];
    [postDataDictionary setObject:gateWay forKey:@"gateway"];
    [postDataDictionary setObject:dnsAddress forKey:@"dns_addr"];
    
    postDataDictionary[@"viewControllerMode"] = @"ModalViewController";
    
    return postDataDictionary;
    
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if (section == 0) {
        
		if (currentMode == 0) {
			
			return [m_cObjConfigLabels count];
			
		}
		else {
			
			return [m_cObjConfigLabels count];
			
		}
		
	}
	else {
		
		return 1;
	}
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //cell.tag=indexPath.row+1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [m_cObjConfigLabels objectAtIndex:indexPath.row];
    
    
    UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, 145, 44)];
    
    
    if ([[m_cObjConfigLabels objectAtIndex:indexPath.row] isEqualToString:@"IP Address"]) {
		
        lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"];
        
    }
    else if ([[m_cObjConfigLabels objectAtIndex:indexPath.row] isEqualToString:@"Subnet Mask"]){
		
        lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"];
    }
    else if ([[m_cObjConfigLabels objectAtIndex:indexPath.row] isEqualToString:@"Gateway"]){
		
        lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"];
		
    }
    else if ([[m_cObjConfigLabels objectAtIndex:indexPath.row] isEqualToString:@"DNS"]){
		
        lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"dns_addr"] objectForKey:@"text"];
		
    }
    
    [lObjTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    lObjTextField.tag = indexPath.row+1;
    lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [lObjTextField setFont:[UIFont systemFontOfSize:14]];
    [lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
    [lObjTextField setBackgroundColor:[UIColor clearColor]];
    lObjTextField.textAlignment = NSTextAlignmentRight;
    [lObjTextField setDelegate:self];
    [cell.contentView addSubview:lObjTextField];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - UITextField Delegate Methods;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	[UIView beginAnimations:nil context:NULL];
	
    [UIView setAnimationDuration:0.35];
    
    _closeButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 60), ([UIScreen mainScreen].bounds.size.height - 245), 60, 30);
    [m_cObjTableView setFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height -66 -210)];
	
    [UIView commitAnimations];
	
	[m_cObjTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
	return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    NSString *lObjCurrentString=nil;
    
    if (range.length == 0) {
        
        if (range.location == textField.text.length)
        {
            
            lObjCurrentString = [NSString stringWithFormat:@"%@%@",textField.text,string];
            
        }
        else if (range.location == 0)
        {
            
            lObjCurrentString = [NSString stringWithFormat:@"%@%@",string,textField.text];
            
        }
        else
        {
            NSString *startString = [NSString stringWithString:[textField.text substringToIndex:range.location]];
            
            NSString *middleString = [NSString stringWithString:string];
            
            NSString *endString = [NSString stringWithString:[textField.text substringFromIndex:range.location]];
            
            lObjCurrentString = [NSString stringWithFormat:@"%@%@%@",startString,middleString,endString];
            
        }
        
    }
    else {
        
        if ([string isEqualToString:@""]) {
            
            
            lObjCurrentString = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            
        }
        
    }
	
	
	NSInteger row = textField.tag - 1;
	
	
	[self replaceStringAtRow:row withString:lObjCurrentString];
	
	
	return YES;
	
}

-(void)replaceStringAtRow:(NSInteger)pObjRow withString:(NSString *)pObjString {
    
	if ([[m_cObjConfigLabels objectAtIndex:pObjRow] isEqualToString:@"IP Address"]) {
        
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"ip_addr"] setObject:pObjString forKey:@"text"];
        
	}
	else if ([[m_cObjConfigLabels objectAtIndex:pObjRow] isEqualToString:@"Subnet Mask"]){
        
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"subnetmask"] setObject:pObjString forKey:@"text"];
        
	}
	else if ([[m_cObjConfigLabels objectAtIndex:pObjRow] isEqualToString:@"Gateway"]){
        
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"gateway"] setObject:pObjString forKey:@"text"];
		
	}
	else if ([[m_cObjConfigLabels objectAtIndex:pObjRow] isEqualToString:@"DNS"]){
        
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"dns_addr"] setObject:pObjString forKey:@"text"];
		
	}
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	[UIView beginAnimations:nil context:NULL];
    
	[UIView setAnimationDuration:0.35];
    
    _closeButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 60), ([UIScreen mainScreen].bounds.size.height + 100), 60, 30);

	[m_cObjTableView setFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height)];
    
	[UIView commitAnimations];
    
	[textField resignFirstResponder];
    
	return YES;
    
}

// called when 'return' key pressed. return NO to ignore.

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
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

