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
 * $RCSfile: LimitedAPWirelessSettingsScreen.m,v $
 *
 * Description : Header file for LimitedAPWirelessSettingsScreen functions and data structures
 *******************************************************************************/

#import "LimitedAPWirelessSettingsScreen.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "GS_ADK_Data.h"
#import "InfoScreen.h"
#import "Identifiers.h"
#import "LimitedAPIPSettingsScreen.h"
#import "ChannelFilter.h"
#import "UINavigationBar+TintColor.h"
#import "ResetFrame.h"
#import "UITableView+SpecificFrame.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"

#import "GSNavigationBar.h"
#import "ModeController.h"
#import "CommonProvMethods.h"
#import "ValidationUtils.h"


#define OPEN_SECURITY               0

#define CHIP_VERSION_1550                       1
#define CHIP_VERSION_1500                       0

#define CHANNEL_PICKER_MODE                     0
#define INDEX_PICKER_MODE                       1


@interface LimitedAPWirelessSettingsScreen (privateMethods)

-(BOOL)checkForEmptyFields;
-(BOOL)checkForBeaconValue;
-(void)resignKeyPad;
-(void)replaceStringAtRow:(NSInteger)pObjRow withString:(NSString *)pObjString;

@end


@implementation LimitedAPWirelessSettingsScreen


@synthesize appDelegate,sharedGsData,m_cObjIPSettingsScreen,m_cObjSegControl,m_cObjTableView;
@synthesize m_cObjChannelSelector,m_cObjChannelInfo,m_cObjChannelPicker,m_cObjKeyboardRemoverButton,m_cObjModeDescriptionLabel;
@synthesize m_cObjPasswordBackup,m_cObjKeyBackup,m_cObjAPCredentails,m_cObjFieldCredentails,m_cObjPickerContentArray,m_cObjModeDescription;
@synthesize ipAdressType,passwordSecurityStatus, chip_version_correction, bandValue;



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
	    
	m_cObjKeyBackup  = @"";
	
	m_cObjPasswordBackup  = @"";
	
	m_cObjModeDescription = @"Open";
	
	appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
	   
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    
    security_string=[[NSString alloc]init];
    
	if ([sharedGsData apConfig]) {
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"security"] setObject:@"none" forKey:@"text"];
            
        }
        
		if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"]) {
			
			globalValues.provisionSharedDelegate.apSecurityType = 0;
			m_cObjAPCredentails =[[NSMutableArray alloc] initWithObjects:@"SSID",@"Channel",@"Beacon Interval (ms)",@"Security",@"Passphrase",@"*",nil];
			
		}
		else if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wpa-personal"]) {
			
			globalValues.provisionSharedDelegate.apSecurityType = 2;
			m_cObjAPCredentails =[[NSMutableArray alloc] initWithObjects:@"SSID",@"Channel",@"Beacon Interval (ms)",@"Security",@"Passphrase",@"*",nil];
			
		}
		else {
			
			globalValues.provisionSharedDelegate.apSecurityType = 1;
			m_cObjAPCredentails =[[NSMutableArray alloc] initWithObjects:@"SSID",@"Channel",@"Beacon Interval (ms)",@"Security",@"WEP Key Index",@"WEP Key",nil];
			
		}
        
	}
	else {
		
		globalValues.provisionSharedDelegate.apSecurityType =0;
		m_cObjAPCredentails =[[NSMutableArray alloc] initWithObjects:@"SSID",@"Channel",@"Beacon Interval (ms)",@"Security",@"Passphrase",@"*",nil];
        
	}
	    
    if  ([sharedGsData.firmwareVersion.chip rangeOfString:@"gs1550m" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        
        [m_cObjAPCredentails insertObject:@"Band" atIndex:1];
        
        chip_version_correction = CHIP_VERSION_1550;
    }
    
    
    m_cObjChannelData = [[NSMutableDictionary alloc] init];
    
    
    NSString *lObjStr = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"];
    
    
    if([lObjStr intValue] > 14)
    {
        bandSelectionIndex = 1;
        bandValue = 5.0;
        [m_cObjChannelData setValue:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"] forKey:@"5.0GHz"];
        
    }
    else {
        
        bandSelectionIndex = 0;
        bandValue = 2.4;
        [m_cObjChannelData setValue:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"] forKey:@"2.4GHz"];
        
    }
    
    
    m_cObjPickerContentArray = [[NSArray alloc] initWithArray:[ChannelFilter getChannelListForFrequency:bandValue firmwareVersion:sharedGsData.firmwareVersion.chip regulatoryDomain:[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"reg_domain"] objectForKey:@"text"] ClientMode:NO]];
    
    self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"]];
    
    self.navigationBar.title = @"Wireless Settings";
    	
	passwordSecurityStatus = YES;
    
    //=============================== UITableView ======================================
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        m_cObjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT+STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-125) style:UITableViewStyleGrouped];
    }
    else {
        
        m_cObjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT+STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TAB_BAR_HEIGHT-STATUS_BAR_HEIGHT-MARGIN) style:UITableViewStyleGrouped];
    }
	
    
	[m_cObjTableView setDataSource:self];
	[m_cObjTableView setDelegate:self];
	[self.view addSubview:m_cObjTableView];
    
    //============================ close button ====================================
	
	m_cObjKeyboardRemoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[m_cObjKeyboardRemoverButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
	[m_cObjKeyboardRemoverButton addTarget:self action:@selector(resignKeyPad) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:m_cObjKeyboardRemoverButton];
    
    //================================== Channel Picker ======================================
    
    m_cObjChannelPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 220) delegate:self withTag:0];
    [m_cObjChannelPicker setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:m_cObjChannelPicker];
    
	
}

