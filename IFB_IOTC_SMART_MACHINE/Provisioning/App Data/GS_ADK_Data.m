/*******************************************************************************
 *
 *               COPYRIGHT (c) 2009-2010 GainSpan Corporation
 *                         All Rights Reserved
 *
 * The source code contained or described herein and all documents
 * related to the source code ("Material") are owned by GainSpan
 * Corporation or its licensors.  Title to the Material remains
 * with GainSpan Corporation or its suppliers and licensors.
 *
 * The Material is protected by worldwide copyright and trade secret
 * laws and treaty provisions. No part of the Material may be used,
 * copied, reproduced, modified, published, uploaded, posted, transmitted,
 * distributed, or disclosed in any way except in accordance with the
 * applicable license agreement.
 *
 * No license under any patent, copyright, trade secret or other
 * intellectual property right is granted to or conferred upon you by
 * disclosure or delivery of the Materials, either expressly, by
 * implication, inducement, estoppel, except in accordance with the
 * applicable license agreement.
 *
 * Unless otherwise agreed by GainSpan in writing, you may not remove or
 * alter this notice or any other notice embedded in Materials by GainSpan
 * or GainSpan's suppliers or licensors in any way.
 *
 * $RCSfile: GS_ADK_Data.m,v $
 *
 * Description : Implementaion file for GS_ADK_Data public/private functions and data structures
 *******************************************************************************/

#import "GS_ADK_Data.h"
#import "Identifiers.h"
#import "FirmwareVersion.h"

@implementation GS_ADK_Data

@synthesize systemApi,apList,apConfig,configId,apiVersion,security,adminSettings;

@synthesize m_cObjIPAddress,m_cObjSubnetMask,m_cObjGateway,m_cObjDNSAddress,securedMode,m_cObjDomainName;

@synthesize confirmationScreen_Password,WEP_Index,wpaEnabled,m_cObjSSID_Str,manualConfigMode,m_gObjNodeIP,chipStatus,setChannelLabelString
;

@synthesize scanParameterDict, isSupportsEAP_Option;


+ (id)sharedInstance {
	
	static GS_ADK_Data *myInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        myInstance = [[GS_ADK_Data alloc] init];
    });
	
//	if (!myInstance) {
//		
//		myInstance = [[[self class] alloc] init]; 
//		
//		// any other special initialization as required here
//
//		}
	
	return myInstance;
	
}


-(void)setCurrentSSID:(NSString *)pObjString
{
	
	m_cObjSSID_Str = [[NSString alloc] initWithString:pObjString];

}

