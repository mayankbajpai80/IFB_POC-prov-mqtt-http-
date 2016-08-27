    //
//  APInfoViewController.m
//  Provisioning
//
//  Created by Saurabh Kumar on 4/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "APInfoViewController.h"
#import "InfoScreen.h"
#import <QuartzCore/QuartzCore.h>
#import "GS_ADK_Data.h"
#import "Identifiers.h"
#import "UINavigationBar+TintColor.h"
#import "ResetFrame.h"

#import "ModeController.h"


@interface APInfoViewController (privateMethods)<UITextFieldDelegate>

-(void)addTable;

@end

@implementation APInfoViewController

@synthesize index;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void)viewWillAppear:(BOOL)animated
{
	
	//lObjNavBar.hidden = NO;
	
	//[appDelegate deallocListData];
}

-(void)viewDidDisappear:(BOOL)animated
{
	
	//lObjNavBar.hidden = YES;
	
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
            
        default:
            break;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
	
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
	
    appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
		
	if ([[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] != nil || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@""]) {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
		
	}
	else {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
        
	}
    
	[self addTable];
	
}

-(void)addTable {
	
	m_cObjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
	[m_cObjTableView setDataSource:self];
	[m_cObjTableView setDelegate:self];
	[self.view addSubview:m_cObjTableView];

}


#pragma mark -
#pragma mark Table view data source

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
	
    return 100;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
	
}// fixed font style. use custom view (UILabel) if you want something different


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   	
	return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
    
	UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 110, 44)];
	[lObjLabel setBackgroundColor:[UIColor clearColor]];
	[lObjLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
	[lObjLabel setFont:[UIFont systemFontOfSize:12]];
	[lObjLabel setTextColor:[UIColor grayColor]];
	[cell.contentView addSubview:lObjLabel];
	
    UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 160, 44)];
    lObjTextField.delegate=self;
	[lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[lObjTextField setTextAlignment:NSTextAlignmentRight];
	[lObjTextField setFont:[UIFont systemFontOfSize:16]];
	[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	[lObjTextField setBackgroundColor:[UIColor clearColor]];
	[lObjTextField setReturnKeyType:UIReturnKeyDefault];
	[cell.contentView addSubview:lObjTextField];
		
	
	
	if(indexPath.row==0)
	{
		lObjLabel.text=@"SSID";
        
        if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
        {
            
            if ([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:index] objectForKey:@"ssid"] objectForKey:@"text"]) {
                
                [lObjTextField setText:[NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:index] objectForKey:@"ssid"] objectForKey:@"text"]]];

            }
            else{
            
                [lObjTextField setText:@""];

            }
            
        }
        else {
        
        
            if ([[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]) {
                
                [lObjTextField setText:[NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]]];
                
            }
            else{
                
                [lObjTextField setText:@""];
                
            }

        }
        
	}
	else if(indexPath.row==1)
	{
		lObjLabel.text=@"Security";
        
        if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
        {
            [lObjTextField setText:[NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:index] objectForKey:@"security"] objectForKey:@"text"]]];
        }
        else {
            [lObjTextField setText:[NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"]]];
        }
	}
	if(indexPath.row==2)
	{
		lObjLabel.text=@"Channel";
        if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
        {
            [lObjTextField setText:[NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:index] objectForKey:@"channel"] objectForKey:@"text"]]];
        }
        else {
            [lObjTextField setText:[NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"channel"] objectForKey:@"text"]]];

        }
	}
    
    return cell;
}


-(void)showInfo
{
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
	[self presentViewController:lObjInfoScreen animated:YES completion:nil];
}


-(void)goBackToPriviousPage
{
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {              // called when 'return' key pressed. return NO to ignore.

    return [textField resignFirstResponder];
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
