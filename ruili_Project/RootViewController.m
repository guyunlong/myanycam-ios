//
//  RootViewController.m
//  Myanycam
//
//  Created by myanycam on 13-3-14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "UIViewController+Helper.h"
#import "UITabBarController+BetterRotation.h"


@interface RootViewController ()

@end

@implementation RootViewController
@synthesize bottomBarView = _bottomBarView;
@synthesize cameraViewController = _cameraViewController;
@synthesize fileListVC = _fileListVC;
@synthesize alertEventController = _alertEventController;
@synthesize settingVC = _settingVC;
@synthesize currentController = _currentController;
@synthesize cameraData = _cameraData;
@synthesize changePwdAlertView = _changePwdAlertView;
@synthesize cameraDeviceInfo = _cameraDeviceInfo;
@synthesize needDissmiss;

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationKICK_OFF object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationRootControllerDismiss object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationCameraState object:nil];

    
    self.currentController = nil;
    self.changePwdAlertView = nil;
    self.cameraDeviceInfo = nil;
    
    
    [AppDelegate getAppDelegate].window.bottomBarView.cameraData = nil;
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraDeviceDelegate = nil;

    
    self.cameraData = nil;
    self.bottomBarView = nil;
    self.cameraViewController = nil;
    self.fileListVC = nil;
    self.settingVC = nil;
    self.alertEventController = nil;
    [_rootTopViewController release];
    [_backImageView release];
    [super dealloc];
}


-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)initWithCameraData:(CameraInfoData *)cameraData{
    
    if (self) {
        self = [super init];
        self.cameraData = cameraData;
    }
    
    return self;
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
     self.isShowBottomBar = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToCameraListViewController:) name:kNotificationRootControllerDismiss object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(notifyCameraState:) name:KNotificationCameraState object:nil];
    

    [[AppDelegate getAppDelegate].window showCustomBottomBar];
    [[AppDelegate getAppDelegate].window.bottomBarView showEventStateImage];
    
    
    if ([ToolClass systemVersionFloat] >= 7.0)
    {
        CGRect rect = self.rootTopViewController.frame;
        rect.size.height = 64;
        self.rootTopViewController.frame = rect;
    }

//    self.backImageView.center = self.view.center;
    
    [self.rootTopViewController setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];
    
    self.currentController = nil;
    
    if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraDeviceDelegate = self;
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetDeviceInfoString];
        
//        RTSPPlayViewController * rtspPlayer = [[RTSPPlayViewController alloc] initWithNibName:@"RTSPPlayViewController" bundle:nil];
//        rtspPlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        self.currentController = rtspPlayer;
//        [rtspPlayer release];
        
        cameraViewViewController * controller =[[cameraViewViewController alloc] initWithNibName:@"cameraViewViewController" bundle:nil info:self.cameraData];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.flagNeedAutoP2p = YES;
        self.currentController = controller;
        self.cameraViewController = controller;
        [AppDelegate getAppDelegate].cameraPlayView = controller;
        [controller release];
        
    }
    else
    {
        cameraViewViewController * controller =[[cameraViewViewController alloc] initWithNibName:@"cameraViewViewController" bundle:nil info:self.cameraData];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.flagNeedAutoP2p = NO;
        self.currentController = controller;
        self.cameraViewController = controller;
        [AppDelegate getAppDelegate].cameraPlayView = controller;
        [controller release];
    }
    

    
}

- (UIAlertView *)showAlertView:(NSString *)titleStr alertMsg:(NSString *)alertMsg userInfo:(NSDictionary *)userInfo delegate:(id<UIAlertViewDelegate>)delegate canclButtonStr:(NSString *)canclButtonStr otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    
    MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:titleStr
                                                      message:alertMsg
                                                     delegate:delegate
                                            cancelButtonTitle:canclButtonStr
                                            otherButtonTitles:nil];
    alertView.userInfo = userInfo;
    [alertView show];
    [alertView release];
    return alertView;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if ([alertView isKindOfClass:[MYAlertView class]]) {
        
        MYAlertView * alert = (MYAlertView *)alertView;
        if ([[alert.userInfo objectForKey:KALERTTYPE] isEqualToString:@"KICK_OFF"]) {
            
            if (buttonIndex == 0) {
                
                [[AppDelegate getAppDelegate].window exitApplication];
            }
        }
        
        if ([[alert.userInfo objectForKey:KALERTTYPE] isEqualToString:@"CameraStatus"]) {
            
            if (buttonIndex == 0) {
                
                [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
                
                [[AppDelegate getAppDelegate].window jumpToRootViewControllerWithOutAnimation];
            }
        }
    }
    

}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if(!self.needDissmiss)
    {
        [self customPresentModalViewController:self.currentController animated:NO];
        
        AppDelegate * appDelegate = [self appDelegate];
        appDelegate.window.currentButtonTag = 1;
        [appDelegate.window bringBottomToFront];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismisscurrentViewController{
    
    self.needDissmiss = YES;
    [self.currentController  customDismissModalViewControllerAnimated:NO];
    self.currentController = nil;
    self.cameraViewController = nil;
}

- (void)showCameraViewController{

    if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
        
//        RTSPPlayViewController * rtspPlayer = [[RTSPPlayViewController alloc] initWithNibName:@"RTSPPlayViewController" bundle:nil];
//        rtspPlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        self.currentController = rtspPlayer;
//        [rtspPlayer release];
//        [self customPresentModalViewController:rtspPlayer animated:YES];
        
        cameraViewViewController *controller=[[cameraViewViewController alloc] initWithNibName:@"cameraViewViewController" bundle:nil info:self.cameraData];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.flagNeedAutoP2p = YES;
        self.currentController = controller;
        [AppDelegate getAppDelegate].cameraPlayView = controller;
        [controller release];
        
        [self customPresentModalViewController:self.currentController animated:NO];

    }
    else
    {
        cameraViewViewController *controller=[[cameraViewViewController alloc] initWithNibName:@"cameraViewViewController" bundle:nil info:self.cameraData];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.flagNeedAutoP2p = YES;
        self.cameraViewController = controller;
        self.currentController = self.cameraViewController;
        [AppDelegate getAppDelegate].cameraPlayView = controller;
        [controller release];
        
        [self customPresentModalViewController:self.currentController animated:NO];

    }
}

