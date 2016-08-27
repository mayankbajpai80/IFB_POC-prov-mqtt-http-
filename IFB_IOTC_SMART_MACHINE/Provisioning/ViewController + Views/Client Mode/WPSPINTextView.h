//
//  WPSPINTextView.h
//  Provisioning
//
//  Created by GainSpan India on 30/10/13.
//
//

#import <UIKit/UIKit.h>

@interface WPSPINTextView : UIView

@property (nonatomic,strong)UITextField *textField;

//@property (nonatomic,strong) UIButton *keyPadResignButton;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
@end
