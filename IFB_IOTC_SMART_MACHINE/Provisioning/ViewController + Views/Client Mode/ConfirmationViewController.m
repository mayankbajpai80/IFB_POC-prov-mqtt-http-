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
 * $RCSfile: ConfirmationViewController.m,v $
 *
 * Description : Header file for ConfirmationViewController functions and data structures
 *******************************************************************************/

#import "ConfirmationViewController.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "GS_ADK_Data.h"
#import "InfoScreen.h"
#import "Identifiers.h"
#import "WPAModeButtonView.h"
#import <QuartzCore/QuartzCore.h>
#import "UINavigationBar+TintColor.h"
#import "ResetFrame.h"
#import "CustomPickerView.h"
#import "ConcurrentModeInfoViewController.h"
#import "PostSummaryController.h"
#import "CommonProvMethods.h"
#import "ValidationUtils.h"


#import "GSAlertInfo.h"
#import "GSUIAlertView.h"
#import "GSNavigationBar.h"


static const NSInteger cnTextFieldTag = 91;
static const NSInteger ouTextFieldTag = 92;
static const NSInteger textFieldTag = 100001;



@interface ConfirmationViewController(privateMethods)<CustomUIAlertViewDelegate>

-(void)launchIPConfigScreenFor:(NSString *)SSID_Str;
-(void)showConfirmationAfterPasscodeEntryWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray;
-(NSString *)getEapType;
-(void)replaceStringAtRow:(NSInteger)pObjRow withString:(NSString *)pObjString;
-(UIView *)getSectionHeader:(NSInteger)index;

@end



@implementation ConfirmationViewController

@synthesize m_cObjDelegate,lObjPassField;

@synthesize wepAuthType = _wepAuthType;



- (void)navigationItemTapped:(NavigationItem)item {
    
    switch (item) {
            
        case NavigationItemBack:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case NavigationItemCancel:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case NavigationItemDone:
            
            [self Done];
            
            break;
            
        case NavigationItemInfo:
            
            [self showInfo];
            
            break;
            
        case  NavigationItemMode:
            
            break;
            
        default:
            break;
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    
	appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    
        [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        _statusBarHeightForIOS_7 = 0;
        
        _viewStartsFrom = 76;
        
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        _statusBarHeightForIOS_7 = STATUS_BAR_HEIGHT;
        
        _viewStartsFrom = 76 + STATUS_BAR_HEIGHT;
    }
    
    
    if(sharedGsData.isSupportsEAP_Option >= 1)
    {
        GS2000_height = 90;
        GS2000_eapType = 5;
    }
    else {
        GS2000_height = 0;
        GS2000_eapType = 3;
    }
    
    
    enterpriseInfoDictionary=[[NSMutableDictionary alloc]init];
    
    [enterpriseInfoDictionary setObject:@"" forKey:@"eap_username"];
    [enterpriseInfoDictionary setObject:@"" forKey:@"eap_password"];
    [enterpriseInfoDictionary setObject:@"" forKey:@"eap_type"];
    
    [enterpriseInfoDictionary setObject:@"" forKey:@"eap_cn"];
    [enterpriseInfoDictionary setObject:@"" forKey:@"eap_ou"];
    
    
    
    UIView *lObjPasswordView = [[UIView alloc] initWithFrame:CGRectMake(10, 200-15, [UIScreen mainScreen].bounds.size.width-20, 44)];
    lObjPasswordView.backgroundColor = [UIColor clearColor];
    [lObjPasswordView setTag:5001];
    [self.view addSubview:lObjPasswordView];
    
    UILabel *lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 11, 280, 20)];
	lObjHeaderLabel.backgroundColor = [UIColor clearColor];
	[lObjHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
	lObjHeaderLabel.shadowColor = [UIColor whiteColor];
	lObjHeaderLabel.text = @"Show Password";
	[lObjPasswordView addSubview:lObjHeaderLabel];
    lObjHeaderLabel.textColor = [UIColor colorWithRed:0.35 green:0.40 blue:0.50 alpha:1];
    lObjHeaderLabel.shadowOffset = CGSizeMake(0, 1);
		
    
	UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 100, 20)];
	[lObjSwitch setOn:YES];
	[lObjSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
	[lObjPasswordView addSubview:lObjSwitch];
	
    
}

