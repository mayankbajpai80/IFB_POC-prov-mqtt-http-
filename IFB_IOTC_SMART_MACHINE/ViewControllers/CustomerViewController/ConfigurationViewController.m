//
//  ConfigurationViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 04/08/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "MySingleton.h"
#import "TCPConnection.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Config";
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:4 forBarMetrics:UIBarMetricsDefault];
}

- (IBAction)applyConfiguration:(id)sender {
    NSString *dataString = @"<network><mode>concurrent</mode><ap_mode>user-ap</ap_mode><client><wireless><ssid>Testing</ssid><security>wpa-personal</security><channel>1</channel><password>IFB123$#</password></wireless><ip><ip_type>dhcp</ip_type></ip></client><ap><wireless><ssid>MAYANK</ssid><security>none</security><channel>1</channel><beacon_interval>100</beacon_interval></wireless><ip><ip_addr>192.168.240.1</ip_addr><gateway>192.168.240.1</gateway><dns_addr/><subnetmask>255.255.255.0</subnetmask><dhcp_server_enable>true</dhcp_server_enable><dns_server_enable>false</dns_server_enable><dhcp_start_addr>192.168.240.2</dhcp_start_addr><dhcp_num_addrs>8</dhcp_num_addrs></ip></ap><mac_addr>20:f8:5e:dd:08:cf</mac_addr><ip><ip_addr>192.168.240.1</ip_addr></ip><reg_domain>fcc</reg_domain></network>";
    [globalValues.tcpConnection performAction:dataString];
}

#pragma mark - UITextfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 4) {
        [textField resignFirstResponder];
    }
    else {
        UIView *next = [[textField superview] viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
    }
    return YES;
}


- (IBAction)hideTextfields:(id)sender {
    [self.view endEditing:YES];
}
@end
