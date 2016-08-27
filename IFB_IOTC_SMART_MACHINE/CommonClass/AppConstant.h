//
//  AppConstant.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 10/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h

// testing
//#define BASE_URL @"http://10.0.5.130:3000/" // local testing url
//#define BASE_URL @"http://10.0.5.85:3000/"
    
#define BASE_URL @"http://52.32.88.197/" // server url

// device details
#define SELECTED_DEVICE_INFO @"deviceInfo"
#define DEVICE_LIST @"deviceList"
#define SELECTED_DEVICE_MAC @"currentDeviceMac"

// APP LOCAL CONSTANTS
#define LOCAL_IP @"localIP"
// APIs
#define LOGIN_API @"login"
#define LOGOUT_API @"logout"
#define SIGNUP_API @"api/signup"
#define ADD_DEVICE_API @"addDevice"
#define GET_DEVICE_LIST_API @"getDeviceList"
#define ADD_SAP_COMPLAINT_API @"addSapComplaint"
#define GET_TECHNICHAIN_JOB_LIST_API @"getTechnicianJobList"
#define TECHNICHIAN_STATUS_UPDATE_API @"technicianStatusUpdate"

// app constants
#define AUTH_TOKEN @"authToken"
#define SAVED_COOKIES @"savedCookies"

// user details
#define USER_ID @"UserId"
#define ROLE @"role"

// network details
#define CONNECTED_SSID @"SSID"
#define SSID_IDENTIFIER @"GS_"
#endif /* AppConstant_h */
