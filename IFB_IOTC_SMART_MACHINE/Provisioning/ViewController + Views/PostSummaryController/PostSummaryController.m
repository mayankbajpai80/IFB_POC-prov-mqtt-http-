//
//  PostSummaryController.m
//  Provisioning
//
//  Created by GainSpan India on 09/01/15.
//
//

#define CELL_LABEL_X_AXIS           10
#define CELL_LABEL_WIDTH            110
#define CELL_TEXTFIELD_X_AXIS       125
#define CELL_TEXTFIELD_WIDTH        160
#define CELL_HEIGHT                 44

#import "PostSummaryController.h"
#import "Identifiers.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "CommonProvMethods.h"
#import "ConcurrentModeInfoViewController.h"





@interface PostSummaryController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CustomUIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ProvisioningAppDelegate *appDelegate;

@property (nonatomic, strong) GS_ADK_Data *shareGsData;

@property (nonatomic, strong) NSMutableDictionary *concurrentDataDict;

@property (nonatomic, strong) NSMutableArray *summaryArray;

@property (nonatomic, assign) BOOL apply;


@end

@implementation PostSummaryController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
   // NSLog(@"view will appear");

   // NSLog(@"_postDictionary >>> %@",_postDictionary);
    
    [self createListToShowSummary];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NSLog(@"viewDidLoad");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationBar.title = @"Configuration Settings";
    
    _appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _shareGsData = (GS_ADK_Data *)[[GS_ADK_Data class]sharedInstance];
    
    _summaryArray = [[NSMutableArray alloc] init];
    

    CGRect frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}


- (void)navigationItemTapped:(NavigationItem)item {
    
    switch (item) {
            
        case NavigationItemBack:
            
            if ([_postDictionary[@"viewControllerMode"] isEqualToString:@"ModalViewController"]) {
             
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                
                [self.navigationController popViewControllerAnimated:YES];

            }
            

            break;
            
        case NavigationItemCancel:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case NavigationItemDone:
            
            [self postingDataOneByOne];
            
            break;
            
        case NavigationItemInfo:
            
           // [self showInfo];
            
            break;
            
        case  NavigationItemMode:
            
            break;
            
        default:
            break;
    }
}


-(NSString *)showStringForAnonymousAndCNOU:(NSString *)lObjStr {
    
    if ([lObjStr isEqualToString:@"true"]) {
        
        return @"On";
    }
    else {
        return @"Off";
    }
}

-(void)createListToShowSummary {
    
    int idx = 0;
    
    _summaryArray[idx++] = @{@"SSID": _postDictionary[@"ssid"]};
    _summaryArray[idx++] = @{@"Channel":_postDictionary[@"channel"]};
    _summaryArray[idx++] = @{@"Security":_postDictionary[@"security"]};
    
    if ([_postDictionary[@"security"] isEqualToString:@"wpa-enterprise"]) {
        
        _summaryArray[idx++] = @{@"EAP Type": _postDictionary[@"eap_type"]};
        
        if ([_postDictionary objectForKey:@"anon"]) {
            
            _summaryArray[idx++] = @{@"Use Anonymous ID": [self showStringForAnonymousAndCNOU:_postDictionary[@"anon"]]};
        }
        if ([_postDictionary objectForKey:@"cnou"]) {
            
            _summaryArray[idx++] = @{@"Configure CNOU": [self showStringForAnonymousAndCNOU:_postDictionary[@"cnou"]]};
        }
        
        if ([_postDictionary[@"cnou"] isEqualToString:@"true"]) {
            
             _summaryArray[idx++] = @{@"CN": _postDictionary[@"eap_cn"]};
             _summaryArray[idx++] = @{@"OU": _postDictionary[@"eap_ou"]};
        }
    
    }
    
    if ([_postDictionary[@"ip_type"] isEqualToString:@"static"]) {
        
        _summaryArray[idx++] = @{@"IP" : _postDictionary[@"ip_addr"]};
        _summaryArray[idx++] = @{@"Subnet Mask" : _postDictionary[@"subnetmask"]};
        _summaryArray[idx++] = @{@"Gateway" : _postDictionary[@"gateway"]};
        _summaryArray[idx++] = @{@"DNS Server" : _postDictionary[@"dns_addr"]};
    }
    
    
    //NSLog(@"_summaryArray = %@",_summaryArray);
}

