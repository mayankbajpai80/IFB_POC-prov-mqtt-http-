
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
 * $RCSfile: Identifiers.h,v $
 *
 * Description : Header file for InfoPage functions and data structures
 *******************************************************************************/



/**
 *******************************************************************************
 * @file Identifiers.h
 * @ingroup AppConfig
 * @brief This is Identifiers file .This file is responsible define micros.
 * That micros are used in other classes.
 ******************************************************************************/


// cloud -> http://gscloud.herokuapp.com/gainspan/system/config/network


#define MANUAL_MODE                                     3
#define SCAN_MODE                                       2



#define GSPROV_POST_URL_UTC_TIME                        @"http://%@/gainspan/system/time?current_ip=%@"

#define GSPROV_POST_URL_CERTIFICATAE                    @"http://%@/gainspan/system/wpacert?current_ip=%@"
#define GSPROV_POST_URL_CERT_UPLOAD                      @"http://%@/gainspan/system/wpacertupload?current_ip=%@"

#define GSPROV_GET_URL_SCAN_PARAMS_URL					@"http://%@/gainspan/system/prov/scan_params?current_ip=%@"
#define GSPROV_POST_URL_NETWORK_DETAILS					@"http://%@/gainspan/system/config/network?current_ip=%@"


#define GSPROV_GET_URL_AP_LIST							@"http://%@/gainspan/system/prov/ap_list?current_ip=%@"
#define GSPROV_GET_URL_NETWORK_DETAILS					@"http://%@/gainspan/system/config/network?current_ip=%@"
#define GSPROV_GET_URL_FIRMWARE_VERSION					@"http://%@/gainspan/system/firmware/version?current_ip=%@"
#define GSPROV_GET_URL_ID								@"http://%@/gainspan/system/config/id?current_ip=%@"
#define GSPROV_GET_URL_API_VERSION						@"http://%@/gainspan/system/api/version?current_ip=%@"
#define GSPROV_GET_WPS_URL								@"http://%@/gainspan/system/prov/wps?current_ip=%@"
#define GSPROV_POST_WPS_URL								@"http://%@/gainspan/system/prov/wps?current_ip=%@"
#define GSPROV_GET_ADMIN_SETTINGS						@"http://%@/gainspan/system/config/httpd?current_ip=%@"
#define GSPROV_GET_CAPABILITIES                         @"http://%@/gainspan/system/capabilities?current_ip=%@"

#define GSPROV_DATA_AP_LIST								@"ap_list"
#define GSPROV_DATA_ID									@"id"
#define GSPROV_DATA_FIRMWARE_VERSION					@"version"
#define GSPROV_DATA_API_VERSION							@"version"
#define GSPROV_DATA_NETWORK_DETAILS						@"network"
#define GSPROV_DATA_WPS									@"wps"
#define GSPROV_DATA_ADMIN_SETTINGS						@"httpd"
#define GSPROV_DATA_SCAN_PARAMS                         @"scan_params"
#define GSPROV_DATA_CAPABILITIES                        @"capabilities"



#define APP_VERSION										@"1.1.4"

#define APP_NAME                                         @"Provisioning"

#define SUPPORTED_API_VERSION							@"0.9.0"

#define IP_TYPE_DHCP									0
#define IP_TYPE_MANUAL									1

#define WEP												1
#define WPA												2

#define OPEN_SECURITY									0
#define WEP_SECURITY									1
#define WPA_PERSONAL_SECURITY							2
#define WPA_ENTERPRISE_SECURITY							3

#define GS_PROV_ACTIVATION_CODE							@""



#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



//TODO: Should these be defined as typed constants instead?
#define NAVIGATION_BAR_HEIGHT       44
#define TAB_BAR_HEIGHT              50
#define STATUS_BAR_HEIGHT           20
#define CELL_HEIGHT                 44
#define MARGIN_BETWEEN_CELLS        10


#define MARGIN                    10


