//
//  SettingRootViewController.m
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "SettingRootViewController.h"
#import "WifiSettingViewController.h"
#import "WiFiSelectViewController.h"
#import "EthernetSettingViewController.h"
#import "RecordVideoViewController.h"
#import "AlertSettingViewController.h"
#import "CameraSystemSettingViewController.h"
#import "AppDelegate.h"
#import "VideoQualitySettingViewController.h"
#import "UINavigationItem+UINavigationItemTitle.h"

@interface SettingRootViewController ()

@end

@implementation SettingRootViewController
@synthesize sectionTitleArray = _sectionTitleArray;
@synthesize videoDataArray  = _videoDataArray;
@synthesize netDataArray = _netDataArray;
@synthesize functionDataArray = _functionDataArray;
@synthesize cameraInfo;

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCameraInfoAlertEvent object:nil];

    self.sectionTitleArray = nil;
    self.videoDataArray = nil;
    self.videoDataArray = nil;
    self.netDataArray = nil;
    self.functionDataArray = nil;
    self.cameraInfo = nil;
    
    [_settingRootTableView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isShowBottomBar = NO;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        
        [self.settingRootTableView setBackgroundView:nil];
        [self.settingRootTableView setBackgroundView:[[[UIView alloc] init] autorelease]];
        [self.settingRootTableView setBackgroundColor:UIColor.clearColor];
        
    }
    
    [self prepareData];
    
    [self.settingRootTableView reloadData];
    self.settingRootTableView.scrollEnabled = NO;
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraDeviceDelegate = self;
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetDeviceInfoString];
    
}

- (void)getDeviceInfoRsp:(NSDictionary *)info{
    
    [[MYDataManager shareManager] updateCameraInfo:info];
    self.cameraInfo = [MYDataManager shareManager].cameraDeviceInfo;
    [[AppDelegate getAppDelegate].window hideWaitAlertView];
}

- (void)prepareData{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertEventAlertView:) name:kNotificationCameraInfoAlertEvent object:nil];

    self.netDataArray = [NSMutableArray arrayWithCapacity:0];
    self.functionDataArray = [NSMutableArray arrayWithCapacity:0];
    self.videoDataArray = [NSMutableArray arrayWithCapacity:0];
    self.sectionTitleArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.videoDataArray addObject:NSLocalizedString(@"Watch Video", nil)];
    [self.netDataArray addObject:NSLocalizedString(@"Select Wi-Fi",nil)];
    [self.netDataArray addObject:NSLocalizedString(@"Ethernet Setting", nil)];

    [self.functionDataArray addObject:NSLocalizedString(@"Restart Camera", nil)];

    UIImage * bg = [[UIImage imageNamed:@"topBar.png"] resizableImage];
    [self.navigationController.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
  
    UIBarButtonItem * finishButton = [ViewToolClass customBarButtonItem:@"buttonNormal.png"
                                             buttonSelectImage:@"buttonSelect.png"
                                                         title:NSLocalizedString(@"Done", nil)
                                                          size:CGSizeMake(64, 32)
                                                        target:self
                                                        action:@selector(goToLoginViewController)];
    self.navigationItem.rightBarButtonItem = finishButton;
    
}

- (void)goToLoginViewController{
    
    [[AppDelegate getAppDelegate].window exitApplication];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)goToSettingSectionOne:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0://wifi
        {
            WiFiSelectViewController * controller = [[WiFiSelectViewController alloc] init];
            controller.title = @"Wi-Fi";
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case 1://以太网
        {
            EthernetSettingViewController * controller = [[EthernetSettingViewController alloc] init];
            controller.title = NSLocalizedString(@"Ethernet", nil);
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
}

-  (void)goToWatchVideo{
    
    
}

- (void)goToDealFunctionSet:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
            
        case 0://重启
        {
            [self showAskAlertViewWithButton:@"" msg:NSLocalizedString(@"Are you sure restart camera ? App will exit !", nil) userInfo:[NSDictionary dictionaryWithObject:@"askRestart" forKey:KALERTTYPE] okBtn:NSLocalizedString(@"OK", nil)];
        }
            break;

        case 1://报警设置
        {
            
            AlertSettingViewController * controller = [[AlertSettingViewController alloc] init];
            [controller.navigationItem setCustomTitle:NSLocalizedString(@"Alarm Setting", nil)];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
            
        default:
            break;
    }
}

