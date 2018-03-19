//
//  cameraViewViewController.m
//  myanycam
//
//  Created by 中程 on 13-1-19.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "cameraViewViewController.h"
#import "AppDelegate.h"
#import "dealWithCommend.h"
#import "navButton.h"
#import "navTitleLabel.h"
//#import "CameraSettingNavigationController.h"
#include <netinet/in.h>		/* in_addr */
#import <arpa/inet.h>
#import <OpenGLES/ES2/gl.h>
#import "MYAlertView.h"
#import "UINavigationItem+UINavigationItemTitle.h"
#import "KxMovieDecoder.h"
#import "AssetsDataIsInaccessibleViewController.h"
#import "MusicPlayEngine.h"
#import "ASIFormDataRequest.h"
#import "QRCodeGenerator.h"
//#import "UMSocial.h"
#import "ShareCameraAlertView.h"
#import "JSONKit.h"
#import <MediaPlayer/MediaPlayer.h>



@interface cameraViewViewController ()

@end

@implementation cameraViewViewController


@synthesize videoDecodeEngine = _videoDecodeEngine;
@synthesize videoFrameQueue = _videoFrameQueue;
@synthesize currentUdpVideoData = _currentUdpVideoData;
@synthesize videoDataDictionary = _videoDataDictionary;
@synthesize currentImage = _currentImage;
@synthesize takePhotoImage = _takePhotoImage;
@synthesize sendAudioArray = _sendAudioArray;
@synthesize flagReceiveAudioData = _flagReceiveAudioData;
@synthesize myRecordAudioEngine = _myRecordAudioEngine;
@synthesize openGlView = _openGlView;
@synthesize yuvFramesQueue = _yuvFramesQueue;
@synthesize changeVideoSizeTimer =  _changeVideoSizeTimer;
@synthesize alaSsetsLibrary = _alaSsetsLibrary;
@synthesize cameraInfo = _cameraInfo;
@synthesize aacplayer;
@synthesize audioFormat = _audioFormat;
@synthesize audioStreamaac ;
@synthesize rootDelegate = _rootDelegate;
@synthesize videoSize = _videoSize;
@synthesize flagNeedAutoP2p = _flagNeedAutoP2p;
@synthesize flagIsCallign = _flagIsCallign;
@synthesize videoQualityView;
@synthesize haveAutoChangeVideoSize;
@synthesize shareCameraAlertView;
//@synthesize audiodata;

-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationBecomeActive object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationResignActive object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationSaveSnapCurrentPicture object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationMYNetAsynsocketError object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationNeedChangeVideoQuality object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationAPmodeManualTakePhoto object:nil];
    [AppDelegate getAppDelegate].cameraPlayView = nil;
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraViewDelegate = nil;
    
    [self.changeVideoSizeTimer invalidate];
    self.changeVideoSizeTimer = nil;
    
    self.shareCameraAlertView.shareDelegate = nil;
    [self.shareCameraAlertView hide];
    self.shareCameraAlertView = nil;
    
    self.rootDelegate = nil;
    self.videoQualityView = nil;
    
//    [_openGlView removeFromSuperview];
//    _openGlView = nil;
    
    self.openGlView = nil;
    self.cameraInfo = nil;
    self.myRecordAudioEngine = nil;
    self.currentUdpVideoData = nil;

    
    self.videoDecodeEngine = nil;
    self.videoFrameQueue = nil;
    self.videoDataDictionary = nil;
    self.currentImage = nil;
    self.takePhotoImage = nil;
    self.audioDataQueue = nil;
    self.pcmDecodeEngine = nil;
    self.sendAudioArray = nil;
    self.aacplayer = nil;

    
    [_cameraViewNavBar release];
    [_cameraViewNavItem release];
    [_videoImageView release];
    [_stopMusicButton release];
    [_takePhotoButton release];
    [_takeVideoButton release];
    [_micPhoneButton release];
    [_vView release];
    [_hViewImageView release];
    [_memoryLabel release];
    [_p2pStatusImageView release];
    [_videoDataSize release];
    [_micPhoneButton release];
    [_operateCameraVview release];
    [_playImageView release];
    [_playMiddleArrowImageView release];
    [_playActionView release];
    [_vVideoPlayView release];
    [_hVideoPlayView release];

    [_touchPlayTipLabel release];
    [_zoomButton release];
    [_micrifyButton release];
    [_micButton release];
    
    if(_display_picture_Queue)
    {
        dispatch_release(_display_picture_Queue);
        _display_picture_Queue = NULL;
    }
    
    self.yuvFramesQueue = nil;
    
    [_frameLengthLabel release];
    [_videoQualityButton release];
    [_videoStreamView release];
    [_recordButton release];
    [_recordStateImageView release];
    [_backImageView release];
    [_batteryImageView release];
    [_sdcardImageView release];
    [_sdcardLabel release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(CameraInfoData *)Info
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.cameraInfo = Info;
    }
    return self;
}

-(id)initWithDict:(CameraInfoData *)Info 
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.cameraInfo = Info;
    }
    return self;
}




- (void)prepareData{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifySavePhotoToAlbum) name:KNotificationSaveSnapCurrentPicture object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(stopOpenGlRender) name:KNotificationResignActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(restartOpenGlRender) name:KNotificationBecomeActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(notifactionSocketError) name:KNotificationMYNetAsynsocketError object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(needChangeVideoQuality:) name:KNotificationNeedChangeVideoQuality object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(manualTakePhotoRespone:)
                                                 name:KNotificationAPmodeManualTakePhoto
                                               object:nil];
    
    _isP2pSuccess=NO;
    _flagWatchCamera = 0;
    isBindPort=NO;
    _decodeFlag = NO;
    _startGetUpdTimerCount = -1;
    
    
    self.videoFrameQueue = [NSMutableArray arrayWithCapacity:10];
    self.audioDataQueue = [NSMutableArray arrayWithCapacity:10];
    self.videoDataDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    self.sendAudioArray = [NSMutableArray arrayWithCapacity:10];
    self.yuvFramesQueue = [NSMutableArray arrayWithCapacity:10];
    
    if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        [[MYDataManager shareManager] initMyUdpSocket:nil];
    }
    
    [MYDataManager shareManager].myUdpSocket.cameraVideoDataDelegate = self;
    [MYDataManager shareManager].myUdpSocket.cameraInfo  = self.cameraInfo;
//    //设置音量默认是 0.5
//    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
//    mpc.volume = 0.5;  //0.0~1.0
    
    [self createPhotoGroupWithName:KIMAGEMODELNAME];
}

- (void)notifactionSocketError{
    
    [self stopPlayVideoAndSocket];
}

- (void)needChangeVideoQuality:(id)sender{
    
    
//    if ([MYDataManager shareManager].myUdpSocket.flagStartPlayVideo && self.cameraInfo.videoQualitySize == 0 && _flagStartDecode ) {
//        
//        NSNotification * notify = (NSNotification *)sender;
//        
//        DebugLog(@"notify.userInfo %@",notify.userInfo);
//        
//        if ([[notify.userInfo objectForKey:@"needChangeVideoSize"] intValue] == 0) {
//            
//            if (_videoSizeType == VIDEO_SIZE_TYPE_720P) {
//                
//                [[MYDataManager shareManager].myUdpSocket sendVideoQualityChange:2];
//                _flagHadChangeVideoSize = YES;
//            }
//            
//            if (_videoSizeType == VIDEO_SIZE_TYPE_640X360 || _videoSizeType == VIDEO_SIZE_TYPE_480P) {
//                
//                [[MYDataManager shareManager].myUdpSocket sendVideoQualityChange:1];
//                _flagHadChangeVideoSize = YES;
//            }
//            
//            if (self.haveAutoChangeVideoSize >= 2) {
//                
//                self.haveAutoChangeVideoSize = -1;
//            }
//            
//        }
//        else
//        {
//            
//            if (self.haveAutoChangeVideoSize == -1 ) {
//                
//                return;
//            }
//            
//            if ((_videoSizeType == VIDEO_SIZE_TYPE_640X360 || _videoSizeType == VIDEO_SIZE_TYPE_480P )&& _haveChangeTo480P ) {
//                
//                [[MYDataManager shareManager].myUdpSocket sendVideoQualityChange:3];
//                self.haveAutoChangeVideoSize = 3;
//                _flagHadChangeVideoSize = YES;
//                
//            }
//            
//            if ( (_videoSizeType == VIDEO_SIZE_TYPE_320X180 || _videoSizeType == VIDEO_SIZE_TYPE_480P ) && !_haveChangeTo480P) {
//                
//                [[MYDataManager shareManager].myUdpSocket sendVideoQualityChange:2];
//                
//                self.haveAutoChangeVideoSize = 2;
//                
//                _flagHadChangeVideoSize = YES;
//                _haveChangeTo480P = YES;
//            }
//            
//        }
//    }
    
}

- (void)stopOpenGlRender{
    
    _decodeFlag = NO;
    _flagStartDecode = NO;
    glFinish();
}

- (void)restartOpenGlRender{
    
    [self startDecodeVideo];
}

- (void)showHbottomView{
    
    if (self.playActionView.hidden) {
        
        if (self.operateCameraVview.hidden) {
            
            [self.operateCameraVview customShowWithAnimation:YES duration:0.2 alpha:0.4];
            
            if (_flagisVviewAndHview) {
                
                [self.cameraViewNavBar customShowWithAnimation:YES duration:0.1];
            }
            
            _flagOperateViewShow = YES;
        }
        else
        {
            [self.operateCameraVview customHideWithAnimation:YES duration:0.2 alpha:0.4];
            
            if (_flagisVviewAndHview) {
                
                [self.cameraViewNavBar customHideWithAnimation:YES duration:0.1];
            }
            _flagOperateViewShow = NO;
        }
        
        if (self.videoQualityView && !self.videoQualityView.hidden) {
            
            [self.videoQualityView customHideWithAnimation:YES
                                                  duration:0.2];
        }
    }
    
    _operateViewShowTime = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"cameraViewViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"cameraViewViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MYDataManager shareManager].myUdpSocket cleanData];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self prepareView];
    [self updateOpenGlFrame];
    [self prepareData];
    
    [AppDelegate getAppDelegate].cameraPlayView = self;


}