-(NSArray *)getFieldInputs
{
	
	NSMutableArray *lObjArray = [[NSMutableArray alloc] init];
	
	for (int i=1; i<=4 + globalValues.provisionSharedDelegate.apSecurityType; i++) {
		
		if (i == 1 || i == 3) {
            
			[lObjArray addObject:@""];
		}
		else if (i==2){
            
			[lObjArray addObject:@""];
			
		}
		
		else if (i==4){
			
			switch (globalValues.provisionSharedDelegate.apSecurityType) {
				case 0:
					[lObjArray addObject:@"none"];
					break;
				case 1:
					[lObjArray addObject:@"WEP"];
					break;
				case 2:
					[lObjArray addObject:@"WPA2"];
					break;
				default:
					break;
			}
			
			
		}
		
		
	}
	
	return lObjArray;
}

-(void)showInfo
{
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
    [self presentViewController:lObjInfoScreen animated:YES completion:nil];
}

-(void)goToNextPage {
    
    [self resignKeyPad];
	
	if (YES == [self checkForEmptyFields] && YES == [self checkForBeaconValue] && YES == [self checkForHexValue] && YES == [self checkPassphraseLength] && YES == [self checkForSSIDLength]) {
		
		[self resignKeyPad];
		
		m_cObjIPSettingsScreen = [[LimitedAPIPSettingsScreen alloc] initWithControllerType:1];
        m_cObjIPSettingsScreen.security_str=security_string;
		[self.navigationController pushViewController:m_cObjIPSettingsScreen animated:YES];
		
	}
	
}

-(BOOL)checkForSSIDLength {
    
    return [ValidationUtils validateSSIDLength:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]];
    
//    NSString *lObjStr = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"];
//    
//    if(lObjStr.length < 33)
//    {
//        return YES;
//    }
//    else {
//        
//        
//        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Not a valid SSID" message:@"Please enter a ssid with a maximum length of 32 characters" confirmationData:[NSDictionary dictionary]];
//        info.cancelButtonTitle = @"OK";
//        info.otherButtonTitle = nil;
//        
//        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
//        [lObjFieldValidation show];
//        [lObjFieldValidation release];
//        
//        return NO;
//    }
}

-(BOOL)checkForEmptyFields {
	
	int lastIndex = 3 + globalValues.provisionSharedDelegate.apSecurityType;
    
	for (int i=0; i < lastIndex; i++) {
        
		if (i != 3) {
            
			UITextField *lObjTextField = (UITextField *)[m_cObjTableView viewWithTag:i+101];
			
			if (lObjTextField != nil) {
                
				if ([[[lObjTextField text] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
                    
                    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Fill up all the fields to continue" message:[NSString stringWithFormat:@"please enter %@",[m_cObjAPCredentails objectAtIndex:i]] confirmationData:[NSDictionary dictionary]];
                    info.cancelButtonTitle = @"OK";
                    info.otherButtonTitle = nil;
                    
                    GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
										
                    [lObjFieldValidation show];
					
					return NO;
				}
				
			}
            
		}
		
	}
	
	return YES;
}

-(BOOL)checkForBeaconValue {
    
	if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"beacon_interval"] objectForKey:@"text"] intValue] < 50 || [[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"beacon_interval"] objectForKey:@"text"] intValue] > 1500) {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Invalid Beacon Interval" message:[NSString stringWithFormat:@"Please enter a beacon interval between 50 and 1500"] confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
        [lObjFieldValidation show];
		
		return NO;
	}
	
	return YES;
}

