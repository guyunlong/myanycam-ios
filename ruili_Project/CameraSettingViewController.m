//
//  CameraSettingViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraSettingViewController.h"
#import "RecordVideoViewController.h"
#import "CameraNameViewController.h"
#import "TimeZoneViewController.h"
#import "AlertSettingViewController.h"
#import "CameraAccessPasswordViewController.h"
#import "AppDelegate.h"
#import "CameraSystemSettingViewController.h"
#import "UINavigationItem+UINavigationItemTitle.h"
#import "VideoQualitySettingViewController.h"
#import "ShareCameraViewController.h"
#import "EthernetSettingViewController.h"
#import "WiFiSelectViewController.h"
#import "CameraPasswordEditViewController.h"



@interface CameraSettingViewController ()

@end

@implementation CameraSettingViewController
@synthesize functionSetDataArray = _functionSetDataArray;
@synthesize infomationSetDataArray = _infomationSetDataArray;
@synthesize cameraInfo = _cameraInfo;
@synthesize cameraInfoDataArray = _cameraInfoDataArray;
@synthesize shareCameraAlertView;

- (void)dealloc {
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraSettingDelegate = nil;
    self.cameraInfoDataArray = nil;
    self.functionSetDataArray = nil;
    self.infomationSetDataArray = nil;
    self.cameraInfo = nil;
    
    self.shareCameraAlertView.shareDelegate = nil;
    [self.shareCameraAlertView hide];
    self.shareCameraAlertView = nil;
    
    [_cameraSetTableView release];
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

- (void)prepareData{
    
    self.infomationSetDataArray = [NSMutableArray arrayWithCapacity:6];
    
    NSString * string = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Camera Details", nil),self.cameraInfo.cameraName];
    if (!self.cameraInfo.cameraName) {
        
    }
    CameraSetData * data = [CameraSetData cameraSetDataWithCellText:string cellSetType:CameraSetType_CameraInfo];
    [self.infomationSetDataArray addObject:data];
    
    
    if ([AppDelegate getAppDelegate].apModelOrCloudModel)
    {
        string =  NSLocalizedString(@"Select Wi-Fi", nil);
        data = [CameraSetData cameraSetDataWithCellText:string cellSetType:CameraSetType_SetWifi];
        [self.infomationSetDataArray addObject:data];
        
        string =  NSLocalizedString(@"Ethernet Setting", nil);
        data = [CameraSetData cameraSetDataWithCellText:string cellSetType:CameraSetType_SetEthernet];
        [self.infomationSetDataArray addObject:data];
    }

    string =  NSLocalizedString(@"Record Setting", nil) ;
    data = [CameraSetData cameraSetDataWithCellText:string cellSetType:CameraSetType_RecordSet];
    [self.infomationSetDataArray addObject:data];

//    string =  NSLocalizedString(@"Alarm Setting", nil) ;
//    data = [CameraSetData cameraSetDataWithCellText:string cellSetType:CameraSetType_AlarmSet];
//    [self.infomationSetDataArray addObject:data];

    string =  NSLocalizedString(@"Rotate Image 180", nil) ;
    data = [CameraSetData cameraSetDataWithCellText:string cellSetType:CameraSetType_Rotate180];
    [self.infomationSetDataArray addObject:data];

    if ([AppDelegate getAppDelegate].apModelOrCloudModel)
    {
        string =  NSLocalizedString(@"Change Camera Access Password", nil);
        data = [CameraSetData cameraSetDataWithCellText:string cellSetType:CameraSetType_ChangeCameraPassword];
    }
    else
    {
        string =  [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"sn", nil),self.cameraInfo.cameraSn];
        data = [CameraSetData cameraSetDataWithCellText:string cellSetType:CameraSetType_Sn];
    }
    
    [self.infomationSetDataArray addObject:data];
    
    string =  NSLocalizedString(@"Restart Camera", nil);
    data = [CameraSetData cameraSetDataWithCellText:string cellSetType:CameraSetType_Restart];
    [self.infomationSetDataArray addObject:data];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isShowBottomBar = YES;    
    UIImage * bg = [[UIImage imageNamed:@"topBar.png"] resizableImage];
    [self.navigationController.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraSettingDelegate = self;

    if (![AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetCameraVersionRequest:self.cameraInfo.cameraId];

        NSString * imageNormalStr = @"icon_Return.png";
        NSString * imageSelectStr = @"icon_Return_hover.png";
        UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"",nil) size:CGSizeMake(32, 32) target:self action:@selector(goBackAction)];
        self.navigationItem.leftBarButtonItem = backButton;
        _indexof180 = 2;
    }
    else
    {
        _indexof180 = 3;
    }
    
    [self.navigationItem setCustomTitle:NSLocalizedString(@"Camera Settings", nil)];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareData];
    [self.cameraSetTableView reloadData];
}