- (void)prepareView{
    
    if ([ToolClass systemVersionFloat] >= 7.0)
    {
        CGRect rect = self.cameraViewNavBar.frame;
        rect.size.height = 64;
        self.cameraViewNavBar.frame = rect;
        
        rect = self.vVideoPlayView.frame;
        rect.origin.y += 20;
        rect.size.height = [UIScreen mainScreen].bounds.size.height - 64 - 50;
        self.vVideoPlayView.frame = rect;
        
        rect = self.videoStreamView.frame;
        rect.origin.y += 20;

        self.videoStreamView.frame = rect;
        
        rect = self.videoQualityButton.frame;
        rect.origin.y += 20;
        self.videoQualityButton.frame = rect;
        
        rect = self.memoryLabel.frame;
        rect.origin.y += 20;
        self.memoryLabel.frame = rect;
        
    }

//    self.operateCameraVview.hidden = NO;
    [_cameraViewNavBar setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];
    [self.cameraViewNavItem setCustomTitle:self.cameraInfo.cameraName];
    
    self.isShowBottomBar = YES;
    if (self.flagIsCallign) {
        
        self.isShowBottomBar = NO;
    }

    if(![AppDelegate getAppDelegate].apModelOrCloudModel)
    {
        NSString * imageNormalStr = @"icon_Return.png";
        NSString * imageSelectStr = @"icon_Return_hover.png";
        UIBarButtonItem * addButton = [ViewToolClass customBarButtonItem:imageNormalStr
                                                       buttonSelectImage:imageSelectStr
                                                                   title:NSLocalizedString(@"", nil)
                                                                    size:CGSizeMake(32, 32)
                                                                  target:self
                                                                  action:@selector(backAction:)];
        _cameraViewNavItem.leftBarButtonItem = addButton;
        
        
    }
    else
    {
        
        [self.cameraViewNavItem setCustomTitle:KAppName];
        self.micButton.hidden = YES;
        CGRect frame = self.takePhotoButton.frame;
        frame.origin.x = frame.origin.x - 75/2;
//        self.takePhotoButton.frame = frame;
        self.videoQualityButton.hidden = YES;
        
    }

    
    [self.changeVideoSizeTimer invalidate];
    self.changeVideoSizeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(checkNetState)
                                   userInfo:nil
                                    repeats:YES];
    

    _videoSizeType = VIDEO_SIZE_TYPE_320X180;
    [MYDataManager shareManager].currentVideoType = VIDEO_SIZE_TYPE_320X180;
    _videoSize.width = 320;
    _videoSize.height = 180;

    
    MYGestureRecognizer * gesture = [[MYGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonAction:)];
    [self.playActionView addGestureRecognizer:gesture];
    [gesture release];
    
    self.touchPlayTipLabel.text = NSLocalizedString(@"Touch to Watch", nil);
//    self.touchPlayTipLabel.hidden = self.flagNeedAutoP2p;
    self.touchPlayTipLabel.hidden = YES;
    
    if ([MYDataManager shareManager].deviceTpye > DeviceTypeIphone5) {
        
        self.zoomButton.hidden = NO;
        self.micrifyButton.hidden = NO;
        self.micrifyButton.enabled = NO;
    }
    
    [self.micButton addTarget:self action:@selector(startMicAction:) forControlEvents:UIControlEventTouchUpInside];
    

    [self updateVideoQualityButtonTitle];
    
    self.videoStreamView.hidden = YES;
    
    self.recordStateImageView.layer.masksToBounds = YES;
    self.recordStateImageView.layer.cornerRadius = 7;
    self.recordStateImageView.hidden = YES;
    
//    self.backImageView.center = self.view.center;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        CGRect  screen = [UIScreen mainScreen].bounds;//全屏
        [self createOpenGLViewWithWidth:screen.size.width height:screen.size.height];
        
    });


}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
   
    UITouch *touch =  [touches anyObject];
    CGPoint originalLocation = [touch locationInView:self.view];
     DebugLog(@"originalLocation x = %f, y = %f",originalLocation.x, originalLocation.y);
    _originalPoint = originalLocation;
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
//     DebugLog(@"touchesMoved %@",touches);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch =  [touches anyObject];
    CGPoint endLocation = [touch locationInView:self.view];
    
    
    CGFloat offset_x = endLocation.x - _originalPoint.x;
    CGFloat offset_y = endLocation.y - _originalPoint.y;
    CGFloat offset = fabs(offset_x) - fabs(offset_y);
    
    DebugLog(@"offset_x = %f, offset_y = %f  offset = %f",offset_x, offset_y ,offset);
    
    if (offset > 0) {
        //左右
        if (offset_x > 0) {
            //向右
            DebugLog(@"向右");
        }
        else {
            //向左
            DebugLog(@"向左");
        }
    }
    else
    {
        //上下
        if (offset_y > 0) {
            //向下
            DebugLog(@"向下");
        }
        else
        {
            //向上
            DebugLog(@"向上");
        }
        
    }
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


- (void)shareButtonAction:(id)sender{
    
//    ShareCameraAlertView * alertView = nil;
//    
//    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"ShareCameraAlertView" owner:nil options:nil];
//    if ([array count] > 0) {
//        
//        alertView = [array lastObject];
//        alertView.frame = CGRectMake(0, 0, 1056, 1056);
//        alertView.shareDelegate = self;
//        self.shareCameraAlertView = alertView;
//    }
//
//    [alertView prepareView:self.cameraInfo];
//    [alertView show];
    
}


- (void)updateVideoQualityButtonTitle{
    
    [self.videoQualityButton setBackgroundImage:[[UIImage imageNamed:@"品质.png"] resizableImage] forState:UIControlStateNormal];
    NSString * videoSizeStr = [NSString stringWithFormat:@"%@",[self getVideoQualityStrWithIndex:self.cameraInfo.videoQualitySize]];
    
//    if ( [[MYDataManager shareManager] currentSystemLanguage] != DeviceLanaguage_ZH_S && [[MYDataManager shareManager] currentSystemLanguage] != DeviceLanaguage_ZH_T) {
    
//        videoSizeStr = NSLocalizedString(@"Quality", nil);
//    }
    
    [self.videoQualityButton setTitle:videoSizeStr forState:UIControlStateNormal];
}

- (NSString *)getVideoQualityStrWithIndex:(NSInteger)index{
    
    NSString * str = nil;
    
    switch (index) {
        case 1:
            str = NSLocalizedString(@"Good", nil);
            break;
        case 2:
            str = NSLocalizedString(@"Better", nil);
            break;
        case 3:
            str = NSLocalizedString(@"Best", nil);
            break;
        case 0:
            str = NSLocalizedString(@"Auto", nil);
            break;
        default:
            break;
    }
    
    return str;
}

