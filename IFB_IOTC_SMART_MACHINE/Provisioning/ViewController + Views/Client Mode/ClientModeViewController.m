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
 * $RCSfile: ClientModeViewController.m,v $
 *
 * Description : Header file for ClientModeViewController functions and data structures
 *******************************************************************************/

#import "ClientModeViewController.h"
#import "InfoScreen.h"
#import <QuartzCore/QuartzCore.h>
#import "Options.h"
#import "GS_ADK_Data.h"
#import "Identifiers.h"
#import "APListViewController.h"
#import "GS_ADK_DataManger.h"
#import "UniversalParser.h"
#import "PostPin.h"
#import "PostPush.h"
#import "ManualClientModeConfig.h"
#import "UINavigationBar+TintColor.h"
#import "ResetFrame.h"
#import "WPSPINTextView.h"

#import "ModeController.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"
#import "GSNavigationBar.h"

@interface ClientModeViewController (privateMethods)<CustomUIAlertViewDelegate> //PostPinDelegate

-(void)parsingDone;
-(void)addOptionTable;
-(void)allocConnectionManagerWithURLStrings:(NSArray *)pObjURLs;
-(void)hideActivityIndicator;
-(void)checkAPIVersion;
-(void)postPush;
-(void)postPin:(NSString *)pObjPin;

@end


@implementation ClientModeViewController

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
            
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
   // self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    [self setUI];
}


#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewVC)];
    self.navigationItem.leftBarButtonItem = barBtnItem;
}

