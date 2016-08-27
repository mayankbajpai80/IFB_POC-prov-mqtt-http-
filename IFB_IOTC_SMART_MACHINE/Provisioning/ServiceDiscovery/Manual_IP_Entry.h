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
 * $RCSfile: Manual_IP_Entry.h,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "GS_ADK_Data.h"

/**
 *******************************************************************************
 * @file Manual_IP_Entry.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup Manual_IP_Entry
 *******************************************************************************/


@interface Manual_IP_Entry : UIView <UITextFieldDelegate>{

	/**
	 *******************************************************************************
	 * Custom objects
	 *******************************************************************************/
	
		
	    GS_ADK_Data *sharedGsData;
	
	
	/**
	 *******************************************************************************
	 * UIKit objects.
	 *******************************************************************************/
	
		UITextField *m_cObjTextField;
		
	    UIButton *m_cObjKeyboardRemoverButton;
	
	}

/**
 *******************************************************************************
 * @ingroup Manual_IP_Entry
 * @brief Its an shared instance of singleton ProvisioningAppDelegate class which
 *        is a subclass of UIApplication class ,having different application related
 *        methods.These methods providing the information about key events in
 *        an application’s execution such as when it finished launching, when it 
 *        is about to be terminated, when memory is low, and when important changes
 *        occur. 
 *******************************************************************************/


/**
 *******************************************************************************
 * @ingroup Manual_IP_Entry
 * @brief It is a shared instance of singleton GS_ADK_Data class,where all
 *		  application data is stored in its variables.
 *******************************************************************************/

@property(nonatomic,strong)GS_ADK_Data *sharedGsData;

/**
 *******************************************************************************
 * @ingroup Manual_IP_Entry
 * @brief Its a textfield object which takes ip address/hostname as input.
 *******************************************************************************/

@property(nonatomic,strong)UITextField *m_cObjTextField;

/**
 *******************************************************************************
 * @ingroup Manual_IP_Entry
 * @brief It is a button used for removing the keyboard.
 *******************************************************************************/

@property(nonatomic, strong) UIButton *m_cObjKeyboardRemoverButton;

@property (nonatomic, strong) UIButton *m_cObjNextButton;

@property (nonatomic, assign) int marginValue;


@property (nonatomic,weak) id delegate;

@property (nonatomic, strong) UIScrollView *m_cObjScrollView;


- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;

@end
