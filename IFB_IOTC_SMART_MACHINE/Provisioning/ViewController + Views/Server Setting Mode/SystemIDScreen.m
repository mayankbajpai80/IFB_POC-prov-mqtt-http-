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
 * $RCSfile: SystemIDScreen.m,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import "SystemIDScreen.h"
#import "InfoScreen.h"
#import "Identifiers.h"
#import "GS_ADK_Data.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "UINavigationBar+TintColor.h"
#import "Identifiers.h"
#import "ResetFrame.h"

#import "ModeController.h"



@interface SystemIDScreen (privateMethods)

-(void)createNavigationBar;

@end


@implementation SystemIDScreen

@synthesize appDelegate,sharedGsData,m_cObjSystemIdView;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)navigationItemTapped:(NavigationItem)item
{
    
    switch (item) {
        case NavigationItemBack:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case NavigationItemCancel:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case NavigationItemInfo:
            
            [self showInfo];
            
            break;
            
        case NavigationItemMode:
            
        {
            ModeController *modeController = [[ModeController alloc] initWithControllerType:5];
            [self.navigationController pushViewController:modeController animated:YES];
            
        }
            
            break;
            
        case NavigationItemDone:
                        
            break;

            
        default:
            break;
    }
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
    sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];

	appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];

//	[self createNavigationBar];
    
    if ([[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] != nil || ![[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@""]) {
    
        self.navigationBar.mode = [NSString stringWithFormat:@"Mode: %@",[[[[sharedGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"]];

    }
    
    
    self.navigationBar.title = @"System Identification";

    
    float statusHeight = [ResetFrame returnStatusBarHeightForIOS_7];
		

	m_cObjSystemIdView = [[UIView alloc] initWithFrame:CGRectMake(10, self.navigationBar.frame.origin.y+self.navigationBar.frame.size.height+statusHeight,[UIScreen mainScreen].bounds.size.width-20,CELL_HEIGHT)];
	[m_cObjSystemIdView setBackgroundColor:[UIColor whiteColor]];
	[m_cObjSystemIdView.layer setCornerRadius:8.0];
	[m_cObjSystemIdView.layer setBorderWidth:1];
	[m_cObjSystemIdView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
	[self.view addSubview:m_cObjSystemIdView];
	
	UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 44)];
	[lObjLabel setBackgroundColor:[UIColor clearColor]];
	[lObjLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
	[lObjLabel setText:@"UUID :"];
	[lObjLabel setFont:[UIFont systemFontOfSize:12]];
	[lObjLabel setTextColor:[UIColor grayColor]];
	[m_cObjSystemIdView addSubview:lObjLabel];
	
	UITextField *lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, 140, 44)];
	lObjTextField.tag = 3;
	[lObjTextField setUserInteractionEnabled:NO];
	lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[lObjTextField setTextAlignment:NSTextAlignmentRight];
	[lObjTextField setDelegate:self];
	[lObjTextField setBackgroundColor:[UIColor clearColor]];
	[lObjTextField setText:[[[[sharedGsData configId] objectForKey:@"id"] objectForKey:@"uid"] objectForKey:@"text"]];
	[lObjTextField setFont:[UIFont systemFontOfSize:14]];
	[lObjTextField setTextColor:[UIColor grayColor]];
	[lObjTextField setReturnKeyType:UIReturnKeyDone];
	[m_cObjSystemIdView addSubview:lObjTextField];
	
    
    m_cObjSystemIdView = [[UIView alloc] initWithFrame:CGRectMake(10, m_cObjSystemIdView.frame.origin.y+m_cObjSystemIdView.frame.size.height+MARGIN_BETWEEN_CELLS, [UIScreen mainScreen].bounds.size.width-20, CELL_HEIGHT)];//
    [m_cObjSystemIdView setBackgroundColor:[UIColor whiteColor]];
    [m_cObjSystemIdView.layer setCornerRadius:8.0];
    [m_cObjSystemIdView.layer setBorderWidth:1];
    [m_cObjSystemIdView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.view addSubview:m_cObjSystemIdView];
    
    lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 44)];
    [lObjLabel setBackgroundColor:[UIColor clearColor]];
    [lObjLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [lObjLabel setText:@"System Name    :"];
    [lObjLabel setFont:[UIFont systemFontOfSize:12]];
    [lObjLabel setTextColor:[UIColor grayColor]];
    [m_cObjSystemIdView addSubview:lObjLabel];
    
    lObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, 140, 44)];
    lObjTextField.tag = 4;
    lObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [lObjTextField setTextAlignment:NSTextAlignmentRight];
    [lObjTextField setDelegate:self];
    [lObjTextField setBackgroundColor:[UIColor clearColor]];
    
    if ([[[[sharedGsData configId] objectForKey:@"id"] objectForKey:@"name"] objectForKey:@"text"] != nil) {
        
        [lObjTextField setText:[[[[sharedGsData configId] objectForKey:@"id"] objectForKey:@"name"] objectForKey:@"text"]];
        
    }
    else{
        
        [lObjTextField setText:@""];
    }
    
    [lObjTextField setFont:[UIFont systemFontOfSize:14]];
    [lObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
    [lObjTextField setReturnKeyType:UIReturnKeyDefault];
    [m_cObjSystemIdView addSubview:lObjTextField];
	
	_m_cObjConfirmButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_m_cObjConfirmButton.frame = CGRectMake(10, 280+30-10+10, 280+20, 66-30+20-10);
	[_m_cObjConfirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
	[_m_cObjConfirmButton addTarget:self action:@selector(confirmPost) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_m_cObjConfirmButton];
    
	
}


-(void)confirmPost {
    
    UITextField *lObjTextField = (UITextField *)[self.view viewWithTag:4];
    
    if (lObjTextField.text.length > 0) {
        
        [self postSystemIdenficationInfo:lObjTextField.text];

    }
    else {
    
        UIAlertView *lObjAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter System Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [lObjAlertView show];
    }
    
    
//    int mode;
//    
//    if ([[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] != nil || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@""] || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@"(null)"]) {
//		
//        if ([[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@"limited-ap"]) {
//            
//            mode=1;
//        }
//        else
//        {
//            mode=2;
//        }
//        
//        [appDelegate setMode:mode];
//
//    }

    
}

-(void)postSystemIdenficationInfo:(NSString *)pObjString {
    
    NSMutableString * xmlString = [[NSMutableString alloc] init];
    
    [xmlString appendString:@"<id>"];
    [xmlString appendFormat:@"<name>%@</name>",pObjString];
    [xmlString appendString:@"</id>"];
    
    NSURL * serviceUrl = [NSURL URLWithString:[NSString stringWithFormat:GSPROV_GET_URL_ID,[sharedGsData m_gObjNodeIP],[sharedGsData currentIPAddress]]];
    
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    
    [serviceRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [serviceRequest setHTTPMethod:@"POST"];
    
    [serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [NSURLConnection connectionWithRequest:serviceRequest delegate:self];

}


-(void)showInfo {
    
	InfoScreen *lObjInfoScreen = [[InfoScreen alloc] initWithControllerType:3];
    [self presentViewController:lObjInfoScreen animated:YES completion:nil];
}


-(void)goBackToPriousPage {
	
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate Method :

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
}
// called when 'return' key pressed. return NO to ignore.


//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    
//    if (textField.tag == 4) {
//        
//        if (![textField.text isEqualToString:[[[[sharedGsData configId] objectForKey:@"id"] objectForKey:@"name"] objectForKey:@"text"]]) {
//            
//            NSLog(@"replaced string");
//            
//            _editable = YES;
//            
//             _m_cObjConfirmButton.alpha = 1.0;
//        }
//        else {
//            
//            _editable = NO;
//            
//            _m_cObjConfirmButton.alpha = 0.5;
//
//        }
//        
//        [_m_cObjConfirmButton setUserInteractionEnabled:_editable];
//
//    }
//    return YES;
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
	return YES;
}// return NO to disallow editing.

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
	if (textField.tag == 4) {
        
		return YES;
	}
	
    NSString *lObjCurrentString;
    
    if (range.length == 0) {
        
        if (range.location == textField.text.length) 
        {
            
            lObjCurrentString = [NSString stringWithFormat:@"%@%@",textField.text,string];
            
        }
        else if (range.location == 0)
        {
            
            lObjCurrentString = [NSString stringWithFormat:@"%@%@",string,textField.text];
            
        }
        else
        {
            NSString *startString = [NSString stringWithString:[textField.text substringToIndex:range.location]];
            
            NSString *middleString = [NSString stringWithString:string];
            
            NSString *endString = [NSString stringWithString:[textField.text substringFromIndex:range.location]];
            
            lObjCurrentString = [NSString stringWithFormat:@"%@%@%@",startString,middleString,endString];
            
        }    
        
        [[[[sharedGsData configId] objectForKey:@"id"] objectForKey:@"name"] setValue:lObjCurrentString forKey:@"text"];

    }
    else if ([string isEqualToString:@""]) {
            
            
        lObjCurrentString = [textField.text stringByReplacingCharactersInRange:range withString:@""];
        
        [[[[sharedGsData configId] objectForKey:@"id"] objectForKey:@"name"] setValue:lObjCurrentString forKey:@"text"];

    }
    
	return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

	UIAlertView *lObjAlert = [[UIAlertView alloc] initWithTitle:@"Configuration saved" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
    [lObjAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        
        int mode;
        
        if ([[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] != nil || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@""] || ![[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@"(null)"]) {
            
            if ([[[[[sharedGsData apConfig] objectForKey:@"network"]objectForKey:@"mode"]objectForKey:@"text"] isEqualToString:@"limited-ap"]) {
                
                mode=1;
            }
            else
            {
                mode=0;
            }
                        
            [globalValues.provisionSharedDelegate setMode:mode];
            
        }
    
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

