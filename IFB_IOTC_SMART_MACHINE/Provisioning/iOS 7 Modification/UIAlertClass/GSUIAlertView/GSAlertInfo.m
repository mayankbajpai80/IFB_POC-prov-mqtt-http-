//
//  GSAlertInfo.m
//  Alert_Test
//
//  Created by Vikash on 9/12/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import "GSAlertInfo.h"

@interface GSAlertInfo ()


@end

@implementation GSAlertInfo

-(id)initWithTitle:(NSString *)title message:(NSString *)message confirmationData:(NSDictionary *)confirmationData
{

    self = [super init];
    
    if (self) {
        
        _title = title;
        _message = message;
        _confirmationData = confirmationData;
    
    }
    
    return self;
}

+(id)infoWithTitle:(NSString *)title message:(NSString *)message confirmationData:(NSDictionary *)confirmationData
{
    
    return [[self alloc] initWithTitle:title message:message confirmationData:confirmationData];
    
}

@end