- (void)goToNetSetting:(UITableView *)tableView didSelected:(NSIndexPath *)indexPath {
    
    
}

- (void)goToSystemSetting{
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            //网络设置
            [self goToSettingSectionOne:tableView didSelectRowAtIndexPath:indexPath];
        }
            break;
        case 1:
        {
            //报警 录像
            [self goToDealFunctionSet:indexPath];
        }
            break;
        case 2:
        {
            
            CameraInfoData * cameraData = [[CameraInfoData alloc] init];
            cameraData.status = 1;
            cameraData.cameraSn = self.cameraInfo.sn;
            cameraData.cameraId = 0;
            cameraData.producter = self.cameraInfo.producter;
            cameraData.mode = self.cameraInfo.mode;
            cameraData.timezone = self.cameraInfo.timezone;
            [[AppDelegate getAppDelegate].window initCustomBottomBar];
            RootViewController * controller = [[RootViewController alloc] init];
            controller.cameraData = cameraData;
            [AppDelegate getAppDelegate].window.myRootViewController = controller;
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            [self.navigationController pushViewController:controller animated:YES];
            [self customPresentModalViewController:controller animated:YES];
            [controller release];
            
            [MYDataManager shareManager].currentCameraData = cameraData;
            [cameraData release];
            
        }
            break;
        default:
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case 0:
        {
            number = [self.netDataArray count];
        }
            break;
        case 1:
        {
            number = [self.functionDataArray count];
        }
            break;
        case 2:
        {
            number = [self.videoDataArray count];
        }
            break;
        default:
            break;
    }
    
    return number;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NSString * string = nil;
    switch (section) {
        case 0:
            string = NSLocalizedString(@"Net Setting", nil);
            break;

        default:
            break;
    }
    return string;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * styleString = @"setting";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:styleString];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:styleString] autorelease];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = [self.netDataArray objectAtIndex:indexPath.row];
        }
            break;
        case 1:
        {
            cell.textLabel.text = [self.functionDataArray objectAtIndex:indexPath.row];
        }
            break;
        case 2:
        {
            cell.textLabel.text = [self.videoDataArray objectAtIndex:indexPath.row];
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)viewDidUnload {
    
    [self setSettingRootTableView:nil];
    [super viewDidUnload];
}

- (void)setDeviceInfoRsp:(NSDictionary *)info
{
    
}

- (void)alertView:(AHAlertView *)alertView otherButtonIndex:(NSInteger)buttonIndex
{
    
    if ([[alertView.userInfo objectForKey:KALERTTYPE] isEqualToString:@"askRestart"]) {
        
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendRestartCameraRequest:0 cameraid:0];
        [[AppDelegate getAppDelegate].window exitApplication];
    }
    
}

- (void)alertEventAlertView:(NSNotification *)sender{
    
    NSDictionary * dict = sender.userInfo;
    NSInteger type = [[dict objectForKey:@"type"] intValue];
    if (type == AlertTypeLow_Power)
    {
        
        NSString * tip = NSLocalizedString(@"Camera‘s battery is low!", nil);
        
        if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
            
            tip = NSLocalizedString(@"Camera‘s battery is low!", nil);
        }
        else
        {
            CameraInfoData * cameraData = [[MYDataManager shareManager] getCameraInfoWithCameraId:[[dict objectForKey:@"cameraid"] intValue]];
            tip = [NSString stringWithFormat:tip,cameraData.cameraName];
        }
        
        [self showAutoDismissAlertView:tip];
        
    }
}


@end
