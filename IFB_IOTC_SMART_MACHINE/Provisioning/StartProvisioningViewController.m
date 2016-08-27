//
//  StartProvisioningViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 16/08/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "StartProvisioningViewController.h"
#import "GS_ADK_DataManger.h"
#import "Identifiers.h"
#import "APSettingsViewController.h"
#import "ServiceList.h"
#import "Manual_IP_Entry.h"
#import "ClientModeViewController.h"
#import "ActivationScreen.h"
#import "AdminSettingsViewController.h"
#import "GS_ADK_ServiceManager.h"
#import "Auth_Check.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Identifiers.h"
#import "ConcurrentModeInfoViewController.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"
#import "CredentialView.h"

//#import "UIViewController+AlertController.h"

#import "WifiInfoController.h"
#import "MySingleton.h"

@interface StartProvisioningViewController (privateMethods)<CustomUIAlertViewDelegate>

-(void)copyBinariesToDocumentsDirectory:(NSString *)_fileName;
-(NSString *)getDataTagForConnectionTag:(NSString *)pObjConnectionTag;
-(void)createKey;
-(void)initializeSplashScreen;
-(void)addLogo;
-(void)removeLogo;
-(void)removeActivationScreen;
-(void)retryPrePopulation;
-(void)checkAuthentication;

@end

@implementation StartProvisioningViewController

@synthesize ipAdressType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalValues.provisionSharedDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUI];
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    
    self.navigationItem.title = @"Provisioning";
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewVC)];
    self.navigationItem.leftBarButtonItem = barBtnItem;
}

-(void)popviewVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startProvisioning:(id)sender {
    UIViewController *wifiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiInfoController"];
    [self.navigationController pushViewController:wifiVC animated:YES];
}

-(void)activationDone {
    
    [self createKey];
    
    sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    //[self initializeSplashScreen];
    
}

-(void)createKey {
    
    _m_cObjRootCertName = @"Attach Root Certificate";
    
    _m_cObjClientCertName = @"Attach Client Certificate";
    
    _m_cObjClientKeyName = @"Attach Client Key";
    
    _m_cObjRootCertPath = @"";
    
    _m_cObjClientCertPath = @"";
    
    _m_cObjClientKeyPath = @"";
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *destPath = [documentsDirectory stringByAppendingPathComponent:@"Key.text"];
    
    [[NSFileManager defaultManager] createFileAtPath:destPath contents:nil attributes:nil];
}

#pragma mark -

-(void)showActivityIndicatorWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder {
    
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
    
    m_cObjAlertView.delegate = self;
    m_cObjAlertView.tag = 90001;
    [m_cObjAlertView show];
}

-(void)showConfirmationForManualConfigWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray {
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Confirm Configuration Settings" message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = aObjresponder;
    info.otherButtonTitle = @"Save";
    
    m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleConfirmation delegate:self];
    m_cObjAlertView.tag=4;
    m_cObjAlertView.delegate = self;
    
    [m_cObjAlertView setContentViewHeight:170];
    
    UIView *lObjView = [[UIView alloc] init];
    lObjView.frame = CGRectMake(20, 20, 244, 170);
    [lObjView setBackgroundColor:[UIColor clearColor]];
    [m_cObjAlertView.contentView addSubview:lObjView];
    
    
    NSArray *lObjTitleArray = [NSArray arrayWithObjects:@"SSID",@"Security",@"IP",@"Subnet Mask",@"Gateway",@"DNS Server",nil];
    
    for (int count=0;count<2;count++)
    {
        UILabel *lObjinfoTile = [[UILabel alloc] initWithFrame:CGRectMake(20, 70 + 20*count, 80, 20)];
        lObjinfoTile.backgroundColor = [UIColor clearColor];
        lObjinfoTile.text = [lObjTitleArray objectAtIndex:count];
        lObjinfoTile.textColor = [UIColor blackColor];
        lObjinfoTile.font = [UIFont boldSystemFontOfSize:12];
        [lObjView addSubview:lObjinfoTile];
        
        UILabel *lObjinfo = [[UILabel alloc] initWithFrame:CGRectMake(110, 70 + 20*count, 120, 20)];
        lObjinfo.backgroundColor = [UIColor clearColor];
        
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
        
        lObjinfo.textColor = [UIColor blackColor];
        lObjinfo.font = [UIFont systemFontOfSize:12];
        lObjinfo.textAlignment = NSTextAlignmentRight;
        [lObjView addSubview:lObjinfo];
    }
    
    [m_cObjAlertView show];
    
}


