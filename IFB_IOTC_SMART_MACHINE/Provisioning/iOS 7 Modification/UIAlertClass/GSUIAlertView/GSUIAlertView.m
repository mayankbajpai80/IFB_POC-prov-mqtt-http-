//
//  GSUIAlertView.m
//  Alert_Test
//
//  Created by Vikash on 9/12/13.
//  Copyright (c) 2013 GainSpan. All rights reserved.
//

#import "GSUIAlertView.h"
#import "CredentialView.h"
#import "ActivityIndicatorView.h"
#import "IPSettingsView.h"

#define CONTENT_WIDTH 250
#define CONTENT_PADDING 10

@interface GSUIAlertView () {
    
//    UITextField *userNameText ;
//    UITextField *passwordText;

//    CGFloat contentWidth;

}




- (void)addActivityIndicator;

- (void)addConfirmationViewWithData:(NSDictionary *)confirmationData;

- (void)addIPSettingOption;

- (void)addCredentialInputOption;

@end

@implementation GSUIAlertView

@synthesize alertViewStyle = _alertViewStyle;


- (id)initWithInfo:(GSAlertInfo *)info style:(GSUIAlertViewStyle)style delegate:(id<CustomUIAlertViewDelegate>)delegate
{
    
    _alertViewStyle = style;
    
    _parentDelegate =delegate;
        
       
    switch (style) {
            
        case GSUIAlertViewStyleDefault:
            
            // Title + Message + Buttons
            
            self = [super initWithTitle:info.title message:info.message delegate:delegate cancelButtonTitle:info.cancelButtonTitle otherButtonTitles:info.otherButtonTitle,nil];
            
            break;

        case GSUIAlertViewStyleActivityIndicator:
            
            // Message + ContentView + Buttons

            self = [super initWithTitle:info.title message:info.message delegate:delegate cancelButtonTitle:@"Cancel" otherButtonTitles:nil];

            if (self) {
                
                [self addActivityIndicator];

            }

            break;
            
        case GSUIAlertViewStyleConfirmation:
            
            // Title + ContentView + Buttons

            self = [super initWithTitle:info.title message:info.message delegate:delegate cancelButtonTitle:info.cancelButtonTitle otherButtonTitles:info.otherButtonTitle,nil];
            
            // create a ScrollView with info and add on self.

            if (self) {

                [self addConfirmationViewWithData:info.confirmationData];
            }
            
            break;
            
        case GSUIAlertViewStyleIPSetting:

            // Title + ContentView + Buttons

            self = [super initWithTitle:info.title message:info.message delegate:delegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"Next",nil];
            
            // create a segmented control and add on self.
            
            if (self) {

                [self addIPSettingOption];

            }
            
            break;
            
        case GSUIAlertViewStyleCredentialInput:

            // Title + ContentView + Buttons

            self = [super initWithTitle:info.title message:info.message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil];

            // create text input controls to credential entry.

            if (self) {
                
                [self addCredentialInputOption];
                
            }
            
            break;
            
        default:
            
            self = nil;
            
            break;
            
    }
    
    return self;

}

- (void)addActivityIndicator
{

    [self addContentView];
    
    // add subviews and calculate their cumulative height
    
    ActivityIndicatorView *lObjActivityIndicatorView = [[ActivityIndicatorView  alloc] initWithFrame:[self getContentFrame]];
    
    lObjActivityIndicatorView.backgroundColor = [UIColor clearColor];
    
    [_contentView addSubview:lObjActivityIndicatorView];
    
    [lObjActivityIndicatorView.alertActivityIndicator startAnimating];
    
    [self setContentViewHeight:CONTENT_PADDING + lObjActivityIndicatorView.frame.size.height + CONTENT_PADDING];
    

}

- (void)addConfirmationViewWithData:(NSDictionary *)confirmationData
{
    
    [self addContentView];
    
    // add subviews and calculate their cumulative height
    
    [self setContentViewHeight:100];

}

- (void)addIPSettingOption
{

    [self addContentView];
    
    // add subviews and calculate their cumulative height

    _m_cObjIPSettingsView = [[IPSettingsView  alloc] initWithFrame:[self getContentFrame] withDelegate:_parentDelegate];
    
    _m_cObjIPSettingsView.backgroundColor = [UIColor clearColor];
    
    [_contentView addSubview:_m_cObjIPSettingsView];
    
    
    [self setContentViewHeight:CONTENT_PADDING + _m_cObjIPSettingsView.frame.size.height + CONTENT_PADDING];


}

- (void)addCredentialInputOption
{
    
    [self addContentView];
    
    // add subviews and calculate their cumulative height
    
    _m_cObjCredentialView = [[CredentialView  alloc] initWithFrame:[self getContentFrame]];
    
    [_m_cObjCredentialView setBackgroundColor:[UIColor clearColor]];
    
    [_contentView addSubview:_m_cObjCredentialView];
    
    [self setContentViewHeight:CONTENT_PADDING + _m_cObjCredentialView.frame.size.height + CONTENT_PADDING+CONTENT_PADDING];
    
}