- (void)updateOpenGlFrame{

    CGRect frame ;
    if (!_flagisVviewAndHview) {
        
        //竖屏
        frame = [UIScreen mainScreen].bounds;
        CGRect screenFrame = self.vVideoPlayView.frame;
        screenFrame.origin.x = 0;
        screenFrame.origin.y = 44;
        if ([ToolClass systemVersionFloat] >= 7.0) {
            
            screenFrame.origin.y += 20;
        }
        
        screenFrame.size.width = frame.size.width;
        screenFrame.size.height = frame.size.height - screenFrame.origin.y - 50;
        self.vVideoPlayView.frame = screenFrame;
//        DebugLog(@"self.backImageView %@",self.backImageView);
//        self.backImageView.frame = CGRectMake(0, 0, 320, 568);

        
        
        switch (_videoSizeType) {

            case 2:
            {
                if ([MYDataManager shareManager].deviceTpye > DeviceTypeIphone5) {
                    
                    frame = CGRectMake((screenFrame.size.width - 320*2)/2, (screenFrame.size.height - 240*2)/2 , 320*2, 240*2);
                }
                else
                {
                    
                    frame = CGRectMake((screenFrame.size.width - 320)/2, (screenFrame.size.height - 240)/2 , 320, 240);
                }
                
            }
                break;
            
            case 4:
            {
                
                if ([MYDataManager shareManager].deviceTpye != DeviceTypeIpad1) {
                    
                    frame = CGRectMake((screenFrame.size.width - 320)/2, (screenFrame.size.height- 240)/2, 320, 240);
                    
                }
                else
                {
                    frame = CGRectMake((screenFrame.size.width - 640)/2, (screenFrame.size.height - 480)/2 , 640, 480);
                }
            }
                break;
            case VIDEO_SIZE_TYPE_480P:
            {
                if ([MYDataManager shareManager].deviceTpye != DeviceTypeIpad1) {
                    //iphone
                    frame = CGRectMake((screenFrame.size.width - V_480P_W)/2, (screenFrame.size.height-V_480P_H)/2 , V_480P_W, V_480P_H);//
                }
                else
                {   //ipad
                    frame = CGRectMake((screenFrame.size.width - 720)/2, (screenFrame.size.height-480)/2, 720, 480);
                }
            }
                break;
                
            case VIDEO_SIZE_TYPE_720P:
            {
                
                if ([MYDataManager shareManager].deviceTpye != DeviceTypeIpad1) {
                    
                    frame = CGRectMake(0, (screenFrame.size.height - V_720P_H)/2, V_720P_W, V_720P_H);
                }
                else
                {
                    frame = CGRectMake((screenFrame.size.width - 768)/2, (screenFrame.size.height - 432)/2, 768, 432);
                }
            }
                break;
                
                
            case VIDEO_SIZE_TYPE_640X360:
            {
                
                if ([MYDataManager shareManager].deviceTpye != DeviceTypeIpad1) {
                    
                    frame = CGRectMake(0, (screenFrame.size.height - 180)/2, 320, 180);
                }
                else
                {
//                    frame = CGRectMake((screenFrame.size.width - 640)/2, (screenFrame.size.height-360)/2, 640, 360);
                    frame = CGRectMake((screenFrame.size.width - 768)/2, (screenFrame.size.height - 432)/2, 768, 432);

                }
            }
                break;
                
            case VIDEO_SIZE_TYPE_320X180:
            {
                
                if ([MYDataManager shareManager].deviceTpye != DeviceTypeIpad1) {
                    
                    frame = CGRectMake(0, (screenFrame.size.height - 180)/2, 320, 180);
                }
                else
                {
                    frame = CGRectMake((screenFrame.size.width - 768)/2, (screenFrame.size.height - 432)/2, 768, 432);

                }
            }
                break;
                
            case VIDEO_SIZE_TYPE_960X540:
            {
                
                if ([MYDataManager shareManager].deviceTpye != DeviceTypeIpad1) {
                    
                    frame = CGRectMake(0, (screenFrame.size.height - 180)/2, 320, 180);
                }
                else
                {
                    frame = CGRectMake((screenFrame.size.width - 960)/2, (screenFrame.size.height - 540)/2, 960, 540);
                    
                }
            }
                break;
                
            default:
                
                frame = CGRectMake(0, (screenFrame.size.height - 180)/2, 320, 180);
                break;
        }
        
        self.openGlView.frame = frame;
        
    }
    else
    {
        //横屏
        CGRect frame = [UIScreen mainScreen].bounds;
        CGRect screenFrame = self.vVideoPlayView.frame;//
        float systemVersion = [ToolClass systemVersionFloat];
        if (systemVersion >= 8.0) {
            
            screenFrame.size.width = frame.size.width;
            screenFrame.size.height = frame.size.height;
        }
        else
        {
            screenFrame.size.width = frame.size.height;
            screenFrame.size.height = frame.size.width;
        }

        screenFrame.origin.x = 0;
        screenFrame.origin.y = 0;
        self.vVideoPlayView.frame = screenFrame;
        
//        DebugLog(@"self.backImageView %@",self.backImageView);
//          self.backImageView.frame = CGRectMake(0, 0, 568, 320);
        
        switch (_videoSizeType) {
            case 2:
            {
                
                if ([MYDataManager shareManager].deviceTpye > DeviceTypeIphone5) {
                    
                    frame = CGRectMake((screenFrame.size.width - 426*2)/2, (screenFrame.size.height - 320*2)/2, 426*2, 320*2);
                }
                else
                {
                    frame = CGRectMake((screenFrame.size.width - 426)/2, (screenFrame.size.height - 320)/2 , 426, 320);

                }
            }
                break;
                
            case VIDEO_SIZE_TYPE_VGA:
            {
                if ([MYDataManager shareManager].deviceTpye > DeviceTypeIphone5 ) {
                    
                    frame = CGRectMake((screenFrame.size.width - 960)/2, (screenFrame.size.height - 720)/2, 960, 720);

                }
                else
                {
                    frame = CGRectMake((screenFrame.size.width - 426)/2, (screenFrame.size.height - 320)/2, 426, 320);
                }
            }
                break;
            case VIDEO_SIZE_TYPE_480P:
            {
                
                if ([MYDataManager shareManager].deviceTpye > DeviceTypeIphone5 ) {
                    
                   frame = CGRectMake((screenFrame.size.width - 1024)/2, (screenFrame.size.height - 682)/2 + 20, 1024, 682);
                }
                else
                {
                    frame = CGRectMake((screenFrame.size.width - H_480P_W)/2, 0 , H_480P_W, H_480P_H);
                }
            }
                break;
                
            case VIDEO_SIZE_TYPE_720P:
            {
                
                if ([MYDataManager shareManager].deviceTpye > DeviceTypeIphone5 ) {
                    
                    frame = CGRectMake((screenFrame.size.width - 1024)/2, (screenFrame.size.height - 576)/2 + 20, 1024, 576);
                }
                else
                {
                    frame = CGRectMake((screenFrame.size.width - H_720P_W)/2, (screenFrame.size.height - H_720P_H)/2, H_720P_W, H_720P_H);
                }
                
            }
                break;
                
            case VIDEO_SIZE_TYPE_640X360:
            {
                
                if ([MYDataManager shareManager].deviceTpye != DeviceTypeIpad1) {
                    
                    
                    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone5) {
                        
                        frame = CGRectMake((screenFrame.size.width - 568)/2, (screenFrame.size.height- 320 )/2, 568, 320);
                    }
                    else
                    {
                        frame = CGRectMake((screenFrame.size.width - H_720P_W)/2, (screenFrame.size.height - H_720P_H)/2, H_720P_W, H_720P_H);
                    }
                }
                else
                {
                    frame = CGRectMake(0, (screenFrame.size.height - 576)/2, 1024, 576);
                }
   
            }
                break;
                
            case VIDEO_SIZE_TYPE_320X180:
            {
                
                if ([MYDataManager shareManager].deviceTpye != DeviceTypeIpad1) {
                    
                    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone5) {
                        
                        frame = CGRectMake((screenFrame.size.width - 568)/2, (screenFrame.size.height- 320 )/2, 568, 320);
                    }
                    else
                    {
                        frame = CGRectMake((screenFrame.size.width - H_720P_W)/2, (screenFrame.size.height - H_720P_H)/2, H_720P_W, H_720P_H);
                    }
                }
                else
                {
                    frame = CGRectMake(0, (screenFrame.size.height - 576)/2, 1024, 576);
                }
                
            }
                break;
                
            case VIDEO_SIZE_TYPE_960X540:
            {
                
                if ([MYDataManager shareManager].deviceTpye != DeviceTypeIpad1) {
                    
                    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone5) {
                        
                        frame = CGRectMake((screenFrame.size.width - 568)/2, (screenFrame.size.height- 320 )/2, 568, 320);
                    }
                    else
                    {
                        frame = CGRectMake((screenFrame.size.width - 480)/2, (screenFrame.size.height - 270)/2, 480, 270);
                    }
                }
                else
                {
                    frame = CGRectMake((screenFrame.size.width - 960)/2, (screenFrame.size.height - 540)/2, 960, 540);
                }
                
            }
                break;
                
            default:
                
                frame = CGRectMake((screenFrame.size.width - H_720P_W)/2, (screenFrame.size.height - H_720P_H)/2, H_720P_W, H_720P_H);
                
                break;
        }
        
        self.openGlView.frame = frame;
    }
    
    
    CGRect buttonFrame = self.videoQualityButton.frame;
    buttonFrame.origin.y = 2;
    self.videoQualityButton.frame = buttonFrame;
    
    buttonFrame = self.videoStreamView.frame;
    buttonFrame.origin.y = 2;
    self.videoStreamView.frame = buttonFrame;
    
}

- (void)createOpenGLViewWithWidth:(CGFloat)w height:(CGFloat)h{

    if (!self.openGlView) {
        
        CustomMovieGLView * openGl = [[CustomMovieGLView alloc] initWithFrame:CGRectMake(0, 0, w, h) videoW:_videoSize.width videoH:_videoSize.height];
        self.openGlView = openGl;
        openGl.tag = 1001;
        openGl.contentMode = UIViewContentModeScaleAspectFit;
        openGl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        MYTapGestureRecognizer * gesture = [MYTapGestureRecognizer myTapGestureRecognizer:self action:@selector(showHbottomView)];
        self.openGlView.userInteractionEnabled = YES;
        [self.openGlView addGestureRecognizer:gesture];
        self.openGlView.backgroundColor = [UIColor clearColor];
        self.openGlView.hidden = YES;
        [self.vVideoPlayView insertSubview:openGl belowSubview:self.operateCameraVview];
        [openGl release];
        
    }
}



- (void)checkaacplayer{
    
    
    if (self.aacplayer) {
        
        [self.aacplayer startCheckBufferState];
    }
    
    if(_flagOperateViewShow)
    {
         _operateViewShowTime ++;
        
        if (_operateViewShowTime > 18) {
            
                [self.operateCameraVview customHideWithAnimation:YES duration:0.2 alpha:0.4];
            
            if (_flagisVviewAndHview) {
                
                [self.cameraViewNavBar customHideWithAnimation:YES duration:0.1];
            }
             _operateViewShowTime = 0;
        }
    }
    else
    {
        _operateViewShowTime = 0;
    }

}

- (void)checkNetState{
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
#ifdef DEBUG

        NSString *string = [[NSString alloc]initWithFormat:@"%4.1fMB",[[UIDevice currentDevice] availableMemory]];
        self.memoryLabel.text = string;
        [string release];
        
        self.p2pStatusImageView.hidden = NO;
        
        if (![MYDataManager shareManager].myUdpSocket.isP2pSuccess) {
            
            [self.p2pStatusImageView setBackgroundColor: [UIColor redColor]];
        }
        else{
            
            [self.p2pStatusImageView setBackgroundColor: [UIColor blueColor]];
        }
        
#endif


        CGFloat size = _videoDataLen/1024.0;
        _videoDataLen = 0;
        NSString * videoDataStr = [[NSString alloc] initWithFormat:@"%4.1fKB/s",size];
        self.videoDataSize.text = videoDataStr;
        [videoDataStr release];
        

        
    });
    
    
        if (_flagStartCountNetState) {
            
            _netStateStatistics ++ ;
            _flagChangeVideoSize = NO;
            
            if (_netStateStatistics ==  10) {
                
                if (_videoSizeType == VIDEO_SIZE_TYPE_480P) {
                    
                    if (_videoDataLength/1024/10 < 40) {
                        
                        _flagChangeVideoSize = YES;
                    }
                }
                
                if (_videoSizeType == VIDEO_SIZE_TYPE_720P) {
                    
                    if (_videoDataLength/1024/10 < 80) {
                        
                        _flagChangeVideoSize = YES;
                    }
                }
                _videoDataLength = 0;
                
                if (_flagChangeVideoSize ) {
                    
                    //[self sendChangeVideoSizeRequest]; 
                }
                
                 _flagStartCountNetState = NO;
                _netStateStatistics = 0;


            }
            
            
        }   
    
}

- (void)stopChangeVideoSizeTimer{
    
    [self.changeVideoSizeTimer invalidate];
    self.changeVideoSizeTimer = nil;
    
}

//- (void)sendChangeVideoSizeRequest{
//    
//       [[MYDataManager shareManager].myUdpSocket sendChangeVideoSizeRequest];
//}

