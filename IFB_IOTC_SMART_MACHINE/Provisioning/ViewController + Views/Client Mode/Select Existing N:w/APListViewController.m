
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
 * $RCSfile: APListViewController.m,v $
 *
 * Description : Header file for APListViewController functions and data structures
 *******************************************************************************/

//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "APListViewController.h"
#import "APSettingsViewController.h"
#import "ConfirmationViewController.h"
#import "Manual_IPSettingScreen.h"
#import "ScanParamsInputScreen.h"
#import "InfoScreen.h"
#import "GS_ADK_Data.h"
#import "GS_ADK_DataManger.h"
#import "GS_ADK_ConnectionManager.h"
#import "Identifiers.h"
#import "UniversalParser.h"
#import "APInfoViewController.h"
#import "UINavigationBar+TintColor.h"
#import "UITableView+SpecificFrame.h"
#import "ResetFrame.h"
#import "ConcurrentModeInfoViewController.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"
#import "GSNavigationBar.h"


#import "ModeController.h"
#import "PostSummaryController.h"




@interface APListViewController(privateMethods)<CustomUIAlertViewDelegate>

-(void)launchIPConfigScreenFor:(NSString *)SSID_Str;
-(UIImage *)getSignalStrengthImageForStregth:(int)signalStrength;
-(void)allocConnectionManagerWithURLStrings:(NSArray *)pObjURLs;
-(void)showConfirmationWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray;
-(void)confirmManualConfiguration;

@end


@implementation APListViewController

@synthesize m_cObjDelegate,ipAdressType,appDelegate,lObjScanParamScreen,sharedGsData,m_cObjProvData;
@synthesize m_cObjConnectionManager,m_cObjUniversalParser,lObjConfirmationPage,m_cObjTable;
@synthesize m_cObjSegControl,m_cObjInfoArray,currentSelection,refreshMode;


-(void)parsingDone {
    
    NSLog(@"parsingDone in APListViewController");
	
   // [self hideActivityIndicator];
    
    [self aplistViewControllerHideActivityIndicator];

	
	refreshMode = YES;
	
	[m_cObjTable reloadData];
    
	
}


-(void)showActivityIndicatorWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder {
    
    if (m_cObjAlertView) {
        
        m_cObjAlertView = nil;
    }
	
    if ([aObjresponder isEqualToString:@"none"]) {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:aObjtitle message:aObjmessage confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = nil;
        info.otherButtonTitle = nil;
        
        m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleActivityIndicator delegate:self];
        
	}
	else {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:aObjtitle message:aObjmessage confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = aObjresponder;
        info.otherButtonTitle = nil;
        
        m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleActivityIndicator delegate:self];
        
	}
    
	[m_cObjAlertView show];
	//[m_cObjAlertView release];

}




-(void)aplistViewControllerHideActivityIndicator {
    
    if (m_cObjAlertView != nil) {
    
                NSLog(@"UIView class");
                
                [m_cObjAlertView dismissWithClickedButtonIndex:0 animated:YES];
            }
}


-(void)dismissScanParamScreen
{
	[lObjScanParamScreen dismissScanParamScreen];
	lObjScanParamScreen=nil;
}

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
            
        case NavigationItemDone:
            
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
    
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	m_cObjProvData = [[GS_ADK_DataManger alloc] init];
    
	m_cObjUniversalParser = [[UniversalParser alloc] init];
	
	sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
	appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    sharedGsData.manualConfigMode = NO;
    
	
	if ([[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] != nil || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@""]) {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
		
	}
	else {
		
		self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"]];
        
	}//
    
    
    m_cObjTable = [[UITableView alloc] initWithiOSVersionSpecificMargin:STATUS_BAR_HEIGHT withAdjustment:(NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
	m_cObjTable.dataSource=self;
	m_cObjTable.delegate = self;
	[self.view addSubview:m_cObjTable];
	
	
	
    
}

-(void)showInfo {
	
    InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
    
    [self presentViewController:lObjInfoScreen animated:YES completion:nil];
    
}

-(void)enterScanParameters {
	
    lObjScanParamScreen = [[ScanParamsInputScreen alloc] initWithControllerType:2];
	lObjScanParamScreen.m_cObjDelegate = self;
    [self presentViewController:lObjScanParamScreen animated:YES completion:nil];
}

-(void)refresh {
    
    
        [self showActivityIndicatorWithTitle:@" " messageTitle:@"Refreshing AP List" responderTitle:@"none"];
        
        [self allocConnectionManagerWithURLStrings:[NSArray arrayWithObjects:[NSString stringWithFormat:GSPROV_GET_URL_AP_LIST,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]],nil]];
    
}

-(void)allocConnectionManagerWithURLStrings:(NSArray *)pObjURLs {
	
	m_cObjConnectionManager = [[GS_ADK_ConnectionManager alloc] init];
	
	[m_cObjConnectionManager setM_cObjDelegate:self];
	
	[m_cObjConnectionManager connectWithURLStrings:pObjURLs autoUpdate:NO updateInterval:4.0];
	
}