-(CGRect)getContentFrame {
    
    switch (self.alertViewStyle) {
            
        case GSUIAlertViewStyleDefault:
        {
            
            return CGRectMake(0, 0, CONTENT_WIDTH, 70);
            
            break;
        }
        case GSUIAlertViewStyleActivityIndicator:
        {
            // Message + ContentView + Buttons
             return CGRectMake(CONTENT_WIDTH/2-30/2, CONTENT_PADDING, 30, 30);
            break;
        }
        case GSUIAlertViewStyleConfirmation:
        {
            // Title + ContentView + Buttons
            
             return CGRectMake(0, 0, CONTENT_WIDTH, 70);
            break;
        }
        case GSUIAlertViewStyleIPSetting:
        {
            // Title + ContentView + Buttons
             return CGRectMake(20, 0, CONTENT_WIDTH-40, 44);
            break;
        }
        case GSUIAlertViewStyleCredentialInput:
        {
            
            // Title + ContentView + Buttons
        
            
            return CGRectMake(0, 0, CONTENT_WIDTH,90);
            
            break;
        }
        default:
        {
            return CGRectZero;
            
            break;
        }
            
    }
}

- (void)addContentView
{

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [self getTitleHeight] + [self getMessageHeight]  + CONTENT_PADDING, CONTENT_WIDTH, 0)];
    [_contentView setBackgroundColor:[UIColor clearColor]];
    [self.alertContentContainer addSubview:_contentView];

}

- (void)setContentViewHeight:(CGFloat)height
{
    
    CGRect frame = _contentView.frame;
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    
    [_contentView setFrame:frame];
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
}


- (CGSize) calculateSize {
    
    switch (self.alertViewStyle) {
            
        case GSUIAlertViewStyleDefault:
        {
            // Title + Message + Buttons

            CGFloat titleHeight = [self getTitleHeight];

            CGFloat messageHeight = [self getMessageHeight];

            CGFloat buttonHeight = [super totalButtonHeight];
            
            return CGSizeMake(CONTENT_WIDTH, titleHeight + CONTENT_PADDING + messageHeight + CONTENT_PADDING + buttonHeight);

            break;
        }
        case GSUIAlertViewStyleActivityIndicator:
        {
            // Message + ContentView + Buttons
            
            CGFloat messageHeight = [self getMessageHeight];
            
            CGFloat contentHeight = [self getAlertContentHeight];
            
            CGFloat buttonHeight = [super totalButtonHeight];

            return CGSizeMake(CONTENT_WIDTH, messageHeight + CONTENT_PADDING + contentHeight + CONTENT_PADDING + buttonHeight);

            break;
        }
        case GSUIAlertViewStyleConfirmation:
        {
            // Title + ContentView + Buttons
            
            
            CGFloat titleHeight = [self getTitleHeight];
            
            CGFloat contentHeight = [self getAlertContentHeight];
            
            CGFloat buttonHeight = [super totalButtonHeight];
            
            return CGSizeMake(CONTENT_WIDTH, titleHeight + CONTENT_PADDING + contentHeight + CONTENT_PADDING + buttonHeight);


            break;
        }
        case GSUIAlertViewStyleIPSetting:
        {
            // Title + ContentView + Buttons

            
            CGFloat titleHeight = [self getTitleHeight];
            
            CGFloat contentHeight = [self getAlertContentHeight];
            
            CGFloat buttonHeight = [super totalButtonHeight];
            
            return CGSizeMake(CONTENT_WIDTH, titleHeight + CONTENT_PADDING + contentHeight + CONTENT_PADDING + buttonHeight);
            
            break;
        }
        case GSUIAlertViewStyleCredentialInput:
        {
            
            // Title + ContentView + Buttons

            CGFloat titleHeight = [self getTitleHeight];

            CGFloat contentHeight = [self getAlertContentHeight];

            CGFloat buttonHeight = [super totalButtonHeight];
            
            return CGSizeMake(CONTENT_WIDTH, titleHeight + CONTENT_PADDING + contentHeight + CONTENT_PADDING + buttonHeight);
            
            break;
        }
        default:
        {
            return CGSizeZero;
            
            break;
        }
            
    }

    return CGSizeZero;
}

- (CGFloat)getTitleHeight {

    return [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(CONTENT_WIDTH, CGFLOAT_MAX)].height;
    
}

- (CGFloat)getMessageHeight
{
    
    return [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(CONTENT_WIDTH, CGFLOAT_MAX)].height;

}

- (CGFloat)getAlertContentHeight
{
    
    return _contentView.frame.size.height;
}


@end