-(void)postingDataOneByOne {
    
    [self uploadUTC_Time];
    
    
    [self uploadFile];
    
    
    [self alertForConfirmationPost];
    
}

-(void)uploadUTC_Time {
    
    if (globalValues.provisionSharedDelegate.UTC_Time_Supported == NO) {
        
        return;
    }
    
    
   // NSLog(@"%hhd",_appDelegate.utcSwitchState);
    
    if (globalValues.provisionSharedDelegate.utcSwitchState == NO) {
        
        return;
    }
    
    NSTimeInterval timeInMiliseconds = ([[NSDate date] timeIntervalSince1970]*1000);
    
    NSString *str = [NSString stringWithFormat:@"%lf",timeInMiliseconds];
    
    NSRange range = [str rangeOfString:@"."];
    
    NSString *actualStr = [str substringToIndex:range.location];
    
    NSString * timeString = [NSString stringWithFormat:@"<time> %@ </time>",actualStr];
    
    NSURL *timeUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_POST_URL_UTC_TIME,[_shareGsData m_gObjNodeIP],[_shareGsData currentIPAddress]]];
    
    NSMutableURLRequest *timeRequest = [NSMutableURLRequest requestWithURL:timeUrl];
    
    [timeRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [timeRequest setHTTPBody:[timeString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [timeRequest setHTTPMethod:@"POST"];
    
    NSURLResponse *response = nil;
    
    NSError *error = nil;
    
    NSData *lObjData = [NSURLConnection sendSynchronousRequest:timeRequest returningResponse:&response error:&error];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode] == 200) {
        
        NSLog(@"didReceiveResponse for utc time ");
        
    }
    else{
        
    }
    
    if (lObjData) {
        
    }
    
    if (error) {
        
        NSLog(@"error in utc time post");
        
        UIAlertView *fileError = [[UIAlertView alloc]initWithTitle:@"Error in UTC time post" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [fileError show];
        
    }
}

-(void)uploadFile {
    
    if(globalValues.provisionSharedDelegate.clientSecurityType == WPA_ENTERPRISE_SECURITY) {
        
        BOOL allCertificatesRequired = ([_postDictionary[@"eap_type"] isEqualToString:@"eap-tls"] && _shareGsData.isSupportsEAP_Option < 1) || ([_postDictionary[@"eap_type"] isEqualToString:@"eap-tls"] && _shareGsData.isSupportsEAP_Option >= 1);

        
        if([globalValues.provisionSharedDelegate.m_cObjRootCertPath isEqualToString:@""] || [globalValues.provisionSharedDelegate.m_cObjRootCertName isEqualToString:@"Attach Root Certificate"])
        {
            return;
        }
        else {
            
            NSData *rootCertData = [[NSData alloc] initWithContentsOfFile:globalValues.provisionSharedDelegate.m_cObjRootCertPath];
            
            NSData *clientCertData;
            NSData *clientkeyData ;
            
            if(allCertificatesRequired) {
                
                clientCertData = [[NSData alloc] initWithContentsOfFile:globalValues.provisionSharedDelegate.m_cObjClientCertPath];
                
                clientkeyData = [[NSData alloc] initWithContentsOfFile:globalValues.provisionSharedDelegate.m_cObjClientKeyPath];
                
            }
            
            NSString *urlString ;
            
            if(_shareGsData.isSupportsEAP_Option >= 1)
            {
                urlString = [NSString stringWithFormat:GSPROV_POST_URL_CERT_UPLOAD,[_shareGsData m_gObjNodeIP],[_shareGsData currentIPAddress]];
                
            }
            else {
                urlString = [NSString stringWithFormat:GSPROV_POST_URL_CERTIFICATAE,[_shareGsData m_gObjNodeIP],[_shareGsData currentIPAddress]];
                
            }
            
            
            
            // setting up the request object now
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            /*
             add some header info now
             we always need a boundary when we post a file
             also we need to set the content type
             
             You might want to generate a random boundary.. this is just the same
             as my output from wireshark on a valid html post
             */
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            /*
             now lets create the body of the post
             */
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
            
            if(allCertificatesRequired)
            {
                
                [body appendData:[@"Content-Disposition: form-data; name=\"TLS_CA\"; filename=\"file1.bin\"\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[NSData dataWithData:rootCertData]];
                
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                
                [body appendData:[@"Content-Disposition: form-data; name=\"TLS_CLIENT\"; filename=\"file2.bin\"\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[NSData dataWithData:clientCertData]];
                
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                
                [body appendData:[@"Content-Disposition: form-data; name=\"TLS_KEY\"; filename=\"file3.bin\"\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[NSData dataWithData:clientkeyData]];
                
                
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@",boundary] dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[@"--\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                
                
            }
            else {
                
                [body appendData:[@"Content-Disposition: form-data; name=\"TLS_CA\"; filename=\"file.bin\"\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[NSData dataWithData:rootCertData]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@",boundary] dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                [body appendData:[@"--\r\n" dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
                
                
            }
            
            
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            
            NSURLResponse *response = nil;
            
            NSError *error = nil;
            
            NSData *lObjData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if ([httpResponse statusCode] == 200) {
                
                //NSLog(@"file upload success");
            }
            else{
                
            }
            
            if (lObjData) {
                
            }
            
            if (error) {
                
                UIAlertView *fileError = [[UIAlertView alloc]initWithTitle:@"Error in file upload" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [fileError show];
            }
            
            
        }
        
    }
}

-(void)alertForConfirmationPost {
    
    //==== concurrent mode check ======
    
    NSString *lObjMessageString = nil;
    NSString *lObjApplyString = nil;
    NSString *lObjLaterString = nil;
    
    if (_shareGsData.supportDualInterface && _shareGsData.doesSupportConcurrentMode) {
        
        lObjMessageString = @"The settings will be saved.";
        
        lObjApplyString = nil;
        
        lObjLaterString = @"Ok";
    }
    else {
        
        lObjMessageString = @" The settings will be saved. Would you also like to apply the new settings right away?";
        
        lObjApplyString = @"Apply";
        
        lObjLaterString = @"Later";
    }
    
    NSLog(@"concurrent mode check");
    
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Confirmation" message:lObjMessageString confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = lObjLaterString;
    info.otherButtonTitle = lObjApplyString;
    
    GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    lObjAlert.tag = 301;
    [lObjAlert show];
    
}

-(void)postManualConfigurationWithMode:(BOOL)mode {
    
    [globalValues.provisionSharedDelegate activityIndicator:YES];
    
   // NSLog(@"postManualConfiguration");
    
    NSMutableString * xmlString = [[NSMutableString alloc] init];
    
    [xmlString appendString:@"<network>"];
    
    if (mode == YES) {
        
        _apply = YES;
        
        if (_shareGsData.doesSupportConcurrentMode /*&& !_shareGsData.supportDualInterface*/ && _shareGsData.currentMode == LimitedAPMode) {
            
            [xmlString appendString:@"<mode>client-verify</mode>"];
        }
        else {
            [xmlString appendString:@"<mode>client</mode>"];
        }
    }
    
    [xmlString appendString:@"<client><wireless>"];
    [xmlString appendFormat:@"<channel>%@</channel>", _postDictionary[@"channel"]];
    [xmlString appendFormat:@"<ssid>%@</ssid>", _postDictionary [@"ssid"]];
    [xmlString appendFormat:@"<security>%@</security>", _postDictionary [@"security"]];
    
       
    if ( [ _postDictionary [@"security"] isEqualToString:@"wpa/wpa2 enterprise"] || [ _postDictionary [@"security"] isEqualToString:@"wpa-enterprise"]) {
        
        [xmlString appendFormat:@"<eap_type>%@</eap_type>", _postDictionary[@"eap_type"]];

        
        [xmlString appendFormat:@"<eap_username>%@</eap_username>", _postDictionary[@"eap_username"]];
        
        [xmlString appendFormat:@"<eap_password>%@</eap_password>", _postDictionary[@"eap_password"]];
        
        if (_shareGsData.supportAnonymousID) {
            
            [xmlString appendFormat:@"<anon>%@</anon>", _postDictionary[@"anon"]];
            
            if ([_postDictionary[@"eap_type"] isEqualToString:@"eap-tls"]) {
                
                [xmlString appendFormat:@"<cnou>%@</cnou>", _postDictionary[@"cnou"]];
                
                if ([_postDictionary[@"cnou"] isEqualToString:@"true"]) {
                    
                    [xmlString appendFormat:@"<eap_cn>%@</eap_cn>", _postDictionary[@"eap_cn"]];

                    [xmlString appendFormat:@"<eap_ou>%@</eap_ou>", _postDictionary[@"eap_ou"]];

                }

            }

            
        }
        
    }
    else if ([ _postDictionary[@"security"] isEqualToString:@"wpa/wpa2 personal"] || [ _postDictionary[@"security"] isEqualToString:@"wpa-personal"]){
        
        
        [xmlString appendFormat:@"<password>%@</password>", _postDictionary[@"password"]];
        
    }
    else if ([_postDictionary[@"security"] isEqualToString:@"wep"]){
        
        [xmlString appendFormat:@"<password>%@:%@</password>", _postDictionary[@"wepKeyIndex"], _postDictionary[@"wepKey"]];
        
    }
    
    if (globalValues.provisionSharedDelegate.clientSecurityType == WEP_SECURITY) {
        
            [xmlString appendFormat:@"<wepauth>%@</wepauth>", _postDictionary[@"wepauth"]];
            
    }
    
    [xmlString appendString:@"</wireless><ip>"];
    
    if (globalValues.provisionSharedDelegate.ipAdressType == IP_TYPE_DHCP) {
        
        [xmlString appendFormat:@"<ip_type>%@</ip_type>",@"dhcp"];
        
    }
    else {
        
        [xmlString appendFormat:@"<ip_type>%@</ip_type>",@"static"];
        
        [xmlString appendFormat:@"<ip_addr>%@</ip_addr>",_postDictionary[@"ip_addr"]];
        
        [xmlString appendFormat:@"<subnetmask>%@</subnetmask>",_postDictionary[@"subnetmask"]];
        
        [xmlString appendFormat:@"<gateway>%@</gateway>",_postDictionary[@"gateway"]];
        
        [xmlString appendFormat:@"<dns_addr>%@</dns_addr>",_postDictionary[@"dns_addr"]];
    }
    
    [xmlString appendString:@"</ip></client></network>"];
    
    NSLog(@"manualClientModeConfig xmlString ======> %@",xmlString);
    
    NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_POST_URL_NETWORK_DETAILS,[_shareGsData m_gObjNodeIP],[_shareGsData currentIPAddress]]];
    
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    
    [serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [serviceRequest setHTTPMethod:@"POST"];
    
    [serviceRequest setTimeoutInterval:180.0];
    
    
    [NSURLConnection connectionWithRequest:serviceRequest delegate:self];
}


#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

    if([httpResponse statusCode] == 200)
    {
        //NSLog(@"success");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_shareGsData.doesSupportConcurrentMode)
    {
        
        UniversalParser *lObjUniversalParser = [[UniversalParser alloc] init];
        
        _concurrentDataDict = [[NSMutableDictionary alloc] initWithDictionary:[lObjUniversalParser dictionaryForXMLData:data]];
        
    NSLog(@"_concurrentDataDict = %@",_concurrentDataDict);
        
        
    }
    else {
        
       // NSLog(@"no data");
    }
    
}



-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
   
    [globalValues.provisionSharedDelegate activityIndicator:NO];
    
    if ( _apply && (!_shareGsData.doesSupportConcurrentMode || _shareGsData.currentMode == ClientMode)) {
        
        NSString *lObjString = [NSString stringWithFormat:@"Your device is now in %@ mode. Please re-connect to the device using your new wireless settings.",@"client"];
        
        
        UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:lObjString message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        lObjAlertView.tag = 6;
        lObjAlertView.delegate = self;
        [lObjAlertView show];
        
    }
    
    else if(_shareGsData.doesSupportConcurrentMode && _shareGsData.supportDualInterface && !_apply){
        
        UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"The settings were saved. Please ensure you have configured both the Client and Limited AP Settings, then choose Concurrent from the Set Mode screen" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        lObjAlertView.delegate = nil;
        [lObjAlertView show];
        
    }
    else if (_shareGsData.doesSupportConcurrentMode && _apply) {
        
        if ([[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"status"] objectForKey:@"text"] isEqualToString:@"success"]) {
            
            ConcurrentModeInfoViewController *concurrentInfoController = [[ConcurrentModeInfoViewController alloc] initWithControllerType:4];
            concurrentInfoController.concurrentInfoDict = [NSMutableDictionary dictionaryWithDictionary:_concurrentDataDict] ;
           // [self.navigationController pushViewController:concurrentInfoController animated:YES];
            
            [self presentViewController:concurrentInfoController animated:YES completion:nil];
            
        }
        else {
            
            NSString *lObjAlertString = nil;
            
            if ([[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"reason"]objectForKey:@"text"] length] > 0) {
                
                lObjAlertString = [NSString stringWithFormat:@"Error:%@ \n Reason:%@",[self convertErrorCodeToSting:[[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"error_code"]objectForKey:@"text"] intValue]],[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"reason"]objectForKey:@"text"]];
            }
            else {
                
                lObjAlertString = [NSString stringWithFormat:@"Error:%@ ",[self convertErrorCodeToSting:[[[[_concurrentDataDict objectForKey:@"verification"] objectForKey:@"error_code"]objectForKey:@"text"] intValue]]];
                
            }
            
            UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"Verification Failed" message:lObjAlertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            lObjAlertView.delegate = nil;
            [lObjAlertView show];
            
        }
    }
    else {
        
        NSLog(@"condition failed");
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [globalValues.provisionSharedDelegate activityIndicator:NO];
    
    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Lost connection, Please try again." message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    
}



#pragma mark - UIAlertView Delegate Methods:
-(void)alertView:(CustomUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 301) {
        
        if (buttonIndex == 0) {
            
            [self postManualConfigurationWithMode:NO];
        }
        else {
            
            [self postManualConfigurationWithMode:YES];
            
        }
        
    }
    else if (alertView.tag == 6) {
        
        exit(0);
    }
    else {
        
    }
}

#pragma mark - UITableView Delegate && DataSource Methods:

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_summaryArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
   //cell.textLabel.text = [NSString stringWithFormat:@"%@",[_titleArray objectAtIndex:indexPath.row]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 150, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = [NSString stringWithFormat:@"%@",[_summaryArray[indexPath.row] allKeys][0]];
 
    [cell.contentView addSubview:titleLabel];
    
    
    UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(CELL_TEXTFIELD_X_AXIS, 0, CELL_TEXTFIELD_WIDTH, CELL_HEIGHT)];
    lObjTextField.delegate=self;
    [lObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [lObjTextField setTextAlignment:NSTextAlignmentRight];
    [lObjTextField setFont:[UIFont systemFontOfSize:16]];
    //[lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
    [lObjTextField setTextColor:[UIColor darkGrayColor]];
    [lObjTextField setBackgroundColor:[UIColor clearColor]];
    [lObjTextField setReturnKeyType:UIReturnKeyDefault];
    [cell.contentView addSubview:lObjTextField];
    [lObjTextField setUserInteractionEnabled:NO];
    lObjTextField.text = [NSString stringWithFormat:@"%@",[_summaryArray[indexPath.row] allValues][0]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