-(void)addInterfaceForEAPCredentialsInput {
    
	globalValues.provisionSharedDelegate.clientSecurityType = WPA_ENTERPRISE_SECURITY;
    
    globalValues.provisionSharedDelegate.m_cObjClientKeyName = @"";
    globalValues.provisionSharedDelegate.m_cObjClientKeyPath = @"";
    
    globalValues.provisionSharedDelegate.m_cObjClientCertName = @"";
    globalValues.provisionSharedDelegate.m_cObjClientCertPath = @"";
    
    globalValues.provisionSharedDelegate.m_cObjRootCertName = @"";
    globalValues.provisionSharedDelegate.m_cObjRootCertPath = @"";
    
    eapTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height-66) style:UITableViewStyleGrouped];
    [eapTableView setDataSource:self];
    [eapTableView setDelegate:self];
    [self.view addSubview:eapTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (sharedGsData.supportAnonymousID && [[self getEapType] isEqualToString:@"eap-tls"]) {
    
        return 6;
    }
    else if (sharedGsData.supportAnonymousID) {
        return 5;
    }
    else {
       	return 4;
 
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
   	UILabel *lObjTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 110, 44)];
    [lObjTitle setBackgroundColor:[UIColor clearColor]];
    [lObjTitle setFont:[UIFont systemFontOfSize:12]];
    [lObjTitle setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [lObjTitle setTextColor:[UIColor grayColor]];
    [cell.contentView addSubview:lObjTitle];
    
    switch (indexPath.row) {
            
        case 0:
            
            [lObjTitle setText:@"EAP Username"];
            
            break;
            
        case 1:
            
            [lObjTitle setText:@"EAP Password"];
            
            break;
            
        case 2:
            
            [lObjTitle setText:@"EAP Type"];
            
            break;
            
        case 3:
            lObjTitle.frame=CGRectMake(10, 0, 110+90, 44);
            [lObjTitle setText:@"Set node time to current UTC time"];
            
            break;
            
            case 4:
            [lObjTitle setText:@"Use AnonymousID"];
            break;
            
        case 5:
            [lObjTitle setText:@"Configure CNOU"];
            break;
            
        default:
            break;
            
    }
    
    
    
    if (indexPath.row == 2) {
        
        
        if(sharedGsData.isSupportsEAP_Option >= 1)
        {
            for (int i=0; i<6; i++) {
                
                WPAModeButtonView *lObjWPA_ModeView = [[WPAModeButtonView alloc] initWithFrame:CGRectMake(30+20, 10*(i+1) + 40*i + 40, 200, 40)];
                [lObjWPA_ModeView setBackgroundColor:[UIColor clearColor]];
                [lObjWPA_ModeView.layer setCornerRadius:5.0];
                [lObjWPA_ModeView.layer setBorderWidth:1];
                [lObjWPA_ModeView.layer setBorderColor:[[UIColor clearColor] CGColor]];
                [lObjWPA_ModeView setClipsToBounds:YES];
                
                if (i==eapType) {
                    
                    [lObjWPA_ModeView.m_cObjImageView setImage:[UIImage imageNamed:@"blue-button-selected.png"]];
                    
                }
                else {
                    
                    [lObjWPA_ModeView.m_cObjImageView setImage:[UIImage imageNamed:@"blue-button.png"]];
                    
                }
                
                [lObjWPA_ModeView addSubview:lObjWPA_ModeView.m_cObjImageView];
                lObjWPA_ModeView.m_cObjImageView  = nil;
                [lObjWPA_ModeView setM_cObjDelegate:self];
                [lObjWPA_ModeView setTag:i+10000];
                [lObjWPA_ModeView setTextWithEAPTypeForVersionIsGreaterThenOne:eapType];
                [lObjWPA_ModeView addSubview:lObjWPA_ModeView.m_cObjLabel];
                lObjWPA_ModeView.m_cObjLabel = nil;
                [cell.contentView addSubview:lObjWPA_ModeView];
            }
            
        }
        else {
            
            for (int i=0; i<4; i++) {
                
                WPAModeButtonView *lObjWPA_ModeView = [[WPAModeButtonView alloc] initWithFrame:CGRectMake(30+20, 10*(i+1) + 40*i + 40, 200, 40)];
                [lObjWPA_ModeView setBackgroundColor:[UIColor clearColor]];
                [lObjWPA_ModeView.layer setCornerRadius:5.0];
                [lObjWPA_ModeView.layer setBorderWidth:1];
                [lObjWPA_ModeView.layer setBorderColor:[[UIColor clearColor] CGColor]];
                [lObjWPA_ModeView setClipsToBounds:YES];
                
                if (i==eapType) {
                    
                    [lObjWPA_ModeView.m_cObjImageView setImage:[UIImage imageNamed:@"blue-button-selected.png"]];
                    
                }
                else {
                    
                    [lObjWPA_ModeView.m_cObjImageView setImage:[UIImage imageNamed:@"blue-button.png"]];
                    
                }
                
                [lObjWPA_ModeView addSubview:lObjWPA_ModeView.m_cObjImageView];
                lObjWPA_ModeView.m_cObjImageView  = nil;
                [lObjWPA_ModeView setM_cObjDelegate:self];
                [lObjWPA_ModeView setTag:i+10000];
                [lObjWPA_ModeView setTextWithEAPType:eapType];
                [lObjWPA_ModeView addSubview:lObjWPA_ModeView.m_cObjLabel];
                lObjWPA_ModeView.m_cObjLabel = nil;
                [cell.contentView addSubview:lObjWPA_ModeView];
            }
            
        }
        
        if (eapType == GS2000_eapType) {
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.35];
            [UIView commitAnimations];
            
            [eapTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            
            m_cObjRootCertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [m_cObjRootCertButton setFrame:CGRectMake(20, 320-10-44-10+GS2000_height, 260, 44)];
            [m_cObjRootCertButton addTarget:self action:@selector(openRootCertificateBrowser) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:m_cObjRootCertButton];
            
            if (globalValues.provisionSharedDelegate.m_cObjRootCertName.length > 0) {
                
                [m_cObjRootCertButton setTitle:globalValues.provisionSharedDelegate.m_cObjRootCertName forState:UIControlStateNormal];
            }
            else {
                [m_cObjRootCertButton setTitle:@"Attach Root Certificate" forState:UIControlStateNormal];
                
            }
            
            m_cObjClientCertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [m_cObjClientCertButton setFrame:CGRectMake(20, 320-10-44-10 + 54+GS2000_height, 260, 44)];
            [m_cObjClientCertButton addTarget:self action:@selector(openClientCertificateBrowser) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:m_cObjClientCertButton];
            
            if (globalValues.provisionSharedDelegate.m_cObjClientCertName.length > 0) {
                
                [m_cObjClientCertButton setTitle:globalValues.provisionSharedDelegate.m_cObjClientCertName forState:UIControlStateNormal];
            }
            else {
                [m_cObjClientCertButton setTitle:@"Attach Client Certificate" forState:UIControlStateNormal];
                
            }

            
            m_cObjClientKeyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [m_cObjClientKeyButton setFrame:CGRectMake(20, 320-10-44-10 + 110+GS2000_height, 260, 44)];
            [m_cObjClientKeyButton addTarget:self action:@selector(openClientKeyBrowser) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:m_cObjClientKeyButton];
            
            if (globalValues.provisionSharedDelegate.m_cObjClientKeyName.length > 0) {
                
                [m_cObjClientKeyButton setTitle:globalValues.provisionSharedDelegate.m_cObjClientKeyName forState:UIControlStateNormal];
            }
            else {
                [m_cObjClientKeyButton setTitle:@"Attach Client Key" forState:UIControlStateNormal];
                
            }

            
        }
        else
        {
            m_cObjRootCertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [m_cObjRootCertButton setFrame:CGRectMake(20, 320-10-44-10+GS2000_height, 260, 44)];
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
    else if (indexPath.row == 3)
    {
        UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 85),7, 50, 40)];
        lObjSwitch.backgroundColor=[UIColor clearColor];
        lObjSwitch.tag = 10000000;
        [lObjSwitch addTarget:self action:@selector(timeSwitchOnOff:) forControlEvents:UIControlEventValueChanged];
       [lObjSwitch setOn:globalValues.provisionSharedDelegate.utcSwitchState];
        [cell.contentView addSubview:lObjSwitch];
        
        if (globalValues.provisionSharedDelegate.UTC_Time_Supported == NO) {
            
            [lObjSwitch setAlpha:0.3];
            [lObjSwitch setUserInteractionEnabled:NO];
            
        }
        
    }
    else if (indexPath.row == 4) {
        
        UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 85),7, 50, 40)];
        lObjSwitch.backgroundColor=[UIColor clearColor];
        [lObjSwitch addTarget:self action:@selector(changeAnonymousIdSwitchValue) forControlEvents:UIControlEventValueChanged];
        [lObjSwitch setOn:sharedGsData.enableAnonymousSwitch];
        [cell.contentView addSubview:lObjSwitch];
    }
    else if (indexPath.row == 5) {
        
        UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 85),7, 50, 40)];
        lObjSwitch.backgroundColor=[UIColor clearColor];
        [lObjSwitch addTarget:self action:@selector(changeCNOUSwitchValue) forControlEvents:UIControlEventValueChanged];
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
            lObjCNTextField.tag = cnTextFieldTag+textFieldTag;
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
            
            lObjCNTextField.text = [enterpriseInfoDictionary objectForKey:@"eap_cn"];
            
            
            
            UILabel *ouLable = [[UILabel alloc] initWithFrame:CGRectMake(10, (cnLable.frame.origin.y + cnLable.frame.size.height + 5), 110, 30)];
            [ouLable setBackgroundColor:[UIColor clearColor]];
            [ouLable setText:@"OU"];
            [ouLable setFont:[UIFont boldSystemFontOfSize:12]];
            [ouLable setBaselineAdjustment:UIBaselineAdjustmentNone];
            [ouLable setTextAlignment:NSTextAlignmentCenter];
            [ouLable setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:ouLable];
            
            UITextField *lObjOUTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, (cnLable.frame.origin.y + cnLable.frame.size.height + 5), 160, 30)];
            lObjOUTextField.tag = ouTextFieldTag+textFieldTag;
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
            
            lObjOUTextField.text = [enterpriseInfoDictionary objectForKey:@"eap_ou"];
            
        }
    }
    else {
        
        UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 0, 130+50, 44)];
        lObjTextField.tag = indexPath.row + textFieldTag;
        
        
        if (indexPath.row==0) {
            
            [lObjTextField setText:[enterpriseInfoDictionary objectForKey:@"eap_username"]];
        }
        
        else if(indexPath.row==1)
        {
            [lObjTextField setText:[enterpriseInfoDictionary objectForKey:@"eap_password"]];
        }
        [lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [lObjTextField setTextAlignment:NSTextAlignmentRight];
        [lObjTextField setFont:[UIFont systemFontOfSize:16]];
        [lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
        [lObjTextField setBackgroundColor:[UIColor clearColor]];
        [lObjTextField setReturnKeyType:UIReturnKeyDefault];
        [lObjTextField setDelegate:self];
        [cell.contentView addSubview:lObjTextField];
        
        if(lObjTextField.tag ==100002)
        {
            if(passwordSecurityStatus == YES)
            {
                lObjTextField.enabled = NO;
                [lObjTextField setSecureTextEntry:YES];
                lObjTextField.enabled = YES;
            }
            else
            {
                lObjTextField.enabled = NO;
                [lObjTextField setSecureTextEntry:NO];
                lObjTextField.enabled = YES;
            }
            
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2 && indexPath.section == 0){
        
        if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
            
            
            if (eapType == GS2000_eapType) {
                
                return 320.0 + 110+GS2000_height;
                
            }
            else
            {
                return 320.0+GS2000_height;
                
            }
            
        }
        
    }
    else if (indexPath.row == 5 && indexPath.section == 0 && globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY && [[self getEapType] isEqualToString:@"eap-tls"]) {
        
        return (sharedGsData.enableCNOUSwitch ? 120.0 : 44.0);
    }
    else {
        
        return 44.0;
        
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 55.0f;
}


-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    
    if (globalValues.provisionSharedDelegate.clientSecurityType != 0) {
		
		return [self getSectionHeader:section];
	}
	
	return nil;
}

