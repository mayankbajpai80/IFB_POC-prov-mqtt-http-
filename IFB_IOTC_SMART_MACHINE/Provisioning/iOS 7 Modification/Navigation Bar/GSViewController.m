//
//  GSViewController.m
//  Provisioning
//
//  Created by GainSpan India on 25/09/13.
//
//

#import "GSViewController.h"

@interface GSViewController ()<GSNavigationBarDelegate>

@end

@implementation GSViewController

- (id)initWithControllerType:(int)type
{
    self = [super init];
    if (self) {
        
        _navigationBar = [[GSNavigationBar alloc] initWithParentController:self];
       // _navigationBar.backgroundColor = [UIColor clearColor];
        //_navigationBar = [[GSNavigationBar alloc] init];
        [_navigationBar setDelegate:self];
        [_navigationBar setViewControllerType:type];
        [self.view addSubview:_navigationBar];

        
        // Custom initialization
    }
    return self;
}

- (void)navigationItemTapped:(NavigationItem)item {
    
}

//- (void)navigationItemTapped:(NavigationItem)item
//{
//    
//    switch (item) {
//        case NavigationItemBack:
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//            break;
//            
//        case NavigationItemCancel:
//            
//            [self dismissViewControllerAnimated:YES completion:nil];
//            
//            break;
//            
//        default:
//            break;
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
