//
//  ServiceListViewController.m
//  Provisioning
//
//  Created by GainSpan India on 03/02/14.
//
//

#import "ServiceListViewController.h"
#import "Identifiers.h"
#import "AdminSettingsViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "ValidationUtils.h"

#import "GS_ADK_ConnectionManager.h"
#import "GSConnection.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"

@interface ServiceListViewController ()

-(void)initializeServiceBrowser;

@end

@implementation ServiceListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    
     _connectionStatus = NO;
    
    [self initializeServiceBrowser];
    [self setUI];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication]delegate];
        
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    self.navigationItem.title = @"Services ";
    [self addManualEntryButton];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(goToPrevious)];
    self.navigationItem.leftBarButtonItem = barBtnItem;
}

#pragma mark UINavigationItem Button Action
/**
 *  go back to previous view
 */
-(void)goToPrevious {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addManualEntryButton {
    
    UIButton *manualButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [manualButton setBackgroundColor:[UIColor clearColor]];
    [manualButton setFrame:CGRectMake(0, 0, 100, 44)];
    [manualButton setTitle:@"ManualEntry" forState:UIControlStateNormal];
    manualButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [manualButton addTarget:self action:@selector(goToManualEntryPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:manualButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

-(void)goToManualEntryPage {
    
    [self discoveryDidFail];
}


-(void)initializeServiceBrowser {
    
    if (_m_cObjServiceList) {
        
        [_m_cObjServiceList removeFromSuperview];
        _m_cObjServiceList = nil;
    }
	
	_m_cObjServiceList = [[ServiceList alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)withDelegate:self];
	[_m_cObjServiceList setAlpha:0];
	[self.view addSubview:_m_cObjServiceList];
    
    
    if (m_gObjServiceManager) {
        
        m_gObjServiceManager = nil;
    }
	
    //m_gObjServiceManager = [[GS_ADK_ServiceManager alloc] initWithTimeOut:0 namePattern:[NSArray arrayWithObjects:@"gslink_prov",@"prov",@"Prov",nil] textRecordPattern:[NSArray arrayWithObjects:@"gs_sys_prov",nil] serviceType:@"_http._tcp" domainName:@""];
    
    m_gObjServiceManager = [[GS_ADK_ServiceManager alloc] initWithTimeOut:0 namePattern:[NSArray arrayWithObjects:@"IFB",nil] textRecordPattern:[NSArray arrayWithObjects:@"gs_sys_prov",nil] serviceType:@"_http._tcp" domainName:@""];
	[m_gObjServiceManager setM_cObjDelegate:self];
	[m_gObjServiceManager startDiscovery];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	
	[_m_cObjServiceList setAlpha:1.0];
    
	[UIView commitAnimations];
	
}

-(void)didUpdateSeriveInfo:(NSMutableDictionary *)pObjServiceInfo {
    
    NSLog(@"pObjServiceInfo = %@",pObjServiceInfo);
	
    if ([pObjServiceInfo isKindOfClass:[NSMutableDictionary class]]) {
        
        if([[pObjServiceInfo allKeys] count]>0)
        {
            [_m_cObjServiceList refreshTableWithData:pObjServiceInfo];
            //[m_gObjServiceManager stopDiscovery];
        }
        else {
            NSLog(@"Sevice Fail...");
        }
    }
}

-(void)discoveryDidFail {
    
    if (_connectionStatus == NO) {
        
        if (m_cObjManualIPEntry) {
            
            [m_cObjManualIPEntry removeFromSuperview];
            m_cObjManualIPEntry = nil;
        }
        
        m_cObjManualIPEntry = [[Manual_IP_Entry alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) withDelegate:self];
        [m_cObjManualIPEntry setAlpha:0];
        [self.view addSubview:m_cObjManualIPEntry];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        [m_cObjManualIPEntry setAlpha:1.0];
        [_m_cObjServiceList setAlpha:0];
        
        [UIView commitAnimations];
               
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
	
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
    
   
    [m_cObjManualIPEntry.m_cObjScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

	
	[m_cObjManualIPEntry.m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
	
	[UIView commitAnimations];

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
    
    [m_cObjManualIPEntry.m_cObjScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+100)];
    
    [m_cObjManualIPEntry.m_cObjScrollView scrollRectToVisible:CGRectMake(0, m_cObjManualIPEntry.m_cObjScrollView.contentSize.height-2,[UIScreen mainScreen].bounds.size.width, 2) animated:YES];
	
	[m_cObjManualIPEntry.m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height-310, 60, 30)];
	
	[UIView commitAnimations];
	
	return YES;
	
}
// return NO to disallow editing.

-(void)resignKeyPadForManualEntryPage {
	
	[m_cObjManualIPEntry.m_cObjTextField resignFirstResponder];
	
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
    
    [m_cObjManualIPEntry.m_cObjScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

	
    [m_cObjManualIPEntry.m_cObjScrollView scrollRectToVisible:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 0) animated:YES];

	[m_cObjManualIPEntry.m_cObjKeyboardRemoverButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
	
	[UIView commitAnimations];
}

-(void)Next {
	   
    sharedGsData.m_gObjNodeIP = [NSString stringWithString:[m_cObjManualIPEntry.m_cObjTextField text]];
    sharedGsData.currentIPAddress = [NSString stringWithString:[m_cObjManualIPEntry.m_cObjTextField text]];
    
    if ([m_cObjManualIPEntry.m_cObjTextField text] != nil && [[m_cObjManualIPEntry.m_cObjTextField text] caseInsensitiveCompare:@"0000"] == NSOrderedSame ) {
        
		[self requestURLString:[NSString stringWithFormat:@"http://%@/gainspan/profile/prov",[m_cObjManualIPEntry.m_cObjTextField text]]];
    }
    else if ([self checkForEmptyFields] == YES) {
		
		[UIView beginAnimations:nil context:NULL];
		
		[UIView setAnimationDuration:0.35];
		
		[m_cObjManualIPEntry setAlpha:0];
		
		[UIView commitAnimations];
        
		[self requestURLString:[NSString stringWithFormat:@"http://%@/gainspan/profile/prov",[m_cObjManualIPEntry.m_cObjTextField text]]];
        
	}
	
}

-(BOOL)checkForEmptyFields
{
    if ([[m_cObjManualIPEntry.m_cObjTextField text] isEqualToString:@""] || [[m_cObjManualIPEntry.m_cObjTextField text] isEqualToString:@"(null)"]) {
        
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Enter an IP Address or Hostname to continue" message:nil confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        	UIAlertView *lObjFieldValidation = [[UIAlertView alloc] initWithTitle:@"Enter an IP Address or Hostname to continue" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [lObjFieldValidation show];
        
        return NO;
    }
    
	return YES;
}

-(BOOL)checkForInvalidCharacters {
	
    NSString *myOriginalString = [NSString stringWithString:[m_cObjManualIPEntry.m_cObjTextField text]];
    
    return [ValidationUtils validateCharacters:myOriginalString];
	
}

-(BOOL)checkForInvalidIPAdresses {
    
    return [ValidationUtils validateIPAddress:[m_cObjManualIPEntry.m_cObjTextField text]];
}


-(void)requestURLString:(NSString *)pObjURLString {
	
    NSLog(@"pObjURLString >>>>>>>>>>>>>> : %@",pObjURLString);
    
    _connectionStatus = YES;
    
	if (_m_cObjServiceList) {
		
		[self removeServiceList];
		
	}
	
	if (m_cObjManualIPEntry) {
		
		[self removeManualIPEntryScreen];
		
	}
	
	m_cObjActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[m_cObjActivity setFrame:CGRectMake(320/2 - 20/2, 480/2 -20/2, 20, 20)];
	[m_cObjActivity startAnimating];
	[self.view addSubview:m_cObjActivity];
	
	
    [self checkAuthentication];
    
}

/**
 *   Called when a service from the service browser list is selected. Ideally the list view is slid down the screen with animation and then released.
 */

-(void)removeServiceList {
    
    [self addLogo];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	[_m_cObjServiceList setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 200, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
	[UIView commitAnimations];
		
	[self performSelector:@selector(releaseServiceList) withObject:nil afterDelay:1.0];
	
}

/**
 *  Called presisely 0.1 (0.6 - 0.5) seconds after service browser list stops sliding animation.At this point of serviceList should be released from memory
 */
-(void)releaseServiceList {

	[_m_cObjServiceList removeFromSuperview];
	
}

-(void)removeManualIPEntryScreen  {
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	[m_cObjManualIPEntry setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 200, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
	[UIView commitAnimations];
		
	[self performSelector:@selector(releaseManualIPEntryScreen) withObject:nil afterDelay:1.0];

}

-(void)releaseManualIPEntryScreen {
    
     [m_cObjManualIPEntry removeFromSuperview];
    
    m_cObjManualIPEntry = nil;

}

/**
 *  Called when a service is selected from service browser list.While it take a small amount of time before the first TLS data is recieved in order to prepare the TLSViewController and GraphView we add a small GS Logo and an activity indicator on the window.
 */



-(void)addLogo {
	 	
	m_cObjLogo = [[UIImageView alloc] initWithFrame:CGRectMake(160 - 264/4, NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT + MARGIN_BETWEEN_CELLS, 264/2, 72/2)];
	[m_cObjLogo setImage:[UIImage imageNamed:@"logo_gainspan.png"]];
	[self.view addSubview:m_cObjLogo];
	[self.view sendSubviewToBack:m_cObjLogo];
	
	m_cObjActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[m_cObjActivity setFrame:CGRectMake(320/2 - 20/2, 480/2 -20/2, 20, 20)];
	[m_cObjActivity startAnimating];
	[self.view addSubview:m_cObjActivity];
	[self.view sendSubviewToBack:m_cObjActivity];
	
}


-(void)checkAuthentication {
   
    if (check) {
        
        check=nil;
    }
    
	check = [[Auth_Check alloc] init];
    
    [check checkWithURL:[NSURL URLWithString:[NSString stringWithFormat:GSPROV_GET_URL_NETWORK_DETAILS,sharedGsData.m_gObjNodeIP,sharedGsData.currentIPAddress]] withDelegate:self];
}

#pragma mark - GSConnection Manager Delegate Methods:

/**
 *  Called when the AuthCheck comes accross an authentication challenge while trying to communicate to the server.This method is an ideal place to prompt for user inputs such as username and pasword.
 *
 * Called when the AuthCheck comes accross an authentication challenge while trying to communicate to the server.This method is an ideal place to prompt for user inputs such as username and pasword.
 *
 *
 *  @param pObjChg NSURLAuthenticationChallenge for request object.
 */


-(void)promptForUserInputForAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg {
    
    if (m_cObjAlertView)
	{
		m_cObjAlertView = nil;
	}
	
	m_cObjAlertView = [[UIAlertView alloc] initWithTitle:@"Enter Credentials" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	m_cObjAlertView.tag=401;
    m_cObjAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
	m_cObjAlertView.delegate = self;
	[m_cObjAlertView show];
    
	
	m_cObjAuthChallenge = pObjChg;

}

-(void)didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg forConnection:(GSConnection *)pObjConnection
{
	
	NSURLCredential *credentials = [NSURLCredential credentialWithUser:_username password:_password persistence:NSURLCredentialPersistenceForSession];
    
    [m_cObjConnectionManager proceedWithCredential:credentials forChallenge:pObjChg forConnection:pObjConnection];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (alertView.tag == 401) {
        
		UITextField *lObjUsernameField = (UITextField *)[alertView textFieldAtIndex:0];
		UITextField *lObjPasswordField = (UITextField *)[alertView textFieldAtIndex:1];
		
		if (lObjUsernameField.text == nil) {
			
			_username = [[NSString alloc] initWithString:[lObjUsernameField text]];
			
		}
		else {
			
			_username = [[NSString alloc] initWithString:[lObjUsernameField text]];
		}
		
		if (lObjPasswordField.text == nil) {
			
			_password = [[NSString alloc] initWithString:lObjPasswordField.text];
		}
		else {
			
			_password = [[NSString alloc] initWithString:lObjPasswordField.text];
		}
		
		NSURLCredential *credentials = [NSURLCredential credentialWithUser:_username password:_password persistence:NSURLCredentialPersistenceForSession];
        
        [check proceedWithCredential:credentials forChallenge:m_cObjAuthChallenge];
		
	}
    
	if (alertView.tag == 6) {
        
		exit(1);
		
		
		return;
	}
	if (alertView.tag == 8) {
        
        
        [self checkAuthentication];
        
		return;
	}
    
}

-(void)authentictionDone {
    
	[self allocProvData];
    
	[self allocParser];
    
	[self allocConnectionManager];
	
	[self removeServiceList];
}


-(void)allocProvData {
	
	m_cObjProvData = [[GS_ADK_DataManger alloc] init];
}


-(void)allocParser {
    
    m_cObjUniversalParser = [[UniversalParser alloc] init];
    
    m_cObjURLs = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:GSPROV_GET_URL_NETWORK_DETAILS,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],[NSString stringWithFormat:GSPROV_GET_URL_ID,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],[NSString stringWithFormat:GSPROV_GET_URL_API_VERSION,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],[NSString stringWithFormat:GSPROV_GET_WPS_URL,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],[NSString stringWithFormat:GSPROV_GET_ADMIN_SETTINGS,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],[NSString stringWithFormat:GSPROV_GET_URL_FIRMWARE_VERSION,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],[NSString stringWithFormat:GSPROV_POST_URL_UTC_TIME,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],[NSString stringWithFormat:GSPROV_GET_URL_SCAN_PARAMS_URL,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],[NSString stringWithFormat:GSPROV_GET_CAPABILITIES,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],nil];
}


-(void)allocConnectionManager {
	
    if (m_cObjConnectionManager) {
        
        m_cObjConnectionManager = nil;
    }
    
	m_cObjConnectionManager = [[GS_ADK_ConnectionManager alloc] init];
	
	[m_cObjConnectionManager setM_cObjDelegate:self];
    
    successCount = 0;
    
    [self iterateConnection];
}



-(void)iterateConnection {
    
    if ([m_cObjURLs count] > successCount) {
        
        [m_cObjConnectionManager connectWithURLStrings:[NSArray arrayWithObject:[m_cObjURLs objectAtIndex:successCount]] autoUpdate:NO updateInterval:4.0];
    }
}


-(NSString *)gsProvFormatterPrefix:(NSString *)lObjSuffix suffix:(NSString *)lObjPrefix {
	
	return nil;
	
}

-(void)connection:(GSConnection *)pObjConnection didReceiveResponse:(NSURLResponse *)pObjResponse {
    
    if ([pObjConnection.m_cObjTag isEqualToString:[NSString stringWithFormat:GSPROV_POST_URL_UTC_TIME,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]]) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)pObjResponse;
        /*
        if ([httpResponse statusCode] == 200) {
            
            appDelegate.UTC_Time_Supported = YES;
        }
        else{
            appDelegate.UTC_Time_Supported = NO;
        }
         */
    }
    
    if ([pObjConnection.m_cObjTag isEqualToString:[NSString stringWithFormat:GSPROV_GET_WPS_URL,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]]) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)pObjResponse;
        
        if ([httpResponse statusCode] == 404) {
            
            sharedGsData.wpaEnabled = NO;
        }
        else{
            sharedGsData.wpaEnabled = YES;
        }
    }
}

-(void)connection:(GSConnection *)pObjConnection endedWithData:(NSData *)pObjData {
    
    if ([pObjData length] != 0) {
        
		NSMutableDictionary *myReleventData = [m_cObjProvData processData:pObjData withParser:m_cObjUniversalParser];
        
        NSLog(@"myReleventData = %@",myReleventData);
		
		[sharedGsData setData:myReleventData];
	}
	else {
	}
    
	if (successCount == [m_cObjURLs count]-1) {
        
        [self createView];
    }
    else {
        successCount++;
        
        [self iterateConnection];
    }
}

-(void)createView {
	
    if (m_cObjLogo) {
        
        [m_cObjLogo removeFromSuperview];
    }
    
	if (m_cObjActivity) {
        
        [m_cObjActivity stopAnimating];
        
        [m_cObjActivity removeFromSuperview];
    }
	
	[self addTabController];
}


-(void)addTabController {
	
	_m_gObjClientMode = [[ClientModeViewController alloc] initWithControllerType:1];
	
	_m_gObjLimitedAPWirelessSettingsScreen = [[LimitedAPWirelessSettingsScreen alloc] initWithControllerType:1];
    
    AdminSettingsViewController *lObjAdminSettings = [[AdminSettingsViewController alloc] initWithControllerType:1];
    
	UINavigationController *lObjClientModeNavController = [[UINavigationController alloc] initWithRootViewController:_m_gObjClientMode];
	[lObjClientModeNavController.navigationBar setTintColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	lObjClientModeNavController.navigationBar.hidden = YES;
	
	UINavigationController *lObjLAPModeNavController = [[UINavigationController alloc] initWithRootViewController:_m_gObjLimitedAPWirelessSettingsScreen];
	[lObjLAPModeNavController.navigationBar setTintColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	lObjLAPModeNavController.navigationBar.hidden = YES;
	
	UINavigationController *lObjLAPSettingsNavController = [[UINavigationController alloc] initWithRootViewController:lObjAdminSettings];
	[lObjLAPSettingsNavController.navigationBar setTintColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
    lObjLAPSettingsNavController.navigationBar.hidden = YES;
    
	_m_gObjTabController = [[UITabBarController alloc] init];
    
    NSArray *lObjMenuList = [[NSArray alloc] initWithObjects:_m_gObjClientMode,_m_gObjLimitedAPWirelessSettingsScreen,lObjAdminSettings,nil];
	
	
	[_m_gObjTabController setViewControllers:lObjMenuList animated:YES];
    
	
	[[_m_gObjTabController.viewControllers objectAtIndex:0] setTitle:@"Client Config"];
	[[_m_gObjTabController.viewControllers objectAtIndex:1] setTitle:@"Limited AP Config"];
	[[_m_gObjTabController.viewControllers objectAtIndex:2] setTitle:@"Admin Settings"];
	
    [self.navigationController pushViewController:_m_gObjTabController animated:YES];
    
    	
    [self removeLogo];
}


-(void)removeLogo
{
    if (m_cObjActivity) {
        
      //  [m_cObjActivity stopAnimating];
       // [m_cObjActivity removeFromSuperview];
    }
}

-(void)showCurrentWiFiConnectionDetails {
    
	CFArrayRef myArray = CNCopySupportedInterfaces();
	
	NSArray *lObjArray = [NSArray arrayWithArray:(__bridge NSArray *)myArray];
    
	if ([lObjArray count] == 0) {
		
        if (myArray) {
            
            CFRelease(myArray);
        }
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Could not get Current Network Details"] message:nil confirmationData:[NSDictionary dictionary]];
        
        info.cancelButtonTitle = @"OK";
        
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
        
        [lObjAlert show];
		
		
        return;
	}
	
    
	CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    
    if (myArray) {
        
        CFRelease(myArray);
        
    }
    
    if (myDict) {
        
        CFStringRef SSID_Str = CFDictionaryGetValue(myDict,@"SSID");
        
        NSString *lObjString = (__bridge NSString *)SSID_Str;
        
        [sharedGsData setCurrentSSID:lObjString];
        
        if (myDict) {
            
            CFRelease(myDict);
        }
    }
    else{
        
        [sharedGsData setCurrentSSID:@""];
    }
	
    
	if (sharedGsData.m_cObjSSID_Str.length > 2) {
		
		if ([[sharedGsData.m_cObjSSID_Str substringToIndex:2] isEqualToString:@"gs"] || [[sharedGsData.m_cObjSSID_Str substringToIndex:2] isEqualToString:@"GS"]) {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Your device is connected to %@",sharedGsData.m_cObjSSID_Str] message:nil confirmationData:[NSDictionary dictionary]];
            
            info.cancelButtonTitle = @"OK";
            
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            
            [lObjAlert show];
			
		}
		else {
            
            GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Your device is connected to %@",sharedGsData.m_cObjSSID_Str] message:nil confirmationData:[NSDictionary dictionary]];
            
            info.cancelButtonTitle = @"OK";
            
            info.otherButtonTitle = nil;
            
            GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:nil];
            
            [lObjAlert show];
			
		}
        
	}
	
}

-(void)connectionFailed:(GSConnection *)pObjConnection withError:(NSError *)pObjError {
    
    if ([pObjConnection.m_cObjTag isEqualToString:[NSString stringWithFormat:GSPROV_POST_URL_UTC_TIME,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]]) {
        
         //appDelegate.UTC_Time_Supported = NO;
    }
    
    [self iterateConnection];
}

-(void)retryPrePopulation {
    
    if (connectionFailurePromptDone == NO) {
        
        connectionFailurePromptDone = YES;
        
        
          m_cObjAlertView = [[UIAlertView alloc] initWithTitle:@"Prepopulation has Failed" message:@"The Application could not be initialized. Press Retry to try again" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil];
        
        m_cObjAlertView.tag = 8;
        m_cObjAlertView.delegate = self;
        
        [m_cObjAlertView show];
        
    }
    else {
        [self allocConnectionManager];
    }
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
