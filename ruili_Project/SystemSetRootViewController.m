//
//  SystemSetRootViewController.m
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "SystemSetRootViewController.h"
#import "AboutViewController.h"
#import "RecordVideoViewController.h"
#import "AlertSettingViewController.h"
#import "AppDelegate.h"
#import "SystemSetAccountCell.h"
#import "correctPasswordViewController.h"
#import "QRWifiSettingViewController.h"
#import "CameraHLSDemoViewController.h"
#import "UINavigationItem+UINavigationItemTitle.h"
#import "SystemSetingTableViewCell.h"

@interface SystemSetRootViewController ()

@end

@implementation SystemSetRootViewController
@synthesize functionSetDataArray = _functionSetDataArray;
@synthesize infomationSetDataArray = _infomationSetDataArray;

- (void)dealloc{
    self.functionSetDataArray = nil;
    self.infomationSetDataArray = nil;
    [_systemSetTableView release];
    [_aboutWebView release];
    [_aboutLogoImageView release];
    [_aboutNameImageView release];
    [_logoutButton release];
    [super dealloc];
}

- (void)prepareData{
    
    self.infomationSetDataArray = [NSMutableArray arrayWithCapacity:2];
    
    SystemSetData * data = nil;
    
    data = [SystemSetData SystemDataWith:NSLocalizedString(@"Account", nil) setType:SystemSetType_Account];
    [self.infomationSetDataArray addObject:data];
    
    if ([MYDataManager shareManager].userInfoData.loginType == LoginTypeNone)
    {
        
         data = [SystemSetData SystemDataWith:NSLocalizedString(@"Change Password", nil) setType:SystemSetType_ChangePassword];
        
        [self.infomationSetDataArray addObject:data];
        
        data = [SystemSetData SystemDataWith:NSLocalizedString(@"About", nil) setType:SystemSetType_About];
        
        [self.infomationSetDataArray addObject:data];
    }
    else
    {
        data = [SystemSetData SystemDataWith:NSLocalizedString(@"About", nil) setType:SystemSetType_About];
        [self.infomationSetDataArray addObject:data];
    }
    

//    [self.functionSetDataArray addObject:NSLocalizedString(@"About", nil)];
//    [self.functionSetDataArray addObject:NSLocalizedString(@"Camera Demo", nil)];
    [self.logoutButton setTitleWithStr:NSLocalizedString(@"Logout",nil) fontSize:14];
    

    
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
    self.isShowBottomBar = NO;
    [self prepareData];
    // Do any additional setup after loading the view from its nib.

    UIImage * bg = [[UIImage imageNamed:@"topBar.png"] resizableImage];
    [self.navigationController.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    
    [self showBackButton:self action:@selector(goToBack) buttonTitle:@""];
    self.systemSetTableView.scrollEnabled = NO;
    self.systemSetTableView.backgroundColor = [UIColor clearColor];
    
    self.systemSetTableView.delegate = self;
    self.systemSetTableView.dataSource = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        
        [self.systemSetTableView setBackgroundView:nil];
        [self.systemSetTableView setBackgroundView:[[[UIView alloc] init] autorelease]];
        [self.systemSetTableView setBackgroundColor:UIColor.clearColor];
    }
    
}

- (void)goToDealFunctionSet:(NSIndexPath *)indexPath{
    
    
    if ([MYDataManager shareManager].userInfoData.loginType == LoginTypeNone)
    {
        switch (indexPath.row) {
                
            case 0://账户
            {
                
            }
                break;
                
            case 1://修改密码
            {
                correctPasswordViewController * controller = [[correctPasswordViewController alloc] init];
                [controller.navigationItem setCustomTitle:NSLocalizedString(@"Change Password", nil)];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
                break;
                
            case 2:
            {
                AboutViewController * controller = [[AboutViewController alloc] init];
                [controller.navigationItem setCustomTitle:NSLocalizedString(@"About", nil)];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            default:
                break;
        }
    }
    else{
        
        switch (indexPath.row) {
                
            case 0://账户
            {
                
            }
                break;
                
            case 1://关于
            {
                AboutViewController * controller = [[AboutViewController alloc] init];
                [controller.navigationItem setCustomTitle:NSLocalizedString(@"About", nil)];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            default:
                break;
        }
    }
    

}

- (void)goToDealInfomationSet:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0://关于
        {
            AboutViewController * controller = [[AboutViewController alloc] init];
            [controller.navigationItem setCustomTitle:NSLocalizedString(@"About", nil)];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            
        }
            break;
        case 1://用户反馈
        {
            
            CameraHLSDemoViewController * viewController = [[CameraHLSDemoViewController alloc] init];
            viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self customPresentModalViewController:viewController animated:YES];
            [viewController release];
            
//            QRWifiSettingViewController * controller = [[QRWifiSettingViewController alloc] init];
//            [controller.navigationItem setCustomTitle:NSLocalizedString(@"Set up Wifi", nil)];
//            controller.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:controller animated:YES];
//            [controller release];
            
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
                [self goToDealFunctionSet:indexPath];
        }
            break;
        case 1:
        {
            [self goToDealInfomationSet:indexPath];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.infomationSetDataArray count];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellStyle = @"cellStyle";
    SystemSetingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    
    if (!cell) {

        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"SystemSetingTableViewCell" owner:nil options:nil];
        if ([views count] > 0) {
                
            cell = [views lastObject];
        }
    }
 
    cell.cellData = [self.infomationSetDataArray objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSystemSetTableView:nil];
    [self setAboutWebView:nil];
    
    [self setAboutLogoImageView:nil];
    [self setAboutNameImageView:nil];
    [self setLogoutButton:nil];
    [super viewDidUnload];
}

- (IBAction)logoutButtonAction:(id)sender {
    
    [MobClick event:@"LO"];
    [[AppDelegate getAppDelegate].mygcdSocketEngine socketClose];
    [[MYDataManager shareManager] deleteAccountFromkeychain:[MYDataManager shareManager].userInfoData.accountIdStr];
    [ShareSDK cancelAuthWithType:[self localLoginTypeToShareSdkShareType:[MYDataManager shareManager].userInfoData.loginType]];
    [self performSelector:@selector(exitApplication) withObject:nil afterDelay:0.1];
    
}

- (ShareType)localLoginTypeToShareSdkShareType:(LoginType)loginType{
    
    ShareType sheraType ;
    
    switch (loginType) {
            
        case LoginTypeQQ:
        {
            sheraType = ShareTypeQQSpace;
        }
            break;
        case LoginTypeFacebook:
        {
            sheraType = ShareTypeFacebook;
        }
            break;
        case LoginTypeTwitter:
        {
            sheraType = ShareTypeTwitter;
        }
            break;
            
        default:
            sheraType = ShareTypeAny;
            break;
    }
    
    return sheraType;
    
}

- (void)exitApplication{
    
    [[AppDelegate getAppDelegate].window exitApplication];
}


@end