-(void)showConfirmationWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray {
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Confirm Configuration Settings" message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = aObjresponder;
    info.otherButtonTitle = @"Save";
    
    m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleConfirmation delegate:self];
    m_cObjAlertView.tag=1;
    m_cObjAlertView.delegate = self;
    
    [m_cObjAlertView setContentViewHeight:170];
    
    UIView *lObjView = [[UIView alloc] init];
    lObjView.frame = CGRectMake(20, 20, 244, 170);
    [lObjView setBackgroundColor:[UIColor clearColor]];
    [m_cObjAlertView.contentView addSubview:lObjView];
    
    
    NSArray *lObjTitleArray = [NSArray arrayWithObjects:@"SSID",@"Security",@"IP",@"Subnet Mask",@"Gateway",@"DNS Server",nil];
    
    for (int count=0;count<=5;count++)
    {
        UILabel *lObjinfoTile = [[UILabel alloc] initWithFrame:CGRectMake(20, 70 + 20*count, 80, 20)];
        lObjinfoTile.backgroundColor = [UIColor clearColor];
        lObjinfoTile.text = [lObjTitleArray objectAtIndex:count];
        lObjinfoTile.textColor = [UIColor blackColor];
        lObjinfoTile.font = [UIFont boldSystemFontOfSize:12];
        [lObjView addSubview:lObjinfoTile];
        
        UILabel *lObjinfo = [[UILabel alloc] initWithFrame:CGRectMake(110, 70 + 20*count, 120, 20)];
        lObjinfo.backgroundColor = [UIColor clearColor];
        lObjinfo.textColor = [UIColor blackColor];
        lObjinfo.font = [UIFont systemFontOfSize:12];
        lObjinfo.textAlignment = NSTextAlignmentRight;
        [lObjView addSubview:lObjinfo];
        
        if (ipAdressType == IP_TYPE_DHCP && count == 2) {
            
            lObjinfo.text = @"Obtained by DHCP";
            break;
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
        
    }
    
    [m_cObjAlertView show];
    
}

-(void)showConfirmationForManualIPEntryWithTitle:(NSString *)aObjtitle messageTitle:(NSString *)aObjmessage responderTitle:(NSString *)aObjresponder info:(NSArray *)aObjinfoArray manualEntry:(NSArray *)aObjManualInfo {
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Confirm Configuration Settings" message:nil confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = aObjresponder;
    info.otherButtonTitle = @"Save";
    
    m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleConfirmation delegate:self];
    m_cObjAlertView.tag=5;
    m_cObjAlertView.delegate = self;
    
    [m_cObjAlertView setContentViewHeight:170];
    
    UIView *lObjView = [[UIView alloc] init];
    lObjView.frame = CGRectMake(20, 20, 244, 170);
    [lObjView setBackgroundColor:[UIColor clearColor]];
    [m_cObjAlertView.contentView addSubview:lObjView];
    
    
    NSArray *lObjTitleArray = [NSArray arrayWithObjects:@"SSID",@"Security",@"IP",@"Subnet Mask",@"Gateway",@"DNS Server",nil];
    
    for (int count=0;count<=5;count++)
    {
        UILabel *lObjinfoTile = [[UILabel alloc] initWithFrame:CGRectMake(20, 70 + 20*count, 80, 20)];
        lObjinfoTile.backgroundColor = [UIColor clearColor];
        lObjinfoTile.text = [lObjTitleArray objectAtIndex:count];
        lObjinfoTile.textColor = [UIColor whiteColor];
        lObjinfoTile.font = [UIFont boldSystemFontOfSize:12];
        [lObjView addSubview:lObjinfoTile];
        
        UILabel *lObjinfo = [[UILabel alloc] initWithFrame:CGRectMake(110, 70 + 20*count, 120, 20)];
        lObjinfo.backgroundColor = [UIColor clearColor];
        
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
        
        lObjinfo.textColor = [UIColor whiteColor];
        lObjinfo.font = [UIFont systemFontOfSize:12];
        lObjinfo.textAlignment = NSTextAlignmentRight;
        [lObjView addSubview:lObjinfo];
    }
    
    [m_cObjAlertView show];
}