- (void)showNetErrorAlertView{

        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Network is too bad", nil) userInfo:[NSDictionary dictionaryWithObject:@"alertNetError" forKey:KALERTTYPE] delegate:self canclButtonStr:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
 
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (![AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        if (!self.cameraInfo.flagUserProvenResp) {
            
            [[AppDelegate getAppDelegate].mygcdSocketEngine sendCheckCameraPasswordRequest:self.cameraInfo];
        }
        else
        {
            if (self.cameraInfo.flagLock) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationShowChangePasswordAlert object:nil];
            }
        }
        
        if (self.flagIsCallign && [MYDataManager shareManager].apnsDict && self.cameraInfo.cameraId == [[[MYDataManager shareManager].apnsDict objectForKey:@"cameraid"] intValue]) {
            
            [MYDataManager shareManager].apnsDict = nil;
        }
    }
    
    if (self.flagNeedAutoP2p) {
        
        [self playButtonAction:nil];
    }
    
    [self updateOpenGlFrame];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark udpDelegate

- (void)udpData:(NSData *)data{
    
}

- (void)videoData:(NSData *)videoData{
    
    if (_decodeFlag) {
        
        [self initVideoDecodeEngine:videoData];

    }
}

- (void)removeWaitView{
    
    
    if (self.playImageView ) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.openGlView.hidden = NO;
            self.operateCameraVview.hidden = NO;
            _flagOperateViewShow = YES;
            
            [self.playActionView customHideWithAnimation:YES duration:0.2];
            [self.playImageView removeAnimations];
            self.playImageView = nil;
        });
    }
    
}

- (void)watchCameraSuccess:(NSDictionary *)dat{
    
    [[MYDataManager shareManager].myUdpSocket updateCameraNatipWithDictionary:dat];
    
}

-(void)watchCameraFailed:(NSDictionary *)dat
{
    NSString * string = NSLocalizedString(@"Watch Error", nil);
    
    int error = [[dat objectForKey:@"ret"] intValue];
    switch (error) {
        case 1://密码错误
        {
            string = NSLocalizedString(@"Access Password Error,please change camera access password", nil);
        }
            break;
        case 2://访问密码
        {
            string = NSLocalizedString(@"You do not have permission to access this camera", nil);
        }
            break;
            
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [dealWithCommend noticeAlertView:string];
        
        [self backAction:nil];

    });

}

-(void)watchCameraCommend
{
    
    [MYDataManager shareManager].myUdpSocket.flagStartPlayVideo = YES;
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraViewDelegate = self;

    NSString * CommandStr = @"";
    
    if (self.cameraInfo.flagUpnp_success == 1) {
        
        CommandStr = @"WATCH_CAMERA_TCP";
    }
    else
    {
        CommandStr = @"WATCH_CAMERA";
    }
    
    if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
     
        CommandStr = @"WATCH_CAMERA_TCP";
    }
    
    
    NSString *cmd=@"";
    
    cmd=[dealWithCommend addElement:cmd eName:@"xns" eData:@"XNS_CLIENT"];
    cmd=[dealWithCommend addElement:cmd eName:@"cmd" eData:CommandStr];
    cmd=[dealWithCommend addElement:cmd eName:@"userid" eData:[NSString stringWithFormat:@"%d",[MYDataManager shareManager].userInfoData.userId]];
    cmd=[dealWithCommend addElement:cmd eName:@"cameraid" eData:[NSString stringWithFormat:@"%d",self.cameraInfo.cameraId]];
    cmd=[dealWithCommend addElement:cmd eName:@"password" eData:self.cameraInfo.password];
    cmd=[dealWithCommend addElement:cmd eName:@"resolution" eData:[NSString stringWithFormat:@"%d",8]];
    
    
    if ([MYDataManager shareManager].myUdpSocket.upnp_ip) {
        
        cmd=[dealWithCommend addElement:cmd eName:@"natip" eData:[MYDataManager shareManager].myUdpSocket.upnp_ip];
        cmd=[dealWithCommend addElement:cmd eName:@"natport" eData:[NSString stringWithFormat:@"%d",[MYDataManager shareManager].myUdpSocket.upnp_port]];

    }
    else
    {
        
        cmd=[dealWithCommend addElement:cmd eName:@"natip" eData:[MYDataManager shareManager].myUdpSocket.natip];
        cmd=[dealWithCommend addElement:cmd eName:@"natport" eData:[NSString stringWithFormat:@"%d",[MYDataManager shareManager].myUdpSocket.natPort]];
    }

    cmd=[dealWithCommend addElement:cmd eName:@"localip" eData:[MYDataManager shareManager].myUdpSocket.localIp];
    cmd=[dealWithCommend addElement:cmd eName:@"localport" eData:[NSString stringWithFormat:@"%d",[MYDataManager shareManager].myUdpSocket.localPort]];
    
    if (self.cameraInfo.videoQualitySize == 0) {
        
        cmd=[dealWithCommend addElement:cmd eName:@"videosize" eData:[NSString stringWithFormat:@"%d",1]];
    }
    else
    {
        cmd=[dealWithCommend addElement:cmd eName:@"videosize" eData:[NSString stringWithFormat:@"%d",self.cameraInfo.videoQualitySize]];
    }
    
    [[[self appDelegate] mygcdSocketEngine] writeDataOnMainThread:cmd tag:0  waitView:NO];
    [MobClick event:@"wc"];
}

- (void)viewDidUnload {

//    [self.gcdSocketToMcu disconnect];
    [self setCameraViewNavBar:nil];
    [self setCameraViewNavItem:nil];
    [self setVideoImageView:nil];
    [self setStopMusicButton:nil];
    [self setTakePhotoButton:nil];
    [self setTakeVideoButton:nil];
    [self setMicPhoneButton:nil];
    [self setVView:nil];
    [self setHViewImageView:nil];
    [self setMemoryLabel:nil];
    [self setP2pStatusImageView:nil];
    [self setVideoDataSize:nil];
    [self setMicPhoneButton:nil];
    [self setOperateCameraVview:nil];
    [self setPlayImageView:nil];
    [self setPlayMiddleArrowImageView:nil];
    [self setPlayActionView:nil];
    [self setVVideoPlayView:nil];
    [self setHVideoPlayView:nil];
    [self setTouchPlayTipLabel:nil];
    [self setZoomButton:nil];
    [self setMicrifyButton:nil];
    [self setMicButton:nil];
    [self setFrameLengthLabel:nil];
    [self setVideoQualityButton:nil];
    [self setVideoStreamView:nil];
    [self setRecordButton:nil];
    [self setRecordStateImageView:nil];
    [self setBackImageView:nil];
    [self setBatteryImageView:nil];
    [self setSdcardImageView:nil];
    [self setSdcardLabel:nil];
    [super viewDidUnload];
}

- (void)stopPlayVideoAndSocket{
    
    _decodeFlag = NO;
    _flagStartDecode = NO;
    glFinish();
    [self sendStopWatchCamera];
    [self stopChangeVideoSizeTimer];
    
    [AppDelegate getAppDelegate].cameraPlayView = nil;
 
    [self stopMic];
    [self stopMusic];
    
    [[MYDataManager shareManager].myUdpSocket cleanData];
    
    if(_display_picture_Queue)
    {
        dispatch_release(_display_picture_Queue);
        _display_picture_Queue = NULL;
    }
    
    [self.playImageView removeAnimations];
   
    UIView *v = [self.vVideoPlayView viewWithTag:1001];
    v.hidden = YES;
    [self.vVideoPlayView bringSubviewToFront:v];
    [v removeFromSuperview];

}

- (void)sendStopWatchCamera{
    
    NSString * cmd = [BuildSocketData buildStopWatchCamera:[MYDataManager shareManager].userInfoData.userId
                                                  cameraid:[NSString stringWithFormat:@"%d",self.cameraInfo.cameraId]
                                                  password:self.cameraInfo.password];
    
    [[[self appDelegate] mygcdSocketEngine ]writeDataOnMainThread:cmd tag:0 waitView:NO];
    
    [[MYDataManager shareManager].myUdpSocket sendCmd:CMD_LEAVE_DATA_CHANNEL];
    [MYDataManager shareManager].myUdpSocket.allFrameCountInTenSeconds = 0;
}

- (void)backAction:(id)sender{
    
    [[AppDelegate getAppDelegate].window jumpToRootViewControllerWithOutAnimation];
    
}

- (void)didSelectVideoQualityWithIndex:(NSInteger)index
{
    
    switch (index) {
        case 0:
            
            self.cameraInfo.videoQualitySize = 3;
            break;
        case 1:
            
            self.cameraInfo.videoQualitySize = 2;
            break;
        case 2:
            
            self.cameraInfo.videoQualitySize = 1;
            break;
        case 3:
            
            self.cameraInfo.videoQualitySize = 0;
            break;
            
        default:
            break;
    }
    
    if ( self.cameraInfo.videoQualitySize != 0) {
        
        if ([MYDataManager shareManager].myUdpSocket.flagStartPlayVideo) {
            
            [[MYDataManager shareManager].myUdpSocket sendVideoQualityChange:self.cameraInfo.videoQualitySize];
            _flagHadChangeVideoSize = YES;
        }
    }
    else{
        
        if ([MYDataManager shareManager].myUdpSocket.flagStartPlayVideo) {
            
            [[MYDataManager shareManager].myUdpSocket sendVideoQualityChange:1];
            _flagHadChangeVideoSize = YES;
        }
    }
    

    
    [self videoQualityChangeButtonAction:self.videoQualityButton];
    [self updateVideoQualityButtonTitle];
    
}

