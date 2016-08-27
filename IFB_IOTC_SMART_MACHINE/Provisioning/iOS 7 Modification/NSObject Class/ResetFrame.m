//
//  ResetFrame.m
//  Provisioning
//
//  Created by GainSpan India on 04/09/13.
//
//

#import "ResetFrame.h"
#import "Identifiers.h"

@implementation ResetFrame

+(void)resignKeyPad:(UIButton *)keyPadCloseButton ChannelPicker:(UIView *)channelPicker SecurityPicker:(UIView *)securityPicker andTableView:(UITableView *)tableView {
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [keyPadCloseButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height+100, 60, 30)];
        [tableView setFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-85)];
        [channelPicker setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 220)];
        [securityPicker setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 220)];
    }
    
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [keyPadCloseButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height+100, 60, 30)];
        
        [channelPicker setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 220)];
        
        [securityPicker setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, 220)];
        
        [tableView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    }
    else {
        
    }
    
}

+(void)presentModelViewControllerPicker:(UIView *)pickerView KeyBoardResignButton:(UIButton *)resignButton andUITableView:(UITableView *)tableView {
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [resignButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height/3+55, 60, 30)];
        
        [tableView setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-150)];
        
        [pickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/3+84, [UIScreen mainScreen].bounds.size.width, 220)];
        
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [resignButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height-220-10, 60, 30)];
        
        [tableView setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
        
        [pickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-200, [UIScreen mainScreen].bounds.size.width, 220)];
       
    }
    else {
        
    }

    
}


+(void)bringUpPicker:(UIView *)pickerView KeyBoardResignButton:(UIButton *)resignButton andUITableView:(UITableView *)tableView {
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        	[resignButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height/2-25, 60, 30)];
        
            [tableView setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
        
            [pickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2+5, [UIScreen mainScreen].bounds.size.width, 220)];
        
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [resignButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height-220-30, 60, 30)];
        
        [tableView setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
        
        [pickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-220, [UIScreen mainScreen].bounds.size.width, 220)];
    }
    else {
        
    }
    
}

+(void)EditTextFieldToBringKeyPad:(UIButton *)keyPadCloseButton andTableView:(UITableView *)tableView {
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
    
        //[keyPadCloseButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 185-15, 60, 30)];
       
        [keyPadCloseButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height/3+55, 60, 30)];
        
       // [tableView setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, 460-44-240+3)];
        
        [tableView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-125)];
       
        //[tableView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TAB_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        
        	//[m_cObjChannelPicker setFrame:CGRectMake(0, 500, 320, 220)];

    }
     else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
     
         [keyPadCloseButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height-246, 60, 30)];
         
         [tableView setFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
         
        // [m_cObjChannelPicker setFrame:CGRectMake(0, 500, 320, 220)];

     }
     else {
         
     }
}


+(float )returnStatusBarHeightForIOS_7 {
    
    float statusHeight;
    
     if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
         
        statusHeight = 10;
     }
     else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
         
         statusHeight = CELL_HEIGHT +MARGIN_BETWEEN_CELLS;
     }
     else {
         
         statusHeight = 0;
     }
    
    return statusHeight;
}

+(UIColor *)actionSheetColorForDifferentIOSVersion {
    

    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
       return [UIColor greenColor];
        
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        return [UIColor greenColor];
        
    }
    else {
        
       return  [UIColor greenColor];
    }
    
   
}

@end
