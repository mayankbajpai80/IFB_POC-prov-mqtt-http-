//
//  AddComplaintViewController.h
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 19/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonDropDown.h"

@interface AddComplaintViewController : UIViewController<ButtonDropDownDelegate>
{
    ButtonDropDown *dropDown;
}

@property (weak, nonatomic) IBOutlet UIButton *selectDevice;
@property (weak, nonatomic) IBOutlet UITextView *problemDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *complaintIDLbl;
@end
