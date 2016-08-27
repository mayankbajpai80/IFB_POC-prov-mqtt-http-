//
//  AppDelegate.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 09/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomViewUtils.h"
#import "SharedPrefrenceUtil.h"
#import "AppConstant.h"
#import "CustomViewUtils.h"

// for test
#import "DeviceOpertaionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*
    //check session status
    SharedPrefrenceUtil *sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
    CustomViewUtils *customViewUtils = [[CustomViewUtils alloc] init];
    NSLog(@"%@",[sharedPrefrenceUtil getNSObject:USER_ID]);
    
    if ([sharedPrefrenceUtil getNSObject:USER_ID] != nil) {
        UIViewController *viewController = [customViewUtils loadUserHomeView];
        self.window.rootViewController = viewController;
    }
    else {
        UINavigationController *navController = [customViewUtils loadFirstView];
        self.window.rootViewController = navController;
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DeviceOpertaionViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"DeviceOpertaionViewController"];
    self.window.rootViewController = loginVC;
    */
    
    // customize navigation bar when app launches.
    CustomViewUtils *customViewUtils = [[CustomViewUtils alloc] init];
    [customViewUtils makeCustomNavigationView];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
