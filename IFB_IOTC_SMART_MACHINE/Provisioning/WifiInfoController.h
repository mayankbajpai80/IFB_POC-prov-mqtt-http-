//
//  WifiInfoController.h
//  SampleORCodeFlow
//
//  Created by GainSpan India on 22/01/14.
//  Copyright (c) 2014 GainSpan. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "QRCodeController.h"

//#import "GSViewController.h"
//#import "ProvisioningAppDelegate.h"


@interface WifiInfoController : UIViewController  {
    
    //ProvisioningAppDelegate *appDelegate;
    
}
@property (nonatomic, assign) BOOL wifiON;

+ (NSString *)fetchSSIDInfo;

@end