-(void)connection:(GSConnection *)pObjConnection didReceiveResponse:(NSURLResponse *)pObjResponse;
{
    
}

-(void)connection:(GSConnection *)pObjConnection endedWithData:(NSData *)pObjData {

	if ([pObjData length] != 0) {
		
		NSMutableDictionary *myReleventData = [m_cObjProvData processData:pObjData withParser:m_cObjUniversalParser];
        
		[sharedGsData setData:myReleventData];
        
        [self parsingDone];
		
	}
    
	
}

-(void)connectionFailed:(GSConnection *)pObjConnection withError:(NSError *)pObjError
{
    NSLog(@"error called hideActivityIndicator !!!!!!!");
    
    [self aplistViewControllerHideActivityIndicator];
}



#pragma mark -
#pragma mark Table view data source

-(UIView *)getSectionHeader: (NSInteger)index
{
	
	UIView *lObjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[lObjView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *lObjConfigScanParamButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lObjConfigScanParamButton setTitle:@"Filter List" forState:UIControlStateNormal];
    [lObjConfigScanParamButton addTarget:self action:@selector(enterScanParameters) forControlEvents:UIControlEventTouchUpInside];
    lObjConfigScanParamButton.tag=index+1;
    lObjConfigScanParamButton.frame = CGRectMake(10, 22-8, (320-30)/2, 44);
    [lObjView addSubview:lObjConfigScanParamButton];
    
    UIButton *lObjRefreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lObjRefreshButton setTitle:@"Refresh List" forState:UIControlStateNormal];
    [lObjRefreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    lObjRefreshButton.tag=index+1;
    lObjRefreshButton.frame = CGRectMake(20 + (320-30)/2, 22-8, (320-30)/2, 44);
    [lObjView addSubview:lObjRefreshButton];
    
    
    
    if([sharedGsData.firmwareVersion.chip rangeOfString:@"gs1550m" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        if([[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"Limited AP"] || [[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"limited-ap"])
        {
            [lObjConfigScanParamButton setAlpha:0.5];
            [lObjConfigScanParamButton setUserInteractionEnabled:NO];
            
            [lObjRefreshButton setAlpha:0.5];
            [lObjRefreshButton setUserInteractionEnabled:NO];
        }
        else {
            
            [lObjConfigScanParamButton setAlpha:1.0];
            [lObjConfigScanParamButton setUserInteractionEnabled:YES];
            
            [lObjRefreshButton setAlpha:1.0];
            [lObjRefreshButton setUserInteractionEnabled:YES];
            
        }
    }
    else if ([sharedGsData.firmwareVersion.chip rangeOfString:@"gs1500m" options:NSCaseInsensitiveSearch].location != NSNotFound){
        
        if([[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"Limited AP"] || [[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"limited-ap"])
        {
            [lObjConfigScanParamButton setAlpha:0.5];
            [lObjConfigScanParamButton setUserInteractionEnabled:NO];
            
            [lObjRefreshButton setAlpha:0.5];
            [lObjRefreshButton setUserInteractionEnabled:NO];
        }
        else {
            
            [lObjConfigScanParamButton setAlpha:1.0];
            [lObjConfigScanParamButton setUserInteractionEnabled:YES];
            
            [lObjRefreshButton setAlpha:1.0];
            [lObjRefreshButton setUserInteractionEnabled:YES];
            
        }
        
        
    }
    
    else if ([sharedGsData.firmwareVersion.chip rangeOfString:@"gs2000" options:NSCaseInsensitiveSearch].location != NSNotFound){
        
        if([[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"Limited AP"] || [[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"limited-ap"])
        {
//            [lObjConfigScanParamButton setAlpha:0.5];
//            [lObjConfigScanParamButton setUserInteractionEnabled:NO];
//            
//            [lObjRefreshButton setAlpha:0.5];
//            [lObjRefreshButton setUserInteractionEnabled:NO];
        }
        else {
            
//            [lObjConfigScanParamButton setAlpha:1.0];
//            [lObjConfigScanParamButton setUserInteractionEnabled:YES];
//            
//            [lObjRefreshButton setAlpha:1.0];
//            [lObjRefreshButton setUserInteractionEnabled:YES];
            
        }
        
        
    }
    else {
        
        if([[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"Limited AP"] || [[[[sharedGsData.apConfig objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"limited-ap"])
        {
            [lObjConfigScanParamButton setAlpha:1.0];
            [lObjConfigScanParamButton setUserInteractionEnabled:YES];
            
            [lObjRefreshButton setAlpha:1.0];
            [lObjRefreshButton setUserInteractionEnabled:YES];
        }
        else {
            
            [lObjConfigScanParamButton setAlpha:1.0];
            [lObjConfigScanParamButton setUserInteractionEnabled:YES];
            
            [lObjRefreshButton setAlpha:1.0];
            [lObjRefreshButton setUserInteractionEnabled:YES];
            
        }
        
    }
	
	return lObjView;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 1 ? 88.0 : 66.0);
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
        
        sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
        
        if (![sharedGsData.m_cObjSSID_Str isEqualToString:@""]) {
            
            return @"Choose an AP to connect to";
            
        }
        else {
            
            return @"Choose an AP to connect to";
            
        }
	}
	else {
        
        return @"Choose an AP to connect to";
        
    }
    
}
// fixed font style. use custom view (UILabel) if you want something different

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section != 0) {
		
		return [self getSectionHeader:section];
	}
	
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
    
    
    if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSNull class]] || [[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]==NULL)
    {
        return 0;
    }
	
	if (section == 0) {
		
		if (refreshMode == NO) {
            
            
			
            if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
            {
                
                return [[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] count];
                
            }
            else
            {
                
                return 1;
                
            }
            
			
		}
		else {
			
            if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
            {
               // NSLog(@" array class :::" );
                
                return [[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] count];
                
            }
            else
            {
                
                return 1;
                
            }
            
            
		}
		
	}
	else {
		return 0;
	}
    
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // NSLog(@"dict = %@", [sharedGsData apList]);
   
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	if (indexPath.section == 0) {
		
        UILabel *lObjNwName = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 210, 32)];
		lObjNwName.numberOfLines = 2;
		lObjNwName.backgroundColor = [UIColor clearColor];
		lObjNwName.font = [UIFont boldSystemFontOfSize:14];
		lObjNwName.textColor = [UIColor darkGrayColor];
        
		if (refreshMode == NO) {
            
            if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
            {
                if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"ssid"] objectForKey:@"text"] != nil)
                {
                    
                    lObjNwName.text = [[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"ssid"] objectForKey:@"text"];
                }
            }
            else {
                
                if([[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"] != nil)
                {
                    lObjNwName.text = [[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"];
                }
                
                
            }
		}
		else {
            
            if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
            {
                if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"ssid"] objectForKey:@"text"] != nil)
                {
                    lObjNwName.text = [[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"ssid"] objectForKey:@"text"];
                }
                
            }
            else {
                
                if([[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"] != nil)
                {
                    lObjNwName.text = [[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"];
                }
                
            }
            
		}
		
		[cell.contentView addSubview:lObjNwName];
        
        
		
		UIImageView *lObjSignalStrength = [[UIImageView alloc] init];
		lObjSignalStrength.frame = CGRectMake(245-7, 12, 20, 20);
		[cell.contentView addSubview:lObjSignalStrength];
		
		if (refreshMode == NO) {
            
            if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
            {
                lObjSignalStrength.image = [self getSignalStrengthImageForStregth:[[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"rssi"] objectForKey:@"text"] intValue]];
            }
            else {
                lObjSignalStrength.image = [self getSignalStrengthImageForStregth:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"rssi"] objectForKey:@"text"] intValue]];
            }
			
		}
		else {
            
            if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
            {
                lObjSignalStrength.image = [self getSignalStrengthImageForStregth:[[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"rssi"] objectForKey:@"text"] intValue]];
            }
            else {
                lObjSignalStrength.image = [self getSignalStrengthImageForStregth:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"rssi"] objectForKey:@"text"] intValue]];
                
            }
            
		}
		
		
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
		
		UIImageView *lObjSecuredStatus = [[UIImageView alloc] init];
		lObjSecuredStatus.frame = CGRectMake(220-5, 12, 20, 20);
		[cell.contentView addSubview:lObjSecuredStatus];
		
		if (refreshMode == NO) {
            
            if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
            {
                NSLog(@"%@",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"]);
                
                if ([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"]) {
                    
                    lObjSecuredStatus.image = nil;
                }
                else {
                    
                    lObjSecuredStatus.image = [UIImage imageNamed:@"stock_lock.png"];
                    
                }
                
            }
            else {
                
                NSLog(@"%@",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"]);

                
                if ([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"]) {
                    
                    lObjSecuredStatus.image = nil;
                }
                else {
                    
                    lObjSecuredStatus.image = [UIImage imageNamed:@"stock_lock.png"];
                    
                }
                
            }
			
            
		}
		else {
            
            if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
            {
                if ([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"]) {
                    
                    lObjSecuredStatus.image = nil;
                }
                else {
                    
                    lObjSecuredStatus.image = [UIImage imageNamed:@"stock_lock.png"];
                    
                }
                
            }
            else {
                
                if ([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"]) {
                    
                    lObjSecuredStatus.image = nil;
                }
                else {
                    
                    lObjSecuredStatus.image = [UIImage imageNamed:@"stock_lock.png"];
                    
                }
                
            }
            
		}
		
	}
	else {
		
        
	}
    
	
    return cell;
}


-(void)didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg forConnection:(GSConnection *)pObjConnection
{
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	APInfoViewController *apView=[[APInfoViewController alloc]initWithControllerType:1];
	apView.index=indexPath.row;
	[self.navigationController pushViewController:apView animated:YES];
}


-(UIImage *)getSignalStrengthImageForStregth:(int)signalStrength
{
	
	if (signalStrength >= 80 )
	{
		return [UIImage imageNamed:@"Default_0_AirPort.png"];
	}
	else if (signalStrength >= 66 && signalStrength <= 79 )
	{
		return [UIImage imageNamed:@"Default_1_AirPort.png"];
	}
	else if (signalStrength >=45 && signalStrength <= 65)
	{
        return [UIImage imageNamed:@"Default_2_AirPort.png"];
	}
	else if (signalStrength <= 44)
	{
		return [UIImage imageNamed:@"Default_3_AirPort.png"];
	}
	else {
		return [UIImage imageNamed:@"Default_0_AirPort.png"];
	}
}

-(void)viewSettings:(id)sender
{
    
	APSettingsViewController *lObjSettingsPage = [[APSettingsViewController alloc] initWithControllerType:1];
	[self.navigationController pushViewController:lObjSettingsPage animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 44;
}





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    globalValues.provisionSharedDelegate.utcSwitchState = NO;
    
	currentSelection = indexPath.row;
    
	if (refreshMode == NO) {
        
        if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
        {
            if ([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"]) {
                
                globalValues.provisionSharedDelegate.securedMode = NO;
                
                m_cObjInfoArray = [[NSArray alloc] initWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"channel"] objectForKey:@"text"],@"",nil];
                
                [self launchIPConfigScreenFor:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"ssid"] objectForKey:@"text"]];
                
            }
            else if([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                lObjConfirmationPage.m_cObjDelegate = self;
                [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                [lObjConfirmationPage addKeyPairTextField];
                [lObjConfirmationPage showKeyPairTextField];
                [lObjConfirmationPage indexOfRow:indexPath.row];
                //[lObjConfirmationPage release];
                
            }
            else if([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wpa-enterprise"]){
                
                
                //NSLog(@"wpa-enterprise ::::::: %@",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"]);
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                lObjConfirmationPage.m_cObjDelegate = self;
                [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                [lObjConfirmationPage addInterfaceForEAPCredentialsInput];
                [lObjConfirmationPage indexOfRow:indexPath.row];
                //[lObjConfirmationPage release];
                
            }
            else {
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                lObjConfirmationPage.m_cObjDelegate = self;
                [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                [lObjConfirmationPage addTextField];
                [lObjConfirmationPage showTextField];
                [lObjConfirmationPage indexOfRow:indexPath.row];
                // [lObjConfirmationPage release];
                
            }
        }
        else {//
            
            if ([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"]) {
                
                globalValues.provisionSharedDelegate.securedMode = NO;
                
                m_cObjInfoArray = [[NSArray alloc] initWithObjects:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"channel"] objectForKey:@"text"],@"",nil];
                
                [self launchIPConfigScreenFor:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]];
                
            }
            else if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                lObjConfirmationPage.m_cObjDelegate = self;
                [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                [lObjConfirmationPage addKeyPairTextField];
                [lObjConfirmationPage showKeyPairTextField];
                [lObjConfirmationPage indexOfRow:indexPath.row];
                //[lObjConfirmationPage release];
                
            }
            else if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wpa-enterprise"]) {
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                lObjConfirmationPage.m_cObjDelegate = self;
                [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                [lObjConfirmationPage addInterfaceForEAPCredentialsInput];
                [lObjConfirmationPage indexOfRow:indexPath.row];
                //[lObjConfirmationPage release];
                
            }
            else {
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                lObjConfirmationPage.m_cObjDelegate = self;
                [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                [lObjConfirmationPage addTextField];
                [lObjConfirmationPage showTextField];
                [lObjConfirmationPage indexOfRow:indexPath.row];
                // [lObjConfirmationPage release];
                
            }
        }
        
	}
	else {
		
        if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
        {
            if ([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:indexPath.row]objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"]) {
                
                globalValues.provisionSharedDelegate.securedMode = NO;
                
                
                m_cObjInfoArray = [[NSArray alloc] initWithObjects:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectAtIndex:indexPath.row] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectAtIndex:indexPath.row]objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectAtIndex:indexPath.row] objectForKey:@"channel"] objectForKey:@"text"],@"",nil];
                
                [self launchIPConfigScreenFor:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectAtIndex:indexPath.row]objectForKey:@"ssid"] objectForKey:@"text"]];
                
            }
            else if([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectAtIndex:indexPath.row] objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                lObjConfirmationPage.m_cObjDelegate = self;
                [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                [lObjConfirmationPage addKeyPairTextField];
                [lObjConfirmationPage showKeyPairTextField];
                [lObjConfirmationPage indexOfRow:indexPath.row];
                //[lObjConfirmationPage release];
                
            }
            else if([[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectAtIndex:indexPath.row]objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wpa-enterprise"]){
                
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                lObjConfirmationPage.m_cObjDelegate = self;
                [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                [lObjConfirmationPage addInterfaceForEAPCredentialsInput];
                [lObjConfirmationPage indexOfRow:indexPath.row];
                //[lObjConfirmationPage release];
                
            }
            else {
                
                globalValues.provisionSharedDelegate.securedMode = YES;
                
                lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                lObjConfirmationPage.m_cObjDelegate = self;
                [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                [lObjConfirmationPage addTextField];
                [lObjConfirmationPage showTextField];
                [lObjConfirmationPage indexOfRow:indexPath.row];
                //[lObjConfirmationPage release];
                
            }
		}
        else
        {
            {
                if ([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"none"]) {
                    
                    globalValues.provisionSharedDelegate.securedMode = NO;
                    
                    
                    m_cObjInfoArray = [[NSArray alloc] initWithObjects:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"],[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"security"] objectForKey:@"text"],@"",@"",@"",@"",[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"channel"] objectForKey:@"text"],@"",nil];
                    
                    [self launchIPConfigScreenFor:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"ssid"] objectForKey:@"text"]];
                    
                }
                else if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wep"]){
                    
                    globalValues.provisionSharedDelegate.securedMode = YES;
                    
                    lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                    lObjConfirmationPage.m_cObjDelegate = self;
                    [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                    [lObjConfirmationPage addKeyPairTextField];
                    [lObjConfirmationPage showKeyPairTextField];
                    [lObjConfirmationPage indexOfRow:indexPath.row];
                    //[lObjConfirmationPage release];
                    
                }
                else if([[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]objectForKey:@"security"] objectForKey:@"text"] isEqualToString:@"wpa-enterprise"]) {
                    
                    globalValues.provisionSharedDelegate.securedMode = YES;
                    
                    lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                    lObjConfirmationPage.m_cObjDelegate = self;
                    [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                    [lObjConfirmationPage addInterfaceForEAPCredentialsInput];
                    [lObjConfirmationPage indexOfRow:indexPath.row];
                    //[lObjConfirmationPage release];
                    
                }
                
                
                else {
                    
                    globalValues.provisionSharedDelegate.securedMode = YES;
                    
                    lObjConfirmationPage = [[ConfirmationViewController alloc] initWithControllerType:2];
                    lObjConfirmationPage.m_cObjDelegate = self;
                    [self presentViewController:lObjConfirmationPage animated:YES completion:nil];
                    [lObjConfirmationPage addTextField];
                    [lObjConfirmationPage showTextField];
                    [lObjConfirmationPage indexOfRow:indexPath.row];
                    //[lObjConfirmationPage release];
                    
                }
            }
        }
	}
	
}

