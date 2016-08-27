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
 * $RCSfile: AdminSettingsViewController.m,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import "AdminSettingsViewController.h"
#import "InfoScreen.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "APSettingsViewController.h"
#import "SystemIDScreen.h"
#import "GS_ADK_Data.h"
#import "UINavigationBar+TintColor.h"
#import "ResetFrame.h"
#import "UITableView+SpecificFrame.h"
#import "Identifiers.h"
#import "ModeController.h"


@interface AdminSettingsViewController(privateMethods)

-(void)createNavigationBar;

@end


@implementation AdminSettingsViewController

@synthesize sharedGsData,m_cObjTableView,m_cObjSettingOptions;

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


#pragma mark -
#pragma mark View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
	
	////lObjNavBar.hidden = NO;
	
	//[appDelegate deallocListData];
}

-(void)viewDidDisappear:(BOOL)animated
{
	
	////lObjNavBar.hidden = YES;
	
}

- (void)navigationItemTapped:(NavigationItem)item
{
    
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
            
        case NavigationItemDone:
            
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

	//appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];

	m_cObjSettingOptions = [[NSArray alloc] initWithObjects:@"System Identification",@"Web Server Settings",nil];
    
    sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
	if ([[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] != nil || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@""]) {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
		
	}
	else {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
        
	}
    
    self.navigationBar.title = @"Admin Settings";

		
    m_cObjTableView = [[UITableView alloc] initWithiOSVersionSpecificMargin:STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT withAdjustment:(NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];

    [m_cObjTableView setDataSource:self];
	[m_cObjTableView setDelegate:self];
	[self.view addSubview:m_cObjTableView];
	
}



-(void)showInfo {
    
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
    [self presentViewController:lObjInfoScreen animated:YES completion:nil];
}




#pragma mark -
#pragma mark Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [m_cObjSettingOptions count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
	[cell.textLabel setText:[m_cObjSettingOptions objectAtIndex:indexPath.row]];
	
    // Configure the cell...
    
    return cell;
}





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   	
	if (indexPath.row == 0) {
		
		SystemIDScreen *lObjSystemIDScreen = [[SystemIDScreen alloc] initWithControllerType:1];
		[self.navigationController pushViewController:lObjSystemIDScreen animated:YES];
	}
	if (indexPath.row == 1) {
		
		APSettingsViewController *lObjServerSettings = [[APSettingsViewController alloc] initWithControllerType:1];
		[self.navigationController pushViewController:lObjServerSettings animated:YES];
	}
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

