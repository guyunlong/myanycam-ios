//
//  AppDelegate.m
//  myanycam
//
//  Created by andida on 13-1-9.
//  Copyright (c) 2013年 andida. All rights reserved.
//  你永远都无法叫醒一个装睡的人

#import "AppDelegate.h"
#import "loginViewController.h"
#import "dealWithCommend.h"
#import "APSetingViewController.h"
#import "MYNetDog.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"




@implementation AppDelegate

@synthesize window = _window;
@synthesize loginVC = _loginVC;
@synthesize mainTBC;
@synthesize rootViewController = _rootViewController;
@synthesize mygcdSocketEngine  = _mygcdSocketEngine;
@synthesize serverInfo = _serverInfo;
@synthesize wallPaperController;
@synthesize reLoginAlert;
@synthesize startTimer = _startTimer;
@synthesize heart_Count = _heart_Count;
@synthesize cameraPlayView;
@synthesize apModelOrCloudModel;
@synthesize flagBackgroundToFront = _flagBackgroundToFront;

- (void)dealloc
{
    
    [self.startTimer invalidate];
    self.startTimer = nil;
    
    self.cameraPlayView = nil;
    self.mygcdSocketEngine = nil;
    self.reLoginAlert = nil;
    self.serverInfo = nil;
    self.loginVC = nil;
    [mainTBC release];
    [_window release];
    [checkData release];
    self.rootViewController = nil;
    self.wallPaperController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationLoginSuccess
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KNotificationMYNetAsynsocketError
                                                  object:nil];
    
    [super dealloc];
}


+ (AppDelegate *)getAppDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    DebugLog(@"launchOptions %@ ", launchOptions);
    

    [MobClick startWithAppkey:KMobileClick];
    
    [ShareSDK registerApp:KShareSdkAppKey];//参数为ShareSDK官网中添加应用后得到的AppKey
    
//    [ShareSDK connectFacebookWithAppKey:KFacebookAppKey appSecret:KFacebookAppSecret];
//    [ShareSDK connectTwitterWithConsumerKey:KTwitterAppKey consumerSecret:KTwitterAppSecret redirectUri:KMyanycamUrl];
    [ShareSDK connectQQWithQZoneAppKey:KQQAppId qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectQZoneWithAppKey:KQQAppId appSecret:KQQAppKey];
    
    
    if (1){//[[MYDataManager shareManager] currentSystemLanguage] == DeviceLanaguage_ZH_S
        
        //添加新浪微博应用
        [ShareSDK connectSinaWeiboWithAppKey:KSinaAppId
                                   appSecret:KSinaAppSecret
                                 redirectUri:KMyanycamUrl];
        //添加微信应用
        [ShareSDK connectWeChatWithAppId:KWXAppId        //此参数为申请的微信AppID
                               wechatCls:[WXApi class]];
        
        
        [ShareSDK connectSMS];
        [ShareSDK connectMail];
        [ShareSDK connectCopy];
        
    }
    else
    {
        
//        //添加Facebook应用
//        [ShareSDK connectFacebookWithAppKey:KFacebookAppKey
//                                  appSecret:KFacebookAppSecret];
//        
//        //添加Twitter应用
//        [ShareSDK connectTwitterWithConsumerKey:KTwitterAppKey
//                                 consumerSecret:KTwitterAppSecret
//                                    redirectUri:KMyanycamUrl];
//        
//        [ShareSDK connectSMS];
//        [ShareSDK connectMail];
//        [ShareSDK connectCopy];
        
    }
    
////////////////////////////////////////////////////////////
    
    [MYDataManager shareManager].userInfoData.device_token = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterMain)
                                                 name:kNotificationLoginSuccess
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(askReLogin)
                                                 name:KNotificationMYNetAsynsocketError
                                               object:nil];
    
    self.window = [[[CustomWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    [self reLoginApp];
 
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|  UIRemoteNotificationTypeBadge|  UIRemoteNotificationTypeSound)];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self initAudioSession];
    
    
    return YES;
}

