//
//  ModeController.m
//  Provisioning
//
//  Created by GainSpan India on 26/09/14.
//
//

#import "ModeController.h"
#import "GS_ADK_Data.h"
//#import "ProvisioningAppDelegate.h"
#import "MySingleton.h"
#import "Identifiers.h"


@interface ModeController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GS_ADK_Data *shareGsData;

@property (nonatomic, strong) ProvisioningAppDelegate *appDelegate;

@property (nonatomic, assign)   NSInteger checkMarkRow;

//@property (nonatomic, assign) BOOL doesSupportConcurrentMode;

@end

@implementation ModeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    _shareGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    _appDelegate = (ProvisioningAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
   // self.navigationBar.mode = @"Switch Mode";
    
    self.navigationBar.title = @"Switch Mode";
    
    _checkMarkRow = [self selectCheckMarkRow:[[[[_shareGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"]];
        
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)navigationItemTapped:(NavigationItem)item
{
    
    switch (item) {
        case NavigationItemBack:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case NavigationItemCancel:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case NavigationItemInfo:
            
            //[self showInfo];
            
            break;
            
        case NavigationItemMode:
            // [self goToSwitchMode];
            
            break;
            
        default:
            break;
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_shareGsData.doesSupportConcurrentMode && _shareGsData.supportDualInterface) {
        
        return 1;

    }
    else {
        
        return 2;

    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Set the mode of operation of your device to ";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifiers = @"CellIdentifiers";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiers];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiers];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSArray *lObjModeNameList = nil;
    
    if (_shareGsData.doesSupportConcurrentMode && _shareGsData.supportDualInterface) {
    
        lObjModeNameList = [NSArray arrayWithObjects:@"Concurrent", nil];

    }
    else {
        
       lObjModeNameList = [NSArray arrayWithObjects:@"Client",@"Limited AP", nil];

    }
    
    
    cell.textLabel.text = [lObjModeNameList objectAtIndex:indexPath.row];
    
    
    
    if (indexPath.row == _checkMarkRow) {
        
        
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
        else {
            
             cell.accessoryType = UITableViewCellAccessoryNone;
        }
    
    return cell;
}



-(int)selectCheckMarkRow:(NSString *)pObjRow
{
    if ([[[[[_shareGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"client"]) {
        
        return 0;
    }
    else if ([[[[[_shareGsData apConfig] objectForKey:@"network"] objectForKey:@"mode"] objectForKey:@"text"] isEqualToString:@"limited-ap"]){
        return 1;
    }
    else {
        
        return 2;
    }
    
}

#define FOOTER_HEIGHT   50
#define FOOTER_BUTON_X_AXIS 10
#define FOOTER_BUTTON_WIDTH  100

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FOOTER_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, FOOTER_HEIGHT)];
    
    UIButton *lObjButton = [UIButton buttonWithType:UIButtonTypeSystem];
    lObjButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - FOOTER_BUTTON_WIDTH)/2, 0, FOOTER_BUTTON_WIDTH, FOOTER_HEIGHT);
    lObjButton.backgroundColor = [UIColor clearColor];
    [lObjButton setTitle:@"Set Mode" forState:UIControlStateNormal];
    [lObjButton addTarget:self action:@selector(setModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:lObjButton];
    
    return footerView;
}

-(void)setModeButtonClicked
{
    
    if (_checkMarkRow < 3) {
        
        [globalValues.provisionSharedDelegate setMode:_checkMarkRow];
        
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _checkMarkRow = indexPath.row;
    
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
