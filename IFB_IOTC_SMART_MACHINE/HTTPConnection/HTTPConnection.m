//
//  HTTPConnection.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 10/08/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "HTTPConnection.h"

@implementation HTTPConnection
-(void)httpPostRequest: (NSMutableURLRequest *)request forPostData:(NSDictionary *)postData resultCallBack: (void (^)(NSDictionary *result, NSString *error))callback {
    //NSLog(@"%@", postData);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData valueForKey:@"Command"]];
    NSError *error;

    //NSString *requestBody = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:postData options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    //NSLog(@"Request body is: %@", requestBody);
 
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *err)
                                  {
                                      // code after completion of task
                                      if (response != nil) {
                                          NSError *err1;
                                          if (data != nil) {
                                              
                                              // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                                              if (err1 != nil) {
                                                  NSLog(@"error is :%@", err1.localizedDescription);
                                                  NSLog(@"Error could not parse JSON: :%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                  NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err1];
                                                  callback(parsedJSON, nil);
                                              }
                                              else {
                                                  NSDictionary *dict = [NSDictionary dictionaryWithObject:data forKey:@"data"];
                                                  //NSLog(@"parsed JSON is :%@",parsedJSON);
                                                  callback(dict, nil);
                                              }
                                          }
                                          else {
                                              NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO], @"data in response is nil.", nil] forKeys:[NSArray arrayWithObjects:@"status", @"status", nil]];
                                              callback(dict, nil);
                                          }
                                      }
                                      else {
                                          NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO], @"nil Response.", nil] forKeys:[NSArray arrayWithObjects:@"status", @"status", nil]];
                                          callback(dict, nil);
                                      }
                                  }];
    [task resume];
}
@end