- (void)reLoginApp{
    
    self.apModelOrCloudModel = NO;
    self.flagBackgroundToFront = 0;
    if (self.reLoginAlert) {
        
        return;
    }
    
    NSDictionary *  wifi = [ToolClass fetchSSIDInfo];
    if (wifi) {
        
        NSString * currentWifi =  [wifi objectForKey:@"SSID"];
        [MYDataManager shareManager].currentWifi = currentWifi;
        if (currentWifi) {
            NSRange range = [currentWifi rangeOfString:@"MyAnyCam_"];
            if (range.length > 0) {
                
                [self showWallPaperViewController];
            }
            else
            {
                [self startLoginView];
            }
        }
    }
    else
    {
        [self showWallPaperViewController];
    }
}

- (void)showWallPaperViewController{
    
    
    [self.rootViewController customDismissModalViewControllerAnimated:NO];
    
    WallPaperViewController * controller = [[WallPaperViewController alloc] init];
    controller.delegate = self;
    self.wallPaperController = controller;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.window.rootViewController = controller;
    [controller release];
    
    [self initAppdelegateSocket:ApHostIp port:ApHostPort type:CameraWorkTypeAP timeOut:10];

    [[MYDataManager shareManager] updateImageFile];
}

- (void)wallPaperTimeOut{
    
    [self startLoginView];
}


- (void)startLoginView{
    
    [self showLoginViewController];
    
}

- (void)initAppdelegateSocket:(NSString *)ip port:(NSInteger)port type:(NSInteger)type timeOut:(NSTimeInterval)timeOut{
    
    //设置服务器和端口
    [self.mygcdSocketEngine socketClose];
    self.mygcdSocketEngine = nil;
    
    if (!self.mygcdSocketEngine) {
        
        MYGCDAsyncSocketEngine * engine = [[MYGCDAsyncSocketEngine alloc] initWithDelegate:self socketDelegateQueueName:"name"];
        self.mygcdSocketEngine  = engine;
        [engine release];
    }

    self.mygcdSocketEngine.ipType = type;// 1:ap模式  2:非ap模式
    [self.mygcdSocketEngine openSocketWithTimeOut:timeOut ip:ip port:port];
    
}

- (void)showLoginViewController{
    
    [self.window jumpToRootViewControllerWithOutAnimation];//20140516 andida
    [self.wallPaperController dismissModalViewController];
    [self.window.myRootViewController customDismissModalViewControllerAnimated:NO];
    [self.rootViewController customDismissModalViewControllerAnimated:NO];
    
   
    //初始化登陆界面
     self.apModelOrCloudModel = NO;
    _loginVC=[[loginViewController alloc] init];
    self.window.rootViewController=_loginVC;
       
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationResignActive object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _flagBackgroundToFront = 1;//进入后台
    [self appForegroundToBackground];
    
    if ([MYDataManager shareManager].flagLoginSuccess ||self.apModelOrCloudModel) {
        
        exit(0);
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationBackgroundToForeground object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCellNeedWobble object:nil];
    _flagBackgroundToFront = 2;//返回前台
    DebugLog(@"_flagBackgroundToFront %d",_flagBackgroundToFront);
    [self appBackgroundToForeground];
    DebugLog(@"_flagBackgroundToFront %d",_flagBackgroundToFront);

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationBecomeActive object:nil];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    return UIInterfaceOrientationMaskAll;
}

- (void)appForegroundToBackground{
    
    [self stopTimerAction];
    [self.mygcdSocketEngine stopHeartTimer];
    [MYDataManager shareManager].apnsDict = nil;
}