-(BOOL)checkForHexValue {
    
//    if (appDelegate.apSecurityType == 1) {
//    
//        return [ValidationUtils validateHexValue:<#(NSString *)#>];
//    }
    
	
	if (globalValues.provisionSharedDelegate.apSecurityType == 1) {
        
		UITextField *lObjTextField = (UITextField *)[m_cObjTableView viewWithTag:106+chip_version_correction];
        
		if ([lObjTextField.text length] != 10) {
            
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Not a valid key" message:@"WEP key must be a 10 digit value using numbers 0-9 and/or characters A-F." confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            [lObjFieldValidation show];
			
			return NO;
            
		}
		
		for (int i = 0; i < [lObjTextField.text length]; i++) {
			
			int asciiCode = [lObjTextField.text characterAtIndex:i]; // 65
			
			if(!((asciiCode >= 48 && asciiCode <= 57) || (asciiCode >=65 && asciiCode <=70) || (asciiCode >=97 && asciiCode <=102)))
			{
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Not a valid key" message:@"Please enter hexadecimal key" confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
                [lObjFieldValidation show];
				
				return NO;
                
			}
			
		}
		
	}
	
	return YES;
}

-(BOOL)checkPassphraseLength {
	
	if (globalValues.provisionSharedDelegate.apSecurityType == 2) {
        
		UITextField *lObjPassField = (UITextField *)[m_cObjTableView viewWithTag:105+chip_version_correction];
        
        return [ValidationUtils validatePassphraseLength:lObjPassField.text];
		
//		if (lObjPassField.text.length < 8 || lObjPassField.text.length > 63) {
//            
//            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Not a valid Passphrase" message:@"Please enter a passphrase with a minimum length of 8 characters and maximum length of 63 characters" confirmationData:[NSDictionary dictionary]];
//            info.cancelButtonTitle = @"OK";
//            info.otherButtonTitle = nil;
//            
//            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
//            [lObjFieldValidation show];
//			[lObjFieldValidation release];
//			
//			return NO;
//		}
//		else {
//			
//			return YES;
//		}
		
		
	}
	else {
        
		return YES;
	}
	
}

-(void)resignKeyPad {
    
    
    for (int tag =0; tag<=4+globalValues.provisionSharedDelegate.apSecurityType+chip_version_correction; tag++) {
        
        UITextField *lObjTextField = (UITextField *)[m_cObjTableView viewWithTag:tag+101];
        
        if (lObjTextField != nil) {
            
            [lObjTextField resignFirstResponder];
            
        }
    }
    
	
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
    
  //  [ResetFrame resignKeyPad:m_cObjKeyboardRemoverButton ChannelPicker:m_cObjChannelPicker SecurityPicker:nil andTableView:m_cObjTableView];
	
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height+100, 60, 30)];
       
        [m_cObjTableView setFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-125)];
    
        [m_cObjChannelPicker setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 220)];
    }
    
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
        
        [m_cObjChannelPicker setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 220)];
        
        [m_cObjTableView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        
    }

	
	[UIView commitAnimations];
	
}

