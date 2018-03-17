//
//  AppDelegate.h
//  myanycam
//  好的用户体验，是从细节开始，并贯穿于每一个细节
//  Created by andida on 13-1-9.
//  Copyright (c) 2013年 andida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dealWithData.h"

//#import <FacebookSDK/FacebookSDK.h>
//#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import "MYGCDAsyncSocketEngine.h"
#import "WallPaperDelegate.h"
#import "WallPaperViewController.h"
#import "loginViewController.h"
#import "CustomWindow.h"
#import "cameraListViewController.h"
#import "MYDataManager.h"


@protocol MyAppCallBackDelegate;
@protocol GCDAsyncSocketEngineDelegate;



@interface AppDelegate : UIResponder <UIApplicationDelegate,GCDAsyncSocketEngineDelegate,WallPaperDelegate>
{
    NSData *checkData;
    NSInteger _step;
    CustomWindow * _window;
    cameraListViewController * _rootViewController;
    MYGCDAsyncSocketEngine * _mygcdSocketEngine;
    NSDictionary    *_serverInfo;
    loginViewController *   _loginVC;
    NSTimer         *_startTimer;
    NSInteger       _heart_Count;
    NSInteger       _keepPort_Count;
    NSInteger       _flagBackgroundToFront;
    NSInteger       _udpLoseDataCountTimer;
    BOOL            _apModelOrCloudModel;
    NSInteger       _checkUdpDataCount;

}

@property (assign, nonatomic) NSInteger    flagBackgroundToFront;
@property (retain, nonatomic) NSTimer    * startTimer;
@property (copy, nonatomic) NSDictionary * serverInfo;
@property (retain, nonatomic) UIAlertView * reLoginAlert;
@property (retain, nonatomic) MYGCDAsyncSocketEngine * mygcdSocketEngine;
@property (retain, nonatomic) cameraListViewController  * rootViewController;
@property (retain, nonatomic) CustomWindow *window;
@property (retain, nonatomic) WallPaperViewController * wallPaperController;

@property (retain,nonatomic) loginViewController *loginVC;
@property (retain,nonatomic) UITabBarController *mainTBC;

@property (assign, nonatomic) BOOL  apModelOrCloudModel;
@property (assign, nonatomic) NSInteger heart_Count;
@property (assign, nonatomic) cameraViewViewController * cameraPlayView;

-(void)enterMain;
-(UIView *)barButton:(NSString *)imageString bFrame:(CGRect)rect;
- (void)startTimerAction;

//- (void)openSession:(BOOL)logineUIFlag;
- (void)initAppdelegateSocket:(NSString *)ip port:(NSInteger)port type:(NSInteger)type timeOut:(NSTimeInterval)timeOut;

+ (AppDelegate *)getAppDelegate;



@end

@protocol MyAppCallBackDelegate <NSObject>

- (void)myAppCallBackRespondToGetNewSeverIp:(NSDictionary *)dictInfo;

@end
