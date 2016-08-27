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
 * $RCSfile: Options.m,v $
 *
 * Description : Header file for Options functions and data structures
 *******************************************************************************/
#import "Options.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "GS_ADK_Data.h"
#import "UITableView+SpecificFrame.h"
#import "Identifiers.h"

@interface Options(privateMethods)

-(UIView *)getSectionFooter;

@end


@implementation Options

@synthesize m_cObjDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
	
    if (self) {
        // Initialization code.
		
		sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];

		appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		m_cObjTableView = [[UITableView alloc] initWithiOSVersionSpecificMargin:STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT withAdjustment:(TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
        
		[m_cObjTableView setDataSource:self];
		[m_cObjTableView setDelegate:self];
		[self addSubview:m_cObjTableView];
		
		
			if (sharedGsData.wpaEnabled == NO) {
				
                if ([sharedGsData.m_gObjNodeIP isEqualToString:@"0000"]) {
                    
                    m_cObjOptions = [[NSArray alloc] initWithObjects:@"WPS Push Button",@"WPS PIN",@"Select an Existing Network",@"Manual configuration",nil];
                    
                    selectedIndex = 2;
                    
                }
                else
                {
                    m_cObjOptions = [[NSArray alloc] initWithObjects:@"Scan For Networks",@"Enter Manually",nil];
                    
                    selectedIndex = 1;
                }
				
				
			}
			else {
				
				m_cObjOptions = [[NSArray alloc] initWithObjects:@"WPS Push Button",@"WPS PIN",@"Select an Existing Network",@"Manual configuration",nil];
				
				selectedIndex = 2;
				
			}
			
    }

    return self;

}


#pragma mark -
#pragma mark Table view data source

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
	return 100;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
	return 100;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Select one of the following methods to connect your device to the wireless network.";
	
}// fixed font style. use custom view (UILabel) if you want something different

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
		
		return [self getSectionFooter];

}

-(UIView *)getSectionFooter
{
	UIView *lObjSectionFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
	[lObjSectionFooter setBackgroundColor:[UIColor clearColor]];
	
	UIButton *lObjProceedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[lObjProceedButton setFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 50)];
	[lObjProceedButton addTarget:self action:@selector(Proceed) forControlEvents:UIControlEventTouchUpInside];
	[lObjProceedButton setTitle:@"Next" forState:UIControlStateNormal];
	[lObjSectionFooter addSubview:lObjProceedButton];
	
	return lObjSectionFooter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   	
	return [m_cObjOptions count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if (selectedIndex == indexPath.row) {
		
		cell.accessoryType = UITableViewCellAccessoryCheckmark;

	}
	else {
		
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	
	cell.textLabel.text = [m_cObjOptions objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)Proceed {
	
    if ([m_cObjOptions count]==2)
	{
		[m_cObjDelegate proceedWithSelectedIndex:selectedIndex+2];

	}
	else {
		
		[m_cObjDelegate proceedWithSelectedIndex:selectedIndex];

	}

}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
	
	if (m_cObjOptions.count == 2) {
	
		selectedIndex = indexPath.row;
		
    }
	else {
		
		selectedIndex = indexPath.row;
		
	}
	
	[tableView reloadData];
}






@end
