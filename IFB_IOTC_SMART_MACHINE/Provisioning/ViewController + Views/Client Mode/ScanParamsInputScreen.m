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
 * $RCSfile: ScanParamsInputScreen.m,v $
 *
 * Description : Header file for ScanParamsInputScreen functions and data structures
 *******************************************************************************/

#define PICKER_HEIGHT    216
#define CLOSE_BUTTON_HEIGHT   30
#define CLOSE_BUTTON_WIDTH    60
#define SCREEN_HEIGHT_MARGIN   100


#import "ScanParamsInputScreen.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "Identifiers.h"
#import "InfoScreen.h"
#import "GS_ADK_Data.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomPickerView.h"

@interface ScanParamsInputScreen(privateMethods)

-(void)postScanParameters;
-(void)prepopulateScanParameters;

@end


@implementation ScanParamsInputScreen

@synthesize appDelegate,m_cObjDelegate,sharedGsData,m_cObjKeyboardRemoverButton,m_cObjWaitScreen,m_cObjActivity;
@synthesize m_cObjTextFieldValues,m_cObjConfigLabels,m_cObjPickerContentArray,scanParameters;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.



- (void)navigationItemTapped:(NavigationItem)item
{
    
    switch (item) {
            
        case NavigationItemBack:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case NavigationItemCancel:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case NavigationItemDone:
            
            [self settingsDone];
            
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

#define CHANNEL_VIEW_WIDTH          300
#define CHANNEL_VIEW_HEIGHT         44
#define CHANNEL_VIEW_Y_AXIS         78
#define CHANNEL_VIEW_X_AXIS         10

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;

    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
    sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];

	appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	m_cObjTextFieldValues = [[NSMutableArray alloc] initWithObjects:@"",@"",nil];
	
  
    [self checkForRegDomain];
    
	
	UIView *lObjView = [[UIView alloc] initWithFrame:CGRectMake(CHANNEL_VIEW_X_AXIS, CHANNEL_VIEW_Y_AXIS, CHANNEL_VIEW_WIDTH, CHANNEL_VIEW_HEIGHT)];
	lObjView.tag = 1;
	[lObjView setBackgroundColor:[UIColor whiteColor]];
	[lObjView.layer setCornerRadius:8.0];
	[lObjView.layer setBorderWidth:1];
	[lObjView.layer setBorderColor:[[UIColor clearColor] CGColor]];	
	[self.view addSubview:lObjView];
	
	UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 44)];
	lObjLabel.tag = 11;
	[lObjLabel setBackgroundColor:[UIColor clearColor]];
	[lObjLabel setText:@"Channel     :"];
	[lObjLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[lObjLabel setTextColor:[UIColor grayColor]];
	[lObjView addSubview:lObjLabel];

	lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 44)];
	lObjLabel.tag = 12;
	[lObjLabel setBackgroundColor:[UIColor clearColor]];
	[lObjLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[lObjLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	[lObjView addSubview:lObjLabel];

    if ([[[[[sharedGsData scanParameterDict] objectForKey:@"scan_params"] objectForKey:@"channel"]objectForKey:@"text"] isEqualToString:@"0"])
    {
        [lObjLabel setText:@"All"];
        
    }
    else
    {
        [lObjLabel setText:[NSString stringWithFormat:@"%@",[[[[sharedGsData scanParameterDict] objectForKey:@"scan_params"] objectForKey:@"channel"]objectForKey:@"text"]]];
        
    }
    
    
    
	
	UIButton *lObjButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[lObjButton setFrame:CGRectMake(100, 0, 200, 44)];
	[lObjButton addTarget:self action:@selector(bringUpChannelSelector) forControlEvents:UIControlEventTouchUpInside];
	[lObjView addSubview:lObjButton];
	
	lObjView = [[UIView alloc] initWithFrame:CGRectMake(10, 88 + 44 +10, 300, 44)];
	lObjView.tag = 2;
	[lObjView setBackgroundColor:[UIColor whiteColor]];
	[lObjView.layer setCornerRadius:8.0];
	[lObjView.layer setBorderWidth:1];
	[lObjView.layer setBorderColor:[[UIColor clearColor] CGColor]];		
	[self.view addSubview:lObjView];

	lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 44)];
	lObjLabel.tag = 21;
	[lObjLabel setBackgroundColor:[UIColor clearColor]];
	[lObjLabel setText:@"Scan Time :"];
	[lObjLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[lObjLabel setTextColor:[UIColor grayColor]];
	[lObjView addSubview:lObjLabel];
	
	UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 200, 44)];
	lObjTextField.tag = 22;
	[lObjTextField setKeyboardType:UIKeyboardTypeNumberPad];
	lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[lObjTextField setFont:[UIFont boldSystemFontOfSize:12]];
	[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
    [lObjTextField setText:[NSString stringWithFormat:@"%@",[[[[sharedGsData scanParameterDict] objectForKey:@"scan_params"] objectForKey:@"scan_time"]objectForKey:@"text"]]];
	lObjTextField.delegate = self;
	[lObjView addSubview:lObjTextField];
	

    m_cObjChannelPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + SCREEN_HEIGHT_MARGIN, [UIScreen mainScreen].bounds.size.width, PICKER_HEIGHT) delegate:self withTag:3001];
    m_cObjChannelPicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_cObjChannelPicker];

	
	m_cObjKeyboardRemoverButton= [UIButton buttonWithType:UIButtonTypeCustom];
	[m_cObjKeyboardRemoverButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
    [m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - CLOSE_BUTTON_WIDTH,[UIScreen mainScreen].bounds.size.height + SCREEN_HEIGHT_MARGIN, CLOSE_BUTTON_WIDTH, CLOSE_BUTTON_HEIGHT)];
	[m_cObjKeyboardRemoverButton addTarget:self action:@selector(resignKeyPad) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:m_cObjKeyboardRemoverButton];
	
}



