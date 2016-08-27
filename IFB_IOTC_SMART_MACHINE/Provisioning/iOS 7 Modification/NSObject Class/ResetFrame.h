//
//  ResetFrame.h
//  Provisioning
//
//  Created by GainSpan India on 04/09/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ResetFrame : NSObject

+(void)resignKeyPad:(UIButton *)keyPadCloseButton ChannelPicker:(UIView *)channelPicker SecurityPicker:(UIView *)securityPicker andTableView:(UITableView *)tableView;

//+(void)bringUpChannelPicker:(UIPickerView *)channelPicker KeyBoardResignButton:(UIButton *)resignButton andUITableView:(UITableView *)tableView;

+(void)bringUpPicker:(UIView *)pickerView KeyBoardResignButton:(UIButton *)resignButton andUITableView:(UITableView *)tableView;

+(void)EditTextFieldToBringKeyPad:(UIButton *)keyPadCloseButton andTableView:(UITableView *)tableView;

+(float )returnStatusBarHeightForIOS_7;

+(UIColor *)actionSheetColorForDifferentIOSVersion ;

+(void)presentModelViewControllerPicker:(UIView *)pickerView KeyBoardResignButton:(UIButton *)resignButton andUITableView:(UITableView *)tableView;

@end
