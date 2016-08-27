//
//  GSAlertInfo.h
//  Alert_Test
//
//  Created by Vikash on 9/12/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSAlertInfo : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSString *cancelButtonTitle;

@property (nonatomic, strong) NSString *otherButtonTitle;

@property (nonatomic, strong) NSDictionary *confirmationData;

-(id)initWithTitle:(NSString *)title message:(NSString *)message confirmationData:(NSDictionary *)confirmationData;

+(id)infoWithTitle:(NSString *)title message:(NSString *)message confirmationData:(NSDictionary *)confirmationData;


@end