-(void)launchIPConfigScreenFor:(NSString *)SSID_Str {
	
	globalValues.provisionSharedDelegate.ipAdressType = IP_TYPE_DHCP;
    
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:[NSString stringWithFormat:@"Network Settings for connecting to %@",SSID_Str] message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"Cancel";
    info.otherButtonTitle = @"Next";
    
    GSUIAlertView *lObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleIPSetting delegate:self];
    
    
    lObjAlertView.m_cObjIPSettingsView.segmentControl.selectedSegmentIndex = IP_TYPE_DHCP;
    
    [lObjAlertView.m_cObjIPSettingsView.segmentControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    [lObjAlertView show];
    

}

-(void)segmentedControlIndexChanged :(id)sender {
    
    UISegmentedControl *lObjSegmentController = (UISegmentedControl *)sender;
	
	switch (lObjSegmentController.selectedSegmentIndex) {
			
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


- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (globalValues.provisionSharedDelegate.ipAdressType == IP_TYPE_DHCP) {
		
        if (alertView.tag == 6) {
            
           // [self didConfigureSuccessfully];
            
            exit(0);
        }
        
//		if (alertView.tag == 301) {
//			
//			if (buttonIndex == 0) {
//				
//                [self confirmManualConfigurationWithSettingsMode:NO];
//				
//			}
//			else {
//                
//                [self confirmManualConfigurationWithSettingsMode:YES];
//                
//			}
//			
//		}
//		else if (alertView.tag == 1) {
//            
//            if (buttonIndex == 0) {
//                
//            }
//            else
//            {
//               // [self confirmManualConfiguration];
//                
//                [self showConfirmationSettingsAlert];
//                
//            }
//			
//		}
		else {
			
			if (buttonIndex == 0) {
				
			}
			else {
                
                
				if([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
                {
                    
                    NSString *SSID_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentSelection] objectForKey:@"ssid"] objectForKey:@"text"]];
                    
                    
                    NSString *Security_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentSelection] objectForKey:@"security"] objectForKey:@"text"]];
                    
                    
                    NSString *Channel_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentSelection] objectForKey:@"channel"] objectForKey:@"text"]];
                    
                    
                    NSArray *infoArray = [NSArray arrayWithObjects:SSID_Str,Security_Str,@"",@"",@"",@"",Channel_Str,@"",nil];
                    
                    [self showConfirmationWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                }
                else
                {
                    NSString *SSID_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]  objectForKey:@"ssid"] objectForKey:@"text"]];
                    
                    NSString *Security_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]  objectForKey:@"security"] objectForKey:@"text"]];
                    
                    NSString *Channel_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"]  objectForKey:@"channel"] objectForKey:@"text"]];
                    
                    NSArray *infoArray = [NSArray arrayWithObjects:SSID_Str,Security_Str,@"",@"",@"",@"",Channel_Str,@"",nil];
                    
                    [self showConfirmationWithTitle:@"\n\n\n\n\n\n\n\n\n" messageTitle:nil responderTitle:@"Cancel" info:infoArray];
                }
			}
			
		}
		
	}
	else {
		
		if (alertView.tag == 301) {
			
			if (buttonIndex == 0) {
				
				
			}
			else {
				
//				int currentMode=2;
//                				
//                [appDelegate setMode:currentMode];
				
                
			}
			
		}
		else {
			
            if (buttonIndex == 0) {
                
                
            }
            else
            {
                Manual_IPSettingScreen *lObjManualIPSettingScreen = [[Manual_IPSettingScreen alloc] initWithControllerType:2];
                //lObjManualIPSettingScreen.m_cObjDelegate = self;
                [lObjManualIPSettingScreen indexOfRow:currentSelection];
                [self presentViewController:lObjManualIPSettingScreen animated:YES completion:nil];
                
            }
            
		}
		
	}
    
}