- (IBAction)videoQualityChangeButtonAction:(id)sender {
    
    if (self.videoQualityView && !self.videoQualityView.hidden) {
        
        [self.videoQualityView customHideWithAnimation:YES
                                              duration:0.2];
        
    }
    else
    {
        self.videoQualityView = nil;
        
        if (!self.videoQualityView) {
         
            VideoQualityChangeView * view = nil;
            
            NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"VideoQualityChangeView" owner:nil options:nil];
            if ([views count] > 0) {
                view = [views lastObject];
            }
            view.hidden = YES;
            view.delegate = self;
            
            CGRect frame  = view.frame;
            frame.origin.x = self.videoQualityButton.frame.origin.x;
            frame.origin.y = self.videoQualityButton.frame.origin.y + self.videoQualityButton.frame.size.height +1;
            view.frame = frame;
            self.videoQualityView = view;
            [self.vVideoPlayView addSubview:view];
            [self.vVideoPlayView bringSubviewToFront:self.videoQualityView];
            
            NSInteger selectedIndex = 3 - self.cameraInfo.videoQualitySize;
            
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            [self.videoQualityView.qualitySelectTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }
        
        [self.videoQualityView customShowWithAnimation:YES duration:0.2];
        [self.vVideoPlayView bringSubviewToFront:self.videoQualityView];
        self.videoQualityView.userInteractionEnabled = YES;

    }

}

- (void)updateVideoQualityViewFrame{
    
    if (self.videoQualityView) {
        
        CGRect frame  = self.videoQualityView.frame;
        frame.origin.x = self.videoQualityButton.frame.origin.x;
        frame.origin.y = self.videoQualityButton.frame.origin.y + self.videoQualityButton.frame.size.height +1;
        self.videoQualityView.frame = frame;
    }

}

- (void)initZoomLevelButton{
    
    
}

- (void)resetZoomLevel{
    
    _zoomLevel = 0;
    self.zoomButton.enabled = YES;
    self.micrifyButton.enabled = NO;
}


- (void)startDisplayVideo{
    
    
    if (!_display_picture_Queue) {
        _display_picture_Queue = dispatch_queue_create("display_picture", NULL);
    }
    
    dispatch_async(_display_picture_Queue, ^{
        
        while (_decodeFlag) {
            
            if ([self.yuvFramesQueue count] > 0 ) {
                
                if (!_sleepFlag) {
                    
                    if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
                        
                        usleep(10*1000);

                    }
                    else
                    {
                        usleep(500*1000);

                    }
                    _sleepFlag = YES;
//                    DebugLog(@"[self.yuvFramesQueue count] %d",[self.yuvFramesQueue count]);
                    _sleepFrameCount = [self.yuvFramesQueue count];
                    [self removeWaitView];
                }
                
                KxVideoFrame * frame = nil;
                
                @synchronized(self.yuvFramesQueue)
                {
                    frame = [self.yuvFramesQueue objectAtIndex:0];
                }
                
                if (frame) {
                    
                    [MYDataManager shareManager].currentVideoFrameTimeStamp = frame.timeStamp;
                    if (!_lastFrameTimeStamp) {
                        
                        _lastFrameTimeStamp = frame.timeStamp;
                        _startDisplayTime = clock();
                    }
                    else
                    {
                        _currentFrameStamp = frame.timeStamp;
                        
                        _endDisplayTime = clock();
                        
//                        DebugLog(@"_currentFrameStamp %lu - _lastFrameTimeStamp %lu = %lu",_currentFrameStamp,_lastFrameTimeStamp,_currentFrameStamp - _lastFrameTimeStamp);
                        
                        clock_t offsetStamp = _currentFrameStamp - _lastFrameTimeStamp;
                        clock_t offsetTime = _endDisplayTime - _startDisplayTime;
                        
                        int offset = offsetStamp - offsetTime;
                        
//                        DebugLog(@"offsetStamp %lu - offsetTime %lu = offset %d",offsetStamp,offsetTime,offset);
                        
                        int count =  [self.yuvFramesQueue count] - _sleepFrameCount;
                        
//                        DebugLog(@"_sleepFrameCount %d", _sleepFrameCount);
                        
//                        DebugLog(@"offset start %d", offset);
                        offset = offset - count * 2600;
//                        DebugLog(@"offset end %d", offset);
                        if (offset > 0) {
                            
                            if (offset > 100000) {
                                
                                offset = 90000;
                            }
                            usleep(offset);
                        }
                        
                        _lastFrameTimeStamp = frame.timeStamp;
                        _startDisplayTime = clock();
                    }
                    
                    
//                    DebugLog(@"self.yuvFramesQueue count %d",[self.yuvFramesQueue count]);
                    
                    [self performSelectorOnMainThread:@selector(playVideo:)
                                           withObject:frame
                                        waitUntilDone:YES];
                    
                    
                    @synchronized(self.yuvFramesQueue){
                        [self.yuvFramesQueue removeObject:frame];
                    }
                }
            }
            else
            {
                _sleepFlag = NO;
            }
        }
        
    });
    
}

- (void)startDecodeVideo{
   
    if (_flagStartDecode) {
         
        return;
    }
    
    _flagStartDecode = YES;
    _decodeFlag = YES;
    
    [NSThread detachNewThreadSelector:@selector(deocdeVideoData) toTarget:self withObject:nil];
    
    [self startDisplayVideo];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
#ifdef DEBUG
        [self.videoStreamView customShowWithAnimation:YES duration:0.2];
#endif
        
        if (self.flagIsCallign) {

            [self stopMusicAction:self.stopMusicButton];
            [self startMicAction:self.micButton];

        }
    });

}

- (void)changeVideoViewRect:(CGFloat)height width:(CGFloat)width{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self resetZoomLevel];
        [self updateOpenGlFrame];
        

        CGRect frame = self.operateCameraVview.frame;
        frame.origin = CGPointMake((self.vVideoPlayView.frame.size.width - frame.size.width)/2, self.openGlView.frame.origin.y + self.openGlView.frame.size.height - self.operateCameraVview.frame.size.height);
        self.operateCameraVview.frame = frame;
        
    });

}

- (void)initVideoDecodeEngine:(NSData *)dataBuffer{
    

    NSMutableData * videoData = [[NSMutableData alloc] initWithData:dataBuffer];
    int type = 0;
    int width = 0;
    int height = 0;
    char * data = [videoData mutableBytes];
    
    MediaData * mediaData = [[MediaData alloc] init];
    int size = sizeof(struct MediaDataHeader);
    struct MediaDataHeader * header = malloc(size);
    memcpy(header, [videoData bytes], size);
    header->time = ntohl(header->time);
    
    mediaData.time = header->time;
    mediaData.header = header;
    mediaData.mediaData = [NSData dataWithBytes:(data + size) length:[videoData length] - size];
    
    if (mediaData.header->mediaType == 0x00) {
        //视频
        if(!_flagInitDecodeEngine)
        {
            _flagInitDecodeEngine = YES;
            
            if(mediaData.header->mediaFormat== 0x00)
            {
                DebugLog(@"mpeg");
                type = 0;
                _videoType = 0;
            }
            if(mediaData.header->mediaFormat == 0x01)
            {
                DebugLog(@"h264");
                type = 1;
                _videoType = 1;
            }
            
            if(mediaData.header->mediaFormatSize == 0x00)
            {
                width = 160;
                height = 120;
            }
            if(mediaData.header->mediaFormatSize == 0x01)
            {
                width = 176;
                height = 144;
            }
            if(mediaData.header->mediaFormatSize == 0x02)
            {
                
                width = 320;
                height = 240;
                
            }
            if(mediaData.header->mediaFormatSize == 0x03)
            {
                
                width = 352;
                height = 288;
            }
            if(mediaData.header->mediaFormatSize == 0x04)
            {
                
                width = 640;
                height = 480;
            }
            if(mediaData.header->mediaFormatSize == 0x05)
            {
                
                width = 720;
                height = 480;
            }
            if(mediaData.header->mediaFormatSize == 0x06)
            {
                width = 1280;
                height = 720;
            }
            
            if(mediaData.header->mediaFormatSize == 0x08 )
            {
                width = 640;
                height = 360;
            }
            
            
            if(mediaData.header->mediaFormatSize == 0x09 )
            {
                width = 320;
                height = 180;
            }
            
            if(mediaData.header->mediaFormatSize == 0x10 )
            {
                width = 960;
                height = 540;
            }
            
            _videoSizeType = mediaData.header->mediaFormatSize;
            [MYDataManager shareManager].currentVideoType = _videoSizeType;
            _videoSize.width = width;
            _videoSize.height = height;

            [self changeVideoViewRect:height width:width];
            
            VideoFrameExtractor * viewVideo = [[VideoFrameExtractor alloc] initCnx:type wid:width hei:height];
            self.videoDecodeEngine = viewVideo;
            [viewVideo release];
            
            _flagStartCountNetState = YES;
            
            [self startDecodeVideo];
            
        }
        
        _videoDataLen = _videoDataLen + [mediaData.mediaData length];
        _videoDataLength = _videoDataLength + [mediaData.mediaData length];
        
         @synchronized(self.videoFrameQueue){
             
             [self.videoFrameQueue addObject:mediaData];
             
         }
        

    }
    else{
        //音频播放
        if (mediaData.header->mediaType == 0x01) {
            
            self.audioFormat = mediaData.header->mediaFormat;
            
            switch (mediaData.header->mediaFormat) {
                case Audio_Format_ARM :
                {
                    
                }
                    break;
                case Audio_Format_iLAB :
                {
                    
                }
                    break;
                case Audio_Format_ADPCM :
                {
//                    DebugLog(@"mediaFormat ADPCM ");
                    if (self.flagReceiveAudioData) {
                        
                        if (!self.pcmDecodeEngine && [self.audioDataQueue count] > 5) {
                            
                            PCMplayEngine * pcm = [[PCMplayEngine alloc] initWithAudio:self.audioDataQueue];
                            self.pcmDecodeEngine = pcm;
                            [pcm release];
                        }

                    }
                    
                    if ([self.audioDataQueue count] > 3) {
                        
                        [self decodeAudioData];
                    }
                }
                    break;
                case Audio_Format_AAC:
                {
                    
                    DebugLog(@"mediaFormat AAC ");
                    
                    if (self.flagReceiveAudioData) {
                        
                        if (!self.aacplayer) {
                            
                            AACPlayer * player = [[AACPlayer alloc] initWithFormat:Audio_Format_AAC];
                            self.aacplayer = player;
                            [player release];
                        }
                        
                    }

                }
                    break;
                    
                case Audio_Format_AAC_8000:
                {
                    
                    DebugLog(@"mediaFormat AAC ");
                    
                    if (self.flagReceiveAudioData) {
                        
                        if (!self.aacplayer) {
                            
                            AACPlayer * player = [[AACPlayer alloc] initWithFormat:Audio_Format_AAC_8000];
                            self.aacplayer = player;
                            [player release];
                        }
                        
                    }
                                        
                }
                    
                    break;
                default:
                    break;
            }
            
            if (self.flagReceiveAudioData) {
  
                @synchronized(self.audioDataQueue){
                    [self.audioDataQueue addObject:mediaData];
                }
                
//                if (!_testPcmData) {
//                    _testPcmData = [[NSMutableData alloc] initWithCapacity:1000];
//                }
//                
//                [_testPcmData appendData:mediaData.mediaData];
//                
//                if ([_testPcmData length] > 2000) {
//                    
//                        NSString * imageName = @"data.pcm";
//                        NSString * imagePath = [[[MYDataManager shareManager] saveImagePath] stringByAppendingPathComponent:imageName];
//                        [_testPcmData writeToFile:imagePath atomically:YES];
//                }
                
                if ([self.audioDataQueue count] > 0) {
                    
                    [self decodeAudioData];
                }
            }
        }
    }
    
    [videoData release];
    [mediaData release];
}

