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
 * $RCSfile: APSettingsViewController.m,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import "APSettingsViewController.h"
#import "InfoScreen.h"
#import "GS_ADK_Data.h"
#import "Identifiers.h"
#import "UINavigationBar+TintColor.h"
#import "ResetFrame.h"
#import "UITableView+SpecificFrame.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"

#import "GSNavigationBar.h"
 #import "ModeController.h"

@interface APSettingsViewController (privateMethods)<CustomUIAlertViewDelegate>

-(void)applyChanges;
-(NSString *)getSystemName;
//-(NSString *)getUUID;
-(NSString *)getUsername;
-(NSString *)getPassword;
-(void)segmentedControlIndexChanged;
-(void)postChangedPasswordToServer;
-(void)disableSecurity;
-(BOOL)checkForEmptyFields;
-(BOOL)confirmPasswordChange;
-(void)postSystemIdentification;

@end


@implementation APSettingsViewController

@synthesize sharedGsData,m_cObjSegControl,lObjTableView,m_cObjSecurityWarningLabel;
@synthesize m_cObjInputLabels,postDone;

-(void)viewWillAppear:(BOOL)animated
{
	
	////lObjNavBar.hidden = NO;
	
	//[appDelegate deallocListData];
}

-(void)viewDidDisappear:(BOOL)animated
{
	
	////lObjNavBar.hidden = YES;
	
}
//-(void)goBackToPriousPage
//{
//	
//	[self.navigationController popViewControllerAnimated:YES];
//}

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
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
	
	//appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    if ([[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] != nil || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@""]) {

        self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
    }
    
    self.navigationBar.title = @"Web-Server Settings";
    
    statusBar_Height = [ResetFrame returnStatusBarHeightForIOS_7];
	
	
	m_cObjInputLabels = [[NSArray alloc] initWithObjects:@"Username                  :",@"Password                   :",@"Confirm Password     :",nil];
	

        
    lObjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88-50, 320, 460-44-22) style:UITableViewStyleGrouped];
	[lObjTableView setDataSource:self];
	[lObjTableView setDelegate:self];
	[self.view addSubview:lObjTableView];
	
	m_cObjSecurityWarningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+330, 88, 320, 220-30)];
	[m_cObjSecurityWarningLabel setBackgroundColor:[UIColor clearColor]];
	[m_cObjSecurityWarningLabel setTextAlignment:NSTextAlignmentCenter];
	[m_cObjSecurityWarningLabel setNumberOfLines:10];
	
	if (m_cObjSegControl.selectedSegmentIndex == 1) {
		
		[m_cObjSecurityWarningLabel setTextColor:[UIColor clearColor]];
		
	}
	else {
		[m_cObjSecurityWarningLabel setTextColor:[UIColor darkGrayColor]];
	}
	
	
	[m_cObjSecurityWarningLabel setText:@"Confirm to disable security"];
	[m_cObjSecurityWarningLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[self.view addSubview:m_cObjSecurityWarningLabel];
	
	
	m_cObjConfirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[m_cObjConfirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
	[m_cObjConfirmButton addTarget:self action:@selector(confirmChange) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:m_cObjConfirmButton];
    
    
    NSMutableArray *lObjArray = [[NSMutableArray alloc] init];
	
	NSString *lObjString = @"Enable Authentication";
	[lObjArray addObject:lObjString];
    
	lObjString = @"Disable Authentication";
	[lObjArray addObject:@"Disable Authentication"];
	
	m_cObjSegControl = [[UISegmentedControl alloc] initWithItems:lObjArray];
    
	//m_cObjSegControl.segmentedControlStyle = UISegmentedControlStyleBar;
	//m_cObjSegControl.frame = CGRectMake(5, 11+22-6+statusBar_Height, 320 - 10, CELL_HEIGHT);
	m_cObjSegControl.frame = CGRectMake(5, STATUS_BAR_HEIGHT+5, [UIScreen mainScreen].bounds.size.width - 10, CELL_HEIGHT);
	m_cObjSegControl.selectedSegmentIndex = 1;
	[m_cObjSegControl setEnabled:YES forSegmentAtIndex:1];
	[m_cObjSegControl addTarget:self action:@selector(segmentedControlIndexChanged) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:m_cObjSegControl];
	
    
    if (![[[[[sharedGsData adminSettings] objectForKey:@"httpd"]objectForKey:@"username"] objectForKey:@"text"] isEqualToString:@""] && ![[[[[sharedGsData adminSettings] objectForKey:@"httpd"]objectForKey:@"username"] objectForKey:@"text"] isEqualToString:@""]) {
        
        m_cObjSegControl.selectedSegmentIndex = 0;
        
        [m_cObjSegControl setEnabled:YES forSegmentAtIndex:0];
        
    }
	
    [self setFrameForDifferentIOS];
	
	[self segmentedControlIndexChanged];
	
}


-(void)setFrameForDifferentIOS {
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
         [lObjTableView setFrame:CGRectMake(0, 88-15, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-22)];
        
        m_cObjSegControl.frame = CGRectMake(5, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT+MARGIN_BETWEEN_CELLS, [UIScreen mainScreen].bounds.size.width - MARGIN_BETWEEN_CELLS, CELL_HEIGHT);
        
        m_cObjConfirmButton.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height-TAB_BAR_HEIGHT-CELL_HEIGHT-40, 280+20, 46);
        
        
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [lObjTableView setFrame:CGRectMake(0, 88-25, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-22)];
        
        m_cObjSegControl.frame = CGRectMake(5, STATUS_BAR_HEIGHT+70, [UIScreen mainScreen].bounds.size.width - 10, CELL_HEIGHT);
        
        m_cObjConfirmButton.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height-TAB_BAR_HEIGHT-CELL_HEIGHT, 280+20, 46);
        
        
    }
    
}