-(NSDictionary *)returnConfirmManualConfigurationData {
    
    NSMutableDictionary *postDataDict = [NSMutableDictionary dictionary];
    
    NSString *SSID_Str=nil;
    NSString *Security_Str=nil;
    NSString *Channel_Str;
    if ([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
    {
        SSID_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentSelection] objectForKey:@"ssid"] objectForKey:@"text"]];
        
        Security_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentSelection] objectForKey:@"security"] objectForKey:@"text"]];
        
        Channel_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentSelection] objectForKey:@"channel"] objectForKey:@"text"]];
        
    }
    else
    {
        SSID_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]];
        
        Security_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"]];
        
        Channel_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"channel"] objectForKey:@"text"]];
        
    }
    
    postDataDict[@"channel"] = Channel_Str;
    postDataDict[@"ssid"] = SSID_Str;
    postDataDict[@"security"] = Security_Str;
    
    if (globalValues.provisionSharedDelegate.ipAdressType == IP_TYPE_DHCP) {
        
        postDataDict[@"ip_type"] = @"dhcp";
        
    }
    else {
        
        postDataDict[@"ip_type"] = @"static";
        postDataDict[@"ip_addr"] = [sharedGsData m_cObjIPAddress];
        postDataDict[@"subnetmask"] = [sharedGsData m_cObjSubnetMask];
        postDataDict[@"gateway"] = [sharedGsData m_cObjGateway];
        postDataDict[@"dns_addr"] = [sharedGsData m_cObjDNSAddress];
        
    }
    
    postDataDict[@"viewControllerMode"] = @"NavigationController";
    
    return postDataDict;
}