-(void)hideActivityIndicator {
    
    NSLog(@" app delegate hideActivityIndicator");
    
    if (m_cObjAlertView) {
        
        if ([m_cObjAlertView isKindOfClass:[UIAlertView class]]) {
            
            NSLog(@" UIAlertView class");
            
            
            [m_cObjAlertView dismissWithClickedButtonIndex:0 animated:YES];
            
        }
        else if (([m_cObjAlertView isKindOfClass:[UIView class]])) {
            
            NSLog(@" UIView class");
            
            
            [m_cObjAlertView removeFromSuperview];
        }
        
    }
}


-(void)setMode:(NSInteger)mode {
    
    m_cObjSetMode = mode;
    
    
    if (sharedGsData.doesSupportConcurrentMode) {
        
        if (m_cObjSetMode == 1) {
            
            [self showConfirmationAlert];
        }
        else {
            
            [self postModeConfigurationSettings];
            
        }
        
    }
    else {
        
        [self showConfirmationAlert];
    }
}

-(void)showConfirmationAlert {
    
    UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"This will apply the settings. Click \"OK\" and then re-connect to the device" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    lObjAlertView.tag = 10;
    [lObjAlertView show];
}

-(void)activityIndicator:(BOOL)show  {
    
    if(show == YES)
    {
        m_cObjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [m_cObjView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.82]];
        [self.window addSubview:m_cObjView];
        
        UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2-65, [UIScreen mainScreen].bounds.size.width-20, 40)];
        lObjLabel.backgroundColor = [UIColor clearColor];
        lObjLabel.textAlignment = NSTextAlignmentCenter;
        lObjLabel.textColor = [UIColor whiteColor];
        lObjLabel.font = [UIFont systemFontOfSize:16];
        lObjLabel.numberOfLines = 2;
        [m_cObjView addSubview:lObjLabel];
        
        if (sharedGsData.doesSupportConcurrentMode) {
            
            if (m_cObjSetMode == 1) {
                
                lObjLabel.text = @"Saving.......";
                
            }
            else {
                
                lObjLabel.text = @"Verifying that the device can connect to the target AP.";
                
            }
        }
        else {
            
            lObjLabel.text = @"Saving.......";
            
        }
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-45/2, [UIScreen mainScreen].bounds.size.height/2-45/2, 45, 45);
        [m_cObjView addSubview:activityIndicator];
        [activityIndicator startAnimating];
    }
    else {
        
        [m_cObjView removeFromSuperview];
    }
    
    
}

//_setModeButtonPress