- (void)setData:(NSMutableDictionary *)pObjData {
    		    
	if ([[[pObjData allKeys] objectAtIndex:0] isEqualToString:GSPROV_DATA_AP_LIST]) {
		
                
        NSMutableDictionary *lObjAPListDict = [pObjData objectForKey:@"ap_list"];
        
        if([[lObjAPListDict objectForKey:@"ap"] isKindOfClass:[NSDictionary class]]) {
            
        }
        else if ([[lObjAPListDict objectForKey:@"ap"] isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *lObjAPArray = [lObjAPListDict objectForKey:@"ap"];
            
            NSMutableArray *removeIndexArray = [[NSMutableArray alloc] init];
            
            for (int index=0; index < lObjAPArray.count; index++) {
                
                NSDictionary *lObjDict = [lObjAPArray objectAtIndex:index];
                
                NSString *lObjSSID = [[lObjDict objectForKey:@"ssid"] objectForKey:@"text"];
                
                if([lObjSSID isEqualToString:@""] || lObjSSID.length == 0) {
                    
                    [removeIndexArray addObject:[NSString stringWithFormat:@"%d",index]];
                }
            }
            
            for (NSInteger removeIndex = removeIndexArray.count; removeIndex > 0 ; removeIndex--) {
                
                [lObjAPArray removeObjectAtIndex:[[removeIndexArray objectAtIndex:removeIndex - 1] integerValue]];
            }
            
            
            [lObjAPListDict setObject:lObjAPArray forKey:@"ap"];
            
            [pObjData setValue:lObjAPListDict forKey:@"ap_list"];
            
        }
        
        apList = [[NSMutableDictionary alloc] initWithDictionary:pObjData];

      
		
	}
	else if ([[[pObjData allKeys] objectAtIndex:0] isEqualToString:GSPROV_DATA_ID]){
		
		
		configId = [[NSMutableDictionary alloc] initWithDictionary:pObjData];
		
	}
	else if ([[[pObjData allKeys] objectAtIndex:0] isEqualToString:GSPROV_DATA_NETWORK_DETAILS]){
				
		apConfig = [[NSMutableDictionary alloc] initWithDictionary:pObjData];
        
        [self checkCurrentMode:[[[apConfig objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"]];
		        
        [[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] removeObjectForKey:@"text"];
        [[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"ip"] removeObjectForKey:@"text"];
        [[[apConfig objectForKey:@"network"] objectForKey:@"ap"]removeObjectForKey:@"text"];
		
        [[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] removeObjectForKey:@"text"];
        [[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"ip"] removeObjectForKey:@"text"];
        [[[apConfig objectForKey:@"network"] objectForKey:@"client"]removeObjectForKey:@"text"];
		
		
		NSArray *lObjArray =  [[[[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"password"] objectForKey:@"text"] componentsSeparatedByString:@":"];
		
		if ([lObjArray count] == 2) {
			
			[[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:[lObjArray objectAtIndex:0] forKey:@"text"] forKey:@"wepKeyIndex"];
			
			[[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:[lObjArray objectAtIndex:1] forKey:@"text"] forKey:@"wepKey"];
            
            //[[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:@"" forKey:@"text"] forKey:@"wepKey"];

			
			[[[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"password"] setValue:@"" forKey:@"text"];
            
			
			
		}
		else {
			
			[[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:@"" forKey:@"text"] forKey:@"wepKey"];
						
			[[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:@"" forKey:@"text"] forKey:@"wepKeyIndex"];
			
			[[[[[apConfig objectForKey:@"network"] objectForKey:@"ap"] objectForKey:@"wireless"] objectForKey:@"password"] setValue:@"" forKey:@"text"];
            
		}
		
		lObjArray =  [[[[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"password"] objectForKey:@"text"] componentsSeparatedByString:@":"];
		
		if ([lObjArray count] == 2) {
			
			[[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:[lObjArray objectAtIndex:0] forKey:@"text"] forKey:@"wepKeyIndex"];
			
			[[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:[lObjArray objectAtIndex:1] forKey:@"text"] forKey:@"wepKey"];
            
           // [[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:@"" forKey:@"text"] forKey:@"wepKey"];

			
			[[[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"password"] setValue:@"" forKey:@"text"];
            
		}
		else {
			
			[[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:@"" forKey:@"text"] forKey:@"wepKey"];
			
			[[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:@"" forKey:@"text"] forKey:@"wepKeyIndex"];
			
			[[[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"password"] setValue:@"" forKey:@"text"];
            
		}
		
	}
	else if ([[[pObjData allKeys] objectAtIndex:0] isEqualToString:GSPROV_DATA_FIRMWARE_VERSION] || [[[pObjData allKeys] objectAtIndex:0] isEqualToString:GSPROV_DATA_API_VERSION]){
		
        //============ check concurrent mode here ===================
        
        NSLog(@"concurrent mode  ===>>>  %@",pObjData);
        
		if([[pObjData objectForKey:@"version"] objectForKey:@"text"] == nil){
		
            
            _firmwareVersion = [[FirmwareVersion alloc] init];
            
            [_firmwareVersion setFirmwareVersionValues:pObjData];
            
            if ([_firmwareVersion.chip rangeOfString:@"1500"].location == NSNotFound)
            {
                chipStatus=NO;
            }
            else
            {
                chipStatus=YES;
            }
            
            [self checkAnonymousIDSupport];

		}
		else {
			
			
			apiVersion = [[NSMutableDictionary alloc] initWithDictionary:pObjData];
            
            NSString *lObjStr = [[apiVersion objectForKey:@"version"] objectForKey:@"text"];
            
            NSArray *lObjArray = [lObjStr componentsSeparatedByString:@"."];
            
            isSupportsEAP_Option = [[lObjArray objectAtIndex:0] intValue];
            
		}
	
		
	}
	else if ([[[pObjData allKeys] objectAtIndex:0] isEqualToString:GSPROV_DATA_WPS]){
		
		
		security = [[NSMutableDictionary alloc] initWithDictionary:pObjData];
	}
	else if ([[[pObjData allKeys] objectAtIndex:0] isEqualToString:GSPROV_DATA_ADMIN_SETTINGS]){
		
		
		adminSettings = [[NSMutableDictionary alloc] initWithDictionary:pObjData];
        
        [[[adminSettings objectForKey:@"httpd"]objectForKey:@"password"] setObject:@"" forKey:@"text"];
	}
    else if ([[[pObjData allKeys] objectAtIndex:0] isEqualToString:GSPROV_DATA_SCAN_PARAMS]){
        
    
        scanParameterDict = [[NSMutableDictionary alloc] initWithDictionary:pObjData];
        
    }
    else if ([[[pObjData allKeys] objectAtIndex:0] isEqualToString:GSPROV_DATA_CAPABILITIES]){
        
        _capabilitiesDict = [[NSMutableDictionary alloc] initWithDictionary:pObjData];
        
        _doesSupportConcurrentMode = [self checkConcurrentModeSupport:[[[_capabilitiesDict objectForKey:@"capabilities"] objectForKey:@"concurrent_mode"] objectForKey:@"text"]];
        
        _supportDualInterface = [self disableApplyButton:[[[_capabilitiesDict objectForKey:@"capabilities"] objectForKey:@"interfaces"] objectForKey:@"text"]];
    }

	else {
		
	}
}

-(void)checkCurrentMode:(NSString *)currentModeString {
    
    if ([currentModeString isEqualToString:@"limited-ap"]) {
        
        _currentMode = LimitedAPMode;
    }
    else {
        
        _currentMode = ClientMode;
    }
}


-(BOOL)disableApplyButton:(NSString *)lObjInterface {
    
    if ([lObjInterface intValue] == 2) {
        
        return true;
    }
    else {
        return false;
    }
}

-(BOOL)checkConcurrentModeSupport:(NSString *)lObjConcurrentMode {
    
    if ([lObjConcurrentMode isEqualToString:@"true"]) {
        
        return true;
    }
    else {
        
        return false;
    }
}

-(void)checkAnonymousIDSupport {
    
    NSString* requiredVersion = @"5.2";
    
    if ([requiredVersion compare:_firmwareVersion.geps options:NSNumericSearch] == NSOrderedSame || [requiredVersion compare:_firmwareVersion.geps options:NSNumericSearch] == NSOrderedAscending) {
        
        _supportAnonymousID = YES;
        
        [[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:@"" forKey:@"text"] forKey:@"eap_cn"];
        
        [[[[apConfig objectForKey:@"network"] objectForKey:@"client"] objectForKey:@"wireless"] setValue:[NSMutableDictionary dictionaryWithObject:@"" forKey:@"text"] forKey:@"eap_ou"];
        
    }
    else {
        _supportAnonymousID = NO;
        
    }
}
    

@end

