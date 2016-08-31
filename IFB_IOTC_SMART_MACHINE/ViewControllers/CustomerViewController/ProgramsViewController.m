
//
//  ProgramsViewController.m
//  IFB_IOTC_SMART_MACHINE
//
//  Created by Mayank on 11/05/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

#import "ProgramsViewController.h"
#import "ProgramsCollectionViewCell.h"
#import "Reachability.h"
#import "CustomViewUtils.h"
#import "SharedPrefrenceUtil.h"
#import "AppConstant.h"
#import "SocketConstant.h"
#import "DeviceOpertaionViewController.h"
#import "WashProgramViewController.h"
#import "MySingleton.h"

@interface ProgramsViewController ()
{
    NSArray *programArray;
    NSArray *programImgArray;
    CustomViewUtils *customViewUtils;
    Reachability * reachability;
    SharedPrefrenceUtil *sharedPrefrenceUtil;
}
@end

@implementation ProgramsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    programArray = [NSArray arrayWithObjects:@"WASH PROGRAM", @"CUSTOM PROGRAM", @"FAVOURITE PROPGRAM", @"SPECIAL PROGRAM", @"Cotton ECO 02 : 35 REPEAT PROGRAM", nil];
    programImgArray = [NSArray arrayWithObjects:@"washProgram", @"customProgram", @"favouriteProgram", @"specialProgram", @"repeatProgram", nil];
    customViewUtils = [[CustomViewUtils alloc] init];
    reachability = [Reachability reachabilityForInternetConnection];
    sharedPrefrenceUtil = [[SharedPrefrenceUtil alloc] init];
    
    //[self registerDevice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUI];
}

#pragma mark - Customize navigation bar

/**
 *  customize navigation bar i.e. navigation items, title.
 */
-(void)setUI {
    self.navigationItem.title = [[sharedPrefrenceUtil getNSObject:SELECTED_DEVICE_INFO] valueForKey:@"deviceName"];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(goToPrevious)];
    self.navigationItem.leftBarButtonItem = barBtnItem;
}

-(void)goToPrevious {
    
    [self.navigationController popViewControllerAnimated:YES];
    if ([globalValues.isLocal isEqualToString:@"no"]) {
        // unsubcribe for mqtt topic..
        [globalValues.mqtt unsubscribeForTopic:[NSString stringWithFormat:@"%@",[sharedPrefrenceUtil getNSObject:SUBSCRIBE_TOPIC]]];
    }
}

-(void)popviewVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView delegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width;
    CGFloat height = collectionView.frame.size.height/3 - 25;
    if (indexPath.row == 4) {
        width = collectionView.frame.size.width - 1;
    }
    else {
        width = collectionView.frame.size.width/2 - 1;
    }
    return CGSizeMake(width, height);
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [programArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProgramsCollectionViewCell *cell;
    NSString *identifier = @"ProgramsCollectionViewCell";
    if (cell == nil) {
        cell = [self.progrmaGridView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    }
    cell.programLabel.text = [programArray objectAtIndex:indexPath.row];
    cell.programImageView.image = [UIImage imageNamed:[programImgArray objectAtIndex:indexPath.row]];
    if ((indexPath.row % 2) == 0) {
        cell.programsBackgroundImageView.image = [UIImage imageNamed:@"cotton"];
    }
    else {
        cell.programsBackgroundImageView.image = [UIImage imageNamed:@"express"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WashProgramViewController *programVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WashProgramViewController"];
    [self.navigationController pushViewController:programVC animated:YES];
}
@end
