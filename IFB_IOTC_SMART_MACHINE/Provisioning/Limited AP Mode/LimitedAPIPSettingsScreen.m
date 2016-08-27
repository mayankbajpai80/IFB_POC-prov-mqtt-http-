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
 * $RCSfile: LimitedAPIPSettingsScreen.m,v $
 *
 * Description : Header file for LimitedAPIPSettingsScreen functions and data structures
 *******************************************************************************/

#import "LimitedAPIPSettingsScreen.h"
#import "GS_ADK_Data.h"
#import "InfoScreen.h"
#import "Identifiers.h"
#import "MySingleton.h"
#import "Scroller.h"
#import <QuartzCore/QuartzCore.h>
#import "UINavigationBar+TintColor.h"
#import "UITableView+SpecificFrame.h"
#import "ResetFrame.h"
#import "ValidationUtils.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"

#import "GSNavigationBar.h"
#import "ModeController.h"

@interface LimitedAPIPSettingsScreen (privateMethods)<CustomUIAlertViewDelegate>

-(void)showLimitedAPConfirmationWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray;


-(void)replaceStringAtIndexPath:(NSIndexPath *)pObjIndexPath withString:(NSString *)pObjString;

-(BOOL)checkForEmptyFields;

-(BOOL)checkForInvalidIPAdresses;

-(BOOL)checkForMaxNoOfipAdresses;

-(BOOL)checkForValidDomainName;

@end


@implementation LimitedAPIPSettingsScreen

@synthesize appDelegate,sharedGsData,m_cObjNavBar,m_cObjTable,m_cObjKeyboardRemoverButton;
@synthesize m_cObjConnParameters,m_cObjTitles,m_cObjFieldTitles,FieldTitles,DHCP_Enabled,DNS_Enabled,security_str;


#pragma mark -
#pragma mark View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
	m_cObjNavBar.hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
	
	m_cObjNavBar.hidden = YES;
	
}
//-(void)goBackToPriousPage
//{
//	
//	[self.navigationController popViewControllerAnimated:YES];
//}

-(void)showInfo
{
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
	[self presentViewController:lObjInfoScreen animated:YES completion:nil];
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
            
        case NavigationItemMode: {
            ModeController *modeController = [[ModeController alloc] initWithControllerType:5];
            [self.navigationController pushViewController:modeController animated:YES];
            
        }
            
            break;
            
        case NavigationItemDone:
            
            
            break;

            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
	appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
    
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
	
	m_cObjTitles = [[NSArray alloc] initWithObjects:@"",@"Enable DHCP Server",@"Enable DNS Server",nil];
    
	m_cObjFieldTitles = [[NSMutableArray alloc] init];
	
	NSArray *lObjArray = [NSArray arrayWithObjects:@"IP Address",@"Subnet Mask",@"Gateway",nil];
	[m_cObjFieldTitles addObject:lObjArray];
	
	lObjArray = [NSArray arrayWithObjects:@"Starting Address",@"Number Of Addresses",nil];
	[m_cObjFieldTitles addObject:lObjArray];
	
	lObjArray = [NSArray arrayWithObjects:@"Domain Name",nil];
	[m_cObjFieldTitles addObject:lObjArray];
	
	NSArray *keys = [NSArray arrayWithObjects:@"dhcp_num_addrs",@"ip_addr",@"dns_domain",@"dhcp_start_addr",@"subnetmask",@"gateway",nil];
	
	NSArray *objects = [NSArray arrayWithObjects:@"Number Of Addresses",@"IP Address",@"Domain Name",@"Starting Address",@"Subnet Mask",@"Gateway",nil];
	
	FieldTitles = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
	if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_server_enable"] objectForKey:@"text"] isEqualToString:@"true"]) {
		
		DHCP_Enabled = YES;
		
	}
	else {
		
		DHCP_Enabled = NO;
		
	}
	
	if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dns_server_enable"] objectForKey:@"text"] isEqualToString:@"true"]) {
		
		DNS_Enabled = YES;
		
	}
	else {
		
		DNS_Enabled = NO;
	}
	
    
	
	if ([[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] != nil || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@""]) {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
		
	}
	else {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
        
	}
    
    //	m_cObjTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-22) style:UITableViewStyleGrouped];
   
    m_cObjTable = [[UITableView alloc]initWithiOSVersionSpecificMargin:STATUS_BAR_HEIGHT withAdjustment:(NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];

	m_cObjTable.dataSource=self;
	m_cObjTable.delegate = self;
	[self.view addSubview:m_cObjTable];
	
	m_cObjKeyboardRemoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[m_cObjKeyboardRemoverButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
	[m_cObjKeyboardRemoverButton addTarget:self action:@selector(resignKeyPad) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:m_cObjKeyboardRemoverButton];
	
	
}

//-(void)goToSwitchMode
//{
//    UIActionSheet *lObjActionSheet = [[UIActionSheet alloc] initWithTitle:@"Switch Mode" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Client",@"Limited AP",nil];
//    
//    if ([[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"limited-ap"])
//    {
//        [[[lObjActionSheet subviews] objectAtIndex:2] setBackgroundColor:[ResetFrame actionSheetColorForDifferentIOSVersion]];
//    }
//    else
//    {
//        [[[lObjActionSheet subviews] objectAtIndex:1] setBackgroundColor:[ResetFrame actionSheetColorForDifferentIOSVersion]];
//    }
//    
//   // [lObjActionSheet showFromTabBar:appDelegate.m_gObjTabController.tabBar ];
//    
//    [lObjActionSheet showInView:self.view];
//
//    [lObjActionSheet release];
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (buttonIndex < 2) {
        
		[globalValues.provisionSharedDelegate setMode:2-buttonIndex];
		
	}
}