- (void)goBackAction{
    
    [[AppDelegate getAppDelegate].window jumpToRootViewControllerWithOutAnimation];
}

- (void)goToCameraVersionInfo:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
            
//        case 1://升级
//        {
//
//            if (self.cameraInfo.needUpdate == 1) {
//                
//                [self showAskAlertViewWithButton:@"" msg:NSLocalizedString(@"Are you sure you want to upgrade camera?", nil) userInfo:[NSDictionary dictionaryWithObject:@"AskUpgrade" forKey:KALERTTYPE] okBtn:NSLocalizedString(@"OK", nil)];
//            }
//            
//        }
//            break;
            
        case 1://重启
        {
            
            [self showAskAlertViewWithButton:@"" msg:NSLocalizedString(@"Are you sure restart camera?", nil) userInfo:[NSDictionary dictionaryWithObject:@"askRestart" forKey:KALERTTYPE] okBtn:NSLocalizedString(@"OK", nil)];
            
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(AHAlertView *)alertView otherButtonIndex:(NSInteger)buttonIndex
{
    
    if ([[alertView.userInfo objectForKey:KALERTTYPE] isEqualToString:@"AskUpgrade"]) {
        
            [[AppDelegate getAppDelegate].mygcdSocketEngine sendUpdateCameraVersionRequest:self.cameraInfo.downloadurlStr cameraid:self.cameraInfo.cameraId];
    }
    
    if ([[alertView.userInfo objectForKey:KALERTTYPE] isEqualToString:@"askRestart"]) {
        
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendRestartCameraRequest:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraInfo.cameraId];
        
        
        if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
            
            [[AppDelegate getAppDelegate].window exitApplication];
        }
        else
        {
            [[AppDelegate getAppDelegate].window jumpToRootViewControllerWithOutAnimation];
        }
    }

}

- (void)cancelButtonAction:(NSDictionary *)info{
    
    
}


//- (void)goToDealFunctionSet:(NSIndexPath *)indexPath{
//    
//     if ([AppDelegate getAppDelegate].apModelOrCloudModel){
//      
//         switch (indexPath.row) {
//                 
//             case 0:// WIFI
//             {
//                 [self goToWifiSettingViewController];
//                 
//             }
//                 break;
//             case 1:// Ethernet
//             {
//                 [self goToEthernetSettingViewController];
//                 
//             }
//                 break;
//                 
//             case 2://录像设置
//             {
//                 [self goToRecordVideoSettingViewController];
//                 
//             }
//                 break;
//                 
//             case 3://旋转180度
//             {
//                 if (self.cameraInfo.vflip == 0)
//                 {
//                     
//                     [[self.cameraSetTableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
//                     
//                 }
//                 else
//                 {
//                     [[self.cameraSetTableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//                     
//                 }
//                 
//                 [[AppDelegate getAppDelegate].mygcdSocketEngine sendRotateCameraRequest:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraInfo.cameraId vflip:self.cameraInfo.vflip== 0?1:0];
//                 
//             }
//                 break;
//                 
//            case 4:// 视频质量设置
//            {
//                if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
//
//                    [self showAskAlertViewWithButton:@"" msg:NSLocalizedString(@"Are you sure restart camera?", nil) userInfo:[NSDictionary dictionaryWithObject:@"askRestart" forKey:KALERTTYPE] okBtn:NSLocalizedString(@"OK", nil)];
//                }
//            }
//                 break;
//                
//                 
//             default:
//                 break;
//         }
//     }
//    else
//    {
//        switch (indexPath.row) {
//                
////            case 0:// WIFI
////            {
////                [self goToWifiSettingViewController];
////                
////            }
////                break;
////            case 1:// Ethernet
////            {
////                [self goToEthernetSettingViewController];
////                
////            }
////                break;
//                
//            case 0://录像设置
//            {
//                [self goToRecordVideoSettingViewController];
//                
//            }
//                break;
//                
//            case 1://报警设置
//            {
//                [self goToAlertSettingViewController];
//            }
//                break;
//                
//            case 2://旋转180度
//            {
//                if (self.cameraInfo.vflip == 0)
//                {
//                    
//                    [[self.cameraSetTableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
//                    
//                }
//                else
//                {
//                    [[self.cameraSetTableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//                    
//                }
//                
//                [[AppDelegate getAppDelegate].mygcdSocketEngine sendRotateCameraRequest:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraInfo.cameraId vflip:self.cameraInfo.vflip== 0?1:0];
//                
//            }
//                break;
//                
////            case 5:// 视频质量设置
////            {
////                if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
////                    
////                    [self showAskAlertViewWithButton:@"" msg:NSLocalizedString(@"Are you sure restart camera?", nil) userInfo:[NSDictionary dictionaryWithObject:@"askRestart" forKey:KALERTTYPE] okBtn:NSLocalizedString(@"OK", nil)];
////                }
////                else
////                {
////                    
////                    [self goToVideoQualitySettingViewController];
////                }
////            }
////                break;
//            default:
//                break;
//        }
//    }
//
//}