-(void)segmentedControlIndexChanged {
    
     NSIndexPath *lIndxPath1;
    NSIndexPath *lIndxPath2;
    
 	switch (m_cObjSegControl.selectedSegmentIndex) {
			
 		case 0:
        {
			security_string=@"none";
            
			[m_cObjTableView reloadData];
            
			if (globalValues.provisionSharedDelegate.apSecurityType == OPEN_SECURITY) {
				
			}
			else if (globalValues.provisionSharedDelegate.apSecurityType == WPA_PERSONAL_SECURITY){
				
				lIndxPath1 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
				
				globalValues.provisionSharedDelegate.apSecurityType = OPEN_SECURITY;
				
				[m_cObjTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
				
			}
			else {
				
				lIndxPath1 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
				lIndxPath2 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
				
				globalValues.provisionSharedDelegate.apSecurityType = OPEN_SECURITY;
				
				[m_cObjTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath2,lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
				
			}
			
			[m_cObjModeDescriptionLabel setFrame:CGRectMake(20, 44-20, 260, 40)];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.35];
			m_cObjModeDescriptionLabel.text = @"";
			[m_cObjModeDescriptionLabel setFrame:CGRectMake(20, 44, 260, 40)];
			[UIView commitAnimations];
			
        }
			break;
		case 1:
        {
			security_string=@"wep";
			if (globalValues.provisionSharedDelegate.apSecurityType == OPEN_SECURITY) {
                
				[m_cObjAPCredentails replaceObjectAtIndex:4+chip_version_correction withObject:@"WEP Key Index"];
				[m_cObjAPCredentails replaceObjectAtIndex:5+chip_version_correction withObject:@"WEP Key"];
				
				//[m_cObjFieldCredentails replaceObjectAtIndex:4 withObject:m_cObjKeyBackup];
				
				[m_cObjTableView reloadData];
				
				lIndxPath1 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
				lIndxPath2 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
				
				globalValues.provisionSharedDelegate.apSecurityType = WEP_SECURITY;
				
				[m_cObjTableView  insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,nil] withRowAnimation:UITableViewRowAnimationFade];
				
				[m_cObjModeDescriptionLabel setFrame:CGRectMake(20, 44-20, 260, 40)];
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.35];
				[m_cObjModeDescriptionLabel setFrame:CGRectMake(20, 44, 260, 40)];
			    [UIView commitAnimations];
			}
			else if (globalValues.provisionSharedDelegate.apSecurityType == WPA_PERSONAL_SECURITY){
				
				[m_cObjAPCredentails replaceObjectAtIndex:5+chip_version_correction withObject:@"WEP Key"];
				[m_cObjAPCredentails replaceObjectAtIndex:4+chip_version_correction withObject:@"WEP Key Index"];
				
				
				
				[m_cObjTableView reloadData];
				
				
				lIndxPath2 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
				
				globalValues.provisionSharedDelegate.apSecurityType = WEP_SECURITY;
				
				[m_cObjTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath2,nil] withRowAnimation:UITableViewRowAnimationFade];
				
			}
			else {
				
				
				globalValues.provisionSharedDelegate.apSecurityType = WEP_SECURITY;
				
			}
			
			m_cObjModeDescriptionLabel.text = @"WEP-40 (Open Authentication)";
        }
			break;
            
		case 2:
        {
            
            security_string=@"wpa-personal";
            
            [m_cObjAPCredentails replaceObjectAtIndex:4+chip_version_correction withObject:@"Passphrase"];
			
			if (globalValues.provisionSharedDelegate.apSecurityType == OPEN_SECURITY) {
                
				[m_cObjTableView reloadData];
				
				lIndxPath1 = [NSIndexPath indexPathForRow:4+chip_version_correction inSection:0];
				
				globalValues.provisionSharedDelegate.apSecurityType = WPA_PERSONAL_SECURITY;
				
				[m_cObjTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
				
				[m_cObjModeDescriptionLabel setFrame:CGRectMake(20, 44-20, 260, 40)];
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.35];
				[m_cObjModeDescriptionLabel setFrame:CGRectMake(20, 44, 260, 40)];
			    [UIView commitAnimations];
				
			}
			else if (globalValues.provisionSharedDelegate.apSecurityType == WPA_PERSONAL_SECURITY){
				
			}
			else {
				
				
				[m_cObjTableView reloadData];
				
				lIndxPath2 = [NSIndexPath indexPathForRow:5+chip_version_correction inSection:0];
				
				globalValues.provisionSharedDelegate.apSecurityType = WPA_PERSONAL_SECURITY;
				
				[m_cObjTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath2,nil] withRowAnimation:UITableViewRowAnimationFade];
				
			}
			
			m_cObjModeDescriptionLabel.text = @"WPA2 Personal (AES + TKIP)";
            
        }
			break;
            
	}
	
}


- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	
}