#pragma mark -
#pragma mark Table view data source

-(UIView *)getSectionHeader: (NSInteger)index {
	
	UIView *lObjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[lObjView setBackgroundColor:[UIColor clearColor]];
    
	if (index != 3) {
		
		//UILabel *lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+1-5, 20+1+8-7, 280, 20)];
//		UILabel *lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,11, 280, 20)];
//		lObjHeaderLabel.backgroundColor = [UIColor clearColor];
//		[lObjHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
//		lObjHeaderLabel.textColor = ;
//		lObjHeaderLabel.text = [m_cObjTitles objectAtIndex:index];
//		[lObjView addSubview:lObjHeaderLabel];
//		[lObjHeaderLabel release];
		
		//lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20-5, 20+8-7, 280, 20)];
		UILabel *lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 280, 20)];
		lObjHeaderLabel.backgroundColor = [UIColor clearColor];
		[lObjHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
		lObjHeaderLabel.textColor = [UIColor colorWithRed:0.35 green:0.40 blue:0.50 alpha:1];
		lObjHeaderLabel.text = [m_cObjTitles objectAtIndex:index];
		[lObjView addSubview:lObjHeaderLabel];
        lObjHeaderLabel.shadowColor = [UIColor whiteColor];
        lObjHeaderLabel.shadowOffset = CGSizeMake(0, 1);
		
		//UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 20-7, 100, 20)];
		UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 7, 100, 20)];
		
		if (index == 1) {
			
			[lObjSwitch setOn:DHCP_Enabled];
		}
		else {
			
			[lObjSwitch setOn:DNS_Enabled];
		}
		
		lObjSwitch.tag = index;
		[lObjSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
		[lObjView addSubview:lObjSwitch];
		
	}
	else {
		
		UIButton *m_cObjConfirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		m_cObjConfirmButton.frame = CGRectMake(20, 0, 280, 66);
		[m_cObjConfirmButton setTitle:@"Next" forState:UIControlStateNormal];
		[m_cObjConfirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
		[lObjView addSubview:m_cObjConfirmButton];
		
	}
	return lObjView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	if (section == 0) {
		
		return 3;
		
	}
	else if (section == 1){
        
		if (DHCP_Enabled) {
			
			return 2;
		}
		else {
			
			return 0;
		}
        
	}
	else if (section == 2){
        
		if (DNS_Enabled) {
			
			return 1;
		}
		else {
			
			return 0;
		}
        
	}
	else {
		
		return 0;
        
	}
	
	
	
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section != 0) {
		
		return [self getSectionHeader:section];
	}
	
	return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == 3) {
		return nil;
	}
	
    static NSString *CellIdentifier = @"Cell";
    
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 110, 44)];
	[lObjLabel setBackgroundColor:[UIColor clearColor]];
	[lObjLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
	[lObjLabel setText:[[m_cObjFieldTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
  	[lObjLabel setFont:[UIFont systemFontOfSize:12]];
	[lObjLabel setNumberOfLines:2];
	[lObjLabel setTextColor:[UIColor grayColor]];
	[cell.contentView addSubview:lObjLabel];
	
	UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(150-40, 0, 145+20+15, 44)];
	
	if ([[[m_cObjFieldTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"IP Address"]) {
		
		lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"];
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Subnet Mask"]) {
		
		lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"];
		
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Gateway"]) {
		
		lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"];
		
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Starting Address"]) {
		
		lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_start_addr"] objectForKey:@"text"];
		
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Number Of Addresses"]) {
		
		lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_num_addrs"] objectForKey:@"text"];
		
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Domain Name"]) {
		
		lObjTextField.text = [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dns_domain"] objectForKey:@"text"];
		
	}
	
	[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	
	if (indexPath.section != 2) {
		
		[lObjTextField setKeyboardType:UIKeyboardTypeDecimalPad];
        
        
	}
    
	lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	lObjTextField.tag = (indexPath.section + 1)*100 + (indexPath.row + 1);
	[lObjTextField setFont:[UIFont systemFontOfSize:16]];
	[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	[lObjTextField setBackgroundColor:[UIColor clearColor]];
	lObjTextField.textAlignment = NSTextAlignmentRight;
	[lObjTextField setDelegate:self];
	[cell.contentView addSubview:lObjTextField];
	
    
	return cell;
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section != 3) {
		
		return 44.0;
	}
	else {
		
		return 66.0;
	}
}

-(void)switchToggled:(id)sender {
	
	UISwitch *lObjSwitch = (UISwitch *)sender;
	
	if (lObjSwitch.tag == 1) {
		
		NSIndexPath *lIndxPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
		NSIndexPath *lIndxPath2 = [NSIndexPath indexPathForRow:1 inSection:1];
		
		if (lObjSwitch.on) {
			
			DHCP_Enabled = YES;
			[m_cObjTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,nil] withRowAnimation:UITableViewRowAnimationFade];
		}
		else {
			
			DHCP_Enabled = NO;
			[m_cObjTable  deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,lIndxPath2,nil] withRowAnimation:UITableViewRowAnimationFade];
			
		}
        
	}
	else {
		
		NSIndexPath *lIndxPath1 = [NSIndexPath indexPathForRow:0 inSection:2];
		
		
		if (lObjSwitch.on) {
			
			DNS_Enabled = YES;
			[m_cObjTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
			
		}
		else {
			
			DNS_Enabled = NO;
			[m_cObjTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lIndxPath1,nil] withRowAnimation:UITableViewRowAnimationFade];
			
		}
		
	}
	
}

-(void)confirm {
    
    [self resignKeyPad];
	
	if ([self checkForEmptyFields] == YES && [self checkForInvalidIPAdresses] == YES && [self checkForMaxNoOfipAdresses] == YES) {
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"ssid"] setObject:@"" forKey:@"text"];
            
        }
        
        
		NSString *SSID_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]];
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] setObject:@"" forKey:@"text"];
            
        }
        
		NSString *Channel_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]];
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"beacon_interval"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"beacon_interval"] setObject:@"" forKey:@"text"];
            
        }
        
		NSString *BeaconInterval_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"beacon_interval"] objectForKey:@"text"]];
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"security"] setObject:@"none" forKey:@"text"];
            
        }
        
        
		NSString *Security_Str = [security_str lowercaseString];
        
        //[NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"security"] objectForKey:@"text"]];
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"ip_addr"] setObject:@"" forKey:@"text"];
            
        }
        
		NSString *IPAddress_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"]];
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"subnetmask"] setObject:@"" forKey:@"text"];
            
        }
        
		NSString *SubnetMask_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"]];
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"gateway"] setObject:@"" forKey:@"text"];
            
        }
        
		NSString *Gateway_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"]];
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_start_addr"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_start_addr"] setObject:@"" forKey:@"text"];
            
        }
        
		NSString *DHCP_StartRange_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_start_addr"] objectForKey:@"text"]];
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_num_addrs"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_num_addrs"] setObject:@"" forKey:@"text"];
            
        }
        
		NSString *NoOfDHCP_Address_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_num_addrs"] objectForKey:@"text"]];
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dns_domain"] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dns_domain"] setObject:@"" forKey:@"text"];
            
        }
        
		NSString *DomainName_Str = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dns_domain"] objectForKey:@"text"]];
        
        
		NSMutableArray *confirmData = [NSMutableArray arrayWithObjects:SSID_Str,Channel_Str,BeaconInterval_Str,Security_Str,IPAddress_Str,SubnetMask_Str,Gateway_Str,DHCP_StartRange_Str,NoOfDHCP_Address_Str,DomainName_Str,nil];
        
		[self showLimitedAPConfirmationWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:confirmData];
        
	}
	
}

