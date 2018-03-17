//
//  cameraViewViewController.h
//  myanycam
//
//  Created by 中程 on 13-1-19.
//  Copyright (c) 2013年 中程. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "cameraViewDelegate.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"
#import "VideoFrameExtractor.h"
#import "PCMplayEngine.h"
#import "MYRecordAudioEngine.h"
#import "VideoReocderEngine.h"
#import "AACPlayer.h"
#import "UdpVideoData.h"
#import "CameraSettingViewController.h"
#import "AudioStreamer.h"
#import "RootViewControllerDismissDelegate.h"
#import "MYImageViewAnimation.h"
#import "CustomMovieGLView.h"
#import "CameraUdpDataDelegate.h"
#import "VideoQualityChangeView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ShareCameraAlertView.h"

#define VideoDataLength     1024*32



@interface cameraViewViewController : BaseViewController<cameraViewDelegate,GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate,UIAlertViewDelegate,ShareAlertViewDelegate, CameraUdpDataDelegate,VideoQualityChangeDelegate>
{
    CameraInfoData * _cameraInfo;
    

    NSMutableData  *    _allUdpDataBuffer;
    BOOL                _flagInitDecodeEngine;
    VideoFrameExtractor *   _videoDecodeEngine;
    BOOL                _decodeFlag;
    NSMutableArray  *   _audioDataQueue;
    NSMutableArray  *   _videoFrameQueue;
    UdpVideoData    *   _currentUdpVideoData;
    NSMutableDictionary * _videoDataDictionary;
    NSMutableArray  *   _sendAudioArray;
    UIImage*            _currentImage;
    UIImage*            _takePhotoImage;
    BOOL _isP2pSuccess;
    BOOL isBindPort;
    BOOL                _flagUpdVideo;
    BOOL                _flagReceiveAudioData;
    BOOL                _flagSavePhotoing;
    BOOL                _flagMicPhoneOpen;
    BOOL                _flagisVviewAndHview;
    NSInteger           _flagWatchCamera;
    BOOL                _flagReciveToken;
    BOOL                _flagStopWaitView;
    BOOL                _flagVideoQueueSort;
    BOOL                _flagBeginPrepareSocket;
    BOOL                _flagOperateViewShow;
    BOOL                _flagNeedTakePhoto;
    BOOL                _flagNeedAutoP2p;
    BOOL                _flagStartDecode;

    NSInteger           _operateViewShowTime;
    NSInteger           _videoType;
    PCMplayEngine   *   _pcmDecodeEngine;

    dispatch_queue_t    _display_picture_Queue;
    NSInteger           _step;
    MYRecordAudioEngine*_myRecordAudioEngine;
    CustomMovieGLView      *_openGlView;
    NSMutableArray     *_yuvFramesQueue;
    NSMutableDictionary*_mcuServerDictionray;
    

    NSInteger          _loopSendTokenTime;
    clock_t            _currentFrameStamp;
    clock_t            _lastFrameTimeStamp;
    clock_t            _startDisplayTime;
    clock_t            _endDisplayTime;
    NSInteger          _sleepFrameCount;
    
    NSTimer            *_changeVideoSizeTimer;
    ALAssetsLibrary    *_alaSsetsLibrary;
    BOOL               *_sleepFlag;
    CGFloat           _videoDataLen;
    CGFloat           _videoDataLength;
    Audio_Format      _audioFormat;
    NSInteger         _countAacplayer;
    NSInteger         _startGetUpdTimerCount;
    CGSize            _videoSize;
    CGFloat           _netStateStatistics;
    BOOL              _flagStartCountNetState;
    BOOL              _flagChangeVideoSize;
    BOOL              _flagHadChangeVideoSize;
    BOOL              _flagDecodeError;
    BOOL              _flagIsCallign;
    BOOL              _flagStartRecord;
    id<RootViewControllerDismissDelegate>   _rootDelegate;
    
    NSInteger   _videoSizeType;
    CGFloat      _zoomLevel;
    CGPoint      _originalPoint;
    BOOL         _haveChangeTo480P;
    
//    NSMutableData * _testPcmData;
    
}

