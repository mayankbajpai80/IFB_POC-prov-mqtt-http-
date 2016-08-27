//
//  HTTPConnection.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 10/08/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPConnection : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate>

/**
 *  API Call for the POST Request
 *
 *  @param request  request  request URL
 *  @param postData postData Data which is to be POSTED in the body of URL
 *  @param callback callback response accordingly
 */
-(void)httpPostRequest: (NSMutableURLRequest *)request forPostData:(NSDictionary *)postData resultCallBack: (void (^)(NSDictionary *result, NSString *error))callback;

@end