-(void)popviewVC {
    [self.navigationController popViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
    self.navigationController.navigationBarHidden = YES;
    
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	m_cObjUniversalParser = (UniversalParser *)[[UniversalParser alloc] init];
	
	m_cObjProvData = [[GS_ADK_DataManger alloc] init];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

    
    globalValues.provisionSharedDelegate.appRunningInBackground = NO;
	
   
	if ([[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] != nil || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@""]) {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
		
	}
	else {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
        
	}
    
    self.navigationBar.title = @" ";
	
	[self addOptionTable];
	
	//[self checkAPIVersion];
    
    m_cObjKeyboardRemoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[m_cObjKeyboardRemoverButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
	[m_cObjKeyboardRemoverButton addTarget:self action:@selector(resignKeyPad) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:m_cObjKeyboardRemoverButton];
}



-(void)checkAPIVersion{
    
	NSArray *lObjCurrentVersion = [[[[sharedGsData apiVersion] objectForKey:@"version"] objectForKey:@"text"] componentsSeparatedByString:@"."];
	
	if ([lObjCurrentVersion count] == 0) {
		
		return;
	}
	
	NSArray *lObjSupportedVersion = [SUPPORTED_API_VERSION componentsSeparatedByString:@"."];
	
	for (int i = 0; i < [lObjCurrentVersion count]-1; i++) {
				
		if ([[lObjCurrentVersion objectAtIndex:i] intValue] > [[lObjSupportedVersion objectAtIndex:i] intValue]) {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Current API version exceeds the supported API version" message:@"The App may not work properly" confirmationData:[NSDictionary dictionary]];
            info.cancelButtonTitle = @" OK ";
            info.otherButtonTitle = nil;
            
            m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            
            [m_cObjAlertView show];
            
			
		}
	}
	
}

-(void)addOptionTable {
	
	Options *m_cObjOptionsTable = [[Options alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
	m_cObjOptionsTable.m_cObjDelegate = self;
	[self.view addSubview:m_cObjOptionsTable];
}

-(void)showInfo
{
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
    [self presentViewController:lObjInfoScreen animated:YES completion:nil];
}

-(void)proceedWithSelectedIndex:(NSInteger)selectedIndex {
    
	if (selectedIndex == MANUAL_MODE) {
		
		m_cObjManualConfigScreen = [[ManualClientModeConfig alloc] initWithControllerType:1];
        m_cObjManualConfigScreen.navigationItem.hidesBackButton = YES;
        
		[self.navigationController pushViewController:m_cObjManualConfigScreen animated:YES];
	}
	else if (selectedIndex == SCAN_MODE) {
		
		[self allocConnectionManagerWithURLStrings:[NSArray arrayWithObjects:[NSString stringWithFormat:GSPROV_GET_URL_AP_LIST,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],nil]];
        
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"" message:@"Please wait while we look for nearby access points" confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"Cancel";
        info.otherButtonTitle = nil;
        
        m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleActivityIndicator delegate:self];
        
        [m_cObjAlertView setTag:102];
        
        [m_cObjAlertView show];
        
        
	}
	else if (selectedIndex == 0) {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Locate the WPS button on your AP.  Click on the “PUSH” button below.  Press the WPS button on your AP within 2 minutes." message:@"Please wait while we look for nearby access points" confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"PUSH";
        info.otherButtonTitle = @"Cancel";
        
        m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
        
        [m_cObjAlertView setTag:103];
        
        [m_cObjAlertView show];
        
        
	}
	else if (selectedIndex == 1){
        
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Please enter PIN " message:@"Enter the WPS PIN below. Click on “PIN” to initiate WPS Provisioning." confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"PIN";
        info.otherButtonTitle = @"Cancel";
        
       GSUIAlertView *lObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleConfirmation delegate:self];
        
        [lObjAlertView setTag:104];
        
        [lObjAlertView setContentViewHeight:70];
        
        m_cObjTextView = [[WPSPINTextView alloc] initWithFrame:CGRectMake(0, 10,250, 30)delegate:self];
        
        [lObjAlertView.contentView addSubview:m_cObjTextView];
        
        
        [lObjAlertView show];
        
		
	}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    m_cObjKeyboardRemoverButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-70,[UIScreen mainScreen].bounds.size.height+100, 60, 30);

    [textField resignFirstResponder];

    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.view bringSubviewToFront:m_cObjKeyboardRemoverButton];
    
    [UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
    
    [UIView commitAnimations];
    
    return YES;
}


-(void)resignKeyPad
{
	 [self.view endEditing:YES];
	
    [UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
    
    [ResetFrame resignKeyPad:m_cObjKeyboardRemoverButton ChannelPicker:Nil SecurityPicker:nil andTableView:nil];
    
	[UIView commitAnimations];
	
}

#pragma mark - GS_ADK_ConnectionManager Delegate Methods

-(void)allocConnectionManagerWithURLStrings:(NSArray *)pObjURLs
{
	
	m_cObjConnectionManager = [[GS_ADK_ConnectionManager alloc] init];
	
	[m_cObjConnectionManager setM_cObjDelegate:self];
	
	[m_cObjConnectionManager connectWithURLStrings:pObjURLs autoUpdate:NO updateInterval:4.0];
	
}

-(void)connection:(GSConnection *)pObjConnection didReceiveResponse:(NSURLResponse *)pObjResponse
{
    if ([pObjConnection.m_cObjTag isEqualToString:[NSString stringWithFormat:GSPROV_GET_URL_AP_LIST,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]]) {
        
        _saveConnectionObject = pObjConnection;
    
    }
}

-(void)connection:(GSConnection *)pObjConnection endedWithData:(NSData *)pObjData
{
	
	if ([pObjData length] != 0) {
		
		NSMutableDictionary *myReleventData = [m_cObjProvData processData:pObjData withParser:m_cObjUniversalParser];
		
		[sharedGsData setData:myReleventData];
		
	}
	else {
		
		//NSLog(@"%@ : did not respond",pObjConnectionTag);
	}
	
	[self parsingDone];
	
}

-(void)connectionFailed:(GSConnection *)pObjConnection withError:(NSError *)pObjError
{
	
    [self parsingDone];
}

-(void)didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg forConnection:(GSConnection *)pObjConnection
{
    
    NSURLCredential *pObjCredential = [NSURLCredential credentialWithUser:globalValues.provisionSharedDelegate.username password:globalValues.provisionSharedDelegate.password persistence:NSURLCredentialPersistenceForSession];
    
    [m_cObjConnectionManager proceedWithCredential:pObjCredential forChallenge:pObjChg forConnection:pObjConnection];
    
}

-(void)parsingDone
{
	[self hideActivityIndicator];
	
	APListViewController *lObjAPListController = [[APListViewController alloc] initWithControllerType:1];
	lObjAPListController.m_cObjDelegate = self;
	[self.navigationController pushViewController:lObjAPListController animated:YES];
}

- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 102) {
        
        [m_cObjConnectionManager abortConnection:_saveConnectionObject];
    }
    else if (alertView.tag == 103) {
		
		if (buttonIndex == 0) {
			
			[self postPush];
			
			[alertView dismissWithClickedButtonIndex:0 animated:YES];
            
		}
		else {
			
			[alertView dismissWithClickedButtonIndex:1 animated:YES];
            
		}
        
	}
	else if (alertView.tag == 104) {
		
		if (buttonIndex == 0) {
			
			UITextField *lObjTextField = (UITextField *)[alertView viewWithTag:1001];
			
			if (lObjTextField.text.length == 8)
			{
				[self postPin:lObjTextField.text];
				
                
			}
			else {
                GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"WPS PIN must be a 8 digit value" message:nil confirmationData:[NSDictionary dictionary]];
                info.cancelButtonTitle = @"OK";
                info.otherButtonTitle = nil;
                
               GSUIAlertView *lObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
                
                [lObjAlertView show];
			}
            
			[alertView dismissWithClickedButtonIndex:0 animated:YES];
			
		}
    }
    else if (alertView.tag == 6) {
            
        exit(0);
    }
    else {
        
    }
}



