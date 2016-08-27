//
//  APICallManager.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 09/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "APICallManager.h"
#import "SharedPrefrenceUtil.h"
#import "AppConstant.h"

@implementation APICallManager

//typedef void (^CallbackBlock)(NSDictionary *result, NSString *error);

-(void)httpPostRequest: (NSMutableURLRequest *)request forPostData:(NSDictionary *)postData resultCallBack: (void (^)(NSDictionary *result, NSString *error))callback {
    //NSLog(@"%@", postData);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [request setHTTPMethod:@"POST"];
    NSError *error;
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:&error]];
    //NSString *requestBody = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:postData options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    //NSLog(@"Request body is: %@", requestBody);
    
    
    // store cookies
    
    SharedPrefrenceUtil *sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
    if ([sharedPrefrenceUtil getNSObject:SAVED_COOKIES] != nil) {
        NSArray *saveCookies = (NSArray *)[sharedPrefrenceUtil getNSObject:SAVED_COOKIES];
        if ([saveCookies count] > 0 ) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[saveCookies objectAtIndex:0]];
        }
        
    }
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //NSLog(@"Request is: %@", request);
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *err)
                                  {
                                      // code after completion of task
                                      //NSLog(@"Response is :%@", response);
                                      if (response != nil) {
                                          NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          //NSLog(@"Body is: %@", strData);
                                          NSError *err1;
                                          if (strData != nil) {
                                              //NSData *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err1];
                                              
                                              // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                                              if (err1 != nil) {
                                                  NSLog(@"error is :%@", err1.localizedDescription);
                                                  NSLog(@"Error could not parse JSON: :%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                  NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err1];
                                                  callback(parsedJSON, nil);
                                              }
                                              else {
                                                  
                                                  // The JSONObjectWithData constructor didn't return an error. But, we should still
                                                  // check and make sure that json has a value using optional binding.
                                        
                                                  /*
                                                  NSLog(@"%@",json);
                                                  if ([[json valueForKey:@"status"] integerValue] == 0) {
                                                      NSLog(@"session Expired");
                                                  }
                                                  */
                                                  
                                                  NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err1];
                                                  
                                                  //NSLog(@"parsed JSON is :%@",parsedJSON);
                                                  callback(parsedJSON, nil);
                                              }
                                          }
                                          else {
                                              NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO], @"Server not responding", nil] forKeys:[NSArray arrayWithObjects:@"status", @"status", nil]];
                                              callback(dict, nil);
                                          }
                                      }
                                      else {
                                          NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO], @"Server not responding", nil] forKeys:[NSArray arrayWithObjects:@"status", @"status", nil]];
                                          callback(dict, nil);
                                      }
                                  }];
    [task resume];
}

-(void)httpGetRequest:(NSMutableURLRequest *)request resultCallBack: (void (^)(NSDictionary *result, NSString *error))callback {
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *err;
        if (response != nil) {
            //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            if (data != nil) {
                NSDictionary *JSON;
                if ([self isResponseJSON:data]) {
                    JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                }
                else {
                    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if ([dataString containsString:@"OK"]) {
                        return;
                    }
                }
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                if (err != nil) {
                    NSLog(@"%@", err.localizedDescription);
                    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"Error could not parse JSON:%@",jsonStr);
                }
                else {
                    // The JSONObjectWithData constructor didn't return an error. But, we should still
                    // check and make sure that json has a value using optional binding.
                    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                    //NSLog(@"parsed JSON is :%@",parsedJSON);
                    callback(parsedJSON, nil);
                }
            }
            else {
                NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO],@"Server not responding", nil] forKeys:[NSArray arrayWithObjects:@"status",@"message", nil]];
                callback(dict, nil);
                
            }
        }
        else {
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO],@"Server not responding", nil] forKeys:[NSArray arrayWithObjects:@"status",@"message", nil]];
            callback(dict, nil);
        }
    }];
    [task resume];
}



-(void)GetCSRFTokenRequest:(NSMutableURLRequest *)request resultCallBack: (void (^)(NSDictionary *result, NSString *error))callback {
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //NSError *err;
        if (response != nil) {
            //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            if (data != nil) {
                
                NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
                
                callback(headers, nil);
            }
            else {
                NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO],@"Server not responding", nil] forKeys:[NSArray arrayWithObjects:@"status",@"message", nil]];
                callback(dict, nil);
                
            }
        }
        else {
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO],@"Server not responding", nil] forKeys:[NSArray arrayWithObjects:@"status",@"message", nil]];
            callback(dict, nil);
        }
    }];
    [task resume];
}

-(BOOL)isResponseJSON: (NSData *)data {
    NSError *error;
    //NSData *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //NSLog(@"%@", json);
    if (error != nil) {
        return YES;
    }
    else {
        return NO;
    }
}
@end
