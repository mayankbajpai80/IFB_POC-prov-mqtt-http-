//
//  WifiInfoController.m
//  SampleORCodeFlow
//
//  Created by GainSpan India on 22/01/14.
//  Copyright (c) 2014 GainSpan. All rights reserved.
//

#import "WifiInfoController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
//#import "Macro.h"
//#import "ServiceListViewController.h"
#import "Identifiers.h"
//#import "LineView.h"


#define SSID_LABEL_HEIGHT         50
#define SSID_LABEL_Y_AXIS_POINT   150
#define BUTTON_WIDTH              150
#define BUTTON_HEIGHT             40

@interface WifiInfoController ()

@end

@implementation WifiInfoController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    self.navigationItem.title=@"Back";
    
     self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {

    [self setUI];
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    
    self.navigationController.navigationBarHidden = NO;

    self.navigationItem.title = @"Provisioning";
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewVC)];
    self.navigationItem.leftBarButtonItem = barBtnItem;
}

-(void)popviewVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //appDelegate.appRunningInBackground = YES;
    
    [self loadPage];
}

-(void)loadPage {

    self.navigationItem.title = @"Provisioning";
    
    NSString *lObjSSID = [WifiInfoController fetchSSIDInfo];
    
    UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SSID_LABEL_Y_AXIS_POINT, [UIScreen mainScreen].bounds.size.width-20, SSID_LABEL_HEIGHT)];
    [lObjLabel setBackgroundColor:[UIColor clearColor]];

    [lObjLabel setBaselineAdjustment:UIBaselineAdjustmentNone];
    [lObjLabel setNumberOfLines:3];
    [lObjLabel setTextAlignment:NSTextAlignmentCenter];
    //[lObjLabel setTextColor:[UIColor darkTextColor]];
    [self.view addSubview:lObjLabel];
    
      NSString * lObjSSID_NameString = nil;
    
    NSMutableAttributedString * lObjAttributedString = nil;
    
    if (lObjSSID != nil) {
        
        // [lObjLabel setText:[NSString stringWithFormat:@"Your are currently connected to this SSID: %@",lObjSSID]];
        
        lObjSSID_NameString = [NSString stringWithFormat:@"You are currently connected to this Network: %@",lObjSSID];
        
        lObjAttributedString = [[NSMutableAttributedString alloc] initWithString:lObjSSID_NameString];
        
        NSRange boldedRange = NSMakeRange(36, [lObjAttributedString length]-36);
        
       // [lObjAttributedString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15] range:boldedRange];
        [lObjAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:boldedRange];
        [lObjAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:(51/255.0) green:(102/255.0) blue:0 alpha:1] range:boldedRange]; // if needed
        
        [lObjLabel setAttributedText: lObjAttributedString];

        _wifiON = YES;
    }
    else {
        
        // [lObjLabel setText:[NSString stringWithFormat:@"Your are not connected to any SSID"]];
        
        lObjSSID_NameString = [NSString stringWithFormat:@"You are currently not connected to any Network: "];
        
        lObjAttributedString = [[NSMutableAttributedString alloc] initWithString:lObjSSID_NameString];
        
        [lObjLabel setAttributedText: lObjAttributedString];

        _wifiON = NO;
        
    }

    UIButton *lObjContinueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [lObjContinueButton setBackgroundColor:[UIColor clearColor]];
    [lObjContinueButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-150/2, lObjLabel.frame.origin.y+lObjLabel.frame.size.height+MARGIN, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [lObjContinueButton setTitle:@"Continue" forState:UIControlStateNormal];
    [lObjContinueButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lObjContinueButton addTarget:self action:@selector(discoveryMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lObjContinueButton];
} 

+ (NSString *)fetchSSIDInfo {
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    
    id info = nil;
    
    for (NSString *ifnam in ifs) {
        
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
        
        if (info && [info count]) {
            break;
        }
        
    }
    
    NSLog(@"info = %@ || %@",info,[info objectForKey:@"SSID"]);
    
    return [info objectForKey:@"SSID"] ;
}

- (void)discoveryMethod {

    _wifiON = YES;
    
    if (!_wifiON) {
        
        UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"Network Info" message:@"Please go to your wi-fi setting, choose your network and again start your app " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [lObjAlertView show];
        
        return;
    }
    else {
        
        NSLog(@"Continue...");
        UIViewController *serviceListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceListViewController"];
        [self.navigationController pushViewController:serviceListVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