- (void)showFileViewController{
        
    PhotosGridViewController *fileListVC=[[PhotosGridViewController alloc] init];
    fileListVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.fileListVC = fileListVC;
    self.currentController = self.fileListVC;
    [fileListVC release];

    [self customPresentModalViewController:self.currentController animated:YES];

}

- (void)showUserViewController{

    EventAlertViewController * controller = [[EventAlertViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.cameraInfo = self.cameraData;
    self.alertEventController = controller;
    self.currentController = self.alertEventController;
    [controller release];

    [self customPresentModalViewController:self.currentController animated:YES];
    
}

- (void)showSettingViewController{
    
    CameraSettingNavigationController *settingVC=[[CameraSettingNavigationController alloc] init];
    settingVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.settingVC = settingVC;
    self.settingVC.cameraInfo = self.cameraData;
     self.currentController = self.settingVC;
    [settingVC release];
    
   
    [self customPresentModalViewController:self.currentController animated:YES];
}

- (BOOL)shouldAutorotate{
    
     UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if ([self.currentController isKindOfClass:[cameraViewViewController class]]) {
        
        return  [self.currentController shouldAutorotate];
    }
    
    if (orientation == UIInterfaceOrientationPortrait) {
        
        return YES;
    }
    
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if ([self.currentController isKindOfClass:[cameraViewViewController class]]) {
       
        return  [self.currentController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    
    return NO;
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
    
    return YES;
}

- (void)backToCameraListViewController:(UIViewController *)controller{
    
    [self customDismissModalViewControllerAnimated:NO];
}

- (void)notifyCameraState:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSNotification * notify = (NSNotification *)sender;
        NSInteger cameraid = [[notify.userInfo objectForKey:@"cameraid"] intValue];
        CameraState cameraState = [[notify.userInfo objectForKey:@"status"] intValue];
        
        if ( cameraState == CameraStateOffline && cameraid == self.cameraData.cameraId )
        {
            
            NSDictionary * userInfo = [NSDictionary dictionaryWithObject:@"CameraStatus" forKey:@"KALERTTYPE"];
            NSString * tip = [NSString stringWithFormat:NSLocalizedString(@"Camera:%@ is offline", nil),self.cameraData.cameraName];
            
            [self showAlertView:tip alertMsg:nil userInfo:userInfo  delegate:self canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        }
        
        if ([[notify.userInfo objectForKey:@"status"] intValue] == CameraStateUpdate
            && [[notify.userInfo objectForKey:@"cameraid"] intValue] == self.cameraData.cameraId )
        {
            
            self.cameraData.needUpdate = 2;//升级中
            NSDictionary * userInfo = [NSDictionary dictionaryWithObject:@"CameraStatus" forKey:@"KALERTTYPE"];
            NSString * tip = [NSString stringWithFormat:NSLocalizedString(@"Camera:%@ is upgrade", nil),self.cameraData.cameraName];
            
            [self showAlertView:tip alertMsg:nil userInfo:userInfo  delegate:self canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        }
        
        if (cameraState == CameraStateOffline) {
            
            [[MYDataManager shareManager] setCameraStateValueWithCameraId:cameraid];
        }
        
    });

}


- (void)viewDidUnload {
    
    [self setRootTopViewController:nil];
    [self setBackImageView:nil];
    [super viewDidUnload];
}

- (void)customDismissModalViewControllerAnimated:(BOOL)animated
{
    [AppDelegate getAppDelegate].window.myRootViewController  = nil;
    [super customDismissModalViewControllerAnimated:animated];
}


- (void)getDeviceInfoRsp:(NSDictionary *)info{
    
    [[MYDataManager shareManager] updateCameraInfo:info];
    self.cameraDeviceInfo = [MYDataManager shareManager].cameraDeviceInfo;
    [[AppDelegate getAppDelegate].window hideWaitAlertView];
    
    CameraInfoData * cameraData = [[CameraInfoData alloc] init];
    cameraData.status = 1;
    cameraData.cameraSn = self.cameraDeviceInfo.sn;
    cameraData.cameraName = KAppName;
    cameraData.cameraId = 0;
    cameraData.producter = self.cameraDeviceInfo.producter;
    cameraData.mode = self.cameraDeviceInfo.mode;
    cameraData.timezone = self.cameraDeviceInfo.timezone;
    cameraData.vflip = [[info objectForKey:@"vflip"] intValue];
    self.cameraData = cameraData;
    [MYDataManager shareManager].currentCameraData = cameraData;
    [cameraData release];
}



@end