-(void)confirmLimitedAPSettingsWithData:(NSArray *)_connParameters
{
	
	NSMutableString * xmlString = [[NSMutableString alloc] init];
	
	[xmlString appendString:@"<network>"];
    [xmlString appendString:@"<ap><wireless>"];
    [xmlString appendFormat:@"<channel>%@</channel>",[_connParameters objectAtIndex:1]];
    [xmlString appendFormat:@"<beacon_interval>%@</beacon_interval>",[_connParameters objectAtIndex:2]];
    [xmlString appendFormat:@"<ssid>%@</ssid>",[_connParameters objectAtIndex:0]];
    [xmlString appendFormat:@"<security>%@</security>",[_connParameters objectAtIndex:3]];
	
	int offset = globalValues.provisionSharedDelegate.apSecurityType;
	
	switch (globalValues.provisionSharedDelegate.apSecurityType) {
		case 0:
			
			break;
		case 1:
            
            [xmlString appendFormat:@"<password>%@:%@</password>",[m_cObjFieldCredentails objectAtIndex:5],[m_cObjFieldCredentails objectAtIndex:4]];
			
			
			offset--;
			break;
		case 2:
			
            [xmlString appendFormat:@"<password>%@</password>",[m_cObjFieldCredentails objectAtIndex:4]];
            
			offset=0;
			break;
		default:
			break;
	}
	
    [xmlString appendString:@"</wireless><ip>"];
	
    [xmlString appendFormat:@"<ip_addr>%@</ip_addr>",[_connParameters objectAtIndex:5-1+offset]];
	
    [xmlString appendFormat:@"<subnetmask>%@</subnetmask>",[_connParameters objectAtIndex:6-1+offset]];
	
    [xmlString appendFormat:@"<gateway>%@</gateway>",[_connParameters objectAtIndex:7-1+offset]];
	
    [xmlString stringByAppendingFormat:@"<dhcp_server_enable>%@</dhcp_server_enable>",[_connParameters objectAtIndex:10-1+offset]];
	
	if ([[_connParameters objectAtIndex:10-1+offset] isEqualToString:@"true"]) {
		
        [xmlString appendFormat:@"<dhcp_start_addr>%@</dhcp_start_addr>",[_connParameters objectAtIndex:8-1+offset]];
		
        [xmlString appendFormat:@"<dhcp_num_addrs>%@</dhcp_num_addrs>",[_connParameters objectAtIndex:9-1+offset]];
	}
	
	
    [xmlString appendFormat:@"<dns_server_enable>%@</dns_server_enable>",[_connParameters objectAtIndex:12-1+offset]];
	
	if ([[_connParameters objectAtIndex:12-1+offset] isEqualToString:@"true"]) {
		
        [xmlString appendFormat:@"<dns_domain>%@</dns_domain>",[_connParameters objectAtIndex:11-1+offset]];
	}
	
    [xmlString appendString:@"</ip></ap></network>"];
    
  //  NSLog(@"xmlString %@",xmlString);
	
	NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_GET_URL_NETWORK_DETAILS,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
	
	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
	
	[serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
	[serviceRequest setHTTPMethod:@"POST"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
    
	[NSURLConnection connectionWithRequest:serviceRequest delegate:self];
	
	
	
}


-(void)switchToggled:(id)sender
{
    int index = 0;
    
	if(globalValues.provisionSharedDelegate.apSecurityType == WPA_PERSONAL_SECURITY)
    {
        index = 1;
    }
	UISwitch *lObjSwitch = (UISwitch *)sender;
    
    // NSLog(@"%i",(106+chip_version_correction-index));
    
	UITextField *lObjTextField = (UITextField *)[m_cObjTableView viewWithTag:(106+chip_version_correction-index)];
	
	if (lObjSwitch.on) {
		
		passwordSecurityStatus = YES;
		
		if (globalValues.provisionSharedDelegate.apSecurityType == 2 || globalValues.provisionSharedDelegate.apSecurityType == 1) {
			
            lObjTextField.enabled = NO;
			[lObjTextField setSecureTextEntry:NO];
            lObjTextField.enabled = YES;
            
		}
		
	}
	else {
		
		passwordSecurityStatus = NO;
		
		if (globalValues.provisionSharedDelegate.apSecurityType == 2 || globalValues.provisionSharedDelegate.apSecurityType == 1) {
			
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
	
	UILabel *lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+1-5, 10-4+10, 280, 20)];
	lObjHeaderLabel.backgroundColor = [UIColor clearColor];
	[lObjHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
	lObjHeaderLabel.textColor = [UIColor whiteColor];
	
	if (globalValues.provisionSharedDelegate.apSecurityType == 1) {
		
		lObjHeaderLabel.text = @"Show WEP Key";
        
	}
	else {
		
        lObjHeaderLabel.text = @"Show Password";
        
	}
    
	
	[lObjView addSubview:lObjHeaderLabel];
	
	lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20-5, 11-4+10, 280, 20)];
	lObjHeaderLabel.backgroundColor = [UIColor clearColor];
	[lObjHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
	lObjHeaderLabel.textColor = [UIColor colorWithRed:0.35 green:0.40 blue:0.50 alpha:1];
	
	if (globalValues.provisionSharedDelegate.apSecurityType == 1) {
		
        lObjHeaderLabel.text = @"Show WEP Key";
        
	}
	else {
		
        lObjHeaderLabel.text = @"Show Password";
        
	}
	
	[lObjView addSubview:lObjHeaderLabel];
	
	UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 100, 20)];
	[lObjSwitch setOn:passwordSecurityStatus];
	[lObjSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
	[lObjView addSubview:lObjSwitch];
	
	
	return lObjView;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 1) {
		
		return 66.0;
	}
	else if (section == 0) {
		
		return 88.0-70.0;
	}
	else {
		
		return 0;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		//return [NSString stringWithFormat:@"These settings govern the functioning of the device when it is operating as a Limited AP."];
		
		return nil;
	}
	else
	{
		return nil;
	}
	
	return nil;
}

