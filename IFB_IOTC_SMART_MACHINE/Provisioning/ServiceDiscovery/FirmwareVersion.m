//
//  FirmwareVersion.m
//  Provisioning
//
//  Created by GainSpan India on 25/02/15.
//
//

#import "FirmwareVersion.h"

@implementation FirmwareVersion

-(void)setFirmwareVersionValues:(NSDictionary *)lObjDict {
    
    NSDictionary *rootFirmwareDict = [lObjDict objectForKey:@"version"];
    
    NSDictionary *currentDict = [rootFirmwareDict objectForKey:@"current"];
    
    NSDictionary *presentDict = currentDict != nil ? currentDict : rootFirmwareDict;
    
    _app = [[NSString alloc] initWithString:[[presentDict objectForKey:@"app"] objectForKey:@"text"]];
    
    _geps = [[NSString alloc] initWithString:[[presentDict objectForKey:@"geps"] objectForKey:@"text"]];
    
    _wlan = [[NSString alloc] initWithString:[[presentDict objectForKey:@"wlan"] objectForKey:@"text"]];
    
    _chip = [[NSString alloc] initWithString:[[rootFirmwareDict objectForKey:@"chip"] objectForKey:@"text"]];
    
}

@end