#pragma mark changeView
- (void)enterMainNotification{
    
    
    cameraListViewController * root = [[cameraListViewController alloc] init];
    self.rootViewController= root;
    self.window.topViewController = root;
    self.window.currentButtonTag = 1;
    [root release];
    
    [self.window hideWaitAlertView];
    self.window.rootViewController = self.rootViewController;
    
    [MYDataManager shareManager].flagLoginSuccess = YES;
    self.flagBackgroundToFront = 0;
    
    [self.loginVC customDismissModalViewControllerAnimated:NO];
    self.loginVC = nil;
    
}
-(void)enterMain
{
    [self performSelectorOnMainThread:@selector(enterMainNotification) withObject:nil waitUntilDone:NO];
}

#pragma mark forNavBarButton
-(UIView *)barButton:(NSString *)imageString bFrame:(CGRect)rect
{
    UIView *result=[[UIView alloc] initWithFrame:rect];
    UIImageView *bgImage=[[UIImageView alloc] initWithFrame:rect];
    bgImage.image=[UIImage imageNamed:imageString];
    [result addSubview:bgImage];
    [bgImage release];
    return [result autorelease];
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];

    DebugLog(@"str %@",str);
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString * str = [NSString stringWithFormat:@"%@",deviceToken];
    NSMutableString * mutableStr = [NSMutableString stringWithFormat:@"%@",str];
    NSRange  range = NSMakeRange(0, [mutableStr length]);
    [mutableStr replaceOccurrencesOfString:@"<" withString:@"" options:NSCaseInsensitiveSearch range:range];
    range = NSMakeRange(0, [mutableStr length]);
    [mutableStr replaceOccurrencesOfString:@">" withString:@"" options:NSCaseInsensitiveSearch range:range];
    [MYDataManager shareManager].userInfoData.device_token = mutableStr;
    DebugLog(@"device token %@",str);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
    DebugLog(@"didReceiveRemoteNotification %@",userInfo);
    NSDictionary * info = [userInfo objectForKey:@"aps"];
    
    if ([[info objectForKey:@"type"] intValue] == CameraApnsStateCall ) {
        
        [MYDataManager shareManager].apnsDict = info;
    }
    
    if ([[info objectForKey:@"type"] intValue] == CameraApnsStateMotion || [[info objectForKey:@"type"] intValue] == CameraApnsStateNoise) {
        
        NSInteger cameraid = [[info objectForKey:@"cameraid"] intValue];
        [[MYDataManager shareManager] addalertEventNumberWithCameraId:cameraid];
        [[MYDataManager shareManager] addAlertApnsDict:info cameraId:cameraid];
    }
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    DebugLog(@"didReceiveRemoteNotification %@",userInfo);
    NSDictionary * info = [userInfo objectForKey:@"aps"];
    if ([[info objectForKey:@"type"] intValue] == CameraApnsStateCall) {
        
        [MYDataManager shareManager].apnsDict = info;
    }

    if ([[info objectForKey:@"type"] intValue] == CameraApnsStateMotion || [[info objectForKey:@"type"] intValue] == CameraApnsStateNoise) {
        
        NSInteger cameraid = [[info objectForKey:@"cameraid"] intValue];
        [[MYDataManager shareManager] addalertEventNumberWithCameraId:cameraid];
        [[MYDataManager shareManager] addAlertApnsDict:info cameraId:cameraid];
    }

}

- (void)aPSetingButtonAction{
    
    
    [self.wallPaperController dismissModalViewControllerAnimated:NO];
    self.wallPaperController = nil;
    
    
    self.apModelOrCloudModel = YES;
    [self.mygcdSocketEngine sendSetCameraTimezone];
    [self startTimerAction];

    [[AppDelegate getAppDelegate].window initCustomBottomBar];
    RootViewController * controller = [[RootViewController alloc] init];
    [AppDelegate getAppDelegate].window.myRootViewController = controller;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.window.rootViewController = controller;
    [controller release];
    
    
    [self.window makeKeyAndVisible];
    
}