- (void)goToWifiSettingViewController{
    
    WiFiSelectViewController * controller = [[WiFiSelectViewController alloc] init];
    controller.cameraInfo = self.cameraInfo;
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Wi-Fi", nil)];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)goToEthernetSettingViewController{
    
    EthernetSettingViewController * controller = [[EthernetSettingViewController alloc] init];
    controller.cameraData = self.cameraInfo;
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Ethernet", nil)];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)goToRecordVideoSettingViewController{
    
    RecordVideoViewController * controller = [[RecordVideoViewController alloc] init];
    controller.cameraData = self.cameraInfo;
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Record Setting", nil)];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)goToAlertSettingViewController{
    
    AlertSettingViewController * controller = [[AlertSettingViewController alloc] init];
    controller.cameraData = self.cameraInfo;
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Alarm Setting", nil)];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void)goToVideoQualitySettingViewController{
    
    VideoQualitySettingViewController * controller = [[VideoQualitySettingViewController alloc] init];
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Video Quality Setting", nil)];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)goToCameraSystemSettingViewController{
    
    CameraSystemSettingViewController * controller = [[CameraSystemSettingViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.cameraInfoData = self.cameraInfo;
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Camera Details", nil)];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void)goToChangeCameraPassword{
    
    CameraPasswordEditViewController * controller = [[CameraPasswordEditViewController alloc] init];
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Change Password", nil)];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)goToCameraNameViewController{
    
    CameraNameViewController * controller = [[CameraNameViewController alloc] init];
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Camera Details", nil)];
    controller.cameraName = self.cameraInfo.cameraName;
    controller.cameraInfo = self.cameraInfo;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)goToShareCameraViewController{
    
    ShareCameraViewController * controller = [[ShareCameraViewController alloc] init];
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Share Camera", nil)];
    controller.cameraData = self.cameraInfo;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void)goToCameraAccessPasswordViewController{
    
    CameraAccessPasswordViewController * controller = [[CameraAccessPasswordViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.cameraInfo = self.cameraInfo;
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"Change Password", nil)];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)goToDealInfomationSet:(NSIndexPath *)indexPath{
    
    
    if([AppDelegate getAppDelegate].apModelOrCloudModel)//AP 模式
    {
        switch (indexPath.row) {
                
            case 0://camera info
            {
                if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
                    
                    [self goToCameraSystemSettingViewController];
                }
                else
                {
                    [self goToCameraNameViewController];
                }
            }
                break;
                
            case 3://录像摄像
            {
                [self goToRecordVideoSettingViewController];
            }
                break;
                
//            case 4://报警设置
//            {
//                [self goToAlertSettingViewController];
//            }
//                break;
                
            case 4://rotate 180 degree
            {
                
                CameraSetTableViewCell * cell  = (CameraSetTableViewCell * )[self.cameraSetTableView cellForRowAtIndexPath:indexPath];
                
                if (self.cameraInfo.vflip == 1)
                {
                    cell.checkImageView.image = [UIImage imageNamed:@"Chevron.png"];
                }
                else
                {
                     cell.checkImageView.image = [UIImage imageNamed:@"icon1_2.png"];
                }
                
                [[AppDelegate getAppDelegate].mygcdSocketEngine sendRotateCameraRequest:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraInfo.cameraId vflip:self.cameraInfo.vflip== 0?1:0];
                
            }
                break;
                
            case 5://sn
            {
                [self goToChangeCameraPassword];
            }
                break;
            case 6://重启
            {
                [self showAskAlertViewWithButton:@"" msg:NSLocalizedString(@"Are you sure restart camera?", nil) userInfo:[NSDictionary dictionaryWithObject:@"askRestart" forKey:KALERTTYPE] okBtn:NSLocalizedString(@"OK", nil)];
            }
                break;
            case 1://wifi
            {
                [self goToWifiSettingViewController];
            }
                break;
            case 2://ethernet
            {
                [self goToEthernetSettingViewController];
            }
                break;
            default:
                break;
        }
    }
    else
    {
//        云模式
        switch (indexPath.row) {
                
            case 0://camera info
            {
                if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
                    
                    [self goToCameraSystemSettingViewController];
                }
                else
                {
                    [self goToCameraNameViewController];
                }
            }
                break;
                
            case 1://录像摄像
            {
                [self goToRecordVideoSettingViewController];
            }
                break;
                
//            case 2://报警设置
//            {
//                [self goToAlertSettingViewController];
//            }
//                break;
                
            case 2://rotate 180 degree
            {
                
                CameraSetTableViewCell * cell  = (CameraSetTableViewCell * )[self.cameraSetTableView cellForRowAtIndexPath:indexPath];
                
                if (self.cameraInfo.vflip == 1)
                {
                    cell.checkImageView.image = [UIImage imageNamed:@"Chevron.png"];
                }
                else
                {
                    cell.checkImageView.image = [UIImage imageNamed:@"icon1_2.png"];
                }
                
                [[AppDelegate getAppDelegate].mygcdSocketEngine sendRotateCameraRequest:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraInfo.cameraId vflip:self.cameraInfo.vflip== 0?1:0];
                
            }
                break;
                
            case 3://sn
            {
                
            }
                break;
            case 4://重启
            {
                [self showAskAlertViewWithButton:@"" msg:NSLocalizedString(@"Are you sure restart camera?", nil) userInfo:[NSDictionary dictionaryWithObject:@"askRestart" forKey:KALERTTYPE] okBtn:NSLocalizedString(@"OK", nil)];
            }
                break;
            case 5://sn
            {
                
            }
                break;
                
            default:
                break;
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self goToDealInfomationSet:indexPath];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.infomationSetDataArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellStyle = @"cellStyle";
    
    CameraSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    if (!cell){
        
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"CameraSetTableViewCell" owner:nil options:nil];
        if ([views count] >0 ) {
            
            cell= [views lastObject];
        }
        
        cell.cellData = [self.infomationSetDataArray objectAtIndex:indexPath.row];
        
        if (cell.cellData.cameraSetType == CameraSetType_Rotate180)
        {
            if (self.cameraInfo.vflip == 0) {
             
                cell.checkImageView.image = [UIImage imageNamed:@"Chevron.png"];
            }
            else
            {
                 cell.checkImageView.image = [UIImage imageNamed:@"icon1_2.png"];
            }
        }
    }

    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    
    [self setCameraSetTableView:nil];
    [super viewDidUnload];
}