-(void)postModeConfigurationSettings {
    
    NSLog(@"postModeConfigurationSettings");
    
    [self activityIndicator:YES];
    
    NSMutableString * xmlString = [[NSMutableString alloc] init];
    
    [xmlString appendString:@"<network>"];
    
    switch (m_cObjSetMode) {
            
        case 0:
            if (sharedGsData.doesSupportConcurrentMode) {
                
                [xmlString appendString:@"<mode>client-verify</mode>"];
            }
            else {
                
                [xmlString appendString:@"<mode>client</mode>"];
            }
            break;
            
        case 1:
            [xmlString appendString:@"<mode>limited-ap</mode>"];
            
            break;
            
        case 2:
            [xmlString appendString:@"<mode>concurrent</mode>"];
            
            break;
            
        default:
            break;
    }
    
    
    [xmlString appendString:@"</network>"];
    
    NSLog(@"mode post = %@",xmlString);
    
    NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_POST_URL_NETWORK_DETAILS,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
    
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    
    [serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [serviceRequest setHTTPMethod:@"POST"];
    
    [serviceRequest setTimeoutInterval:180.0];
    
    [serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [NSURLConnection connectionWithRequest:serviceRequest delegate:self];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (sharedGsData.doesSupportConcurrentMode) {
        
        if (data != nil) {
            
            UniversalParser *lObjUniversalParser = [[UniversalParser alloc] init];
            
            NSDictionary *concurrentModeDictionary = [[NSDictionary alloc] initWithDictionary:[lObjUniversalParser dictionaryForXMLData:data]];
            
            [self activityIndicator:NO];
            
            NSLog(@"didReceiveData ===>>>  %@",concurrentModeDictionary);
            
            if ([concurrentModeDictionary allKeys].count > 0) {
                
                if ([concurrentModeDictionary objectForKey:@"status"]) {
                    
                    [self showAlertToRebootDevice];
                    
                }
                else if ([[[[concurrentModeDictionary objectForKey:@"verification"] objectForKey:@"status"] objectForKey:@"text"] isEqualToString:@"success"]){
                    
                    ConcurrentModeInfoViewController *concurrentModeInfo = [[ConcurrentModeInfoViewController alloc] initWithControllerType:4];
                    concurrentModeInfo.concurrentInfoDict = [NSMutableDictionary dictionaryWithDictionary:concurrentModeDictionary];
                    self.window.rootViewController = concurrentModeInfo;
                    
                    
                }
                else {
                    
                    NSString *lObjAlertString = nil;
                    
                    if ([[[[concurrentModeDictionary objectForKey:@"verification"] objectForKey:@"reason"]objectForKey:@"text"] length] > 0) {
                        
                        lObjAlertString = [NSString stringWithFormat:@"Error:%@ \n Reason:%@",[self convertErrorCodeToSting:[[[[concurrentModeDictionary objectForKey:@"verification"] objectForKey:@"error_code"]objectForKey:@"text"] intValue]],[[[concurrentModeDictionary objectForKey:@"verification"] objectForKey:@"reason"]objectForKey:@"text"]];
                    }
                    else {
                        
                        lObjAlertString = [NSString stringWithFormat:@"Error:%@ ",[self convertErrorCodeToSting:[[[[concurrentModeDictionary objectForKey:@"verification"] objectForKey:@"error_code"]objectForKey:@"text"] intValue]]];
                        
                    }
                    
                    UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"Verification Failed" message:lObjAlertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    lObjAlertView.delegate = nil;
                    [lObjAlertView show];
                    
                }
                
            }
            
        }
    }
    
}

-(NSString *)convertErrorCodeToSting:(int)errorCode {
    
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

-(void)showAlertToRebootDevice {
    
    NSString *lObjModeString = nil;
    
    switch (m_cObjSetMode) {
        case 0:
            lObjModeString = @"client";
            break;
            
        case 1:
            lObjModeString = @"limited-ap";
            break;
            
        case 2:
            lObjModeString = @"concurrent";
            break;
            
        default:
            lObjModeString = @"";
            break;
    }
    
    
    
    NSString *lObjString = [NSString stringWithFormat:@"Your device is now in %@ mode. Please re-connect to the device using your new wireless settings.",lObjModeString];
    
    
    UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:lObjString message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    lObjAlertView.tag = 6;
    lObjAlertView.delegate = self;
    [lObjAlertView show];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (sharedGsData.doesSupportConcurrentMode) {
        
        [self activityIndicator:NO];
    }
    else {
        
        NSString *lObjModeString = nil;
        
        switch (m_cObjSetMode) {
            case 0:
                lObjModeString = @"client";
                break;
                
            case 1:
                lObjModeString = @"limited-ap";
                break;
                
            case 2:
                lObjModeString = @"concurrent";
                break;
                
            default:
                lObjModeString = @"";
                break;
        }
        
        
        
        NSString *lObjString = [NSString stringWithFormat:@"Your device is now in %@ mode. Please re-connect to the device using your new wireless settings.",lObjModeString];
        
        
        UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:lObjString message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        lObjAlertView.tag = 6;
        lObjAlertView.delegate = self;
        [lObjAlertView show];
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self activityIndicator:NO];
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Mode could not be changed" message:[error localizedDescription] confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"OK";
    info.otherButtonTitle = nil;
    
    m_cObjAlertView = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    m_cObjAlertView.tag = 7;
    m_cObjAlertView.delegate = self;
    [m_cObjAlertView show];
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //NSLog(@"buttonIndex = %d",buttonIndex);
    
    if (alertView.tag == 10) {
        
        if (buttonIndex == 1) {
            
            [self postModeConfigurationSettings];
        }
    }
	   
    if (alertView.tag == 6) {
        
        [self activityIndicator:NO];
        
        exit(1);
        
        
        return;
    }
    if (alertView.tag == 8) {
        
        
        [self checkAuthentication];
        
        return;
    }
    
}

@end