- (void)startDecodeaac{
    
    @synchronized(self.aacplayer)
    {
        [self.aacplayer aacplay];
    }
}

- (void)changeVideoFrameSizeWithMediaData:(MediaData *)mediaData{
    
        //视频
        if (_videoSizeType != mediaData.header->mediaFormatSize) {
            
            _flagChangeVideoSize = NO;
            _flagHadChangeVideoSize = NO;
            
            int width = 0;
            int height = 0;
            
            if(mediaData.header->mediaFormatSize == 0x00)
            {
                width = 160;
                height = 120;
            }
            if(mediaData.header->mediaFormatSize == 0x01)
            {
                width = 176;
                height = 144;
            }
            if(mediaData.header->mediaFormatSize == 0x02)
            {
                
                width = 320;
                height = 240;
                
            }
            if(mediaData.header->mediaFormatSize == 0x03)
            {
                
                width = 352;
                height = 288;
            }
            if(mediaData.header->mediaFormatSize == 0x04)
            {
                
                width = 640;
                height = 480;
            }
            if(mediaData.header->mediaFormatSize == 0x05)
            {
                
                width = 720;
                height = 480;
            }
            if(mediaData.header->mediaFormatSize == 0x06)
            {
                width = 1280;
                height = 720;
            }
            
            if(mediaData.header->mediaFormatSize == 0x08 )
            {
                width = 640;
                height = 360;
            }
            
            if(mediaData.header->mediaFormatSize == 0x09 )
            {
                width = 320;
                height = 180;
            }
            
            if(mediaData.header->mediaFormatSize == 0x10 )
            {
                width = 960;
                height = 540;
            }
            
            _videoSizeType = mediaData.header->mediaFormatSize;
            _videoSize.width = width;
            _videoSize.height = height;
            [MYDataManager shareManager].currentVideoType = _videoSizeType;
            
            self.videoDecodeEngine.outputWidth = width;
            self.videoDecodeEngine.outputHeight = height;
            [self changeVideoViewRect:height width:width];
            
        }
        

}

- (void)decodeAudioData{
    
    if ([self.audioDataQueue count] > 0) {
        
            if (self.aacplayer && self.aacplayer.audioDecodeFlag == AUDIO_PLAY_STATE_NONE) {
                self.aacplayer.dataArray = self.audioDataQueue;
                [self.aacplayer aacplay];
            }

        
        if (self.pcmDecodeEngine) {
            
            if (self.pcmDecodeEngine.audioDeocdeFlag != AUDIO_PLAY_STATE_PLAY) {
                self.pcmDecodeEngine.dataArray = self.audioDataQueue;
               [self.pcmDecodeEngine play];
            }
            
            
        }
    }
    
}

- (void)pauseDecodeAndSend{
    
    _decodeFlag = NO;
    
}

- (void)deocdeVideoData{
    
        while (_decodeFlag) {
            
            if ([self.videoFrameQueue count] > 0) {
                
                NSAutoreleasePool * pool  = [[NSAutoreleasePool alloc] init];
                
                [self.videoFrameQueue sortUsingDescriptors:[NSArray arrayWithObjects:
                                                            [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES],
                                                            nil]];
                
                MediaData* mediaData = [self.videoFrameQueue objectAtIndex:0];

                if (_flagHadChangeVideoSize) {
                    
                    [self changeVideoFrameSizeWithMediaData:mediaData];
                }
                
                int flag = 0;
                
                if ([self.videoFrameQueue count] > 30) {
                    
//                    [self sendChangeVideoSizeRequest];
                }
                
                flag = [self.videoDecodeEngine manageData:mediaData.mediaData];
                
                
                if (flag == 1) {
                    
                    _flagDecodeError = YES;
                    if (_flagNeedTakePhoto) {
                        
                        UIImage * photoImage = [self.videoDecodeEngine currentImage];
                        self.takePhotoImage = photoImage;
                        _flagNeedTakePhoto = NO;
                        [self notifySavePhotoToAlbum];
                        
                    }
                    
                    KxVideoFrame * frame = [self.videoDecodeEngine handleVideoFrame];
                    
                    if (frame) {
                        
                        frame.timeStamp = mediaData.time;
                        @synchronized(self.yuvFramesQueue)
                        {
                            [self.yuvFramesQueue addObject:frame];
                        }
                    }
                }
                else{
                    
                    DebugLog(@"decode error");
                }
                
                @synchronized(self.videoFrameQueue)
                {
                    [self.videoFrameQueue removeObject:mediaData];
                }
                
                [pool release];
                
            }

        }
    
        @synchronized(self.videoFrameQueue)
        {
              [self.videoFrameQueue removeAllObjects];
        }
    
}

- (void)playVideo:(id)sender{
    
    [self.openGlView render:sender];
    
}



- (void)notifySavePhotoToAlbum{
    
    [NSThread detachNewThreadSelector:@selector(savePhotoToAlbum) toTarget:self withObject:nil];

}

- (void)savePhotoToAlbum{
    
//    [self ShowWaitAlertView:@"Saving..."];
    
    @autoreleasepool {
        
        UIImage * image = self.takePhotoImage;
        
        if (image) {
            
            NSData * imageData = UIImagePNGRepresentation(image);
            if (!imageData) {
                imageData = UIImageJPEGRepresentation(image, 1);
            }
            if (imageData) {
                
                ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
                    
                    NSString *errorMessage = @"User denied access albums";
                    switch ([error code]) {
                        case ALAssetsLibraryAccessUserDeniedError:
                        case ALAssetsLibraryAccessGloballyDeniedError:
                            errorMessage = @"User denied access albums";
                            break;
                        default:
                            errorMessage = @"Reason unknown.";
                            break;
                    }
                    
                    DebugLog(@"errorMessage %@",errorMessage);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                          [self showAlertView:NSLocalizedString(@"", nil) alertMsg:NSLocalizedString(@"User denied access albums. Settings> Location Services. Set KCam App is On", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                        
                    });
                };
                
                
                NSDate *shootTime = [NSDate date];
                NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
                [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
                NSString *strDate = [dateFormatter stringFromDate:shootTime];//kCGImagePropertyTIFFDateTime
                NSDictionary *metaDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:KIMAGEMODELNAME,(NSString *)kCGImagePropertyTIFFSoftware,KIMAGEMODELNAME,(NSString *)kCGImagePropertyTIFFArtist, strDate,(NSString *)kCGImagePropertyTIFFDateTime,KIMAGEMODELNAME,kCGImagePropertyTIFFMake,nil],(NSString *)kCGImagePropertyTIFFDictionary,nil];
                
                [self.alaSsetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metaDic completionBlock:^(NSURL *assetURL, NSError *error){
                    
                    NSLog(@"save image:%@",assetURL);
                    
                    [self.alaSsetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                        
                        NSString* groupname = [group valueForProperty:ALAssetsGroupPropertyName];
                        NSLog(@"groupname %@",groupname);
                        if ([groupname isEqualToString:@"KCam"]) {
                            
                            stop = false;
                            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                            [self.alaSsetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                
                                [group addAsset:asset];
                                int count  = [group numberOfAssets];
                                NSLog(@"count:%d",count);
                                
                                [[MYDataManager shareManager] addTakePhotoImage:[assetURL absoluteString]];
                                
                            } failureBlock:^(NSError *error) {
                                
                                
                            }];
                        }
                        
                    } failureBlock:failureBlock];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self savePhotoSuccess];

                    });
                }];
            }
        }
    }    
}

//- (void)savePhotoToAlbum{
//    
//    if (self.takePhotoImage) {
//        _flagSavePhotoing = YES;
//        @autoreleasepool {
//            
//            NSData * imageData = UIImagePNGRepresentation(self.takePhotoImage);
//            if (!imageData) {
//                imageData = UIImageJPEGRepresentation(self.takePhotoImage, 1);
//            }
//            
//            if (imageData) {
//                NSDate * date = [NSDate date];
//                int timeName =  [date timeIntervalSince1970];
//                NSString * imageName = [NSString stringWithFormat:@"%d.png",timeName];
//                NSString * imagePath = [[[MYDataManager shareManager] saveImagePath] stringByAppendingPathComponent:imageName];
//                [imageData writeToFile:imagePath atomically:YES];
//                [[MYDataManager shareManager] addImageFileWithImageName:imageName imagePath:imagePath];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self savePhotoSuccess];
//                });
//            }
//
//        }
//    }
//}

- (void)savePhotoSuccess{
    
    _flagSavePhotoing = NO;
    if(1){
        
        DebugLog(@"Photo saved to library!");
        
        [[MusicPlayEngine sharedMusicPlayerEngine] playSoundEffect:SoundEffectShot repeat:NO];
        
//        if (![AppDelegate getAppDelegate].apModelOrCloudModel)
//        {
//            
//            ShareAlertView * alertView = nil;
//            NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"ShareAlertView" owner:nil options:nil];
//            if ([views count]) {
//                
//                alertView = [views lastObject];
//                alertView.tag = AlertViewTypeQuestion;
//                [alertView prepareView];
//                [alertView show];
//                alertView.delegate = self;
//            }
//        }
        
        NSString * savePhotoSuccess = NSLocalizedString(@"Take Photo Success!", nil);
        [self showAutoDismissAlertView:savePhotoSuccess];
      
        
    } else{
        
        DebugLog(@"Saving failed :(");
    }
    
//    [self createPhotoGroupWithName:@"myanycam"];
}


