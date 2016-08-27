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
 * $RCSfile: CertificateBrowser.h,v $
 *
 * Description : Header file for CertificateBrowser functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "GSViewController.h"

/**
 *******************************************************************************
 * @file CertificateBrowser.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup Client Mode
 *******************************************************************************/


@protocol CertificateBrowserDelegate <NSObject>

-(void)selectCertificate:(NSString *)pObjString path:(NSString *)pObjString withTag:(int)pObjTag;

@end

@interface CertificateBrowser : GSViewController <UITableViewDataSource,UITableViewDelegate>{
    
    /**
	 *******************************************************************************
	 * UI SUFFIX Objects
	 *******************************************************************************/
    
    
//	UINavigationBar *//lObjNavBar;
    
    UITableView *m_cObjTable;
    
    /**
	 *******************************************************************************
	 * NS SUFFIX Objects
	 *******************************************************************************/
    
    
    NSMutableArray *m_cObjCertificates;
    
	NSMutableArray *m_cObjCertificatePaths;
    
    /**
	 *******************************************************************************
	 * Custom Objects
	 *******************************************************************************/
    
    
    id <CertificateBrowserDelegate> __weak m_cObjDelegate;
    
    
    /**
	 *******************************************************************************
	 * C Variables
	 *******************************************************************************/
    
    
    int m_cObjTag;
}

@property (nonatomic,weak) id <CertificateBrowserDelegate> m_cObjDelegate;

@property (nonatomic,assign) int statusBarHeightForIOS_7;



/**
 *******************************************************************************
 * @ingroup Client Mode
 * @brief This method sets the Tag for a selected File.
 *
 * @param pObjTag of type int is tag for a selected file.
 * @retval Returns void.
 *******************************************************************************/

-(void)setTag:(int)pObjTag;

@end
