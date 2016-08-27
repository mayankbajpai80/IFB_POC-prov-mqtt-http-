//
//  FirmwareVersion.h
//  Provisioning
//
//  Created by GainSpan India on 25/02/15.
//
//

#import <Foundation/Foundation.h>

@interface FirmwareVersion : NSObject

@property (nonatomic, strong) NSString *wlan;

@property (nonatomic, strong) NSString *geps;

@property (nonatomic, strong) NSString *app;

@property (nonatomic, strong) NSString *chip;

-(void)setFirmwareVersionValues:(NSDictionary *)lObjDict;

@end