//newversion：程序的最新版本
//versioninfo：程序的当前版本
//downloadurl：程序的下载路径
//versioninfo：版本的更新信息

//cameraid = 223;
//cmd = "GET_CAMERA_VERSION_RESP";
//downloadurl = "http://121.199.6.197:8081/0101/2.1.7/update";
//fromuid = 223;
//newversion = "2.1.7";
//sessionid = 425391700;
//touid = 268;
//userid = 268;
//version = "2.1.8";
//versioninfo = "";
//xns = "XNS_CLIENT";

- (void)getCameraVersion:(NSDictionary *)dat{
    
    DebugLog(@"dat %@",dat);
    self.cameraInfo.romVersionStr = [dat objectForKey:@"version"];
    self.cameraInfo.downloadurlStr = [dat objectForKey:@"downloadurl"];
    self.cameraInfo.versioninfoStr = [dat objectForKey:@"versioninfo"];
    self.cameraInfo.vflip = [[dat objectForKey:@"vflip"] intValue];
    
    if (![self.cameraInfo.romVersionStr isEqualToString:[dat objectForKey:@"newversion"]]) {
        
        self.cameraInfo.needUpdate = 1;
    }
    else
    {
        self.cameraInfo.needUpdate = 0;
    }
    
    [self prepareData];
    [self.cameraSetTableView reloadData];
}


- (void)updateCameraVersion:(NSDictionary *)dat{
    
    if ([[dat objectForKey:@"ret"] intValue] == 1) {
        
        [self showAutoDismissAlertView:NSLocalizedString(@"Please Insert SD card into camera", nil)];
    }
}

//<cmd=SET_VIDEO_ROTAT_RESP><ret=0> 0:成功 1：不成功
- (void)setRotateCameraRespon:(NSDictionary *)dat{
    
    NSInteger ret = [[dat objectForKey:@"ret"] integerValue];
    if (ret == 0) {
        
        self.cameraInfo.vflip = [[dat objectForKey:@"vflip"] intValue];
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:_indexof180 inSection:1];
        [[self.cameraSetTableView cellForRowAtIndexPath:indexpath] setAccessoryType:self.cameraInfo.vflip == 1 ?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryDisclosureIndicator];
    }
}

@end