// fixed font style. use custom view (UILabel) if you want something different

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section != 0 && globalValues.provisionSharedDelegate.apSecurityType != 0) {
		
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
		
		if (globalValues.provisionSharedDelegate.apSecurityType == OPEN_SECURITY) {
			
            return 4+chip_version_correction;
		}
		else if (globalValues.provisionSharedDelegate.apSecurityType == WPA_PERSONAL_SECURITY){
			
            return 5+chip_version_correction;
		}
		else {
			
            return 6+chip_version_correction;
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
	
	cell.tag = indexPath.row + 1;
	
	if (indexPath.section == 0) {
        
		
		UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 110+30, 44)];
		[lObjLabel setBackgroundColor:[UIColor clearColor]];
		[lObjLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
		[lObjLabel setText:[m_cObjAPCredentails objectAtIndex:indexPath.row]];
		[lObjLabel setFont:[UIFont systemFontOfSize:12]];
		[lObjLabel setTextColor:[UIColor grayColor]];
		[cell.contentView addSubview:lObjLabel];
		
		if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"SSID"]) {
			
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.tag = indexPath.row + 101;
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
			[lObjTextField setDelegate:self];
            
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]];
			
			[cell.contentView addSubview:lObjTextField];
			
		}
		else if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"Channel"]){
			
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.tag = indexPath.row + 101;
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDone];
			[lObjTextField setDelegate:self];
			[lObjTextField setUserInteractionEnabled:NO];
            
            
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]];
			
            
			[cell.contentView addSubview:lObjTextField];
            
            
			UIButton *lObjButton = [UIButton buttonWithType:UIButtonTypeCustom];
			lObjButton.tag = indexPath.row + 1001;
			[lObjButton setFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjButton addTarget:self action:@selector(bringUpKeySelector:) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:lObjButton];
			
		}
        
        else if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"Band"]){
            
            NSArray *lObjArray = [NSArray arrayWithObjects:@"2.4 GHz",@"5 GHz", nil];
            
            UISegmentedControl	*m_cObjBandSegControl = [[UISegmentedControl alloc] initWithItems:lObjArray];
           // m_cObjBandSegControl.segmentedControlStyle = UISegmentedControlStylePlain;
            m_cObjBandSegControl.frame = CGRectMake(135,7,160, 30);//(110, 7, 185, 30)
            m_cObjBandSegControl.selectedSegmentIndex = bandSelectionIndex;
            m_cObjBandSegControl.tag=4;
            [m_cObjBandSegControl addTarget:self action:@selector(BandsegmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:m_cObjBandSegControl];
            
            
        }
		else if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"Security"]){
			
			NSMutableArray *lObjArray = [[NSMutableArray alloc] init];
			
			NSString *lObjString = @"None";
			[lObjArray addObject:lObjString];
			
			lObjString = @"WEP";
			[lObjArray addObject:lObjString];
			
			lObjString = @"WPA";
			[lObjArray addObject:lObjString];
            
            NSArray *postSrtingArray = [NSArray arrayWithObjects:@"none",@"wep",@"wpa-personal",nil];
            
            // security_string=@"none";
            // security_string=@"wep";
            // security_string=@"wpa-personal";
            
            
            if(globalValues.provisionSharedDelegate.apSecurityType < 3) {
                
                security_string = [postSrtingArray objectAtIndex:globalValues.provisionSharedDelegate.apSecurityType];
                
            }
			
            
			m_cObjSegControl = [[UISegmentedControl alloc] initWithItems:lObjArray];
			// m_cObjSegControl.tag = SECURITY_TYPE;
			//m_cObjSegControl.segmentedControlStyle = UISegmentedControlStylePlain;
			m_cObjSegControl.frame = CGRectMake(110, 7, 185, 30);
			
			m_cObjSegControl.selectedSegmentIndex = globalValues.provisionSharedDelegate.apSecurityType;
			
			[m_cObjSegControl addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventValueChanged];
			[cell.contentView addSubview:m_cObjSegControl];
			
		}
		else if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"Passphrase"]){
			
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.tag = indexPath.row + 101;
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
			[lObjTextField setDelegate:self];
            
			if (passwordSecurityStatus == NO) {
				
				[lObjTextField setSecureTextEntry:YES];
			}
			else {
				[lObjTextField setSecureTextEntry:NO];
				
			}
			         
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"password"] objectForKey:@"text"]];
            
			[cell.contentView addSubview:lObjTextField];
			
		}
		else if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"WEP Key"]){
			
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.tag = indexPath.row + 101;
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
			[lObjTextField setDelegate:self];
			
			if (passwordSecurityStatus == NO) {
				
				[lObjTextField setSecureTextEntry:YES];
			}
			else {
				[lObjTextField setSecureTextEntry:NO];
				
			}
			
            
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKey"] objectForKey:@"text"]];
            
			
			[cell.contentView addSubview:lObjTextField];
			
		}
		else if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"WEP Key Index"]){
            
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.tag = indexPath.row + 101;
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDone];
			[lObjTextField setDelegate:self];
			[lObjTextField setUserInteractionEnabled:NO];
			[cell.contentView addSubview:lObjTextField];
            
            if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"] length] > 0) {
                
                [lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"]];
            }
            else {
             
                [lObjTextField setText:@"1"];
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] setObject:@"1" forKeyedSubscript:@"text"];
            }
			
			
			UIButton *lObjButton = [UIButton buttonWithType:UIButtonTypeCustom];
			lObjButton.tag = indexPath.row + 1001;
			[lObjButton setFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjButton addTarget:self action:@selector(bringUpKeySelector:) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:lObjButton];
			
		}
		else if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"Wep Auth"]){
			
			NSMutableArray *lObjArray = [[NSMutableArray alloc] init];
			
			NSString *lObjString = @"open";
			[lObjArray addObject:lObjString];
			
			lObjString = @"shared";
			[lObjArray addObject:lObjString];
			
			
			m_cObjSegControl = [[UISegmentedControl alloc] initWithItems:lObjArray];
			//m_cObjSegControl.segmentedControlStyle = UISegmentedControlStylePlain;
			m_cObjSegControl.frame = CGRectMake(110, 7, 185, 30);
			m_cObjSegControl.selectedSegmentIndex = 0;
			
			[m_cObjSegControl setTag:6];
			
			[m_cObjSegControl addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventValueChanged];
			
			[cell.contentView addSubview:m_cObjSegControl];
			
		}
		else if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"Beacon Interval (ms)"]){
			
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.tag = indexPath.row + 101;
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [lObjTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDefault];
			[lObjTextField setDelegate:self];
			
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"beacon_interval"] objectForKey:@"text"]];
			
			[cell.contentView addSubview:lObjTextField];
            
		}
		else if ([[m_cObjAPCredentails objectAtIndex:indexPath.row] isEqualToString:@"EAP Password"]){
			
			UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
			[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
			lObjTextField.tag = indexPath.row + 101;
			lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[lObjTextField setTextAlignment:NSTextAlignmentRight];
			[lObjTextField setFont:[UIFont systemFontOfSize:16]];
			[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
			[lObjTextField setBackgroundColor:[UIColor clearColor]];
			[lObjTextField setReturnKeyType:UIReturnKeyDone];
			[lObjTextField setDelegate:self];
			
			[lObjTextField setText:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"eap_password"] objectForKey:@"text"]];
			
			[cell.contentView addSubview:lObjTextField];
			
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

-(void)BandsegmentedControlIndexChanged :(id)sender {
    
    
    UITextField *lObjTextField = (UITextField *)[self.view viewWithTag:102+chip_version_correction];
    
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    
    switch (segControl.selectedSegmentIndex) {
            
        case 0:
            
            bandSelectionIndex = 0;
            
            bandValue = 2.4;
                        
            if([[m_cObjChannelData objectForKey:@"2.4GHz"] length] > 0)
            {
                [lObjTextField setText:[m_cObjChannelData objectForKey:@"2.4GHz"]];
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"2.4GHz"] forKey:@"text"];
                
                
            }
            else {
                
                [lObjTextField setText:@"1"];
                
            }
            
            
            
            break;
        case 1:
            
            bandSelectionIndex = 1;
            
            bandValue = 5.0;
            
            if([[m_cObjChannelData objectForKey:@"5.0GHz"] length]>0) {
                
                [lObjTextField setText:[m_cObjChannelData objectForKey:@"5.0GHz"]];
                
                [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"5.0GHz"] forKey:@"text"];
                
                
            }
            else {
                
                [lObjTextField setText:@"36"];
                
            }
            
            
            break;
            
        default:
            break;
            
    }
    
}



