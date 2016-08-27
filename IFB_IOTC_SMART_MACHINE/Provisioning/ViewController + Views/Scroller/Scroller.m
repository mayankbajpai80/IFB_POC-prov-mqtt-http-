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
 * $RCSfile: Scroller.m,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import "Scroller.h"
#import "Identifiers.h"


@implementation Scroller

@synthesize m_cObjUpArraow,m_cObjDownArraow;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		[self setDelegate:self];
		
		m_cObjUpArraow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up_arrow.png"]];
		m_cObjUpArraow.hidden = YES;
		//[m_cObjUpArraow setFrame:CGRectMake(132, 70, 20, 10)];
		[m_cObjUpArraow setFrame:CGRectMake(150/2, 70, 20, 10)];
		
		m_cObjDownArraow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow.png"]];
		//[m_cObjDownArraow setFrame:CGRectMake(132, 290, 20, 10)];
        
        if ((int)[[UIScreen mainScreen] bounds].size.height == 568)
        {
            // This is iPhone 5 screen
             [m_cObjDownArraow setFrame:CGRectMake(150, 290+40, 20, 10)];
        } else {
            // This is iPhone 4 screen
            [m_cObjDownArraow setFrame:CGRectMake(150, 290, 20, 10)];
        }
        
    
		
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
	CGRect visibleRect;
	visibleRect.origin = scrollView.contentOffset;
	visibleRect.size = scrollView.contentSize;
	
	
	if (visibleRect.origin.y <= 0) {
		
		m_cObjUpArraow.hidden = YES;
	}
	else {
		
		m_cObjUpArraow.hidden = NO;
	}
	
	if (visibleRect.origin.y >= 210) {
		
		m_cObjDownArraow.hidden = YES;
	}
	else {
		
		m_cObjDownArraow.hidden = NO;
	}
			
}



@end