@property (assign, nonatomic) BOOL     flagNeedAutoP2p;
@property (assign, nonatomic) CGSize   videoSize;
@property (retain, nonatomic) IBOutlet UIView *vVideoPlayView;
@property (retain, nonatomic) IBOutlet UIView *hVideoPlayView;
@property (assign, nonatomic) id<RootViewControllerDismissDelegate>   rootDelegate;
@property (retain, nonatomic) AudioStreamer *   audioStreamaac;
@property (assign, nonatomic) Audio_Format      audioFormat;
@property (retain, nonatomic) AACPlayer        *aacplayer;
@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) ALAssetsLibrary *alaSsetsLibrary;
@property (retain, nonatomic) NSTimer       * changeVideoSizeTimer;
@property (retain, nonatomic) NSTimer       * aacplayerTimer;
@property (retain, nonatomic) IBOutlet UIImageView *p2pStatusImageView;

@property (retain, nonatomic) NSMutableArray   *yuvFramesQueue;
@property (retain, nonatomic) CustomMovieGLView    *openGlView;
@property (retain, nonatomic) IBOutlet UILabel *memoryLabel;

@property (retain, nonatomic) IBOutlet UIView *vView;


@property (retain, nonatomic) IBOutlet UILabel *videoDataSize;
@property (retain, nonatomic) MYRecordAudioEngine  *myRecordAudioEngine;
@property (assign, nonatomic) BOOL                 flagReceiveAudioData;
@property (retain, nonatomic) PCMplayEngine        * pcmDecodeEngine;
@property (retain, nonatomic) NSMutableArray        * audioDataQueue;
@property (retain, nonatomic) NSMutableArray        * sendAudioArray;
@property (copy, nonatomic)   UIImage               * currentImage;
@property (retain, nonatomic)   UIImage               * takePhotoImage;
@property (retain, nonatomic) NSMutableDictionary   * videoDataDictionary;
@property (retain, nonatomic) UdpVideoData          * currentUdpVideoData;
@property (retain, nonatomic) VideoFrameExtractor   * videoDecodeEngine;
@property (retain, nonatomic) NSMutableArray        * videoFrameQueue;
@property (retain, nonatomic) IBOutlet UIImageView *videoImageView;
@property (retain, nonatomic) IBOutlet UIImageView *hViewImageView;

@property (retain, nonatomic) IBOutlet UIButton *stopMusicButton;
@property (retain, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (retain, nonatomic) IBOutlet UIButton *takeVideoButton;
@property (retain, nonatomic) IBOutlet UIButton *micPhoneButton;

@property (retain, nonatomic) IBOutlet UINavigationBar *cameraViewNavBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *cameraViewNavItem;

@property (retain, nonatomic) IBOutlet UIView *operateCameraVview;

@property (retain, nonatomic) IBOutlet MYImageViewAnimation *playImageView;
@property (retain, nonatomic) IBOutlet UIImageView *playMiddleArrowImageView;
@property (retain, nonatomic) IBOutlet UIView *playActionView;

@property (retain, nonatomic) IBOutlet UILabel *touchPlayTipLabel;
@property (retain, nonatomic) IBOutlet UIButton *zoomButton;
@property (retain, nonatomic) IBOutlet UIButton *micrifyButton;
@property (retain, nonatomic) IBOutlet UIButton *micButton;

@property (retain, nonatomic) IBOutlet UILabel *frameLengthLabel;
@property (assign, nonatomic) BOOL     flagIsCallign;

@property (retain, nonatomic) IBOutlet UIButton *videoQualityButton;
@property (retain, nonatomic) VideoQualityChangeView    * videoQualityView;
@property (assign, nonatomic) NSInteger haveAutoChangeVideoSize;
@property (retain, nonatomic) IBOutlet UIView *videoStreamView;
@property (retain, nonatomic) IBOutlet UIButton *recordButton;

@property (retain, nonatomic) IBOutlet UIImageView *recordStateImageView;
@property (retain, nonatomic) ShareCameraAlertView * shareCameraAlertView;
@property (retain, nonatomic) IBOutlet UIImageView *backImageView;

@property (retain, nonatomic) IBOutlet UIImageView *sdcardImageView;
@property (retain, nonatomic) IBOutlet UIImageView *batteryImageView;
@property (retain, nonatomic) IBOutlet UILabel *sdcardLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(CameraInfoData *)Info;
- (id)initWithDict:(CameraInfoData *)Info;

- (void)checkaacplayer;
- (void)backAction:(id)sender;
- (IBAction)videoQualityChangeButtonAction:(id)sender;

- (IBAction)stopMusicAction:(id)sender;

- (IBAction)takePhotoAction:(id)sender;
- (void)micPhoneAction:(id)sender;

- (void)playButtonAction:(id)sender;
- (IBAction)startRecordButtonAction:(id)sender;

- (NSString *)getVideoQualityStrWithIndex:(NSInteger)index;

@end