-(BOOL)checkForEmptyFields {
	
	NSArray *lOBjArray = [NSArray arrayWithArray:[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] allKeys]];
    
	for (int i = 0; i < [lOBjArray count]; i++) {
        
        if ([[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:[lOBjArray objectAtIndex:i]] objectForKey:@"text"]) {
            
            
        }
        else
        {
            
            [[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:[lOBjArray objectAtIndex:i]] setObject:@"" forKey:@"text"];
            
        }
        
        
        if ([[[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:[lOBjArray objectAtIndex:i]] objectForKey:@"text"] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            
            NSString *lObjString = [FieldTitles objectForKey:[lOBjArray objectAtIndex:i]];
            
            if ([lObjString isEqualToString:@"Starting Address"] && DHCP_Enabled == NO) {
                
                continue;
            }
            if ([lObjString isEqualToString:@"Number Of Addresses"] && DHCP_Enabled == NO) {
                
                continue;
            }
            if ([lObjString isEqualToString:@"Domain Name"] && DNS_Enabled == NO) {
                
                continue;
            }
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Fill up all the fields to continue" message:[NSString stringWithFormat:@"please enter %@",lObjString] confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            
            
            // UIAlertView *lObjFieldValidation = [[UIAlertView alloc] initWithTitle:@"Fill up all the fields to continue" message:[NSString stringWithFormat:@"please enter %@",lObjString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [lObjFieldValidation show];
            
            return NO;
            
        }
        
		
	}
	
	return YES;
	
}