//-(void)confirmManualConfigurationWithSettingsMode:(BOOL)mode
//{
//     [appDelegate activityIndicator:YES];
//    
//    NSString *SSID_Str=nil;
//    NSString *Security_Str=nil;
//    NSString *Channel_Str;
//	if ([[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] isKindOfClass:[NSArray class]])
//    {
//        SSID_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentSelection] objectForKey:@"ssid"] objectForKey:@"text"]];
//        
//        Security_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentSelection] objectForKey:@"security"] objectForKey:@"text"]];
//        
//        Channel_Str = [NSString stringWithString:[[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectAtIndex:currentSelection] objectForKey:@"channel"] objectForKey:@"text"]];
//        
//    }
//    else
//    {
//        SSID_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"ssid"] objectForKey:@"text"]];
//        
//        Security_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"security"] objectForKey:@"text"]];
//        
//        Channel_Str = [NSString stringWithString:[[[[[sharedGsData apList] objectForKey:@"ap_list"] objectForKey:@"ap"] objectForKey:@"channel"] objectForKey:@"text"]];
//        
//    }
//	
//    
//	NSMutableString * xmlString = [[NSMutableString alloc] init];
//	
//	[xmlString appendString:@"<network>"];
//    
//    if (mode == YES) {
//        
//        _saveMode = YES;
//        
//        if (sharedGsData.doesSupportConcurrentMode) {
//            
//            [xmlString appendString:@"<mode>client-verify</mode>"];
//        }
//        else {
//            [xmlString appendString:@"<mode>client</mode>"];
//        }
//    }
//    
//	[xmlString appendString:@"<client><wireless>"];
//	[xmlString appendFormat:@"<channel>%@</channel>",Channel_Str];
//    [xmlString appendFormat:@"<ssid>%@</ssid>",SSID_Str];
//	[xmlString appendFormat:@"<security>%@</security>",Security_Str];
//	[xmlString appendString:@"</wireless><ip>"];
//	
//	if (appDelegate.ipAdressType == IP_TYPE_DHCP) {
//		
//        [xmlString appendFormat:@"<ip_type>%@</ip_type>",@"dhcp"];
//		
//	}
//	else {
//		
//		[xmlString appendFormat:@"<ip_type>%@</ip_type>",@"static"];
//		[xmlString appendFormat:@"<ip_addr>%@</ip_addr>",[sharedGsData m_cObjIPAddress]];
//        [xmlString appendFormat:@"<subnetmask>%@</subnetmask>",[sharedGsData m_cObjSubnetMask]];
//        [xmlString appendFormat:@"<gateway>%@</gateway>",[sharedGsData m_cObjGateway]];
//		[xmlString appendFormat:@"<dns_addr>%@</dns_addr>",[sharedGsData m_cObjDNSAddress]];
//		
//	}
//	
//	
//    [xmlString appendString:@"</ip></client></network>"];
//	
//	
//    
//	//	You can GET and POST data to this URI (/gainspan/config/network)
//	
//    
//	
//	NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_POST_URL_NETWORK_DETAILS,[sharedGsData m_gObjNodeIP]]];
//	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
//	
//	[serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	[serviceRequest setHTTPMethod:@"POST"];
//	
//	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	[xmlString release];
//	
//	[NSURLConnection connectionWithRequest:serviceRequest delegate:self];
//    
//}


