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
 * $RCSfile: ActivationScreen.h,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/

#import <UIKit/UIKit.h>
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
/**
 *******************************************************************************
 * @file ActivationScreen.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup ActivationScreen
 *******************************************************************************/


@interface ActivationScreen : UIView <UITextFieldDelegate>{

	/**
	 *******************************************************************************
	 * Custom Objects
	 *******************************************************************************/	
	
		ProvisioningAppDelegate *appDelegate;	
	
	/**
	 *******************************************************************************
	 * UIKit Objects
	 *******************************************************************************/
	
		UITextField *m_cObjTextField;
	    
	    UIButton *m_cObjKeyboardRemoverButton;
	
	}


/**
 *******************************************************************************
 * @ingroup ActivationScreen
 * @brief Its an shared instance of singleton ProvisioningAppDelegate class which
 *        is a subclass of UIApplication class ,having different application related
 *        methods.These methods providing the information about key events in
 *        an application’s execution such as when it finished launching, when it 
 *        is about to be terminated, when memory is low, and when important changes
 *        occur.
 *******************************************************************************/

@property(nonatomic,strong)ProvisioningAppDelegate *appDelegate;

/**
 *******************************************************************************
 * @ingroup ActivationScreen
 * @brief Its a textfield object which takes activation code as input.
 *******************************************************************************/

@property(nonatomic,strong)UITextField *m_cObjTextField;

/**
 *******************************************************************************
 * @ingroup ActivationScreen
 * @brief It is a button used for removing the keyboard.
 *******************************************************************************/

@property(nonatomic,strong)UIButton *m_cObjKeyboardRemoverButton;


@end
