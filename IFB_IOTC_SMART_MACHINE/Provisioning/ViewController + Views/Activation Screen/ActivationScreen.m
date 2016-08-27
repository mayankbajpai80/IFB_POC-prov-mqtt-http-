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
 * $RCSfile: ActivationScreen.m,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import "ActivationScreen.h"
#import "Identifiers.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "ValidationUtils.h"


#import "GSAlertInfo.h"
#import "GSUIAlertView.h"

#import "GSNavigationBar.h"

@interface ActivationScreen (privateMethods)<CustomUIAlertViewDelegate>

-(BOOL)checkForEmptyFields;
-(BOOL)checkForValidPasscode;

@end

@implementation ActivationScreen

@synthesize appDelegate,m_cObjTextField,m_cObjKeyboardRemoverButton;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
	
    if (self) {
		
		// Initialization code.
		
		appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
		
        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
		UIImageView *lObjLogo = [[UIImageView alloc] initWithFrame:CGRectMake(160 - 264/4, 50, 264/2, 72/2)];
		[lObjLogo setImage:[UIImage imageNamed:@"logo_gainspan.png"]];
		[self addSubview:lObjLogo];
		
		UILabel *lObjSuggestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100+10, 300, 80)];
		[lObjSuggestionLabel setTextAlignment:NSTextAlignmentCenter];
		[lObjSuggestionLabel setNumberOfLines:2];
		[lObjSuggestionLabel setBackgroundColor:[UIColor clearColor]];
		[lObjSuggestionLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[lObjSuggestionLabel setTextColor:[UIColor darkGrayColor]];
		[lObjSuggestionLabel setText:@"Enter the Activation Code to Proceed"];
		[self addSubview:lObjSuggestionLabel];
		
		m_cObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 160+30, 320-80, 44)];
		m_cObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[m_cObjTextField setFont:[UIFont boldSystemFontOfSize:16]];
        [m_cObjTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
		[m_cObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
		[m_cObjTextField setTextAlignment:NSTextAlignmentCenter];
		[m_cObjTextField setBorderStyle:UITextBorderStyleBezel];
		[m_cObjTextField setKeyboardType:UIKeyboardTypeDefault];
		[m_cObjTextField setBackgroundColor:[UIColor whiteColor]];
		[m_cObjTextField.layer setBorderColor:[[UIColor clearColor] CGColor]];
		[m_cObjTextField.layer setBorderWidth:1.0];
		[m_cObjTextField.layer setCornerRadius:8];
		[m_cObjTextField setDelegate:self];
		[self addSubview:m_cObjTextField];
		
		m_cObjKeyboardRemoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[m_cObjKeyboardRemoverButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
		[m_cObjKeyboardRemoverButton setFrame:CGRectMake(305-40-5,500, 60, 30)];
		[m_cObjKeyboardRemoverButton addTarget:self action:@selector(resignKeyPad) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_cObjKeyboardRemoverButton];
		
		UIButton *m_cObjNextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[m_cObjNextButton setTitle:@"Next" forState:UIControlStateNormal];
		[m_cObjNextButton setFrame:CGRectMake(30, 480-30-44-56, 260, 56)];
		[m_cObjNextButton addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_cObjNextButton];
		
	}
	
    return self;
	
}

-(void)Next
{
	
	if ([self checkForEmptyFields] == YES && [self checkForValidPasscode] == YES) {
        
		[UIView beginAnimations:nil context:NULL];
		
		[UIView setAnimationDuration:0.35];
		
		[self setAlpha:0];
		
		[UIView commitAnimations];
		
		
		[self performSelector:@selector(activationDone) withObject:self afterDelay:0.5];
        
	}
	
	
}

-(void)activationDone
{
	[globalValues.provisionSharedDelegate activationDone];
}

-(BOOL)checkForEmptyFields {
	
	if ([[m_cObjTextField text] isEqualToString:@""] || [[m_cObjTextField text] isEqualToString:@"(null)"]) {
        
        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Enter an IP Address to continue" message:nil confirmationData:[NSDictionary dictionary]];
        info.cancelButtonTitle = @"OK";
        info.otherButtonTitle = nil;
        
        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
        [lObjFieldValidation show];
		
		return NO;
	}
	
	return YES;
}

-(BOOL)checkForValidPasscode
{
    
	if ([[m_cObjTextField text] isEqualToString:GS_PROV_ACTIVATION_CODE])
	{
		return YES;
        
	}
    
	return NO;
	
}

-(BOOL)checkForInvalidCharacters {
    
    NSString *myOriginalString = [NSString stringWithString:[m_cObjTextField text]];
    
    return [ValidationUtils validateCharacters:myOriginalString];
	
//    BOOL valid;
//	
//    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
//	
//	NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[myOriginalString stringByReplacingOccurrencesOfString:@"." withString:@""]];
//	
//	valid = [alphaNums isSupersetOfSet:inStringSet];
//	
//	if (!valid) {
//        
//        
//        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Alphanumeric characters other than (.) is not allowed" message:nil confirmationData:[NSDictionary dictionary]];
//        info.cancelButtonTitle = @"OK";
//        info.otherButtonTitle = nil;
//        
//        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
//        [lObjFieldValidation show];
//		[lObjFieldValidation release];
//		
//		return NO;
//		
//	}
//	else {
//		
//	}
//	
//	return YES;
	
}

-(BOOL)checkForInvalidIPAdresses {
    
    return [ValidationUtils validateIPAddress:[m_cObjTextField text]];
	
	
//	NSArray *lObjIPSplit = [NSArray arrayWithArray:[[m_cObjTextField text] componentsSeparatedByString:@"."]];
//	
//	if ([lObjIPSplit count] != 4) {
//        
//        GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Invalid ip address used" message:[NSString stringWithFormat:@"please enter a valid ip address"] confirmationData:[NSDictionary dictionary]];
//        info.cancelButtonTitle = @"OK";
//        info.otherButtonTitle = nil;
//        
//        GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
//        
//        [lObjFieldValidation show];
//		[lObjFieldValidation release];
//		
//		return NO;
//	}
//	
//	for (int j=0; j < [lObjIPSplit count]; j++) {
//		
//		if ([[lObjIPSplit objectAtIndex:j] intValue] > 255 || [[lObjIPSplit objectAtIndex:j] intValue] < 0 || [[lObjIPSplit objectAtIndex:j] isEqualToString:@""]) {
//            
//            GSAlertInfo *info = [GSAlertInfo infoWithTitle:@"Invalid ip address used" message:[NSString stringWithFormat:@"please enter a valid ip address"] confirmationData:[NSDictionary dictionary]];
//            info.cancelButtonTitle = @"OK";
//            info.otherButtonTitle = nil;
//            
//            GSUIAlertView *lObjFieldValidation = [[GSUIAlertView alloc] initWithInfo:info style:GSUIAlertViewStyleDefault delegate:self];
//            [lObjFieldValidation show];
//			[lObjFieldValidation release];
//			
//			return NO;
//			
//		}
//		
//	}
//	
//	
//	return YES;
	
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
	
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake(305-40-5, 185-15+55+10, 60, 30)];
	
	[UIView commitAnimations];
	
	return YES;
	
}

-(void)resignKeyPad
{
	
	[m_cObjTextField resignFirstResponder];
	
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.35];
	
	[m_cObjKeyboardRemoverButton setFrame:CGRectMake(305-40-5,500, 60, 30)];
	
	[UIView commitAnimations];
	
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */



@end
