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
 * $RCSfile: Auth_Check.m,v $
 *
 * Description : Implementaion file for Auth_Check public/private functions and data structures
 *******************************************************************************/

#import "Auth_Check.h"
#import "Identifiers.h"
#import "GSAlertInfo.h"
#import "GSUIAlertView.h"

#import "GSNavigationBar.h"


@interface Auth_Check(privateMethods)<CustomUIAlertViewDelegate>

-(void)authentictionDone;
-(void)promptForUserInputForAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg;

@end

@implementation Auth_Check


- (void)checkWithURL:(NSURL *)url withDelegate:(id)delegate {
    
    
    _delegate = delegate;
    
	currentURL_Str = [[NSString alloc] initWithString:[url absoluteString]];
    
    NSLog(@"currentURL_Str ==== %@",currentURL_Str);
	
	//appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	[NSURLConnection connectionWithRequest:request delegate:self];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
	[_delegate authentictionDone];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Connection Failed" message:[error localizedDescription] confirmationData:[NSDictionary dictionary]];
    info.cancelButtonTitle = @"Cancel";
    info.otherButtonTitle = @"Try Again";
    
    GSUIAlertView *lObjAlert = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
    
	//UIAlertView *lObjAlert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again",nil];
	
    [lObjAlert show];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)pObjChg {
    
	[_delegate promptForUserInputForAuthenticationChallenge:pObjChg];
    
}

-(void)proceedWithCredential:(NSURLCredential *)pObjCredential forChallenge:(NSURLAuthenticationChallenge *)pObjChg
{
	
    [[pObjChg sender] useCredential:pObjCredential forAuthenticationChallenge:pObjChg];

}

- (void)alertView:(GSUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        
        exit(1);
    }
    else
    {
        [self checkWithURL:[NSURL URLWithString:currentURL_Str]withDelegate:_delegate];
        
    }
    
}




@end