-(void)showInfo
{
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
    [self presentViewController:lObjInfoScreen animated:YES completion:nil];
}

-(void)resignKeyPad
{
	
    UITextField *lObjTextField = (UITextField *)[(UIView *)[self.view viewWithTag:2] viewWithTag:22];
			
	[lObjTextField resignFirstResponder];

	
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
	
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - CLOSE_BUTTON_WIDTH, [UIScreen mainScreen].bounds.size.height + SCREEN_HEIGHT_MARGIN, CLOSE_BUTTON_WIDTH, CLOSE_BUTTON_HEIGHT)];
	
	[m_cObjChannelPicker setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + SCREEN_HEIGHT_MARGIN, [UIScreen mainScreen].bounds.size.width, PICKER_HEIGHT)];
		
	[UIView commitAnimations];
	
}

-(void)goBackToPriousPage
{
	[m_cObjDelegate dismissScanParamScreen];
	
}
-(void)dismissScanParamScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)checkForRegDomain {
    
    if([[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"reg_domain"] objectForKey:@"text"] isEqualToString:@"fcc"])
    {
        m_cObjPickerContentArray = [[NSArray alloc]initWithObjects:@"All",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",nil];
        
    }
    else if ([[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"reg_domain"] objectForKey:@"text"] isEqualToString:@"etsi"])
    {
        m_cObjPickerContentArray = [[NSArray alloc]initWithObjects:@"All",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",nil];
        
    }
    else 
    {
        m_cObjPickerContentArray = [[NSArray alloc]initWithObjects:@"All",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",nil];
    }
    
}
-(void)settingsDone
{
	
	GSAlertInfo *info = [GSAlertInfo infoWithTitle:nil message:@"Please wait while the changes take effect" confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = nil;
    info.otherButtonTitle = nil;
    
   m_cObjWaitScreen = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleActivityIndicator delegate:self];
        m_cObjWaitScreen.tag=301;
		m_cObjWaitScreen.delegate = self;
		[m_cObjWaitScreen show];

	
	[self postScanParameters];
}

-(void)postScanParameters
{

	UILabel *lObjLabel = (UILabel *)[(UIView *)[self.view viewWithTag:1] viewWithTag:12];
	
	UITextField *lObjTextField = (UITextField *)[(UIView *)[self.view viewWithTag:2] viewWithTag:22];
	
	NSString *channelNo;
	
	if (lObjLabel.text == nil) {
		
		channelNo = @"";
		
	}
	else if ([lObjLabel.text isEqualToString:@"All"]){
		
		channelNo = @"0";
		
	}
	else {
		
		channelNo = [NSString stringWithString:lObjLabel.text];
	}

	
	[scanParameters replaceObjectAtIndex:0 withObject:channelNo];
	
	NSString *timeInterval;

	if (lObjTextField.text == nil) 
    {
		timeInterval = @"";

	}
	else {
		
		timeInterval = [NSString stringWithString:lObjTextField.text];

	}

	[scanParameters replaceObjectAtIndex:1 withObject:timeInterval];

	
	NSString *xmlString = [NSString stringWithFormat:@"<scan_params><channel>%@</channel><scan_time>%@</scan_time></scan_params>",channelNo,timeInterval];
	
	//NSLog(@"posted url  %@",xmlString);
  	
	NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_GET_URL_SCAN_PARAMS_URL,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
	
	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
	
	[serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
		
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
	NSLog(@"<<<<<<<<<<<  ScanParamsInputScreen   >>>>>>>>>>");
	
    [m_cObjDelegate refresh];
	
    [m_cObjWaitScreen dismissWithClickedButtonIndex:0 animated:YES];
    
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Scan Parameters have been Successfully changed" message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"OK";
    info.otherButtonTitle = nil;
    
    GSUIAlertView *m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    m_cObjAlertView.tag=101;
	m_cObjAlertView.delegate = self;
	[m_cObjAlertView show];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	
    [m_cObjWaitScreen dismissWithClickedButtonIndex:0 animated:YES];
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Scan Parameters could not be changed" message:[error localizedDescription] confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"OK";
    info.otherButtonTitle = nil;
    
    GSUIAlertView *m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    m_cObjAlertView.tag=102;
	m_cObjAlertView.delegate = self;
	[m_cObjAlertView show];
	
}

- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (alertView.tag == 101) {
		
		[self goBackToPriousPage];
		
	}
	else if (alertView.tag == 301){
		
		[alertView dismissWithClickedButtonIndex:0 animated:YES];
	}

	
}



-(void)bringUpChannelSelector
{	
	UITextField *lObjTextField = (UITextField *)[(UIView *)[self.view viewWithTag:2] viewWithTag:22];
	
	[lObjTextField resignFirstResponder];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
    
    [m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - CLOSE_BUTTON_WIDTH, [UIScreen mainScreen].bounds.size.height - PICKER_HEIGHT - CLOSE_BUTTON_HEIGHT, CLOSE_BUTTON_WIDTH, CLOSE_BUTTON_HEIGHT)];

	[m_cObjChannelPicker setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - PICKER_HEIGHT, [UIScreen mainScreen].bounds.size.width, PICKER_HEIGHT)];
	
	[UIView commitAnimations];

	
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
	
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - CLOSE_BUTTON_WIDTH, [UIScreen mainScreen].bounds.size.height - PICKER_HEIGHT - CLOSE_BUTTON_HEIGHT, CLOSE_BUTTON_WIDTH, CLOSE_BUTTON_HEIGHT)];
	
	[UIView commitAnimations];
			
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
    
    [[[[sharedGsData scanParameterDict] objectForKey:@"scan_params"] objectForKey:@"scan_time"] setValue:lObjCurrentString forKey:@"text"];     
    [(UITextField *)[(UIView *)[self.view viewWithTag:1] viewWithTag:22] setText:[NSString stringWithFormat:@"%@",[[[[sharedGsData scanParameterDict] objectForKey:@"scan_params"] objectForKey:@"scan_time"]objectForKey:@"text"]]];

	return YES;
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
	
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - CLOSE_BUTTON_WIDTH,[UIScreen mainScreen].bounds.size.height + 100, CLOSE_BUTTON_WIDTH, CLOSE_BUTTON_HEIGHT)];
	
	[UIView commitAnimations];
	
	[textField resignFirstResponder];
	
	return YES;

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}


#pragma UIPickerView Delegate && DataSource Mathods

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
    
  //  sharedGsData.channelDataFromScanParameter = [NSString stringWithFormat:@"%d",row];
	if (row!=0)
    {
        [[[[sharedGsData scanParameterDict] objectForKey:@"scan_params"] objectForKey:@"channel"] setValue:[NSString stringWithFormat:@"%zd",row] forKey:@"text"];
        [(UILabel *)[(UIView *)[self.view viewWithTag:1] viewWithTag:12] setText:[NSString stringWithFormat:@"%@",[[[[sharedGsData scanParameterDict] objectForKey:@"scan_params"] objectForKey:@"channel"]objectForKey:@"text"]]];


    }
    else
    {
        [[[[sharedGsData scanParameterDict] objectForKey:@"scan_params"] objectForKey:@"channel"] setValue:@"All" forKey:@"text"];    
        [(UILabel *)[(UIView *)[self.view viewWithTag:1] viewWithTag:12] setText:[NSString stringWithFormat:@"%@",[[[[sharedGsData scanParameterDict] objectForKey:@"scan_params"] objectForKey:@"channel"]objectForKey:@"text"]]];
    

    }
   
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
