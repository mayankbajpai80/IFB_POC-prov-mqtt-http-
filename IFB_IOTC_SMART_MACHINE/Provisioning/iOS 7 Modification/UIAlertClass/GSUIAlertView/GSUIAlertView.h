//
//  GSUIAlertView.h
//  Alert_Test
//
//  Created by Vikash on 9/12/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import "CustomUIAlertView.h"
#import "GSAlertInfo.h"
#import "IPSettingsView.h"

@class CredentialView;

enum {
    GSUIAlertViewStyleDefault=                    1,
    GSUIAlertViewStyleActivityIndicator=          2,
    GSUIAlertViewStyleIPSetting=                  3,
    GSUIAlertViewStyleConfirmation=               4,
    GSUIAlertViewStyleCredentialInput=            5
};
typedef int GSUIAlertViewStyle;

@interface GSUIAlertView : CustomUIAlertView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic,assign)int alertViewStyle;

@property (nonatomic,strong) CredentialView *m_cObjCredentialView;

@property (nonatomic,strong) IPSettingsView *m_cObjIPSettingsView;

@property (nonatomic,weak)id parentDelegate;

- (id)initWithInfo:(GSAlertInfo *)info style:(GSUIAlertViewStyle)style delegate:(id<CustomUIAlertViewDelegate>)delegate;

- (void)setContentViewHeight:(CGFloat)height;

@end
