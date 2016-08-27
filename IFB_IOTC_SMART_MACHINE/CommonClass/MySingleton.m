//
//  MySingleton.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 13/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "MySingleton.h"

@implementation MySingleton

@synthesize outputStream;

#pragma mark - singleton method

+ (MySingleton*)sharedInstance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    //static id sharedObject = nil;  //if you're not using ARC
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        //sharedObject = [[[self alloc] init] retain]; // if you're not using ARC
    });
    return sharedObject;
}

+ (id)parser {
    static MySingleton *responseParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        responseParser = [[self alloc] init];
    });
    return responseParser;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

@end