-(void)showInfo {
	
    InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
    [self presentViewController:lObjInfoScreen animated:YES completion:nil];
}

-(void)switchToggled:(id)sender {
	
	UISwitch *lObjSwitch = (UISwitch *)sender;
	
	UITableViewCell *cell_1 = (UITableViewCell *)[lObjTableView viewWithTag:2];
	UITextField *lObTextField_1 = (UITextField *)[cell_1.contentView viewWithTag:2];
	
	UITableViewCell *cell_2 = (UITableViewCell *)[lObjTableView viewWithTag:3];
	UITextField *lObTextField_2 = (UITextField *)[cell_2.contentView viewWithTag:3];
	
	if (lObjSwitch.on) {
		
		[lObTextField_1 setSecureTextEntry:NO];
		[lObTextField_2 setSecureTextEntry:NO];
	}
	else {
		
		[lObTextField_1 setSecureTextEntry:YES];
		[lObTextField_2 setSecureTextEntry:YES];
		
	}
	
}

-(void)confirmChange {
    
	switch (m_cObjSegControl.selectedSegmentIndex) {
			
		case 0:
            
			if ([self checkForEmptyFields] == YES && [self confirmPasswordChange] == YES && [self checkForTextFieldLength] ==YES)
			{
				if([[self getUsername] length] > 3 && [[self getPassword] length] > 3)
				{
                    
                    [self postChangedPasswordToServer];
                    
				}
				else
				{
                    
                    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Warning" message:@"Username and Password length must be geater than 3" confirmationData:[NSDictionary dictionary]];
                    info.cancelButtonTitle = @"OK";
                    info.otherButtonTitle = nil;
                    
                    GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
                    [lObjAlert show];
					
					for (int i = 1; i <= 3; i++)
					{
						UITableViewCell *cell = (UITableViewCell *)[lObjTableView viewWithTag:i];
						UITextField *lObTextField = (UITextField *)[cell.contentView viewWithTag:i];
						lObTextField.text=@"";
					}
                    
				}
                
			}
			
			
			
			break;
		case 1:

			[self disableSecurity];
			
			break;
			
		default:
			break;
			
	}
	
}