-(void)bringUpKeySelector:(id)sender
{
	
	UIButton *lObjButton = (UIButton *)sender;
	
	for (int i=101; i<=3+globalValues.provisionSharedDelegate.apSecurityType; i++) {
		
		if (i != 104) {
            
			UITextField *lObjTextField = (UITextField *)[m_cObjTableView viewWithTag:i];
			
			[lObjTextField resignFirstResponder];
			
		}
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
	
    [ResetFrame bringUpPicker:m_cObjChannelPicker KeyBoardResignButton:m_cObjKeyboardRemoverButton andUITableView:m_cObjTableView];
	
	[UIView commitAnimations];
	
	
	if (lObjButton.tag == 1002+chip_version_correction) {
        
        pickerMode = CHANNEL_PICKER_MODE;
        
        m_cObjPickerContentArray = [[NSArray alloc] initWithArray:[ChannelFilter getChannelListForFrequency:bandValue firmwareVersion:sharedGsData.firmwareVersion.chip regulatoryDomain:[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"reg_domain"] objectForKey:@"text"] ClientMode:NO]];
        
        NSInteger selectedRow;
        
        if([m_cObjPickerContentArray containsObject:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]])
        {
            selectedRow = [m_cObjPickerContentArray indexOfObject:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]];
            
        }
        else {
            
            selectedRow = 0;
        }
        
        [m_cObjChannelPicker.lObjPicker reloadComponent:0];
        
        [m_cObjChannelPicker.lObjPicker selectRow:selectedRow inComponent:0 animated:NO];
        
		[m_cObjTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
	}
	else {
        
        pickerMode = INDEX_PICKER_MODE;
		
        
        m_cObjPickerContentArray = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",nil];
        
        /* -----------------------------------------------------------------------------------------
         if the wepkeyIndex is nil or zero then it select 1st value. But idelly it show not come as zero
         --------------------------------------------------------------.----------------------------------------*/
        
        NSInteger selectedRow;
        
        if([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"] isEqualToString:@""] || [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"] == nil || [[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"] intValue]== 0)
        {
            selectedRow = 0;
        }
        else if([m_cObjPickerContentArray containsObject:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"]]) {
            
            selectedRow  = [m_cObjPickerContentArray indexOfObject:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"]];
            
        }
        else {
            
            selectedRow = 0;
        }
		
		
        [m_cObjChannelPicker.lObjPicker reloadComponent:0];
        
        [m_cObjChannelPicker.lObjPicker selectRow:selectedRow inComponent:0 animated:NO];
        
		[m_cObjTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5+chip_version_correction inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
	}
	
	
}


#pragma mark - UIPickerView Delegate & DataSource Methods :

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [m_cObjPickerContentArray count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	return [m_cObjPickerContentArray objectAtIndex:row];
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	int sectionWidth = 100;
	
	return sectionWidth;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
	
	
	if (pickerMode == CHANNEL_PICKER_MODE) {
        
        
        if (bandSelectionIndex == 0) {
            
            [m_cObjChannelData setValue:[m_cObjPickerContentArray objectAtIndex:row] forKey:@"2.4GHz"];
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"2.4GHz"] forKey:@"text"];
            
        }
        else
        {
            [m_cObjChannelData setValue:[m_cObjPickerContentArray objectAtIndex:row] forKey:@"5.0GHz"];
            
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:[m_cObjChannelData objectForKey:@"5.0GHz"] forKey:@"text"];
            
        }
        
	}
	else {
        
		
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] setValue:[m_cObjPickerContentArray objectAtIndex:row] forKey:@"text"];
        
		
		
	}
	
	[m_cObjTableView reloadData];
    
}

