//
//  GSNavigationBar.m
//  Provisioning
//
//  Created by GainSpan India on 25/09/13.
//
//

#import "GSNavigationBar.h"
#import "Identifiers.h"

@interface GSNavigationBar ()



@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *infoButton;

@property (nonatomic, strong) UIButton *modeButton;

@property (nonatomic, strong) UIButton *doneButton;

//@property (nonatomic, assign) GSViewController *parentController;

@property (nonatomic, strong) UILabel *modeStatusLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GSNavigationBar

- (id)initWithParentController:(GSViewController *)parentController

//- (id)initWithParentController
{
    
    self = [super init];
    
    if (self) {
    
        // Initialization code
        
       // self.backgroundColor = [UIColor redColor];
        
        [self setFrame:CGRectMake(0, 0, 320, 66)];
        
       // _parentController = parentController;
        
       // [self determineParentControllerType];
        
//        switch (_viewControllerType) {
//                
//            case ViewControllerTypeRoot:
//                
//                [self addModeButton];
//
//                break;
//                
//            case ViewControllerTypeRegular:
//                
//                [self addBackButton];
//
//                [self addModeButton];
//
//                break;
//                
//            case ViewControllerTypeModal:
//
//                [self addDoneButton];
//
//                [self addCancelButton];
//
//                break;
//
//            default:
//                break;
//        }
//        
//        [self addInfoButton];
//        
//        [self addModeStatus];
//
//        [self addTitle];
        
    }
    
    return self;

}

-(void)setViewControllerType:(int)Type {
    
    _viewControllerType = Type;
    
    switch (_viewControllerType) {
            
        case ViewControllerTypeRoot:
            
            [self addModeButton];
            
            [self addInfoButton];
            
            break;
            
        case ViewControllerTypeRegular:
            
            [self addBackButton];
            
            [self addModeButton];
            
            [self addInfoButton];
            
            break;
            
        case ViewControllerTypeModal:
            
            [self addDoneButton];
            
            [self addCancelButton];
            
            [self addInfoButton];
            
            break;
            
        case ViewControllerTypeInfo:
            
            [self addCancelButton];
            
            break;
            
        case ViewControllerTypeCuncurrent:
            
            [self addDoneButton];
            
            break;
            
        case ViewControllerTypeMode:
        
            [self addBackButton];
            
            break;
            
        case ViewControllerTypeSummary:
            [self addBackButton];
            [self addDoneButton];
            break;
            
        default:
            break;
    }
    
    
    [self addModeStatus];
    
    [self addTitle];

}


//- (void)determineParentControllerType
//{
//    
//    //_viewControllerType = ViewControllerTypeRoot;
//    
//    ClientModeViewController *x = (ClientModeViewController *)_parentController;
//    
//    NSLog(@"parentViewController : %@",x.parentViewController);
//
//    if (_parentController.navigationController != nil) {
//        
//        //UINavigationController *parentNavigationController = (UINavigationController *)_parentController.parentViewController;
//        
//        if (_parentController.navigationController.viewControllers.count == 0) {
//            
//            _viewControllerType = ViewControllerTypeRoot;
//            
//        }
//        else{
//            
//            _viewControllerType = ViewControllerTypeRegular;
//            
//        }
//        
//        
//    }
//    else{
//        
//        _viewControllerType = ViewControllerTypeModal;
//    }
//    
//}

//- (void)determineParentControllerType
//{
//    if ([_parentController.parentViewController isKindOfClass:[UINavigationController class]]) {
//    
//        UINavigationController *parentNavigationController = (UINavigationController *)_parentController.parentViewController;
//
//        if (parentNavigationController.viewControllers.count == 1) {
//            
//            _viewControllerType = ViewControllerTypeRoot;
//
//        }
//        else{
//        
//            _viewControllerType = ViewControllerTypeRegular;
//
//        }
//        
//
//    }
//    else{
//    
//            _viewControllerType = ViewControllerTypeModal;
//    }
//    
//}

- (void)addBackButton
{
    
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
            _backButton.frame = CGRectMake(3, 5, 54+10, 33+15);
            [_backButton setBackgroundImage:[UIImage imageNamed:@"Back_normel.png"] forState:UIControlStateNormal];
        
        }
        else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
            [_backButton setFrame:CGRectMake(5, 20+10, 50, 25)];
            [_backButton setTitle:@"❬Back" forState:UIControlStateNormal];
        
        }
        [_backButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_backButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];

}

- (void)addCancelButton
{
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cancelButton setFrame:CGRectMake(10, 35, 50, 25)];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_cancelButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
}


- (void)addInfoButton
{
    
    _infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [_infoButton setFrame:CGRectMake(233, 22, 20, 20)];
        
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [_infoButton setFrame:CGRectMake(233, 27, 20, 20)];
        
    }
    
    [_infoButton addTarget:self action:@selector(infoButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_infoButton];
    
}

- (void)addModeButton
{
    
    _modeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
     
        [_modeButton setFrame:CGRectMake(260,5, 56, 56)];

    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [_modeButton setFrame:CGRectMake(260,15, 56, 56)];

    }
    
    [_modeButton setTitle:@"Set\nMode" forState:UIControlStateNormal];
    [_modeButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_modeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    _modeButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_modeButton.titleLabel setNumberOfLines:3];
    [_modeButton addTarget:self action:@selector(modeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_modeButton];
    
}

- (void)addDoneButton
{
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneButton setFrame:CGRectMake(320-60, 35, 50, 25)];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_doneButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [_doneButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_doneButton];

}

- (void)backButtonTapped
{
    [self.delegate navigationItemTapped:NavigationItemBack];
}

- (void)cancelButtonTapped
{
    [self.delegate navigationItemTapped:NavigationItemCancel];
}

- (void)infoButtonTapped
{
    [self.delegate navigationItemTapped:NavigationItemInfo];
}

- (void)doneButtonTapped
{
    [self.delegate navigationItemTapped:NavigationItemDone];
}

- (void)modeButtonTapped
{
    [self.delegate navigationItemTapped:NavigationItemMode];
}

- (void)addModeStatus
{
    _modeStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 35)];
    [_modeStatusLabel setBackgroundColor:[UIColor clearColor]];
    [_modeStatusLabel setFont:[UIFont systemFontOfSize:12]];
    [_modeStatusLabel setTextAlignment:NSTextAlignmentCenter];
    [_modeStatusLabel setNumberOfLines:2];
   // [_modeStatusLabel setText:@"Mode : Client"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [_modeStatusLabel setTextColor:[UIColor whiteColor]];

    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [_modeStatusLabel setTextColor:[UIColor lightGrayColor]];

    }
    
    [self addSubview:_modeStatusLabel];
}


- (void)addTitle
{
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, 22)];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
   // [_titleLabel setText:@"Manual Settings"];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        [_titleLabel setTextColor:[UIColor whiteColor]];
        
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [_titleLabel setTextColor:[UIColor colorWithRed:(51/255.0) green:(153/255.0) blue:(255/255.0) alpha:1]];
        
    }

    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_titleLabel];

}

- (void)setTitle:(NSString *)title
{
    [_titleLabel setText:title];
}

- (void)setMode:(NSString *)mode
{
    [_modeStatusLabel setText:mode];
}

- (NSString *)title
{
    return _titleLabel.text;
}

- (NSString *)mode
{
    return _modeStatusLabel.text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