//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    if (sharedGsData.doesSupportConcurrentMode)
//    {
//        
//        UniversalParser *lObjUniversalParser = [[UniversalParser alloc] init];
//        
//        _concurrentDataDict = [[NSMutableDictionary alloc] initWithDictionary:[lObjUniversalParser dictionaryForXMLData:data]];
//        
//        [lObjUniversalParser release];
//        
//        
//        NSLog(@"_concurrentDataDict = %@",_concurrentDataDict);
//        
//        
//    }
//    else {
//        
//        NSLog(@"no data");
//    }
//    
//}
//
//
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    [appDelegate activityIndicator:NO];
//    
//    if (!sharedGsData.doesSupportConcurrentMode && _saveMode ) {
//        
//        NSString *lObjString = [NSString stringWithFormat:@"Your device is now in %@ mode. Please re-connect to the device using your new wireless settings.",@"client"];
//        
//        
//        UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:lObjString message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        lObjAlertView.tag = 6;
//        lObjAlertView.delegate = self;
//        [lObjAlertView show];
//        [lObjAlertView release];
//        
//    }
//    
//    else if(sharedGsData.doesSupportConcurrentMode && sharedGsData.supportDualInterface && !_saveMode){
//        
//        UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"The settings were saved. Please ensure you have configured both the Client and Limited AP Settings, then choose Concurrent from the Set Mode screen" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        lObjAlertView.delegate = nil;
//        [lObjAlertView show];
//        [lObjAlertView release];
//        
//    }
//    else if (sharedGsData.doesSupportConcurrentMode && _saveMode) {
//        
//        if ([[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"status"] objectForKey:@"text"] isEqualToString:@"success"]) {
//            
//            ConcurrentModeInfoViewController *concurrentInfoController = [[ConcurrentModeInfoViewController alloc] initWithControllerType:4];
//            concurrentInfoController.concurrentInfoDict = _concurrentDataDict;
//            [self.navigationController pushViewController:concurrentInfoController animated:YES];
//            
//        }
//        else {
//            
//            NSString *lObjAlertString = nil;
//            
//            if ([[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"reason"]objectForKey:@"text"] length] > 0) {
//                
//                lObjAlertString = [NSString stringWithFormat:@"Error:%@ \n Reason:%@",[self convertErrorCodeToSting:[[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"error_code"]objectForKey:@"text"] intValue]],[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"reason"]objectForKey:@"text"]];
//            }
//            else {
//                
//                lObjAlertString = [NSString stringWithFormat:@"Error:%@ ",[self convertErrorCodeToSting:[[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"error_code"]objectForKey:@"text"] intValue]]];
//                
//            }
//            
//            UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"Verification Failed" message:lObjAlertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            lObjAlertView.delegate = nil;
//            [lObjAlertView show];
//            [lObjAlertView release];
//            
//        }
//    }
//    else {
//        
//        NSLog(@"condition failed");
//    }
//    
//}
//
//-(NSString *)convertErrorCodeToSting:(int)errorCode {
//    
//    switch (errorCode) {
//        case 1:
//            return @"Access Point not found. Please verify the SSID";
//            break;
//        case 2:
//            return @"Failed to connect";
//            break;
//        case 3:
//            return @"Authentication failure. Please verify the password";
//            break;
//            
//        default:
//            return @"";
//            break;
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    [appDelegate activityIndicator:NO];
//    
//}
//
//-(void)didFailToConfigure {
//    
//    
//}


