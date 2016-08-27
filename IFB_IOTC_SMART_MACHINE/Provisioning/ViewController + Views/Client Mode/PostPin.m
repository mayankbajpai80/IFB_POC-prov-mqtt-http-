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
 * $RCSfile: PostPin.m,v $
 *
 * Description : Header file for PostPin functions and data structures
 *******************************************************************************/

#import "PostPin.h"
#import "Identifiers.h"
#import "GS_ADK_Data.h"

#import "GSAlertInfo.h"
#import "GSUIAlertView.h"

#import "GSNavigationBar.h"
#import "UniversalParser.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "ConcurrentModeInfoViewController.h"


@interface PostPin ()<CustomUIAlertViewDelegate>

@end

@implementation PostPin

-(void)postPin:(NSString *)pObjPin pushPinCompletion:(ResponseBlock)callBack {
    
    _responseBlock = callBack;
    
    [self postPin:pObjPin];
}

-(void)postPin:(NSString *)pObjPin {
    
    appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
   
    sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    [globalValues.provisionSharedDelegate activityIndicator:YES];
    
    NSString *xmlString = nil;
    
    if (sharedGsData.doesSupportConcurrentMode && sharedGsData.currentMode == LimitedAPMode) {
        
        xmlString = [NSString stringWithFormat:@"<wps><enabled>true</enabled><mode>pin-verify</mode><pin>%@</pin></wps>",pObjPin];

    }
    else {
        
        xmlString = [NSString stringWithFormat:@"<wps><enabled>true</enabled><mode>pin</mode><pin>%@</pin></wps>",pObjPin];

    }
	
	NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_POST_WPS_URL,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
	
	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
	
	[serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	
	[serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
	
	[serviceRequest setHTTPMethod:@"POST"];
		
	[NSURLConnection connectionWithRequest:serviceRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (sharedGsData.doesSupportConcurrentMode) {
        
           UniversalParser *lObjUniversalParser = [[UniversalParser alloc] init];
            
            _cuncurrentModeDictionary = [[NSDictionary alloc] initWithDictionary:[lObjUniversalParser dictionaryForXMLData:data]];
            NSLog(@"didReceiveData ===>>>  %@",_cuncurrentModeDictionary);
    }
    else {
        _cuncurrentModeDictionary = nil;
    }
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    _responseBlock(ResponseTypeSuccess,_cuncurrentModeDictionary,nil);
    
    [globalValues.provisionSharedDelegate activityIndicator:NO];
}



-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    _responseBlock(ResponseTypeFail,nil,error);

    [globalValues.provisionSharedDelegate activityIndicator:NO];

}


@end