- (void)AsyncSocketEngineDelegate:(MYGCDAsyncSocketEngine *)socket data:(NSDictionary *)dictInfo tag:(NSInteger)tag{
    
    
}

- (void)socketDisconnect:(MYGCDAsyncSocketEngine *)socket err:(NSError *)err{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self startLoginView];
    });
}

- (void)checkTokenSuccess{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self aPSetingButtonAction];
    });
}

- (void)appBackgroundToForeground{
    
    
    if (![self.mygcdSocketEngine isConnect]) {
        
        [self reLoginApp];
    }
    else{
        
        _flagBackgroundToFront = 0;

        [self startTimerAction];
        [self.mygcdSocketEngine startHeartSendData];
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        self.reLoginAlert = nil;
        [self reLoginApp];

    }
    
    if (buttonIndex == 0) {
        
        [self.window exitApplication];
    }
}

- (void)askReLogin{
    
    if ([MYDataManager shareManager].flagKickOff || _flagBackgroundToFront > 0) {
        
        return;
    }
    
    if (![self.mygcdSocketEngine isConnect] && [MYDataManager shareManager].flagLoginSuccess) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (!self.reLoginAlert) {
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Alert", nil)
                                          message:NSLocalizedString(@"relogin", nil)
                                          delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                [alertView show];
                self.reLoginAlert = alertView;
                [alertView release];
            }

        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (!self.reLoginAlert) {
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Alert", nil)
                                          message:NSLocalizedString(@"Network Error,try again", nil)
                                          delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                [alertView show];
                self.reLoginAlert = alertView;
                [alertView release];
            }
            
        });
    }
}

- (void)startTimerAction{
    
    _heart_Count = 0;
    _keepPort_Count = 0;
    self.mygcdSocketEngine.heartTokenCount = 0;
    
    if (!self.startTimer) {
        self.startTimer  = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
}

- (void)stopTimerAction{
    
    [self.startTimer invalidate];
    self.startTimer  = nil;
    
}

- (void)timerAction{
    
    _heart_Count ++;
    _keepPort_Count ++;
    _checkUdpDataCount ++ ;
    
    if (_heart_Count > 40) {
        
        _heart_Count = 0;
        [self.mygcdSocketEngine sendHeartData];
    }
    
    if (_keepPort_Count > 50) {
        
        _keepPort_Count = 0;
        
        [[MYDataManager shareManager].myUdpSocket sendDataToKeepNatip];
    }
    
//    if ([MYDataManager shareManager].myUdpSocket.flagStartPlayVideo) {
//        
//        if ([MYDataManager shareManager].currentCameraData.videoQualitySize == 0) {
//            
//            if (_checkUdpDataCount >= 20) {
//                
//                _checkUdpDataCount = 0;
//                [[MYDataManager shareManager].myUdpSocket checkUdpDataLose];
//            }
//        }
//        else
//        {
//            _checkUdpDataCount = 0;
//        }
//    }
//    else{
//        
//        _checkUdpDataCount = 0;
//    }
    

    
    if (self.cameraPlayView) {
        
        [self.cameraPlayView checkaacplayer];
    }
    
}

- (void)initAudioSession
{
    //初始化：如果这个忘了的话，可能会第一次播放不了
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    OSStatus error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    if (error) {
        DebugLog(@"kAudioSessionCategory_PlayAndRecord error %ld",error);
    }
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    error =  AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
    
    
    audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (audioRouteOverride),&audioRouteOverride);
    
    if (error) {
        DebugLog(@"kAudioSessionOverrideAudioRoute_None error %ld",error);
    }
    
    AudioSessionSetActive(true);
    
}


- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    //TODO: 3. 实现handleOpenUrl相关的两个方法，用来处理微信的回调信息
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    NSString * WXSTR = [url absoluteString];
    if ([WXSTR rangeOfString:KWXAppId options:NSCaseInsensitiveSearch].length > 0) {
        
        return YES;
    }
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

@end