-(void)postChangedPasswordToServer {
    
	NSMutableString * xmlString = [[NSMutableString alloc] init];
	
	[xmlString appendString:@"<httpd>"];
	[xmlString appendFormat:@"<username>%@</username>",[self getUsername]];
	[xmlString appendFormat:@"<password>%@</password>",[self getPassword]];
	[xmlString appendString:@"<port></port>"];
	[xmlString appendString:@"</httpd>"];
	
    //NSLog(@"POST xml : %@",xmlString);
    
	NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_GET_ADMIN_SETTINGS,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
	
	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
	
	[serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
	[serviceRequest setHTTPMethod:@"POST"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
    
	[NSURLConnection connectionWithRequest:serviceRequest delegate:self];
	
}

-(void)disableSecurity {
    
	NSMutableString * xmlString = [[NSMutableString alloc] init];
	
	[xmlString appendString:@"<httpd>"];
	[xmlString appendString:@"<username></username>"];
	[xmlString appendString:@"<password></password>"];
	[xmlString appendString:@"<port></port>"];
	[xmlString appendString:@"</httpd>"];
		
	NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_GET_ADMIN_SETTINGS,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
	
	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
	
	[serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
	[serviceRequest setHTTPMethod:@"POST"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
    
	[NSURLConnection connectionWithRequest:serviceRequest delegate:self];
	
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
    //////NSLog(@"didReceiveResponse");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	//////NSLog(@"did recieve data");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Configuration Saved" message:@"Would you like to apply the new settings now?" confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"Later";
    info.otherButtonTitle = @"Apply";
    
    GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    lObjAlert.tag = 101;
    lObjAlert.delegate=self;
    [lObjAlert show];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Changes could not be Saved" message:[error localizedDescription] confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"OK";
    info.otherButtonTitle = nil;
    
    GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    [lObjAlert show];
	
}

-(void)postSystemIdentification
{
	NSMutableString * xmlString = [[NSMutableString alloc] init];
	
    [xmlString appendString:@"<id>"];
    [xmlString appendFormat:@"<name>%@</name>",[self getSystemName]];
//    [xmlString appendFormat:@"<uid>%@</uid>",[self getUUID]];
    [xmlString appendString:@"</id>"];
	
	//////NSLog(@"post xml : %@",xmlString);
	
	NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_GET_URL_ID,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
	
	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
	
	[serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
	[serviceRequest setHTTPMethod:@"POST"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
	
	[NSURLConnection connectionWithRequest:serviceRequest delegate:self];
	
}

-(NSString *)getSystemName {
    
	UITextField *lObjTextField = (UITextField *)[self.view viewWithTag:4];
	
	if (lObjTextField.text != nil || (lObjTextField.text.length > 0)) {
		
		return lObjTextField.text;
	}
	else {
		
		return @"";
	}
	
}

//-(NSString *)getUUID
//{
//	
//	NSString *lObjUDID_Str = [[UIDevice currentDevice] uniqueIdentifier];
//	
//	if (lObjUDID_Str == nil) {
//		
//		return @"";
//	}
//	else {
//		return lObjUDID_Str;
//	}
//	
//}

-(NSString *)getUsername
{
   	UITableViewCell *cell = (UITableViewCell *)[lObjTableView viewWithTag:1];
	
	UITextField *lObTextField = (UITextField *)[cell.contentView viewWithTag:1];
	
	return lObTextField.text;
}

-(NSString *)getPassword {
    
	UITableViewCell *cell = (UITableViewCell *)[lObjTableView viewWithTag:2];
	
	UITextField *lObTextField = (UITextField *)[cell.contentView viewWithTag:2];
	
	return lObTextField.text;
}

- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (alertView.tag == 101) {
		
		if (buttonIndex == 0) {
			
			[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
			
		}
		else {
			
			[self applyChanges];
			
		}
	}
	
}

-(void)applyChanges {
    
    int currentMode;
    
    if ([[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"Limited AP"] || [[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"limited-ap"]) {
        
        currentMode = 1;
    }
    else {
        currentMode = 0;
    }
    
    [globalValues.provisionSharedDelegate setMode:currentMode];
    
}

-(BOOL)checkForEmptyFields {
	
	for (int i = 1; i <= 3; i++) {
		
		UITableViewCell *cell = (UITableViewCell *)[lObjTableView viewWithTag:i];
		
		UITextField *lObTextField = (UITextField *)[cell.contentView viewWithTag:i];
		
		if ([lObTextField.text isEqualToString:@""] || lObTextField.text == nil) {
            
			checkForEmptyFields=YES;
		}
	}
	
	if(checkForEmptyFields==YES)
	{
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Fill up all the fields to continue" message:nil confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
        [lObjFieldValidation show];
		
		checkForEmptyFields=NO;
		
		return NO;
		
	}
	
	return YES;
}

-(BOOL)confirmPasswordChange
{
	
	UITableViewCell *cell_1 = (UITableViewCell *)[lObjTableView viewWithTag:2];
	UITableViewCell *cell_2 = (UITableViewCell *)[lObjTableView viewWithTag:3];
	
	UITextField *lObTextField_1 = (UITextField *)[cell_1.contentView viewWithTag:2];
	UITextField *lObTextField_2 = (UITextField *)[cell_2.contentView viewWithTag:3];
	
	if ([lObTextField_1.text isEqualToString:lObTextField_2.text]) {
		
		return YES;
	}
	else {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Password change could not be confirmed" message:nil confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"Try Again";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
        [lObjFieldValidation show];
		
		return NO;
	}
	
}


-(BOOL)checkForTextFieldLength {
    
    UITableViewCell *cell_0 = (UITableViewCell *)[lObjTableView viewWithTag:1];
    UITableViewCell *cell_1 = (UITableViewCell *)[lObjTableView viewWithTag:2];
	UITableViewCell *cell_2 = (UITableViewCell *)[lObjTableView viewWithTag:3];
    
    UITextField *lObTextField_0 = (UITextField *)[cell_0.contentView viewWithTag:1];
    UITextField *lObTextField_1 = (UITextField *)[cell_1.contentView viewWithTag:2];
	UITextField *lObTextField_2 = (UITextField *)[cell_2.contentView viewWithTag:3];
    
   // NSLog(@"%d = %d = %d",lObTextField_0.text.length, lObTextField_1.text.length, lObTextField_2.text.length);
    
    if ([lObTextField_0.text length]<=16 && [lObTextField_1.text length]<=16 && [lObTextField_2.text length]<=16)
    {
        return YES;
    }
    else
    {
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Username and Password length should not exceed beyond 16 characters." message:nil confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
        
        [lObjFieldValidation show];
        return NO;
    }
}

-(void)segmentedControlIndexChanged {
	
	switch (m_cObjSegControl.selectedSegmentIndex) {
			
		case 0:
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.35];
			[UIView setAnimationDelay:0.35];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                
                [lObjTableView setFrame:CGRectMake(0, 88-15, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-22)];
               
                [m_cObjSecurityWarningLabel setFrame:CGRectMake(0+330, 88, 320, 220-30)];
                
            }
            else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                [lObjTableView setFrame:CGRectMake(0, 88-25, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-22)];
                
                [m_cObjSecurityWarningLabel setFrame:CGRectMake(0+330, 88, 320, 220-30)];

            }
            
			[UIView commitAnimations];
			break;
            
		case 1:
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.35];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
			         
            
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                
                [lObjTableView setFrame:CGRectMake(0-360, 88-15, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-22)];
                [m_cObjSecurityWarningLabel setFrame:CGRectMake(0, 88, 320, 220-30)];

                
            }
            else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                
                [lObjTableView setFrame:CGRectMake(0-360, 88-25, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-22)];

                
                [m_cObjSecurityWarningLabel setFrame:CGRectMake(0, 88, 320, 220-30)];
                
            }
			[UIView commitAnimations];
			break;
			
		default:
			break;
			
	}
	
}





#pragma mark -
#pragma mark Table view data source

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
		cell.tag = indexPath.row+1;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//}
		
		//cell.textLabel.text = @"Server setting";
		
		UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 110+20, 44)];
		[lObjLabel setBackgroundColor:[UIColor clearColor]];
		[lObjLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
		[lObjLabel setText:[m_cObjInputLabels objectAtIndex:indexPath.row]];
		[lObjLabel setFont:[UIFont systemFontOfSize:12]];
		[lObjLabel setTextColor:[UIColor grayColor]];
		[cell.contentView addSubview:lObjLabel];
		
		UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(10+110+5, 0, 165, 44)];
		lObjTextField.tag = indexPath.row+1;
		lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[lObjTextField setTextAlignment:NSTextAlignmentRight];
		[lObjTextField setDelegate:self];
		[lObjTextField setBackgroundColor:[UIColor clearColor]];
		
		
		if ([[m_cObjInputLabels objectAtIndex:indexPath.row] isEqualToString:@"Username                  :"]) {
			
			[lObjTextField setText:[[[[sharedGsData adminSettings] objectForKey:@"httpd"]objectForKey:@"username"] objectForKey:@"text"]];
            
		}
		else {
			
			[lObjTextField setText:[[[[sharedGsData adminSettings] objectForKey:@"httpd"]objectForKey:@"password"] objectForKey:@"text"]];
            
		}
		
		[lObjTextField setFont:[UIFont systemFontOfSize:14]];
		[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
		[lObjTextField setReturnKeyType:UIReturnKeyDefault];
		
		if (indexPath.row != 0 && indexPath.row != 3) {
			[lObjTextField setSecureTextEntry:YES];
		}
		
		[cell.contentView addSubview:lObjTextField];
	}
	return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[m_cObjSegControl setUserInteractionEnabled:NO];
	
	if (textField.tag == 4) {
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		if (m_cObjSegControl.selectedSegmentIndex == 0) {
			
			[lObjTableView setFrame:CGRectMake(0, -480, 320, 480-66)];
		}
		
		[UIView commitAnimations];
	}
	else {
		
		[lObjTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
	}
	
	return YES;
}// return NO to disallow editing.


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 4) {
		
		return YES;
	}
    
	return YES;
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	[m_cObjSegControl setUserInteractionEnabled:YES];
	
	if (textField.tag == 4) {
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		if (m_cObjSegControl.selectedSegmentIndex == 0) {
			
			[lObjTableView setFrame:CGRectMake(0, 88-17-25, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-66)];
			
		}
				
		[UIView commitAnimations];
	}
	else {
				
	}
	[textField resignFirstResponder];
	
    return YES;
    
}
// called when 'return' key pressed. return NO to ignore.

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	
	return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
	return 55.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 100.0;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *lObjFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    [lObjFooterView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *lObjHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 41, 210, 20)];
	lObjHeaderLabel.tag=52;
	lObjHeaderLabel.backgroundColor = [UIColor clearColor];
	[lObjHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
	lObjHeaderLabel.textColor = [UIColor colorWithRed:0.35 green:0.40 blue:0.50 alpha:1];
    lObjHeaderLabel.shadowColor = [UIColor whiteColor];
    lObjHeaderLabel.shadowOffset = CGSizeMake(0, 1);
	lObjHeaderLabel.text = @"Show Password";
	[lObjFooterView addSubview:lObjHeaderLabel];
	
	UISwitch *lObjSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210,35, 100, 20)];
	lObjSwitch.tag=53;
	[lObjSwitch setOn:NO];
	//lObjSwitch.tag = index;
	[lObjSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
	[lObjFooterView addSubview:lObjSwitch];
    
    
    return lObjFooterView;
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