-(void)hideActivityIndicator {
    
    if ([m_cObjAlertView superview]) {
        
        [m_cObjAlertView dismissWithClickedButtonIndex:0 animated:YES];
        
    }
    
}

-(void)postPush {
   
    PostPush *lObjPush = [[PostPush alloc] init];
    [lObjPush pushCompletion:^(ResponseType type, NSDictionary *responseData, NSError *error) {
    
        [self showVerifiedDataWith:type ResponseData:responseData Error:error];
    }];
}

-(void)showVerifiedDataWith:(ResponseType)responseType ResponseData:(NSDictionary *)responseData Error:(NSError *)error {
    
        NSString *lObjMessageString = nil;
        NSString *lObjTitleString = nil;
        
        if (responseType == ResponseTypeSuccess) {
            
            if (responseData != nil && sharedGsData.doesSupportConcurrentMode) {
                
                if ([[[[responseData objectForKey:@"verification"] objectForKey:@"status"] objectForKey:@"text"] isEqualToString:@"success"]) {
                    
                    [self showVerifiedProvisioingData:responseData];
                }
                else {
                    if ([[[[responseData objectForKey:@"verification"] objectForKey:@"reason"]objectForKey:@"text"] length] > 0) {
                        
                        lObjMessageString = [NSString stringWithFormat:@"Error:%@ \n Reason:%@",[self convertErrorCodeToSting:[self errorCode:responseData]],[self errorReason:responseData]];
                    }
                    else {
                        
                        lObjMessageString = [NSString stringWithFormat:@"Error:%@ ",[self convertErrorCodeToSting:[self errorCode:responseData]]];
                        
                    }
                    
                    lObjTitleString =@"Verification Failed";
                    [self showAlertMessage:lObjMessageString WithTitle:lObjTitleString WithForceExit:NO];
                }
            }
            else {
                
                lObjTitleString = @"";
                lObjMessageString = @"The configuration is complete. Your device will connect to the AP through WPS. You may close this application.";
                
                [self showAlertMessage:lObjMessageString WithTitle:lObjTitleString WithForceExit:YES];
            }
            
        }
        else {
            
            [self showAlertForConfigurationNotComplete];
        }
}

-(NSString *)errorReason:(NSDictionary *)lObjDict {
    
    return [[[lObjDict objectForKey:@"verification"] objectForKey:@"reason"]objectForKey:@"text"];
}

-(NSInteger)errorCode:(NSDictionary *)lObjDict {
    
    return [[[[lObjDict objectForKey:@"verification"] objectForKey:@"error_code"]objectForKey:@"text"] integerValue];
}


-(void)showAlertMessage:(NSString *)lObjMessage WithTitle:(NSString *)lObjTitle WithForceExit:(BOOL)lObjExit {
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:lObjTitle message:lObjMessage confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"OK";
    info.otherButtonTitle = nil;
    
    GSUIAlertView *lObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    
    if (lObjExit) {
        
        lObjAlertView.tag = 6;
    }
    [lObjAlertView show];
    
}

-(NSString *)convertErrorCodeToSting:(NSInteger)errorCode {
    
    switch (errorCode) {
        case 1:
            return @"Access Point not found. Please verify the SSID";
            break;
        case 2:
            return @"Failed to connect";
            break;
        case 3:
            return @"Authentication failure. Please verify the password";
            break;
            
        default:
            return @"";
            break;
    }
}

-(void)postPin:(NSString *)pObjPin {
    
    PostPin *lObjPin = [[PostPin alloc] init];
    [lObjPin postPin:pObjPin pushPinCompletion:^(ResponseType type, NSDictionary *responseData, NSError *error) {
    
        [self showVerifiedDataWith:type ResponseData:responseData Error:error];
    
    }];
    
}

-(void)showAlertForConfigurationNotComplete {
    
    UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"The configuration could not be completed complete" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [lObjAlertView show];
}

-(void)showVerifiedProvisioingData:(NSDictionary *)pObjData {
    
              ConcurrentModeInfoViewController  *concurrentInfoController = [[ConcurrentModeInfoViewController alloc] initWithControllerType:4];
                concurrentInfoController.concurrentInfoDict = [NSMutableDictionary dictionaryWithDictionary:pObjData];
                [self.navigationController pushViewController:concurrentInfoController animated:YES];
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
