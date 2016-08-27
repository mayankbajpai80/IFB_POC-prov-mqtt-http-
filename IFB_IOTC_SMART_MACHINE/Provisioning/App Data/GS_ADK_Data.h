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
 * $RCSfile: GS_ADK_Data.h,v $
 *
 * Description : Header file for GS_ADK_Data functions and data structures
 *******************************************************************************/


#import <Foundation/Foundation.h>
#import "FirmwareVersion.h"

/**
 *******************************************************************************
 * @file  ServiceList.h
 * @brief This is the interface for ServiceList implementation class. This class 
 * is responsible for listing and updating discovered services in a Cocoa-style
 * table view.On selection of a particular service the app communicates with the 
 * particular host using the discovered parameters such as host name.
 ******************************************************************************/

/**
 *******************************************************************************
 * @ingroup App Data
 *******************************************************************************/

typedef NS_ENUM(NSUInteger, CurrentMode) {
    LimitedAPMode,
    ClientMode,
};



@interface GS_ADK_Data : NSObject {

	NSMutableDictionary *systemApi;
	NSMutableDictionary *apList;
	NSMutableDictionary *apConfig;
	//NSMutableDictionary *fwVersion;
	NSMutableDictionary *configId;
	NSMutableDictionary *apiVersion;
	NSMutableDictionary *security;
	NSMutableDictionary *adminSettings;
    NSMutableDictionary *scanParameterDict;

	
	NSString *m_cObjIPAddress;
	NSString *m_cObjSubnetMask;
	NSString *m_cObjGateway;
	NSString *m_cObjDNSAddress;
    NSString *confirmationScreen_Password;
	
    NSString *WEP_Index;
    NSString *m_cObjSSID_Str;
    NSString *m_cObjDomainName;
    NSString *m_gObjNodeIP;
    NSString *setChannelLabelString;
	
	BOOL securedMode;
    BOOL wpaEnabled;
    BOOL manualConfigMode;
	BOOL stringExist;
	BOOL chipStatus;
	
    
    int  isSupportsEAP_Option;

}

@property (nonatomic, strong) FirmwareVersion *firmwareVersion;

@property (nonatomic,strong) NSMutableDictionary *systemApi;
@property (nonatomic,strong) NSMutableDictionary *apList;
@property (nonatomic,strong) NSMutableDictionary *apConfig;
//@property (nonatomic,retain) NSMutableDictionary *fwVersion;
@property (nonatomic,strong) NSMutableDictionary *configId;
@property (nonatomic,strong) NSMutableDictionary *apiVersion;
@property (nonatomic,strong) NSMutableDictionary *security;
@property (nonatomic,strong) NSMutableDictionary *adminSettings;
@property (nonatomic,strong) NSMutableDictionary *scanParameterDict;
@property (nonatomic, strong) NSMutableDictionary *capabilitiesDict;


@property (nonatomic,strong) NSString *m_cObjIPAddress;
@property (nonatomic,strong) NSString *m_cObjSubnetMask;
@property (nonatomic,strong) NSString *m_cObjGateway;
@property (nonatomic,strong) NSString *m_cObjDNSAddress;
@property (nonatomic,strong) NSString *m_cObjSSID_Str;
@property (nonatomic,strong) NSString *m_cObjDomainName;
@property (nonatomic,strong) NSString *m_gObjNodeIP;
@property (nonatomic,strong) NSString *currentIPAddress;


@property (nonatomic,strong) NSString *confirmationScreen_Password;
@property (nonatomic,strong) NSString *WEP_Index;
@property (nonatomic,strong) NSString *setChannelLabelString;


@property (nonatomic,assign) BOOL securedMode;
@property (nonatomic,assign) BOOL wpaEnabled;
@property (nonatomic,assign) BOOL manualConfigMode;
@property (nonatomic,assign) BOOL chipStatus;
@property (nonatomic,assign) BOOL doesSupportConcurrentMode;
@property (nonatomic,assign) BOOL supportDualInterface;
@property (nonatomic,assign) BOOL supportAnonymousID;
@property (nonatomic,assign) BOOL enableAnonymousSwitch;
@property (nonatomic,assign) BOOL enableCNOUSwitch;
@property (nonatomic,assign) int  isSupportsEAP_Option;

@property (nonatomic, assign) CurrentMode currentMode;



/**
 *******************************************************************************
 * @ingroup App Data
 * @brief This method returns the instance of the GS_ADK_Data class which is a 
 *        singleton.
 *
 * @retval Returns id.
 *******************************************************************************/

+ (id)sharedInstance; 

/**
 *******************************************************************************
 * @ingroup App Data
 * @brief This method sets m_cObjSSID_Str to the currently connected WiFi's SSID. 
 *
 * @param pObjString is of type NSString and holds the current SSID.
 * @retval Returns void.
 *******************************************************************************/

-(void)setCurrentSSID:(NSString *)pObjString;

/**
 *******************************************************************************
 * @ingroup App Data
 * @brief This methods for allocation and initialization all the NSDictionary 
 * objects defined in GS_ADK_Data interface.
 *
 * @param pObjData is of type NSMutableDictionary contains the NSDictionary 
 *        equivalent of downloaded xml after parsing. 
 * @retval Returns void.
 *******************************************************************************/

-(void)setData:(NSMutableDictionary *)pObjData; 


@end
