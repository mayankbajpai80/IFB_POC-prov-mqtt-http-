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
 * $RCSfile: Manual_IP_Entry.m,v $
 *
 * Description : Header file for Manual_IP_Entry functions and data structures
 *******************************************************************************/

#import "Manual_IP_Entry.h"
#import <QuartzCore/QuartzCore.h>
#import "GS_ADK_Data.h"
#import "GSAlertInfo.h"
#import "GSUIAlertView.h"

#import "GSNavigationBar.h"

#import "Identifiers.h"


@interface Manual_IP_Entry (privateMethods)<CustomUIAlertViewDelegate>

-(BOOL)checkForEmptyFields;

-(BOOL)checkForInvalidIPAdresses;

-(void)requestURLString:(NSString *)pObjURLString;

-(void)resignKeyPad;

-(void)Next;

@end

@implementation Manual_IP_Entry

@synthesize sharedGsData,m_cObjTextField,m_cObjKeyboardRemoverButton;


#define GAINSPAN_IMAGE_WIDTH     132
#define GAINSAPN_IMAGE_HEIGHT    36

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate {
    
    self = [super initWithFrame:frame];
	
    if (self) {
        
		// Initialization code.
				
        sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
        
        _delegate = delegate;
        
        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            
            _marginValue = 0;
        }
        else {
            
            _marginValue = 0;
        }
        
        _m_cObjScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _marginValue, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self addSubview:_m_cObjScrollView];
        
		UIImageView *lObjLogo = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - GAINSPAN_IMAGE_WIDTH/2, _marginValue+MARGIN*2, GAINSPAN_IMAGE_WIDTH, GAINSAPN_IMAGE_HEIGHT)];
		[lObjLogo setImage:[UIImage imageNamed:@"logo_gainspan.png"]];
		[_m_cObjScrollView addSubview:lObjLogo];
		
		UILabel *lObjSuggestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lObjLogo.frame.origin.y+lObjLogo.frame.size.height+NAVIGATION_BAR_HEIGHT, 300, 80)];
		[lObjSuggestionLabel setTextAlignment:NSTextAlignmentCenter];
		[lObjSuggestionLabel setNumberOfLines:3];
		[lObjSuggestionLabel setBackgroundColor:[UIColor clearColor]];
		[lObjSuggestionLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[lObjSuggestionLabel setTextColor:[UIColor darkGrayColor]];
		[lObjSuggestionLabel setText:@"Discovery has failed !\nEnter IP Address or Hostname manually to proceed"];
		[_m_cObjScrollView addSubview:lObjSuggestionLabel];
        
		m_cObjTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, lObjSuggestionLabel.frame.origin.y+lObjSuggestionLabel.frame.size.height+NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width-80, NAVIGATION_BAR_HEIGHT)];
		m_cObjTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [m_cObjTextField setText:@""];
        [m_cObjTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[m_cObjTextField setFont:[UIFont boldSystemFontOfSize:16]];
		[m_cObjTextField setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
		[m_cObjTextField setTextAlignment:NSTextAlignmentCenter];
		[m_cObjTextField setBorderStyle:UITextBorderStyleBezel];
		[m_cObjTextField setKeyboardType:UIKeyboardTypeDefault];
		[m_cObjTextField setBackgroundColor:[UIColor whiteColor]];
		[m_cObjTextField.layer setBorderColor:[[UIColor clearColor] CGColor]];
		[m_cObjTextField.layer setBorderWidth:1.0];
		[m_cObjTextField.layer setCornerRadius:8];
		[m_cObjTextField setDelegate:_delegate];
		[_m_cObjScrollView addSubview:m_cObjTextField];
		
		_m_cObjNextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[_m_cObjNextButton setTitle:@"Next" forState:UIControlStateNormal];
		[_m_cObjNextButton setFrame:CGRectMake(30, m_cObjTextField.frame.origin.y+m_cObjTextField.frame.size.height+NAVIGATION_BAR_HEIGHT, 260, 56)];
		[_m_cObjNextButton addTarget:_delegate action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
		[_m_cObjScrollView addSubview:_m_cObjNextButton];
		
	}
	
    return self;
}


@end
