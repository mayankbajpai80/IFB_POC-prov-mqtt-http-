//
//  APICallManager.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 09/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface APICallManager : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate>

/**
 *  API Call for the POST Request
 *
 *  @param request  request  request URL
 *  @param postData postData Data which is to be POSTED in the body of URL
 *  @param callback callback response accordingly
 */
-(void)httpPostRequest: (NSMutableURLRequest *)request forPostData:(NSDictionary *)postData resultCallBack: (void (^)(NSDictionary *result, NSString *error))callback;

/**
 *  API Call for the GET Request
 *
 *  @param request  request  request URL
 *  @param callback callback response accordingly
 */
-(void)httpGetRequest:(NSMutableURLRequest *)request resultCallBack: (void (^)(NSDictionary *result, NSString *error))callback;

-(void)GetCSRFTokenRequest:(NSMutableURLRequest *)request resultCallBack: (void (^)(NSDictionary *result, NSString *error))callback;

@end