#pragma mark -
#pragma mark Table view data source

-(UIView *)getSectionHeader:(NSInteger)index {
	
	UIView *lObjheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
	[lObjheaderView setBackgroundColor:[UIColor clearColor]];

	
	UILabel *lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20-5, 11-4+10, 280, 20)];
	lObjHeaderLabel.backgroundColor = [UIColor clearColor];
	[lObjHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
	lObjHeaderLabel.textColor = [UIColor colorWithRed:0.35 green:0.40 blue:0.50 alpha:1];
    lObjHeaderLabel.shadowColor = [UIColor whiteColor];
    lObjHeaderLabel.shadowOffset = CGSizeMake(0, 1);
	lObjHeaderLabel.text = @"Show Password";
	[lObjheaderView addSubview:lObjHeaderLabel];
	
	UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 100, 20)];
	
	if (passwordSecurityStatus == NO) {
		
        [lObjSwitch setOn:YES];
	}
	else {
		
        [lObjSwitch setOn:NO];
	}
	
	[lObjSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
	[lObjheaderView addSubview:lObjSwitch];
	
	
	return lObjheaderView;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
	
    if (section == 1) {
		
		return 66.0;
	}
	else {
		
		return 0;
	}
}

#pragma mark - UISwitch Methods

-(void)timeSwitchOnOff:(id)sender {
    
    globalValues.provisionSharedDelegate.utcSwitchState = !globalValues.provisionSharedDelegate.utcSwitchState;
    
}

-(void)changeAnonymousIdSwitchValue {
    
    sharedGsData.enableAnonymousSwitch = !sharedGsData.enableAnonymousSwitch;
}

-(void)changeCNOUSwitchValue {
    
    sharedGsData.enableCNOUSwitch = !sharedGsData.enableCNOUSwitch;
    
    [eapTableView reloadData];
}


-(void)openRootCertificateBrowser {
    
    m_cObjBrowser = [[CertificateBrowser alloc] initWithControllerType:2];
    [m_cObjBrowser setTag:1];
    [m_cObjBrowser setM_cObjDelegate:self];
    [self presentViewController:m_cObjBrowser animated:YES completion:nil];
    
}

-(void)openClientCertificateBrowser {
    
    m_cObjBrowser = [[CertificateBrowser alloc] initWithControllerType:2];
    [m_cObjBrowser setTag:2];
    [m_cObjBrowser setM_cObjDelegate:self];
    [self presentViewController:m_cObjBrowser animated:YES completion:nil];
    
}

-(void)openClientKeyBrowser {
    
    m_cObjBrowser = [[CertificateBrowser alloc] initWithControllerType:2];
    [m_cObjBrowser setTag:3];
    [m_cObjBrowser setM_cObjDelegate:self];
    [self presentViewController:m_cObjBrowser animated:YES completion:nil];
    
}



-(void)showInfo {
    
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
    [self presentViewController:lObjInfoScreen animated:YES completion:nil];
}