//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    
//    [self didConfigureSuccessfully];
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    
//    [self didFailToConfigure];
//    
//}

//-(void)showConfirmationSettingsAlert {
//    
//        NSString *lObjMessageString = nil;
//        NSString *lObjApplyString = nil;
//        NSString *lObjLaterString = nil;
//        
//        if (sharedGsData.supportDualInterface && sharedGsData.doesSupportConcurrentMode) {
//            
//            lObjMessageString = @"The settings will be saved.";
//            
//            lObjApplyString = nil;
//            
//            lObjLaterString = @"Ok";
//        }
//        else {
//            
//            lObjMessageString = @" The settings will be saved. Would you also like to apply the new settings right away?";
//            
//            lObjApplyString = @"Apply";
//            
//            lObjLaterString = @"Later";
//        }
//        
//        NSLog(@"concurrent mode check");
//        
//        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Confirmation" message:lObjMessageString confirmationData:[NSDictionary dictionary]];
//        info.cancelButtonTitle = lObjLaterString;
//        info.otherButtonTitle = lObjApplyString;
//        
//        GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
//        lObjAlert.tag = 301;
//        [lObjAlert show];
//        [lObjAlert release];
//}

//-(void)didConfigureSuccessfully
//{
//    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Configuration Saved" message:@"Would you like to apply the new settings now?" confirmationData:[NSDictionary dictionary]];
//    info.cancelButtonTitle = @"Later";
//    info.otherButtonTitle = @"Apply";
//    
//    GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
//	lObjAlert.tag = 301;
//	[lObjAlert show];
//	[lObjAlert release];
//}