-(BOOL)checkForInvalidIPAdresses {
	
	NSArray *lOBjArray = [NSArray arrayWithArray:[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] allKeys]];
    
	for (int i = 0; i < [lOBjArray count]; i++) {
		
		NSString *lObjString = [FieldTitles objectForKey:[lOBjArray objectAtIndex:i]];
        
        
		if ([[lOBjArray objectAtIndex:i] isEqualToString:@"dhcp_num_addrs"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"dns_server_enable"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"dhcp_server_enable"] || [[lOBjArray objectAtIndex:i] isEqualToString:@"dns_domain"]) {
			
			continue;
		}
        else if ([lObjString isEqualToString:@"Starting Address"] && DHCP_Enabled == NO) {
            
			continue;
        }
		else {
            
            NSString *myOriginalString = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:[lOBjArray objectAtIndex:i]] objectForKey:@"text"]];
            
			if ([myOriginalString length]<7) {
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Invalid %@",lObjString] message:nil confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
                
                [lObjFieldValidation show];
				
				return NO;
				
			}
			else {
				
				if ([myOriginalString characterAtIndex:0] == '.' || [myOriginalString characterAtIndex:myOriginalString.length-1] == '.') {
                    
                    GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Invalid %@",lObjString] message:nil confirmationData:[NSDictionary dictionary]];
                    info.cancelButtonTitle = @"OK";
                    info.otherButtonTitle = nil;
                    
                    GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
                    [lObjFieldValidation show];
					
					return NO;
                    
				}
			}
            
            
            BOOL validation = [ValidationUtils validateIPAddress:myOriginalString withTitle:lObjString];
            
            if (!validation) {
                return NO;
            }            
            
            
            BOOL valid;
			
            NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
            
            NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[myOriginalString stringByReplacingOccurrencesOfString:@"." withString:@""]];
            
            valid = [alphaNums isSupersetOfSet:inStringSet];
            
            if (!valid) {
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Alphanumeric characters other than (.) is not allowed"   message:[NSString stringWithFormat:@"%@ should not contain alphanumeric characters other than (.)",lObjString] confirmationData:[NSDictionary dictionary]];
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

-(BOOL)checkForMaxNoOfipAdresses {
    
	
    if (DHCP_Enabled == YES) {
        
        if ([sharedGsData.firmwareVersion.chip rangeOfString:@"2000"].location != NSNotFound)
        {
            if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_num_addrs"] objectForKey:@"text"] intValue] > 64 || [[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_num_addrs"] objectForKey:@"text"] intValue] < 1) {
                
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Maximum Number Of Addresses should be more than 1 and less than 65"   message:nil confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
                GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
                [lObjFieldValidation show];
                
                return NO;
                
            }
        }
        else
        {
            if ([[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_num_addrs"] objectForKey:@"text"] intValue] > 32 || [[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_num_addrs"] objectForKey:@"text"] intValue] < 1) {
                
                
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Maximum Number Of Addresses should be more than 1 and less than 33"   message:nil confirmationData:[NSDictionary dictionary]];
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

-(BOOL)checkForValidDomainName {
	
    if (DNS_Enabled == NO) {
        
        return YES;
    }
    
	NSString *lObjStr = [NSString stringWithString:[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dns_domain"] objectForKey:@"text"]];
    
	if ([lObjStr length]<5) {
        
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Invalid Domain Name"]   message:nil confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
        [lObjFieldValidation show];
		
		return NO;
		
	}
	else {
		
		if ([lObjStr characterAtIndex:0] == '.' || [lObjStr characterAtIndex:lObjStr.length-1] == '.') {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Invalid Domain Name"]   message:nil confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            [lObjFieldValidation show];
			
			return NO;
			
		}
		
	}
	
	NSArray *lObjArray = [lObjStr componentsSeparatedByString:@"."];
	
	if (lObjArray) {
		
		if ([lObjArray count]!=3) {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Invalid Domain Name"]   message:nil confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @"OK";
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            [lObjFieldValidation show];
			
			return NO;
			
		}
		
		
	}
	else {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Invalid Domain Name"]   message:nil confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
        [lObjFieldValidation show];
		
		return NO;
		
	}
	
	return YES;
	
}

-(void)showLimitedAPConfirmationWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray {
    
	
	m_cObjConnParameters = [[NSArray alloc] initWithArray:aObjinfoArray];
    
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Confirm Configuration Settings" message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = aObjresponder;
    info.otherButtonTitle = @"Save";
    
    GSUIAlertView *m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleConfirmation delegate:self];
    m_cObjAlertView.tag = 3;
	m_cObjAlertView.delegate = self;
    
    [m_cObjAlertView setContentViewHeight:210];
	
    Scroller *lObjScroll = [[Scroller alloc] initWithFrame:CGRectMake(0,0, 250, 270-60)];
	lObjScroll.tag = 31;
	[lObjScroll setBackgroundColor:[UIColor clearColor]];
	[m_cObjAlertView.contentView addSubview:lObjScroll];
    
	[m_cObjAlertView addSubview:[lObjScroll m_cObjUpArraow]];
	lObjScroll.m_cObjUpArraow = nil;
    
	[m_cObjAlertView addSubview:[lObjScroll m_cObjDownArraow]];
	lObjScroll.m_cObjDownArraow= nil;
	
	NSMutableArray *lObjTitleArray = [NSMutableArray arrayWithObjects:@"SSID",@"Channel",@"Beacon Interval (ms)",@"Security",@"IP Address",@"Subnet Mask",@"Gateway",nil];
	
    
    if (DHCP_Enabled == YES) {
        
        [lObjTitleArray addObject:@"DHCP Starting Range"];
        [lObjTitleArray addObject:@"Number Of DHCP addresses"];
        
    }
    
    if (DNS_Enabled == YES) {
        
        [lObjTitleArray addObject:@"Domain Name"];
        
    }
    
    
	for (int count=0;count < [lObjTitleArray count];count++)
	{
		[lObjScroll setContentSize:CGSizeMake(244, 60 + 40*count)];
		
		UILabel *lObjinfoTile = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 40*count, 80+20, 30)];
		lObjinfoTile.backgroundColor = [UIColor clearColor];
		lObjinfoTile.text = [lObjTitleArray objectAtIndex:count];
		lObjinfoTile.textColor = [UIColor blackColor];
		lObjinfoTile.font = [UIFont boldSystemFontOfSize:11];
		[lObjinfoTile setNumberOfLines:2];
		[lObjScroll addSubview:lObjinfoTile];
		
		UILabel *lObjinfo = [[UILabel alloc] initWithFrame:CGRectMake(110+10, 10 + 40*count, 100+15, 30)];
		lObjinfo.backgroundColor = [UIColor clearColor];
		
		if (count == 9) {
			
			lObjinfo.text = [aObjinfoArray objectAtIndex:count];
			
		}
		else {
			
			if ([[aObjinfoArray objectAtIndex:count] isEqualToString:@"wpa-personal"]) {
				
				lObjinfo.text = @"WPA/WPA2 Personal";
				
			}
			else if ([[aObjinfoArray objectAtIndex:count] isEqualToString:@"wep"]){
				
				lObjinfo.text = @"WEP";
			}
            else if ([[aObjinfoArray objectAtIndex:count] isEqualToString:@"none"]){
				
				lObjinfo.text = @"None";
			}
			else
			{
				lObjinfo.text = [aObjinfoArray objectAtIndex:count];
				
			}
			
		}
		
		lObjinfo.textColor = [UIColor blackColor];
		lObjinfo.font = [UIFont systemFontOfSize:11];
		lObjinfo.textAlignment = NSTextAlignmentRight;
       // lObjinfo.numberOfLines=2;
		[lObjScroll addSubview:lObjinfo];
	}
	
	[m_cObjAlertView show];
	
}

