//
//  ConcurrentModeInfoViewController.m
//  Provisioning
//
//  Created by GainSpan India on 10/07/14.
//
//

#import "ConcurrentModeInfoViewController.h"
#import "GSNavigationBar.h"


@interface ConcurrentModeInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ConcurrentModeInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
  //  self.navigationBar.mode = @"Status";
    
    self.navigationBar.title = @"Provisioning Success";

    
    _concurrentInfoDict = [[NSMutableDictionary alloc] init];
    
    _firstSectionNameArray = [[NSMutableArray alloc] initWithObjects:@"SSID",@"BSSID", @"Channel", nil];
    
    _secondSectionNameArray = [[NSMutableArray alloc] initWithObjects:@"IP Address",@"SubnetMask",@"DNS Address", @"Gateway", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0+ 44 + 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)navigationItemTapped:(NavigationItem)item
{
    switch (item) {
        case NavigationItemDone:
            exit(0);
            break;
            
        default:
            break;
    }
}


#pragma mark - UITableView Delegate && DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return 65.0;
    }
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 44)];

    if (section == 0) {
        
        UILabel *lObjNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 44)];
        [lObjNameLabel setBackgroundColor:[UIColor clearColor]];
        [lObjNameLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [lObjNameLabel setText:[NSString stringWithFormat:@"%@",@"The device has been configured. The network settings are as follows"]];
        lObjNameLabel.textAlignment = NSTextAlignmentLeft;
        [lObjNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
        lObjNameLabel.numberOfLines = 2;
        [lObjNameLabel setTextColor:[UIColor grayColor]];
        [sectionView addSubview:lObjNameLabel];

    }
     return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
       
        return  _firstSectionNameArray.count;
    }
    else {
        
        return _secondSectionNameArray.count;

    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell!= nil) {
        cell = nil;
    }
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        NSLog(@"_firstSectionNameArray >>>>>>> %@",[_firstSectionNameArray objectAtIndex:indexPath.row]);

        
        UILabel *lObjNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
        [lObjNameLabel setBackgroundColor:[UIColor clearColor]];
        [lObjNameLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [lObjNameLabel setText:[NSString stringWithFormat:@"%@",[_firstSectionNameArray objectAtIndex:indexPath.row]]];
        lObjNameLabel.textAlignment = NSTextAlignmentLeft;
        [lObjNameLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [lObjNameLabel setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:lObjNameLabel];
        
        if ([[_firstSectionNameArray objectAtIndex:indexPath.row] isEqualToString:@"SSID"]) {
            
            
            UILabel *lObjSSIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 120, 44)];
            [lObjSSIDLabel setBackgroundColor:[UIColor clearColor]];
            [lObjSSIDLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
            lObjSSIDLabel.textAlignment = NSTextAlignmentRight;
            [lObjSSIDLabel setFont:[UIFont systemFontOfSize:14]];
            [lObjSSIDLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
            [cell.contentView addSubview:lObjSSIDLabel];
            
            lObjSSIDLabel.text = [NSString stringWithFormat:@"%@",[[[[[_concurrentInfoDict objectForKey:@"verification"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"ssid"] objectForKey:@"text"]];
            
            
        }
        
        else if ([[_firstSectionNameArray objectAtIndex:indexPath.row] isEqualToString:@"Channel"]) {
            
            UILabel *lObjChannelLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 120, 44)];
            [lObjChannelLabel setBackgroundColor:[UIColor clearColor]];
            [lObjChannelLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
            lObjChannelLabel.textAlignment = NSTextAlignmentRight;
            [lObjChannelLabel setFont:[UIFont systemFontOfSize:14]];
            [lObjChannelLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
            [cell.contentView addSubview:lObjChannelLabel];
            
            lObjChannelLabel.text = [NSString stringWithFormat:@"%@",[[[[[_concurrentInfoDict objectForKey:@"verification"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"channel"] objectForKey:@"text"]];
            
        }
        
        else if ([[_firstSectionNameArray objectAtIndex:indexPath.row] isEqualToString:@"BSSID"]) {
            
            UILabel *lObjChannelLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 120, 44)];
            [lObjChannelLabel setBackgroundColor:[UIColor clearColor]];
            [lObjChannelLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
            lObjChannelLabel.textAlignment = NSTextAlignmentRight;
            [lObjChannelLabel setFont:[UIFont systemFontOfSize:14]];
            [lObjChannelLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
            [cell.contentView addSubview:lObjChannelLabel];
            
            lObjChannelLabel.text = [NSString stringWithFormat:@"%@",[[[[[_concurrentInfoDict objectForKey:@"verification"] objectForKey:@"client"] objectForKey:@"wireless"] objectForKey:@"bssid"] objectForKey:@"text"]];
            
        }


    }
    else {
        
        NSLog(@" >>>>>>> %@",[_secondSectionNameArray objectAtIndex:indexPath.row]);
        
        UILabel *lObjNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
        [lObjNameLabel setBackgroundColor:[UIColor clearColor]];
        [lObjNameLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [lObjNameLabel setText:[NSString stringWithFormat:@"%@",[_secondSectionNameArray objectAtIndex:indexPath.row]]];
        lObjNameLabel.textAlignment = NSTextAlignmentLeft;
        [lObjNameLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [lObjNameLabel setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:lObjNameLabel];
        
        UILabel *lObjLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 120, 44)];
        [lObjLabel setBackgroundColor:[UIColor clearColor]];
        [lObjLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        lObjLabel.textAlignment = NSTextAlignmentRight;
        [lObjLabel setFont:[UIFont systemFontOfSize:14]];
        [lObjLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
        [cell.contentView addSubview:lObjLabel];


        
         if ([[_secondSectionNameArray objectAtIndex:indexPath.row] isEqualToString:@"IP Address"]) {
            
//            UILabel *lObjIPAddessLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 120, 44)];
//            [lObjIPAddessLabel setBackgroundColor:[UIColor clearColor]];
//            [lObjIPAddessLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
//            lObjIPAddessLabel.textAlignment = NSTextAlignmentRight;
//            [lObjIPAddessLabel setFont:[UIFont systemFontOfSize:14]];
//            [lObjIPAddessLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
//            [cell.contentView addSubview:lObjIPAddessLabel];
            
            lObjLabel.text = [NSString stringWithFormat:@"%@",[[[[[_concurrentInfoDict objectForKey:@"verification"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"ip_addr"] objectForKey:@"text"]];
            
        }
        
        else if ([[_secondSectionNameArray objectAtIndex:indexPath.row] isEqualToString:@"SubnetMask"]) {
            
//            UILabel *lObjSubnetMaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 120, 44)];
//            [lObjSubnetMaskLabel setBackgroundColor:[UIColor clearColor]];
//            [lObjSubnetMaskLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
//            lObjSubnetMaskLabel.textAlignment = NSTextAlignmentRight;
//            [lObjSubnetMaskLabel setFont:[UIFont systemFontOfSize:14]];
//            [lObjSubnetMaskLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
//            [cell.contentView addSubview:lObjSubnetMaskLabel];
            
            lObjLabel.text = [NSString stringWithFormat:@"%@",[[[[[_concurrentInfoDict objectForKey:@"verification"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"subnetmask"] objectForKey:@"text"]];
            
        }
        
        else if ([[_secondSectionNameArray objectAtIndex:indexPath.row] isEqualToString:@"DNS Address"]) {
            
//            UILabel *lObjSubnetMaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 120, 44)];
//            [lObjSubnetMaskLabel setBackgroundColor:[UIColor clearColor]];
//            [lObjSubnetMaskLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
//            lObjSubnetMaskLabel.textAlignment = NSTextAlignmentRight;
//            [lObjSubnetMaskLabel setFont:[UIFont systemFontOfSize:14]];
//            [lObjSubnetMaskLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
//            [cell.contentView addSubview:lObjSubnetMaskLabel];
            
            lObjLabel.text = [NSString stringWithFormat:@"%@",[[[[[_concurrentInfoDict objectForKey:@"verification"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"dns_addr"] objectForKey:@"text"]];
            
        }

        
        else if ([[_secondSectionNameArray objectAtIndex:indexPath.row] isEqualToString:@"Gateway"]) {
            
//            UILabel *lObjGatewayLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 120, 44)];
//            [lObjGatewayLabel setBackgroundColor:[UIColor clearColor]];
//            [lObjGatewayLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
//            lObjGatewayLabel.textAlignment = NSTextAlignmentRight;
//            [lObjGatewayLabel setFont:[UIFont systemFontOfSize:14]];
//            [lObjGatewayLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
//            [cell.contentView addSubview:lObjGatewayLabel];
            
            lObjLabel.text = [NSString stringWithFormat:@"%@",[[[[[_concurrentInfoDict objectForKey:@"verification"] objectForKey:@"client"] objectForKey:@"ip"] objectForKey:@"gateway"] objectForKey:@"text"]];
            
            
        }

    }
    
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.


//    [_firstSectionNameArray release];
//    [_secondSectionNameArray release];
//    [_concurrentInfoDict release];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
