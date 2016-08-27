//
//  APInfoViewController.h
//  Provisioning
//
//  Created by Saurabh Kumar on 4/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "GS_ADK_Data.h"


@interface APInfoViewController : GSViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate> {
    
    /**
	 *******************************************************************************
	 * Custom Objects
	 *******************************************************************************/
    
    
	ProvisioningAppDelegate *appDelegate;
	
	GS_ADK_Data *sharedGsData;
	
    /**
	 *******************************************************************************
	 * UI SUFFIX Objects
	 *******************************************************************************/
    
	//UINavigationBar *//lObjNavBar;
	
	UITableView *m_cObjTableView;
	
    /**
	 *******************************************************************************
	 * C Variables
	 *******************************************************************************/
    
	NSInteger index;
}

@property(nonatomic,assign)NSInteger index;


@end