#pragma mark - UITextField Delegate Methods :

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
   // NSLog(@"tag => %d",textField.tag);
	
    [UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [m_cObjTableView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-125)];
        
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [m_cObjTableView setFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-150)];
        
    }

	
	[UIView commitAnimations];
    
    [m_cObjTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(textField.tag-101) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

	return YES;
	
}// return NO to disallow editing.

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
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
	
	
	NSInteger row = textField.tag - 101;
	
	
	[self replaceStringAtRow:row withString:lObjCurrentString];
	
	return YES;
	
}

-(void)replaceStringAtRow:(NSInteger)pObjRow withString:(NSString *)pObjString
{
	
	
	if ([[m_cObjAPCredentails objectAtIndex:pObjRow] isEqualToString:@"SSID"]) {
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"ssid"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[m_cObjAPCredentails objectAtIndex:pObjRow] isEqualToString:@"Channel"]){
        
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] setValue:pObjString forKey:@"text"];
        
	}
	else if ([[m_cObjAPCredentails objectAtIndex:pObjRow] isEqualToString:@"Passphrase"]){
        
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"password"] setValue:pObjString forKey:@"text"];
        
	}
	else if ([[m_cObjAPCredentails objectAtIndex:pObjRow] isEqualToString:@"WEP Key"]){
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKey"] setValue:pObjString forKey:@"text"];
        
	}
	else if ([[m_cObjAPCredentails objectAtIndex:pObjRow] isEqualToString:@"WEP Key Index"]){
        
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] setValue:pObjString forKey:@"text"];
        
	}
	else if ([[m_cObjAPCredentails objectAtIndex:pObjRow] isEqualToString:@"Beacon Interval (ms)"]){
        
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"beacon_interval"] setValue:pObjString forKey:@"text"];
        
	}
	else if ([[m_cObjAPCredentails objectAtIndex:pObjRow] isEqualToString:@"EAP Password"]){
        
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"eap_password"] setValue:pObjString forKey:@"text"];
        
	}
	else {
		
		
	}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
	
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height+100, 60, 30)];
        [m_cObjTableView setFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-85)];
    }
    
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
        
        [m_cObjTableView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        
    }

    
	
	[UIView commitAnimations];
	
	[textField resignFirstResponder];
	
	return YES;
	
}// called when 'return' key pressed. return NO to ignore.

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	
	return YES;
}
// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0 && indexPath.section == 1) {
		
		return 66.0;
	}
	else if (indexPath.row == 3+chip_version_correction && indexPath.section == 0){
		
		if (globalValues.provisionSharedDelegate.apSecurityType == 0) {
			
			return 44.0;
		}
		else {
			
			return 44.0;
		}
		
	}
	else {
		
		return 44.0;
	}
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