- (void)customalertView:(ShareAlertView *)alertView buttonAtIndex:(int)buttonAtIndex{
    

    if (buttonAtIndex == 0) {
        
//        [self shareIphoneWithShareSdk:KSharebyMyanycam image:self.takePhotoImage title:KAppName shareUrl:@"" viewController:self shareMediaType:SSPublishContentMediaTypeImage];
        
        if ([MYDataManager shareManager].deviceTpye == DeviceTypeIpad1) {
            
            [self shareWithShareSdk:KSharebyMyanycam image:self.takePhotoImage title:KAppName shareUrl:@"" view:self.takePhotoButton arrowDirect:UIPopoverArrowDirectionDown shareMediaType:SSPublishContentMediaTypeImage];
        }
        else
        {
            [self shareIphoneWithShareSdk:KSharebyMyanycam image:self.takePhotoImage title:KAppName shareUrl:@"" viewController:self shareMediaType:SSPublishContentMediaTypeImage];
        }
    }
    
    
}

- (void)cancelButtonClick:(ShareAlertView *)alertView{
    
}

- (void)postPhotoToFaceBookSuccess{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showAlertView:NSLocalizedString(@"Share Success", nil) alertMsg:nil userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    });
}

- (void)alertView:(AHAlertView *)alertVie otherButtonIndex:(NSInteger)buttonIndex{
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView isKindOfClass:[MYAlertView class]]) {
        
        MYAlertView * alert = (MYAlertView *)alertView;
        if ([[alert.userInfo objectForKey:KALERTTYPE] isEqualToString:@"SAVE_IMAGE"]) {
            
            if (buttonIndex == 0) {
                
            }
        }
        
        if ([[alert.userInfo objectForKey:KALERTTYPE] isEqualToString:@"CameraStatus"]) {
            
            if (buttonIndex == 0) {
                
                [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
                [self backAction:nil];
            }
        }
        
        if ([[alert.userInfo objectForKey:KALERTTYPE] isEqualToString:@"GET_MCU_FAILD"]) {
            
            if (buttonIndex == 0) {
                
                [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
                [self backAction:nil];
            }
        }
        
        if ([[alert.userInfo objectForKey:KALERTTYPE] isEqualToString:@"alertNetError"]) {
            
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
            [self backAction:nil];
        }
        
        if ([[alert.userInfo objectForKey:KALERTTYPE] isEqualToString:@"CameraHangup"]) {
            
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
            [self backAction:nil];
        }
        
    }
}

- (void)sendSwitchMusicRequest:(NSInteger)flag{
    
    NSString * cmdStr = [BuildSocketData buildSwitchAudioStr:[MYDataManager shareManager].myUdpSocket.mcuIp mcuPort:[MYDataManager shareManager].myUdpSocket.mcuPort channelId:[MYDataManager shareManager].myUdpSocket.channelId userid:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraInfo.cameraId switchFlag:flag];
    
    [[[self appDelegate] mygcdSocketEngine] writeDataOnMainThread:cmdStr tag:0  waitView:NO];
    
    if (!flag) {
        
        [MobClick event:@"SL"];
    }
    else
    {
        [MobClick event:@"L"];
    }

}

- (void)stopMusic{
    
    if (_flagReceiveAudioData) {
        
        _flagReceiveAudioData = NO;
        
        [self sendSwitchMusicRequest:0];
        
        if (self.aacplayer) {
            
            @synchronized(self.aacplayer)
            {
                [self.aacplayer stop];
                self.aacplayer.selectData = nil;
                self.aacplayer = nil;
            }
        }
        
        if (self.pcmDecodeEngine) {
            
            [self.pcmDecodeEngine stop];
            self.pcmDecodeEngine.selectData = nil;
            self.pcmDecodeEngine = nil;
        }
        
        usleep(10*1000);
        
        @synchronized(self.audioDataQueue)
        {
            [self.audioDataQueue removeAllObjects];
        }
    }
    
}

- (IBAction)stopMusicAction:(id)sender {
    
    _operateViewShowTime = 0;

    UIImage * imageView = nil;
    UIImage * imageViewPress = nil;
    
    if (_flagReceiveAudioData) {
        
        _flagReceiveAudioData = NO;
        
        [self sendSwitchMusicRequest:0];
        
        imageView = [UIImage imageNamed:@"icon_Sound.png"];
        imageViewPress = [UIImage imageNamed:@"icon_Sound_hover.png"];
        
        if (self.aacplayer) {
            
            @synchronized(self.aacplayer)
            {
                [self.aacplayer stop];
                self.aacplayer.selectData = nil;
                self.aacplayer = nil;
            }
        }
        
        
        if (self.pcmDecodeEngine) {
            
            [self.pcmDecodeEngine stop];
            self.pcmDecodeEngine.selectData = nil;
            self.pcmDecodeEngine = nil;
        }
      
        usleep(10*1000);
        
        @synchronized(self.audioDataQueue)
        {
            [self.audioDataQueue removeAllObjects];
        }
    }
    else{
        

        
        _flagReceiveAudioData = YES;
        [self sendSwitchMusicRequest:1];
        
        imageView = [UIImage imageNamed:@"icon_Sound1.png"];
        imageViewPress = [UIImage imageNamed:@"icon_Sound1_hover.png"];
    }

    
    UIButton *button = (UIButton *)sender;
    [button setButtonBgImage:imageView highlight:imageViewPress];
    
    self.cameraInfo.flagListen = _flagReceiveAudioData;
    
}

- (IBAction)startRecordButtonAction:(id)sender {
    
    UIButton * btn = (UIButton *)(sender);

    UIImage * imageView = nil;
    NSString * pressStr = @"icon_Video_hover.png";
    NSString * norStr = @"icon_Video.png";
    
    if (_flagStartRecord) {
        
        _flagStartRecord = NO;

        imageView = [UIImage imageNamed:norStr];
        [self.videoDecodeEngine setRecording:NO];
        [self.videoDecodeEngine setEndRecord:YES];

       // [[AppDelegate getAppDelegate].mygcdSocketEngine sendManualRecordWithSwith:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraInfo.cameraId swithFlag:0];
 
    }
    else
    {
        _flagStartRecord = YES;
      //  [[AppDelegate getAppDelegate].mygcdSocketEngine sendManualRecordWithSwith:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraInfo.cameraId swithFlag:1];
        imageView = [UIImage imageNamed:pressStr];
        [self.videoDecodeEngine setStartRecord:YES];
        [self.videoDecodeEngine setRecording:YES];
        
        


    }
    
    [btn setButtonBgImage:imageView highlight:imageView];

}

- (IBAction)takePhotoAction:(id)sender {
    
    if (!_flagSavePhotoing) {
        
        _flagSavePhotoing = YES;
        _flagNeedTakePhoto = YES;
        _operateViewShowTime = 0;
        
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendTakePhoto:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraInfo.cameraId];
        
        [MobClick event:@"TP"];

    }
}


- (void)startMicAction:(id)sender{
    
    UIButton * btn = (UIButton *)(sender);
    _operateViewShowTime = 0;
    
    UIImage * imageView = nil;
    NSString * pressStr = @"icon_Microphone1.png";
    NSString * norStr = @"icon_Microphone.png";
    
    if (!_flagMicPhoneOpen) {
        
        imageView = [UIImage imageNamed:pressStr];
        _flagMicPhoneOpen = YES;
        [[MYDataManager shareManager].audioRecordEngine start];
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendCameraSpeakerSwitch:self.cameraInfo flagSwitch:1 mcuIp:[MYDataManager shareManager].myUdpSocket.mcuIp port:[MYDataManager shareManager].myUdpSocket.mcuPort];
        [MobClick event:@"S"];
    }
    else{
        
        imageView = [UIImage imageNamed:norStr];
        _flagMicPhoneOpen = NO;
        [[MYDataManager shareManager].audioRecordEngine stop];
       [[AppDelegate getAppDelegate].mygcdSocketEngine sendCameraSpeakerSwitch:self.cameraInfo flagSwitch:0 mcuIp:[MYDataManager shareManager].myUdpSocket.mcuIp port:[MYDataManager shareManager].myUdpSocket.mcuPort];
        [MobClick event:@"SS"];
    }
    
    [btn setButtonBgImage:imageView highlight:imageView];
    
}

- (void)micPhoneAction:(id)sender {
    
    UIButton * btn = (UIButton *)(sender);
    _operateViewShowTime = 0;
    
        UIImage * imageView = nil;
        NSString * pressStr = @"icon_Microphone1.png";
    
        if (!_flagMicPhoneOpen) {
            
            imageView = [UIImage imageNamed:pressStr];
            _flagMicPhoneOpen = YES;
            [[MYDataManager shareManager].audioRecordEngine start];
            [[AppDelegate getAppDelegate].mygcdSocketEngine sendCameraSpeakerSwitch:self.cameraInfo flagSwitch:1 mcuIp:[MYDataManager shareManager].myUdpSocket.mcuIp port:[MYDataManager shareManager].myUdpSocket.mcuPort];
            [MobClick event:@"S"];
        }
        else{
             
//            imageView = [UIImage imageNamed:norStr];
//            _flagMicPhoneOpen = NO;
////            [self.myRecordAudioEngine pause];
//            [[MYDataManager shareManager].audioRecordEngine stop];
//            
//           [[AppDelegate getAppDelegate].mygcdSocketEngine sendCameraSpeakerSwitch:self.cameraInfo flagSwitch:0 mcuIp:[MYDataManager shareManager].myUdpSocket.mcuIp port:[MYDataManager shareManager].myUdpSocket.mcuPort];
        }
        
        [btn setButtonBgImage:imageView highlight:imageView];
    
//    [btn setBackgroundImage:imageView forState:UIControlStateNormal];
    
    
        
}