-(void)confirmLimitedAPSettingsWithData:(NSArray *)_connParameters WithSettingsMode:(BOOL)mode {
    
    [globalValues.provisionSharedDelegate activityIndicator:YES];
	
	NSMutableString * xmlString = [[NSMutableString alloc] init];
	
    [xmlString appendString:@"<network>"];
    
    if (mode == YES) {
        
        _saveMode = YES;
        
       [xmlString appendString:@"<mode>limited-ap</mode>"];
    }
    
    
    [xmlString appendString:@"<ap><wireless>"];
    [xmlString appendFormat:@"<channel>%@</channel>",[_connParameters objectAtIndex:1]];
    [xmlString appendFormat:@"<beacon_interval>%@</beacon_interval>",[_connParameters objectAtIndex:2]];
    [xmlString appendFormat:@"<ssid>%@</ssid>",[_connParameters objectAtIndex:0]];
	[xmlString appendFormat:@"<security>%@</security>",[_connParameters objectAtIndex:3]];
    
	//int offset = appDelegate.apSecurityType;
	
	switch (globalValues.provisionSharedDelegate.apSecurityType) {
		case 0:
            [xmlString appendString:@"<password></password>"];
			break;
		case 1:
            
            [xmlString appendFormat:@"<password>%@:%@</password>",[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKeyIndex"] objectForKey:@"text"],[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"wepKey"] objectForKey:@"text"]];
			
			//offset--;
			break;
		case 2:
			
            [xmlString appendFormat:@"<password>%@</password>",[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"password"] objectForKey:@"text"]];
            
			//offset=0;
			break;
		default:
			break;
	}
	
    [xmlString appendString:@"</wireless><ip>"];
	
    [xmlString appendFormat:@"<ip_addr>%@</ip_addr>",[_connParameters objectAtIndex:4]];
	
    [xmlString appendFormat:@"<subnetmask>%@</subnetmask>",[_connParameters objectAtIndex:5]];
	
    [xmlString appendFormat:@"<gateway>%@</gateway>",[_connParameters objectAtIndex:6]];
	
	if (DHCP_Enabled == YES) {
		
        [xmlString appendFormat:@"<dhcp_server_enable>%@</dhcp_server_enable>",@"true"];
        
        [xmlString appendFormat:@"<dhcp_start_addr>%@</dhcp_start_addr>",[_connParameters objectAtIndex:7]];
        
        [xmlString appendFormat:@"<dhcp_num_addrs>%@</dhcp_num_addrs>",[_connParameters objectAtIndex:8]];
        
	}
	else {
		
		[xmlString appendFormat:@"<dhcp_server_enable>%@</dhcp_server_enable>",@"false"];
        
	}
	
	if (DNS_Enabled == YES) {
		
        [xmlString appendFormat:@"<dns_server_enable>%@</dns_server_enable>",@"true"];
        
		[xmlString appendFormat:@"<dns_domain>%@</dns_domain>",[_connParameters objectAtIndex:9]];
        
	}
	else {
        
        [xmlString appendFormat:@"<dns_server_enable>%@</dns_server_enable>",@"false"];
        
	}
	
    [xmlString appendString:@"</ip></ap></network>"];
    
    NSLog(@"confirmLimitedAPSettingsWithData >> %@",xmlString);
    
	NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_POST_URL_NETWORK_DETAILS,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
	
	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
	
	[serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
	[serviceRequest setHTTPMethod:@"POST"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
	
	[NSURLConnection connectionWithRequest:serviceRequest delegate:self];
	
	
	
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [globalValues.provisionSharedDelegate activityIndicator:NO];
    
    if (sharedGsData.supportDualInterface && sharedGsData.doesSupportConcurrentMode && !_saveMode) {
        
        UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"The settings were saved. Please ensure you have configured both the Client and Limited AP Settings, then choose Concurrent from the Set Mode screen" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        lObjAlertView.delegate = nil;
        [lObjAlertView show];

    }
    else if(_saveMode) {
        
        NSString *lObjString = [NSString stringWithFormat:@"Your device is now in %@ mode. Please re-connect to the device using your new wireless settings.",@"limited-ap"];
        
        
        UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:lObjString message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        lObjAlertView.tag = 6;
        lObjAlertView.delegate = self;
        [lObjAlertView show];

        
    }
    else {
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [globalValues.provisionSharedDelegate activityIndicator:NO];
}


-(void)showConfirmationAlert {
    
    NSString *lObjMessageString = nil;
    NSString *lObjApplyString = nil;
    NSString *lObjLaterString = nil;
    
    if (sharedGsData.supportDualInterface && sharedGsData.doesSupportConcurrentMode) {
        
        lObjMessageString = @"The settings will be saved.";
        
        lObjApplyString = nil;
        
        lObjLaterString = @"Ok";
    }
    else {
        
        lObjMessageString = @" The settings will be saved. Would you also like to apply the new settings right away?";
        
        lObjApplyString = @"Apply";
        
        lObjLaterString = @"Later";
    }
    
    NSLog(@"concurrent mode check");
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Confirmation" message:lObjMessageString confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = lObjLaterString;
    info.otherButtonTitle = lObjApplyString;
    
    GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    lObjAlert.tag = 301;
    [lObjAlert show];
    
}



- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // NSLog(@"alertView.tag >> %lu",alertView.tag);
    
	if (alertView.tag == 301) {
		
		if (buttonIndex == 0) {
            
            [self confirmLimitedAPSettingsWithData:m_cObjConnParameters WithSettingsMode:NO];
			
		}
		else {
            
            [self confirmLimitedAPSettingsWithData:m_cObjConnParameters WithSettingsMode:YES];
            
		}
		
	}
    if (alertView.tag == 6) {
        
        exit(1);        
        return;

    }
    
    if (alertView.tag == 3) {
        
        if (buttonIndex == 1) {
            
            //[self confirmLimitedAPSettingsWithData:m_cObjConnParameters];
            
            [self showConfirmationAlert];
            
        }
        
    }
    
	
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
   // NSLog(@"textField.tag => %zd",textField.tag);
    
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
    
    if (textField.tag == 301) {
        
        [m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+ 100, 60, 30)];

    }
    else {
        [m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height-247, 60, 30)];

    }
		
	[m_cObjTable setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-240)];
    
	[UIView commitAnimations];
	
	NSInteger section = (textField.tag / 100)-1;
	
	NSInteger row = (textField.tag % 100)-1;
	
	[m_cObjTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
	
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
	
	
	NSInteger section = (textField.tag / 100)-1;
	
	NSInteger row = (textField.tag % 100)-1;
	
	
	NSIndexPath *lObjIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
	
	[self replaceStringAtIndexPath:lObjIndexPath withString:lObjCurrentString];
	
	
	return YES;
	
}

-(void)replaceStringAtIndexPath:(NSIndexPath *)pObjIndexPath withString:(NSString *)pObjString
{
	
	if ([[[m_cObjFieldTitles objectAtIndex:pObjIndexPath.section] objectAtIndex:pObjIndexPath.row] isEqualToString:@"IP Address"]) {
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"ip_addr"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:pObjIndexPath.section] objectAtIndex:pObjIndexPath.row] isEqualToString:@"Subnet Mask"]){
        
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"subnetmask"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:pObjIndexPath.section] objectAtIndex:pObjIndexPath.row] isEqualToString:@"Gateway"]){
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"gateway"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:pObjIndexPath.section] objectAtIndex:pObjIndexPath.row] isEqualToString:@"Starting Address"]){
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_start_addr"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:pObjIndexPath.section] objectAtIndex:pObjIndexPath.row] isEqualToString:@"Number Of Addresses"]){
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dhcp_num_addrs"] setValue:pObjString forKey:@"text"];
		
	}
	else if ([[[m_cObjFieldTitles objectAtIndex:pObjIndexPath.section] objectAtIndex:pObjIndexPath.row] isEqualToString:@"Domain Name"]){
		
		[[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] objectForKey:@"dns_domain"] setValue:pObjString forKey:@"text"];
		
	}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
	
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
	//[m_cObjTable setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    
    [m_cObjTable setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height-22)];

	
	[UIView commitAnimations];
	
	[textField resignFirstResponder];
	
	return YES;
	
}// called when 'return' key pressed. return NO to ignore.

-(void)resignKeyPad
{
	
	for (int i=0; i<[m_cObjFieldTitles count]; i++) {
		
		for (int j=0; j<[[m_cObjFieldTitles objectAtIndex:i] count]; j++) {
            
			UITextField *lObjTextField = (UITextField *)[m_cObjTable viewWithTag:(i+1)*100+(j+1)];
			
			[lObjTextField resignFirstResponder];
		}
		
	}
	
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
	
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height+100, 60, 30)];
    
	[m_cObjTable setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height-22)];
	
	[UIView commitAnimations];
	
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

