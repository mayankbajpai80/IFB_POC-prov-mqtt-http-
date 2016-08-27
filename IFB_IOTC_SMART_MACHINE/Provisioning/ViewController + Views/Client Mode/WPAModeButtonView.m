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
 * $RCSfile: WPAModeButtonView.m,v $
 *
 * Description : Header file for WPAModeButtonView functions and data structures
 *******************************************************************************/

#import "WPAModeButtonView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WPAModeButtonView

@synthesize m_cObjDelegate,m_cObjLabel,m_cObjImageView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		m_cObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[m_cObjLabel setTextAlignment:NSTextAlignmentCenter];
		[m_cObjLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[m_cObjLabel setBackgroundColor:[UIColor clearColor]];
		
		m_cObjImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[m_cObjImageView setBackgroundColor:[UIColor clearColor]];
		[m_cObjImageView.layer setCornerRadius:8.0];
		[m_cObjImageView.layer setBorderWidth:1];
		[m_cObjImageView.layer setBorderColor:[[UIColor clearColor] CGColor]];	
		[m_cObjImageView setClipsToBounds:YES];
		
	}
	
    return self;
}

-(void)setTextWithEAPTypeForVersionIsGreaterThenOne:(int)pObjEAPType {
    
	switch ([self tag]) {
		case 10000:
			
			[m_cObjLabel setText:@"EAP-FAST-GTC"];
			
			break;
		case 10001:
			
			[m_cObjLabel setText:@"EAP-FAST-MSCHAP"];
            
			break;
		case 10002:
			
            [m_cObjLabel setText:@"EAP-TTLS"];

			break;
		
        case 10003:
            
            [m_cObjLabel setText:@"EAP-PEAP0"];
            
            break;
            
        case 10004:
            
            [m_cObjLabel setText:@"EAP-PEAP1"];
            
            break;
            
            case 10005:

			[m_cObjLabel setText:@"EAP-TLS"];
            
			break;
		default:
			break;
            
	}
	
	if ([self tag]%10000 == pObjEAPType) {
		
		[m_cObjLabel setTextColor:[UIColor whiteColor]];
        
	}
	else {
		
		[m_cObjLabel setTextColor:[UIColor darkGrayColor]];
        
	}
    
	
}

-(void)setTextWithEAPType:(int)pObjEAPType {

	switch ([self tag]) {
		
        case 10000:
            [m_cObjLabel setText:@"EAP-FAST"];
			break;
		
        case 10001:
			[m_cObjLabel setText:@"EAP-TTLS"];
			break;
		
        case 10002:
			[m_cObjLabel setText:@"EAP-PEAP"];
			break;
		
        case 10003:
			[m_cObjLabel setText:@"EAP-TLS"];
			break;
		
        default:
			break;
	
	}
	
	if ([self tag]%10000 == pObjEAPType) {
		
		[m_cObjLabel setTextColor:[UIColor whiteColor]];

	}
	else {
		
		[m_cObjLabel setTextColor:[UIColor darkGrayColor]];

	}

	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	[m_cObjDelegate selectedWPAMode:[self tag]];
	 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/



@end