-(void)showConfirmationWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray {
    
    
    PostSummaryController *postController = [[PostSummaryController alloc] initWithControllerType:6];
    postController.postDictionary = [self returnConfirmManualConfigurationData];
    [self.navigationController pushViewController:postController animated:YES];
    
//    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Confirm Configuration Settings" message:nil confirmationData:[NSDictionary dictionary]];
//    info.cancelButtonTitle = aObjresponder;
//    info.otherButtonTitle = @"Save";
//    
//    GSUIAlertView *lObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleConfirmation delegate:self];
//    
//    lObjAlertView.tag = 1;
//    
//    UIView *lObjView = [[UIView alloc] init];
//	lObjView.frame = CGRectMake(0, 0, 244, 150);
//	[lObjView setBackgroundColor:[UIColor clearColor]];
//	[lObjAlertView.contentView addSubview:lObjView];
//	[lObjView release];
//    
//    [lObjAlertView setContentViewHeight:150];
//    
//	
//	NSArray *lObjTitleArray = [NSArray arrayWithObjects:@"SSID",@"Security",@"IP",@"Subnet Mask",@"Gateway",@"DNS Server",nil];
//    
//    
//	for (int count=0;count<=5;count++)
//	{
//		UILabel *lObjinfoTile = [[UILabel alloc] initWithFrame:CGRectMake(20, 30 + 20*count, 80, 20)];
//		lObjinfoTile.backgroundColor = [UIColor clearColor];
//		lObjinfoTile.text = [lObjTitleArray objectAtIndex:count];
//		lObjinfoTile.textColor = [UIColor blackColor];
//		lObjinfoTile.font = [UIFont boldSystemFontOfSize:12];
//		[lObjView addSubview:lObjinfoTile];
//		[lObjinfoTile release];
//		
//		UILabel *lObjinfo = [[UILabel alloc] initWithFrame:CGRectMake(110, 30 + 20*count, 120, 20)];
//		lObjinfo.backgroundColor = [UIColor clearColor];
//		lObjinfo.textColor = [UIColor blackColor];
//		lObjinfo.font = [UIFont systemFontOfSize:12];
//		lObjinfo.textAlignment = NSTextAlignmentRight;
//		[lObjView addSubview:lObjinfo];
//		[lObjinfo release];
//		
//		if (ipAdressType == IP_TYPE_DHCP && count == 2) {
//			
//			lObjinfo.text = @"Obtained by DHCP";
//			
//			break;
//		}
//		else {
//			
//			if ([[aObjinfoArray objectAtIndex:count] isEqualToString:@"wpa-personal"]) {
//				
//				lObjinfo.text = @"WPA/WPA2 Personal";
//				
//			}
//			else if ([[aObjinfoArray objectAtIndex:count] isEqualToString:@"wep"]){
//				
//				lObjinfo.text = @"WEP";
//			}
//            else if ([[aObjinfoArray objectAtIndex:count] isEqualToString:@"none"]){
//				
//				lObjinfo.text = @"None";
//			}
//			else
//			{
//				lObjinfo.text = [aObjinfoArray objectAtIndex:count];
//				
//			}
//			
//		}
//		
//	}
//	
//	[lObjAlertView show];
//	[lObjAlertView release];
	
}



//-(void)dismissViewController
//{
//	[lObjConfirmationPage dismissViewController];
//	
//}

-(void)goToIPSettingsScreen
{
	[lObjConfirmationPage dismissViewControllerAnimated:NO completion:nil];
	
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismissDone) userInfo:nil repeats:NO];
	
	
}
-(void)dismissDone
{
    
    Manual_IPSettingScreen *lObjManualIPSettingScreen = [[Manual_IPSettingScreen alloc] initWithControllerType:2];
    //lObjManualIPSettingScreen.m_cObjDelegate = self;
    [lObjManualIPSettingScreen indexOfRow:currentSelection];
    //lObjManualIPSettingScreen.manualSettingsEAP_Type =
    [self presentViewController:lObjManualIPSettingScreen animated:YES completion:nil];
	
}

-(NSString *)refreshSSIDStrForindex:(int)index
{
    return @"";
}
-(NSString *)refreshSignalStrengthForindex:(int)index
{
    return @"";
}
-(NSString *)refreshSecurityTypeForindex:(int)index
{
    return @"";
}
-(NSString *)refreshChannelNoForindex:(int)index
{
    return @"";
}



-(BOOL)refreshMode
{
	return refreshMode;
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