- (void)stopMicButtonAction:(id)sender {
    
     UIButton * btn = (UIButton *)(sender);
    UIImage * imageView = nil;
    NSString * norStr = @"icon_Microphone.png";
    
    imageView = [UIImage imageNamed:norStr];
    _flagMicPhoneOpen = NO;
    [[MYDataManager shareManager].audioRecordEngine stop];
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendCameraSpeakerSwitch:self.cameraInfo flagSwitch:0 mcuIp:[MYDataManager shareManager].myUdpSocket.mcuIp port:[MYDataManager shareManager].myUdpSocket.mcuPort];
    [btn setButtonBgImage:imageView highlight:imageView];
    [MobClick event:@"SS"];

}

- (void)stopMic{
    
    if (_flagMicPhoneOpen) {
        
        _flagMicPhoneOpen = NO;        
        [[MYDataManager shareManager].audioRecordEngine stop];
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendCameraSpeakerSwitch:self.cameraInfo flagSwitch:0 mcuIp:[MYDataManager shareManager].myUdpSocket.mcuIp port:[MYDataManager shareManager].myUdpSocket.mcuPort];
        [MobClick event:@"SS"];
    }

}


- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
    
    return YES;
}

- (void)updateViewDeviceOrientation{
    
     _flagisVviewAndHview = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self changeVideoViewRect:self.videoSize.height width:self.videoSize.width];
    
    [self.cameraViewNavBar customHideWithAnimation:YES duration:0.2];
    [[AppDelegate getAppDelegate].window hideCustomBottomBar];
    
    [self updateVideoQualityViewFrame];
    
    [self hideBatteryView];
}

- (void)updateViewDeviceOrientationPortrait{
    
     _flagisVviewAndHview = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self changeVideoViewRect:self.videoSize.height width:self.videoSize.width];
   
    [self.cameraViewNavBar customShowWithAnimation:YES duration:0.2];
    
    if (self.isShowBottomBar) {
        [[AppDelegate getAppDelegate].window showCustomBottomBar];
    }
    
    [[AppDelegate getAppDelegate].window bringBottomToFront];
    
    [self updateVideoQualityViewFrame];
    [self showBatteryView];
    
}


//if (orientation == UIInterfaceOrientationLandscapeLeft) {
//    return CGAffineTransformMakeRotation(M_PI*1.5);
//} else if (orientation == UIInterfaceOrientationLandscapeRight) {
//    return CGAffineTransformMakeRotation(M_PI/2);
//} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
//    return CGAffineTransformMakeRotation(-M_PI);
//} else {
//    return CGAffineTransformIdentity;
//}

- (BOOL)shouldAutorotate{
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    
    if (orientation == UIDeviceOrientationLandscapeRight ) {
        
        [self updateViewDeviceOrientation];
        
        return YES;
    }
    
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        
        [self updateViewDeviceOrientation];
        return YES;
    }
    
    if (orientation == UIDeviceOrientationPortrait) {
                
        [self updateViewDeviceOrientationPortrait];
        return YES;
    }
    
    if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        return NO;
    }
    
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;  // 可以修改为任何方向
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        //zuo
        
        [self updateViewDeviceOrientation];
        return YES;
    }
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
        //you
        
        [self updateViewDeviceOrientation];
        return YES;
    }
    
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait) {
        //shang
       [self updateViewDeviceOrientationPortrait];
        return YES;
    }
    if (toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
        //xia
        return NO;
    }
    
    return YES;
}


- (void)twitterPostImage:(NSInteger)error{
    
    if (error == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAlertView:NSLocalizedString(@"Share Success", nil) alertMsg:nil userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        });
    }
}


- (void)whirlVplay{
    
    CAKeyframeAnimation *spinAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    spinAnim.duration = 1.0f; // some appropriate duration
    spinAnim.repeatCount = 999999.0f;
    spinAnim.values = [NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 2.0, 0, 0, 1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                       nil];
    
    [self.playImageView addAnimation:spinAnim forKey:@"playWait"];
}

- (void)playButtonAction:(id)sender {
    
    if (self.cameraInfo.status == 0 && ![AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        return;
    }
    
    self.touchPlayTipLabel.hidden = YES;
    
    if (!_flagBeginPrepareSocket) {
        
        _flagBeginPrepareSocket = YES;
    }
    else
    {
        return;
    }
    
    _decodeFlag = YES;
    
    [self watchCameraCommend];
    
    [self whirlVplay];
    
}

- (void)customDismissModalViewControllerAnimated:(BOOL)animated{
    
    [self stopPlayVideoAndSocket];
    
    [super customDismissModalViewControllerAnimated:animated];
}


- (void)manualTakePhotoRespone:(NSNotification *)notify{
    
    NSDictionary * dat = (NSDictionary *)notify.object;
    if ([[dat objectForKey:@"ret"] intValue] == 0) {
        
        //        [self showCustomAutoDismssAlertView:NSLocalizedString(@"Take Photo Success", nil)];
    }
    else
    {
        [self showCustomAutoDismssAlertView:NSLocalizedString(@"Please Insert SD card into camera", nil)];
    }
}

- (void)manualRecordResp:(NSDictionary *)dat{
    
    if ([[dat objectForKey:@"ret"] intValue] == 1) {
        
        _flagStartRecord = NO;
        NSString * norStr = @"icon_Video.png";
        UIImage * imageView = [UIImage imageNamed:norStr];
        [self.recordButton setButtonBgImage:imageView highlight:imageView];
        [self showAutoDismissAlertView:NSLocalizedString(@"Please Insert SD card into camera", nil)];
    }
    
    if ([[dat objectForKey:@"ret"] intValue] == 2) {
        
        _flagStartRecord = NO;
        NSString * norStr = @"icon_Video.png";
        UIImage * imageView = [UIImage imageNamed:norStr];
        [self.recordButton setButtonBgImage:imageView highlight:imageView];
        NSString * tip = NSLocalizedString(@"Camera‘s battery is low!", nil);
        
        if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
            
            tip = NSLocalizedString(@"Camera‘s battery is low!", nil);
        }
        else
        {
            tip = [NSString stringWithFormat:tip,self.cameraInfo.cameraName];
        }
        
        [self showAutoDismissAlertView:tip];
    }
    else
    {
        if (_flagStartRecord ) {
            
            self.recordStateImageView.hidden = NO;
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            [animation setDuration:0.3];
            [animation setAutoreverses:YES];    //这里设置是否恢复初始的状态,
            [animation setRepeatCount:9999];   //设置重复次数
            [animation setFromValue:[NSNumber numberWithInt:1.0]];  //设置透明度从1 到 0
            [animation setToValue:[NSNumber numberWithInt:0.0]];
            [self.recordStateImageView.layer addAnimation:animation forKey:@"opatity-animation"];
        }
        else
        {
            [self.recordStateImageView.layer removeAllAnimations];
            self.recordStateImageView.hidden = YES;
        }

    }
    
}

- (void)callHangUp:(NSDictionary *)dat{
    
    if ([[dat objectForKey:@"cameraid"] intValue] == self.cameraInfo.cameraId) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary * userInfo = [NSDictionary dictionaryWithObject:@"CameraHangup" forKey:@"KALERTTYPE"];
            NSString * tip = [NSString stringWithFormat:NSLocalizedString(@"Camera:%@ Hang up", nil),self.cameraInfo.cameraName];
            [self showAlertView:tip alertMsg:nil userInfo:userInfo  delegate:self canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        });
    }
    
}

//xns= XNS_CAMERA
//cmd= DEVICE_STATUS
//cameraid=
//battery=0;  //电池电量 -1：本机不带电池  0：电量低 1：低于25% 2：低于50% 3：低于75% 4：低于100%
//sdcard=0； //SD卡剩余容量  00000000000M 标识剩余多少M的容量

- (void)deviceStatus:(NSDictionary *)dat{
    
    if([[dat objectForKey:@"cameraid"] integerValue] == self.cameraInfo.cameraId)
    {
        self.cameraInfo.battery = [[dat objectForKey:@"battery"] integerValue];
        self.cameraInfo.sdcard = [dat objectForKey:@"sdcard"];
        NSString * imageName = nil;
        switch (self.cameraInfo.battery) {
            case -1:
            case 0:
                imageName = @"Battery0.png";
                break;
            case 1:
                imageName = @"Battery1.png";
                break;
            case 2:
            case 3:
                imageName = @"Battery2.png";
                break;
            case 4:
                imageName = @"Battery3.png";
                break;
            default:
                imageName = @"Battery0.png";
                break;
        }
        
        self.batteryImageView.image = [UIImage imageNamed:imageName];
        self.sdcardLabel.text = [NSString stringWithFormat:@"%@M",[dat objectForKey:@"sdcard"]];
        [self showBatteryView];
        
    }
}

- (void)hideBatteryView{
    
    self.batteryImageView.hidden = YES;
    self.sdcardImageView.hidden = YES;
    self.sdcardLabel.hidden = YES;
}

- (void)showBatteryView{
    
    if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        self.batteryImageView.hidden = NO;
        self.sdcardImageView.hidden = NO;
        self.sdcardLabel.hidden = NO;
    }
}
- (void)createPhotoGroupWithName:(NSString *)groupNameStr{
    
    if (!self.alaSsetsLibrary)
    {
        ALAssetsLibrary * lib = [[ALAssetsLibrary alloc] init];
        self.alaSsetsLibrary = lib;
        [lib release];
    }
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        NSString * errorMessage = @"User denied access albums";
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"User denied access albums";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        
        DebugLog(@"errorMessage %@",errorMessage);

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAlertView:NSLocalizedString(@"", nil) alertMsg:NSLocalizedString(@"User denied access albums. Settings> Location Services. Set KCam App is On", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        });
    };

    //创建相簿
    //do add a group named groupNameStr
    [self.alaSsetsLibrary addAssetsGroupAlbumWithName:groupNameStr
                                   resultBlock:^(ALAssetsGroup *group) {
        
                                       if (group) {
                                           
                                           NSLog(@"group %@",group);
                                       }
                                       
     } failureBlock:failureBlock];
}






@end
