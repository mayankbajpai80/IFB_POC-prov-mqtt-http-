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
 * $RCSfile: InfoScreen.m,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import "InfoScreen.h"
#import "GS_ADK_Data.h"
#import "Identifiers.h"
#import <QuartzCore/QuartzCore.h>
#import "UINavigationBar+TintColor.h"
#import "UITableView+SpecificFrame.h"
#import "ResetFrame.h"


@implementation InfoScreen

@synthesize  sharedGsData,m_cObjTable,m_cObjTitles;

#pragma mark -
#pragma mark Initialization

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
                        
            break;
            
        case NavigationItemMode:
            
            break;
            
            case NavigationItemDone:
            
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	//[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];

	m_cObjTitles = [[NSMutableArray alloc] initWithObjects:[NSMutableArray arrayWithObjects:@"System Identification",@"Name",@"UUID",@"MAC",nil],[NSMutableArray arrayWithObjects:@"Firmware Info",@"App version",@"WLAN",@"GEPS",@"API version",@"MODULE",nil],[NSMutableArray arrayWithObjects:@"iOS app info",@"version",nil],[NSMutableArray arrayWithObjects:@"IP Settings",@"IP Address",nil],nil];
    
    float statusBarHeight;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
         statusBarHeight = 0;
    }
    
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    
        statusBarHeight = 20;
    }
    
    self.navigationBar.title=@"Info";
    
    m_cObjTable = [[UITableView alloc] initWithiOSVersionSpecificMargin:STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT withAdjustment:0 style:UITableViewStyleGrouped];
    m_cObjTable.dataSource=self;
	m_cObjTable.delegate = self;
	[self.view addSubview:m_cObjTable];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[m_cObjTitles objectAtIndex:section] objectAtIndex:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [m_cObjTitles count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[m_cObjTitles objectAtIndex:section] count]-1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    
	UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150-10, 44)];
	[lObjLabel setBackgroundColor:[UIColor clearColor]];
	[lObjLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[lObjLabel setTextColor:[UIColor grayColor]];
	[lObjLabel setText:[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1]];
	[cell.contentView addSubview:lObjLabel];
	
		
	lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(150-40, 0, 150-10+40, 44)];
	[lObjLabel setBackgroundColor:[UIColor clearColor]];
	[lObjLabel setTextAlignment:NSTextAlignmentRight];
	[lObjLabel setFont:[UIFont systemFontOfSize:14]];
	[lObjLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	
	
	if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"Name"]) {
		
		[lObjLabel setText:[[[[sharedGsData configId] objectForKey:@"id"]objectForKey:@"name"] objectForKey:@"text"]];

	}
	else if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"UUID"]) {
		
		[lObjLabel setText:[[[[sharedGsData configId] objectForKey:@"id"]objectForKey:@"uid"] objectForKey:@"text"]];

	}
	else if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"MAC"]) {
		
		[lObjLabel setText:[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mac_addr"] objectForKey:@"text"]];

	}
	else if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"App version"]) {
		
		if([[NSString stringWithFormat:@"%@",sharedGsData.firmwareVersion.app] isEqualToString:@"(null)"])
		{
			[lObjLabel setText:@""];
		}
		else
		{
			[lObjLabel setText:sharedGsData.firmwareVersion.app];
		}
		
	}
	else if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"WLAN"]) {
		
		[lObjLabel setText:sharedGsData.firmwareVersion.wlan];

	}
	else if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"GEPS"]) {
		
		[lObjLabel setText:sharedGsData.firmwareVersion.geps];

	}
	else if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"MODULE"]) {
				
        if([sharedGsData.firmwareVersion.chip rangeOfString:@"gs1550m" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [lObjLabel setText:@"GS1550"];
        }
        else if ([sharedGsData.firmwareVersion.chip rangeOfString:@"gs1500m" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [lObjLabel setText:@"GS1500"];
        }
        else if ([sharedGsData.firmwareVersion.chip rangeOfString:@"gs2000" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [lObjLabel setText:@"GS2000"];
        }
        else
        {
            [lObjLabel setText:@"GS1011"];
        }
		
	}

	else if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"API version"]) {
		
		[lObjLabel setText:[[[sharedGsData apiVersion] objectForKey:@"version"] objectForKey:@"text"]];

	}
	else if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"version"]) {
		
		[lObjLabel setText:APP_VERSION];

	}
	else if ([[[m_cObjTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row+1] isEqualToString:@"IP Address"]) {
		
        [lObjLabel setText:[[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"ip"]objectForKey:@"ip_addr"] objectForKey:@"text"]];
		
	}
	
	[cell.contentView addSubview:lObjLabel];
	
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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