-(void)Done {
    /// continue from here
    
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
	
    sharedGsData.manualConfigMode = NO;

    switch (globalValues.provisionSharedDelegate.clientSecurityType) {
     
        case WEP_SECURITY:
        {
            if (YES == [self checkForHexValue]) {
     
     
                if (YES == [m_cObjDelegate refreshMode]) {
                    
                    if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
                    {
                        [self launchIPConfigScreenFor:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
                    }
                    else
                    {
                        [self launchIPConfigScreenFor:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"ssid"] objectForKey:@"text"]];
                    }
                    return;
                    
                }
                else {
                    if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
                    {
                        [self launchIPConfigScreenFor:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
                    }
                    else
                    {
                        [self launchIPConfigScreenFor:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]  objectForKey:@"ssid"] objectForKey:@"text"]];
                    }
                    
                    return;
                    
                }
                
            }
            else
            {
                return;
            }
            
        }
            break;
            
        case WPA_PERSONAL_SECURITY:
        {
            if (YES == [self checkPassphaseLength] && YES == [self checkForHexValue]) {
                
                if (YES == [m_cObjDelegate refreshMode]) {
                    
                    if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
                    {
                        [self launchIPConfigScreenFor:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
                    }
                    else
                    {
                        [self launchIPConfigScreenFor:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]];
                    }
                    return;
                    
                }
                else {
                    if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
                    {
                        [self launchIPConfigScreenFor:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
                    }
                    else
                    {
                        [self launchIPConfigScreenFor:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]];
                    }
                    return;
                    
                }
                
            }
            else
            {
                return;
            }
            
            return;
            
        }
            break;
            
        case WPA_ENTERPRISE_SECURITY:
        {
            NSLog(@"enterpriseInfoDictionary = %@",enterpriseInfoDictionary);
            
            if ([[enterpriseInfoDictionary objectForKey:@"eap_username"] isEqualToString:@""] || [[enterpriseInfoDictionary objectForKey:@"eap_username"] length] == 0) //
            {
                [self showAlertMessageForEmptyField:@"Enter EAP Username"];
                
                return;
                
            }
            
            if ([[enterpriseInfoDictionary objectForKey:@"eap_password"] isEqualToString:@""] || [[enterpriseInfoDictionary objectForKey:@"eap_password"] length] == 0)
            {
                
                [self showAlertMessageForEmptyField:@"Enter EAP Password"];
                
                return;
            }
            
            
            if (sharedGsData.supportAnonymousID && [[self getEapType] isEqualToString:@"eap-tls"] && sharedGsData.enableCNOUSwitch) {
            
            if ([[enterpriseInfoDictionary objectForKey:@"eap_cn"] isEqualToString:@""] || [[enterpriseInfoDictionary objectForKey:@"eap_cn"] length] == 0) {
                
                [self showAlertMessageForEmptyField:@"Enter CN Value"];
                
                return;

            }
            
            if ([[enterpriseInfoDictionary objectForKey:@"eap_ou"] isEqualToString:@""] || [[enterpriseInfoDictionary objectForKey:@"eap_ou"] length] == 0) {
                
                [self showAlertMessageForEmptyField:@"Enter OU Value"];
                
                return;

            }
                
            }
            
            if (YES == [self checkAttachedCertificates]) {
                
                [enterpriseInfoDictionary setValue:[self getEapType] forKey:@"eap_type"];
                
            }
            else
            {
                return;
            }
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_type"] setValue:[self getEapType] forKey:@"text"];
        }
            
            break;
            
        default:
            
            return;
            
            break;
    }
    if ([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
    {
        [self launchIPConfigScreenFor:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
    }
    else
    {
        [self launchIPConfigScreenFor:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]];
    }
    
    
}

-(void)showAlertMessageForEmptyField:(NSString *)fieldName {
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:fieldName message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"OK";
    info.otherButtonTitle = nil;
    
    GSUIAlertView *lObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    [lObjAlertView show];

}

-(BOOL)checkAttachedCertificates {
	
    if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
        
        if (eapType == GS2000_eapType) {
            
            if ([globalValues.provisionSharedDelegate.m_cObjRootCertName isEqualToString:@"Attach Root Certificate"] || globalValues.provisionSharedDelegate.m_cObjRootCertName.length == 0) {
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Attachment missing" message:[NSString stringWithFormat:@"please attach Root Certificate to proceed"] confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
                [lObjFieldValidation show];
                
                return NO;
                
            }
            else if ([globalValues.provisionSharedDelegate.m_cObjClientCertName isEqualToString:@"Attach Client Certificate"] || globalValues.provisionSharedDelegate.m_cObjClientCertName.length == 0) {
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Attachment missing" message:[NSString stringWithFormat:@"please attach Client Certificate to proceed"] confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
                [lObjFieldValidation show];
                
                return NO;
                
            }
            else if ([globalValues.provisionSharedDelegate.m_cObjClientKeyName isEqualToString:@"Attach Client Key"] || globalValues.provisionSharedDelegate.m_cObjClientKeyName.length == 0) {
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Attachment missing" message:[NSString stringWithFormat:@"please attach Client Key to proceed"] confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
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


-(void)selectCertificate:(NSString *)pObjNameString path:(NSString *)pObjPathString withTag:(int)pObjTag {
    
    switch (pObjTag) {
            
        case 1:
            
            globalValues.provisionSharedDelegate.m_cObjRootCertName = [[NSString alloc] initWithString:pObjNameString];
            
            globalValues.provisionSharedDelegate.m_cObjRootCertPath = [[NSString alloc] initWithString:pObjPathString];
			
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


-(NSString *)getEapType
{
    NSString *lObjString = nil;
    
    if(sharedGsData.isSupportsEAP_Option >=1)
    {
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
    
    return lObjString;
}

-(void)switchToggled:(id)sender
{
	
	UISwitch *lObjSwitch = (UISwitch *)sender;
    
    if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
        
        UITextField *lObjTextField = (UITextField *)[self.view viewWithTag:100002];
        
        if ([lObjSwitch isOn]) {
			
            passwordSecurityStatus = NO;
            
            lObjTextField.enabled = NO;
            [lObjTextField setSecureTextEntry:NO];
            lObjTextField.enabled = YES;
            
            
            
        }
        else {
			
            passwordSecurityStatus = YES;
            
            lObjTextField.enabled = NO;
            [lObjTextField setSecureTextEntry:YES];
            lObjTextField.enabled = YES;
            
        }
        
        
        
    }
    else {
        
        if ([lObjSwitch isOn]) {
			
            passwordSecurityStatus = NO;
            
            lObjPassField.enabled = NO;
            [lObjPassField setSecureTextEntry:NO];
            lObjPassField.enabled = YES;
            
            
            
        }
        else {
			
            passwordSecurityStatus = YES;
            
            lObjPassField.enabled = NO;
            [lObjPassField setSecureTextEntry:YES];
            lObjPassField.enabled = YES;
            
        }
    }
}

-(void)indexOfRow:(NSInteger)rowNo
{
	currentIndex = rowNo;
	
    
	if (YES == [m_cObjDelegate refreshMode]) {
        
        if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
        {
            
            if ([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"] || [[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@""]) {
                
                self.navigationBar.title = [[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"];
                
            }
            else if([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                
                self.navigationBar.title = [NSString stringWithFormat:@"%@",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
                
            }
            else {
                
                self.navigationBar.title = [NSString stringWithFormat:@"%@",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
                
            }
		}
        else
        {
            
            if ([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"] || [[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@""]) {
                
                self.navigationBar.title = [[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"];
                
            }
            else if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                
                self.navigationBar.title = [NSString stringWithFormat:@"%@",[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]  objectForKey:@"ssid"] objectForKey:@"text"]];
            }
            else {
                
                self.navigationBar.title = [NSString stringWithFormat:@"%@",[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]];
            }
		}
	}
	else {
		if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
        {
            if ([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"] || [[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@""]) {
                
                self.navigationBar.title = [[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"];
                
            }
            else if([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                
                
                self.navigationBar.title = [NSString stringWithFormat:@"%@",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
                
            }
            else {
                
                self.navigationBar.title = [NSString stringWithFormat:@"%@",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
                
            }
        }
        else
        {
            
            if ([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"] || [[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@""]) {
                
                self.navigationBar.title = [[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"];
                
            }
            else if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                
                self.navigationBar.title = [NSString stringWithFormat:@"%@",[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]  objectForKey:@"ssid"] objectForKey:@"text"]];
                
            }
            else {
                
                self.navigationBar.title = [NSString stringWithFormat:@"%@",[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]];
                
            }
		}
	}
    
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
    
    
    if (lObjString) {
        
        [enterpriseInfoDictionary setObject:lObjString forKey:@"text"];

    }
        
    
	for (int i=10000; i<eapTypeTag; i++) {
		
		WPAModeButtonView *lObjTempView = (WPAModeButtonView *)[self.view viewWithTag:i];
		
		if (i == pObjTag) {
			
			[[lObjTempView m_cObjLabel] setTextColor:[UIColor whiteColor]];
			[[lObjTempView m_cObjImageView] setImage:[UIImage imageNamed:@"blue-button-selected.png"]];
			
		}
		else {
			
			[[lObjTempView m_cObjLabel] setTextColor:[UIColor darkGrayColor]];
			[[lObjTempView m_cObjImageView ]setImage:[UIImage imageNamed:@"blue-button.png"]];
			
		}
		
	}
	
    [eapTableView reloadData];
}

-(void)addTextField {
    
	globalValues.provisionSharedDelegate.clientSecurityType= WPA_PERSONAL_SECURITY;
	
	lObjView = [[UIView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-20, 44)];
	[lObjView setBackgroundColor:[UIColor whiteColor]];
	[lObjView.layer setCornerRadius:8.0];
	[lObjView.layer setBorderWidth:1];
	[lObjView.layer setBorderColor:[[UIColor clearColor] CGColor]];
	[self.view addSubview:lObjView];
	
	UILabel *lObjTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 44)];
	lObjTitle.font = [UIFont boldSystemFontOfSize:12];
	lObjTitle.textColor = [UIColor grayColor];
	lObjTitle.text = @"Passphrase :";
	[lObjView addSubview:lObjTitle];
	
	lObjPassField = [[UITextField alloc] initWithFrame:CGRectMake(80+5, 0, 210-10, 44)];
	lObjPassField.delegate = self;
	[lObjPassField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	[lObjPassField setTextAlignment:NSTextAlignmentRight];
	lObjPassField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	lObjPassField.returnKeyType = UIReturnKeyDefault;
    [lObjPassField becomeFirstResponder];
	[lObjView addSubview:lObjPassField];
	
}

-(void)showTextField {
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
	
	[lObjView setFrame:CGRectMake(10, _viewStartsFrom, [UIScreen mainScreen].bounds.size.width-20, CELL_HEIGHT)];
    
    [(UIView *)[self.view viewWithTag:5001] setFrame:CGRectMake(10, _viewStartsFrom+CELL_HEIGHT+MARGIN_BETWEEN_CELLS, [UIScreen mainScreen].bounds.size.width-20, CELL_HEIGHT)];
    
	
	[UIView commitAnimations];
}

-(void)addKeyPairTextField {
    
	globalValues.provisionSharedDelegate.clientSecurityType = WEP_SECURITY;
	
	lObjView = [[UIView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-20, 44)];
	lObjView.tag = 1001;
	[lObjView setBackgroundColor:[UIColor whiteColor]];
	[lObjView.layer setCornerRadius:8.0];
	[lObjView.layer setBorderWidth:1];
	[lObjView.layer setBorderColor:[[UIColor clearColor] CGColor]];
	[self.view addSubview:lObjView];
	
	UILabel *lObjTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 44)];
	lObjTitle.tag = 101;
	lObjTitle.font = [UIFont boldSystemFontOfSize:12];
	lObjTitle.textColor = [UIColor grayColor];
	lObjTitle.text = @"WEP Key Index";
	[lObjView addSubview:lObjTitle];
	
	lObjTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 44)];
	lObjTitle.tag = 102;
	[lObjTitle setBackgroundColor:[UIColor clearColor]];
	[lObjTitle setFont:[UIFont systemFontOfSize:16]];
	[lObjTitle setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	[lObjTitle setTextAlignment:NSTextAlignmentRight];
	[lObjView addSubview:lObjTitle];
	
    
	UIButton *lObjCustomButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[lObjCustomButton setFrame:CGRectMake(0, 0, 300, 44)];
	[lObjCustomButton addTarget:self action:@selector(bringUpKeySelector) forControlEvents:UIControlEventTouchUpInside];
	[lObjView addSubview:lObjCustomButton];
    
    //===========================================================================================
	
	lObjView = [[UIView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height+CELL_HEIGHT+MARGIN_BETWEEN_CELLS, [UIScreen mainScreen].bounds.size.width-20, 44)];
	lObjView.tag = 2001;
	[lObjView setBackgroundColor:[UIColor whiteColor]];
	[lObjView.layer setCornerRadius:8.0];
	[lObjView.layer setBorderWidth:1];
	[lObjView.layer setBorderColor:[[UIColor clearColor] CGColor]];
	[self.view addSubview:lObjView];
	
	lObjTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 44)];
	lObjTitle.tag = 201;
	lObjTitle.font = [UIFont boldSystemFontOfSize:12];
	lObjTitle.textColor = [UIColor grayColor];
	lObjTitle.text = @"WEP Key";
	[lObjView addSubview:lObjTitle];
	
	lObjPassField = [[UITextField alloc] initWithFrame:CGRectMake(80+5, 0, 210-10, 44)];
	lObjPassField.tag = 202;
	lObjPassField.textAlignment = NSTextAlignmentRight;
	lObjPassField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	lObjPassField.delegate = self;
	//lObjPassField.font = [UIFont boldSystemFontOfSize:14];
	lObjPassField.returnKeyType = UIReturnKeyDefault;
	//lObjPassField.secureTextEntry = YES;
	[lObjPassField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	[lObjView addSubview:lObjPassField];
	//[lObjIndexField becomeFirstResponder];
    
    
    
    //==============================================================================================
    
    lObjView = [[UIView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height+(CELL_HEIGHT*2)+(MARGIN_BETWEEN_CELLS*2), [UIScreen mainScreen].bounds.size.width-20, 44)];
	lObjView.tag = 4001;
	[lObjView setBackgroundColor:[UIColor whiteColor]];
	[lObjView.layer setCornerRadius:8.0];
	[lObjView.layer setBorderWidth:1];
	[lObjView.layer setBorderColor:[[UIColor clearColor] CGColor]];
	[self.view addSubview:lObjView];
    
    lObjTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 44)];
	lObjTitle.tag = 401;
	lObjTitle.font = [UIFont boldSystemFontOfSize:12];
	lObjTitle.textColor = [UIColor grayColor];
	lObjTitle.text = @"Wep Auth";
	[lObjView addSubview:lObjTitle];
    
    NSMutableArray *lObjArray = [[NSMutableArray alloc] initWithObjects:@"open",@"shared", nil];
    
    _wepAuthType = 0;
    
    UISegmentedControl *lObjSegControl = [[UISegmentedControl alloc] initWithItems:lObjArray];
    //lObjSegControl.segmentedControlStyle = UISegmentedControlStylePlain;
    lObjSegControl.frame = CGRectMake(110, 7, 185, 30);
    lObjSegControl.selectedSegmentIndex = _wepAuthType;
    [lObjSegControl setTag:402];
    [lObjSegControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [lObjView addSubview:lObjSegControl];
    
    
    
   m_cObjKeyPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 216) delegate:self withTag:3001];
    m_cObjKeyPicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_cObjKeyPicker];
    //[m_cObjKeyPicker release];
    
    
    
    m_cObjKeyboardRemoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[m_cObjKeyboardRemoverButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
	[m_cObjKeyboardRemoverButton addTarget:self action:@selector(resignKeyPad) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:m_cObjKeyboardRemoverButton];
}

-(void)segmentedControlChangedValue:(id)sender {
    
    UISegmentedControl *lObjSegControl = (UISegmentedControl *)[self.view viewWithTag:402];
    
    switch (lObjSegControl.selectedSegmentIndex) {
            
        case 0:
        {
            _wepAuthType = 0;
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepauth"] setValue:@"open" forKey:@"text"];
            
        }
            break;
        case 1:
        {
            _wepAuthType = 1;
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepauth"] setValue:@"shared" forKey:@"text"];
            
        }
            break;
    }
    
}

-(void)showKeyPairTextField {
    
	[UIView beginAnimations:nil context:NULL];
	
    [UIView setAnimationDuration:0.35];
	
	[(UIView *)[self.view viewWithTag:1001] setFrame:CGRectMake(10, _viewStartsFrom, [UIScreen mainScreen].bounds.size.width-20, CELL_HEIGHT)];
    
	[(UIView *)[self.view viewWithTag:2001] setFrame:CGRectMake(10, _viewStartsFrom+(CELL_HEIGHT+MARGIN_BETWEEN_CELLS), [UIScreen mainScreen].bounds.size.width-20, 44)];
	
    [(UIView *)[self.view viewWithTag:4001] setFrame:CGRectMake(10, _viewStartsFrom+(CELL_HEIGHT+MARGIN_BETWEEN_CELLS)*2, [UIScreen mainScreen].bounds.size.width-20, 44)];
    
    [(UIView *)[self.view viewWithTag:5001] setFrame:CGRectMake(10, _viewStartsFrom+(CELL_HEIGHT+MARGIN_BETWEEN_CELLS)*3, [UIScreen mainScreen].bounds.size.width-20, 44)];
    
	[UIView commitAnimations];
}


-(void)bringUpKeySelector
{
	[(UITextField *)[(UIView *)[self.view viewWithTag:2001] viewWithTag:202] resignFirstResponder];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
        
    [ResetFrame presentModelViewControllerPicker:m_cObjKeyPicker KeyBoardResignButton:m_cObjKeyboardRemoverButton andUITableView:nil];
	
	[UIView commitAnimations];
}


-(void)resignKeyPad
{
	
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
	
    [ResetFrame resignKeyPad:m_cObjKeyboardRemoverButton ChannelPicker:m_cObjKeyPicker SecurityPicker:nil andTableView:nil];
	
	[UIView commitAnimations];
	
}


#pragma mark - UIPickerView Delegate && DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
	return 4;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    NSLog(@"title for row = %@",[NSString stringWithFormat:@"      %d",row+1]);
	return [NSString stringWithFormat:@"      %zd",row+1];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	int sectionWidth = 100;
	
	return sectionWidth;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
	[(UILabel *)[(UIView *)[self.view viewWithTag:1001] viewWithTag:102] setText:[NSString stringWithFormat:@"%zd",row+1]];
    
    [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] setObject:[NSString stringWithFormat:@"%zd",row+1] forKey:@"text"];
    
}



#pragma mark - UITextField Delegate Methods 

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSInteger row = textField.tag - textFieldTag;

    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
    
    if (row > 90) {
        
        [eapTableView setContentOffset:CGPointMake(0, 480) animated:YES];
    }
    else {
        
        m_cObjKeyPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 100, [UIScreen mainScreen].bounds.size.width, 220);
    }
	
	[UIView commitAnimations];
	
	return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
	return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
	return YES;
}

-(BOOL)checkPassphaseLength {
    
    return [ValidationUtils validatePassphraseLength:lObjPassField.text];
}

-(BOOL)checkForHexValue {
	
	if (globalValues.provisionSharedDelegate.clientSecurityType == WEP_SECURITY) {
		
        return [ValidationUtils validateHexValue:lObjPassField.text];
	}
	
	return YES;
}


-(void)launchIPConfigScreen {
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Network Settings" message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"Cancel";
    info.otherButtonTitle = @"Next";
    
    GSUIAlertView *m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleIPSetting delegate:self];
    
    m_cObjAlertView.m_cObjIPSettingsView.segmentControl.selectedSegmentIndex = globalValues.provisionSharedDelegate.ipAdressType;
    
    [m_cObjAlertView.m_cObjIPSettingsView.segmentControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    [m_cObjAlertView show];
    
    
    
    globalValues.provisionSharedDelegate.ipAdressType = IP_TYPE_DHCP;
}

-(void)launchIPConfigScreenFor:(NSString *)SSID_Str {
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Network Settings for connecting to %@",SSID_Str] message:nil confirmationData:[NSDictionary dictionary]];
    
    info.cancelButtonTitle = @"Cancel";
    info.otherButtonTitle = @"Next";
    
    GSUIAlertView *m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleIPSetting delegate:self];
    
    
    [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"password"] setValue:[lObjPassField text] forKey:@"text"];
    
    
	m_cObjAlertView.m_cObjIPSettingsView.segmentControl.selectedSegmentIndex = IP_TYPE_DHCP;

    globalValues.provisionSharedDelegate.ipAdressType = IP_TYPE_DHCP;
    
	[m_cObjAlertView.m_cObjIPSettingsView.segmentControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    [m_cObjAlertView show];
    
    
}


-(void)segmentedControlIndexChanged :(id)sender{
    
    UISegmentedControl *lObjSegmentControl = (UISegmentedControl *)sender;
	
	switch (lObjSegmentControl.selectedSegmentIndex) {
			
		case 0:
			
			globalValues.provisionSharedDelegate.ipAdressType = IP_TYPE_DHCP;
			
			break;
		case 1:
			
			globalValues.provisionSharedDelegate.ipAdressType = IP_TYPE_MANUAL;
            
			break;
			
		default:
			break;
			
	}
	
}

- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (globalValues.provisionSharedDelegate.ipAdressType == IP_TYPE_DHCP) {
		
		globalValues.provisionSharedDelegate.securedMode = NO;
		
        if (alertView.tag == 6) {
            
            exit(0);
            
        }
		else {
			
			if (buttonIndex == 0) {
				
				
			}
			else {
				
				NSArray *infoArray ;
				
				if (YES == [m_cObjDelegate refreshMode]) {
					
                    if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
                    {
                        if ([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"] || [[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@""]) {
                            
                            infoArray = [NSArray arrayWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"],lObjPassField.text,nil];
                            
                            [self showConfirmationAfterPasscodeEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                            
                            
                        }
                        else if([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                            
                            UILabel *lObjLabel = (UILabel *)[(UIView *)[self.view viewWithTag:1001] viewWithTag:102];
                            
                            NSString *passWord = [NSString stringWithFormat:@"%@:%@",lObjLabel.text,lObjPassField.text];
                            infoArray = [NSArray arrayWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"],passWord,nil];
                            
                            [self showConfirmationAfterPasscodeEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                            
                            
                        }
                        else {
                            
                            infoArray = [NSArray arrayWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"],lObjPassField.text,nil];
                            
                            [self showConfirmationAfterPasscodeEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                            
                        }
                    }
                    else
                    {
                        if ([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"] || [[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@""]) {
                            
                            
                        }
                        else if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                            
                            
                        }
                        else {
                            
                        }
                    }
				}
				else {
					
                    if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
                    {
                        if ([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"] || [[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@""]) {
                            
                            infoArray = [NSArray arrayWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"],lObjPassField.text,nil];
                            
                            
                            [self showConfirmationAfterPasscodeEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                            
                            
                        }
                        else if([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                            
                            UILabel *lObjLabel = (UILabel *)[(UIView *)[self.view viewWithTag:1001] viewWithTag:102];
                            
                            NSString *passWord = [NSString stringWithFormat:@"%@:%@",lObjLabel.text,lObjPassField.text];
                            infoArray = [NSArray arrayWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"],passWord,nil];
                            
                            
                            [self showConfirmationAfterPasscodeEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                            
                            
                        }
                        else {
                            
                            infoArray = [NSArray arrayWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"],lObjPassField.text,nil];
                            
                            
                            [self showConfirmationAfterPasscodeEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                            
                            
                        }
                        
                        
                    }
                    else
                    {
                        if ([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"] || [[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@""]) {
                            
                            infoArray = [NSArray arrayWithObjects:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]  objectForKey:@"ssid"] objectForKey:@"text"],[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"channel"] objectForKey:@"text"],lObjPassField.text,nil];
                            
                            
                            [self showConfirmationAfterPasscodeEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                            
                            
                        }
                        else if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                            
                            UILabel *lObjLabel = (UILabel *)[(UIView *)[self.view viewWithTag:1001] viewWithTag:102];
                            
                            NSString *passWord = [NSString stringWithFormat:@"%@:%@",lObjLabel.text,lObjPassField.text];
                            infoArray = [NSArray arrayWithObjects:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"channel"] objectForKey:@"text"],passWord,nil];
                            
                            [self showConfirmationAfterPasscodeEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                            
                            
                        }
                        else {
                            
                            infoArray = [NSArray arrayWithObjects:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]  objectForKey:@"channel"] objectForKey:@"text"],lObjPassField.text,nil];
                            
                            
                            [self showConfirmationAfterPasscodeEntryWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                            
                            
                            
                        }
                        
                        
                    }
				}
				
			}
			
		}
		
	}
	else {
		
		globalValues.provisionSharedDelegate.ipAdressType = YES;
		globalValues.provisionSharedDelegate.securedMode = YES;
		[m_cObjDelegate goToIPSettingsScreen];
		
	}
}




-(NSDictionary *)returnPostManualConfigurationData {
    
    NSMutableDictionary *postDataDict = [NSMutableDictionary dictionary];
    
    postDataDict[@"channel"] = [ConfigEntrys objectAtIndex:6];
    postDataDict[@"ssid"] = [ConfigEntrys objectAtIndex:0];
    postDataDict[@"security"] = [ConfigEntrys objectAtIndex:1];
    
    
    if(	globalValues.provisionSharedDelegate.clientSecurityType == WEP_SECURITY)
    {
        UILabel *lObjLabel = (UILabel *)[self.view viewWithTag:102];
        
        postDataDict[@"wepKeyIndex"] = lObjLabel.text;
        
        postDataDict[@"wepKey"] = lObjPassField.text;
        
        NSArray *lObjWepAuthArray = [NSArray arrayWithObjects:@"open",@"shared", nil];
        
        postDataDict[@"wepauth"] = [lObjWepAuthArray objectAtIndex:_wepAuthType];
        
    }
    else if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
        
        postDataDict[@"eap_type"] = [CommonProvMethods getStringForEAPType:eapType];
        
        postDataDict[@"eap_username"] = [enterpriseInfoDictionary objectForKey:@"eap_username"];
        
        postDataDict[@"eap_password"] = [enterpriseInfoDictionary objectForKey:@"eap_password"];
        
        if (sharedGsData.supportAnonymousID) {
            
            postDataDict[@"anon"] = (sharedGsData.enableAnonymousSwitch ? @"true" : @"false");
            
            if ([[self getEapType] isEqualToString:@"eap-tls"]) {
                
                postDataDict[@"cnou"] = (sharedGsData.enableCNOUSwitch ? @"true" : @"false");
                if (sharedGsData.enableCNOUSwitch) {
                    
                    postDataDict[@"eap_cn"] = [enterpriseInfoDictionary objectForKey:@"eap_cn"];
                    postDataDict[@"eap_ou"] = [enterpriseInfoDictionary objectForKey:@"eap_ou"];
                }
            }
            
        }

        
    }
    else {
        postDataDict[@"password"] = lObjPassField.text;

    }
    
    
    if (globalValues.provisionSharedDelegate.ipAdressType == IP_TYPE_DHCP) {
        
        postDataDict[@"ip_type"] = @"dhcp";
    }
    else {
        postDataDict[@"ip_type"] = @"static";

    }
    
    postDataDict[@"viewControllerMode"] = @"ModalViewController";
    
    NSLog(@"returnPostManualConfigurationData = %@",postDataDict);
    
    return postDataDict;
    
}

-(void)showConfirmationForManualConfigWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray {
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Confirm Configuration Settings" message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = aObjresponder;
    info.otherButtonTitle = @"Save";
    
    GSUIAlertView *m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleConfirmation delegate:self];
    m_cObjAlertView.tag = 401;
    
    
    UIView *lObjTempView = [[UIView alloc] init];
	lObjTempView.frame = CGRectMake(20, 20, 244, 200);
	[lObjTempView setBackgroundColor:[UIColor clearColor]];
	[m_cObjAlertView.contentView addSubview:lObjTempView];
    
    [m_cObjAlertView setContentViewHeight:200];
    
    
	for (int count=0;count< [aObjinfoArray count];count++)
	{
        
		UILabel *lObjinfoTile = [[UILabel alloc] initWithFrame:CGRectMake(20, 30 + 20*count, 80, 20)];
		lObjinfoTile.backgroundColor = [UIColor clearColor];
		//lObjinfoTile.text = [[[aObjinfoArray objectAtIndex:count] allKeys] objectAtIndex:0];
		lObjinfoTile.text = [aObjinfoArray objectAtIndex:count];
		lObjinfoTile.textColor = [UIColor whiteColor];
		lObjinfoTile.font = [UIFont boldSystemFontOfSize:12];
		[lObjView addSubview:lObjinfoTile];
		
		UILabel *lObjinfo = [[UILabel alloc] initWithFrame:CGRectMake(110, 30 + 20*count, 120, 20)];
		lObjinfo.backgroundColor = [UIColor clearColor];
		lObjinfo.text = [aObjinfoArray objectAtIndex:count];
		lObjinfo.textColor = [UIColor whiteColor];
		lObjinfo.font = [UIFont systemFontOfSize:12];
		lObjinfo.textAlignment = NSTextAlignmentRight;
		[lObjView addSubview:lObjinfo];
        
	}
    
	[m_cObjAlertView show];
	
}


-(void)showConfirmationAfterPasscodeEntryWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray {
    
    ConfigEntrys=[[NSArray alloc]initWithArray:aObjinfoArray];
    
    PostSummaryController *postController = [[PostSummaryController alloc] initWithControllerType:6];
    postController.postDictionary = [self returnPostManualConfigurationData];
    [self presentViewController:postController animated:YES completion:nil];
}



//-(void)saveConfiguration
//{
//	[globalValues.provisionSharedDelegate activityIndicator:YES];
//    
//	NSString *SSID_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"ssid"] objectForKey:@"text"]];
//	
//	NSString *Security_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"security"] objectForKey:@"text"]];
//	
//	NSString *Channel_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentIndex] objectForKey:@"channel"] objectForKey:@"text"]];
//	
//	NSMutableString * xmlString = [[NSMutableString alloc] init];
//	
//    [xmlString appendString:@"<network>"];
//    [xmlString appendString:@"<client><wireless>"];
//    [xmlString appendFormat:@"<channel>%@</channel>",Channel_Str];
//    [xmlString appendFormat:@"<ssid>%@</ssid>",SSID_Str];
//	[xmlString appendFormat:@"<security>%@</security>",Security_Str];
//    
//    if (globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
//        
//        [xmlString appendFormat:@"<eap_username>%@</eap_username>",[enterpriseInfoDictionary objectForKey:@"eap_username"]];
//        [xmlString appendFormat:@"<eap_password>%@</eap_password>",[enterpriseInfoDictionary objectForKey:@"eap_password"]];
//        [xmlString appendFormat:@"<eap_type>%@</eap_type>",[self getEapType]];
//        
//        [xmlString appendString:@"</wireless><ip>"];
//        
//    }
//    else {
//        
//        [xmlString appendFormat:@"<password>%@</password>",[lObjPassField text]];
//        
//        [xmlString appendString:@"</wireless><ip>"];
//        
//    }
//    [xmlString appendString:@"</client></network>"];
//	
//    
//    // NSLog(@">>> %@",xmlString);
//	
//	NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_POST_URL_NETWORK_DETAILS,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
//	
//	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
//	
//	[serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//	
//	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	[serviceRequest setHTTPMethod:@"POST"];
//	
//	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//	
//	[NSURLConnection connectionWithRequest:serviceRequest delegate:self];
//	
//}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *lObjCurrentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	NSInteger row = textField.tag - textFieldTag;
    
    if (row > 90) {
     
        [self replaceCNOUStringAtRow:row withString:lObjCurrentString];
    }
    else {
        
        [self replaceStringAtRow:row withString:lObjCurrentString];
    }
    
	return YES;
}

-(void)replaceCNOUStringAtRow:(NSInteger)lObjRow withString:(NSString *)lObjString {
    
    if (lObjRow == cnTextFieldTag) {
        
        [enterpriseInfoDictionary setValue:lObjString forKey:@"eap_cn"];
            }
    else if (lObjRow == ouTextFieldTag) {
        
        [enterpriseInfoDictionary setValue:lObjString forKey:@"eap_ou"];
    }
    else {
        
    }
}

-(void)replaceStringAtRow:(NSInteger)pObjRow withString:(NSString *)pObjString {
    
    if(globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
        
        if (pObjRow == 0) {
            
            [enterpriseInfoDictionary setValue:pObjString forKey:@"eap_username"];
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_username"] setValue:pObjString forKey:@"text"];
        }
        else if (pObjRow == 1){
                        
            [enterpriseInfoDictionary setValue:pObjString forKey:@"eap_password"];
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"eap_password"] setValue:pObjString forKey:@"text"];
        }
        
    }
    else if (globalValues.provisionSharedDelegate.clientSecurityType == WEP_SECURITY){
        
        [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"wepKey"] setValue:pObjString forKey:@"text"];
    }
    else {
        
    }
    
	
    //[eapTableView reloadData];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
