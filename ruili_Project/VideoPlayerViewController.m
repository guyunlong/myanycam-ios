//
//  VideoPlayerViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController
@synthesize cellData;
@synthesize cameraInfo;
@synthesize videoUrlData;
@synthesize recordUrl;

- (void)dealloc{
    
    [MYDataManager shareManager].imageUrlEngine.delegate = nil;
    self.cellData = nil;
    self.cameraInfo = nil;
    self.videoUrlData = nil;
    self.recordUrl = nil;
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
    
    NSString * fileName = self.cellData.videoFileName;
    fileName = [NSString stringWithFormat:@"%@_%@",self.cameraInfo.cameraSn,fileName];
    
    NSString *  path = [[MYDataManager shareManager] getVideoFilePath:Kdownloadvideos];
    NSString *  downloadPath = [path stringByAppendingPathComponent:fileName];
    
    if ([[MYDataManager shareManager] checkHaveDownloadVideoWithFileName:fileName] && [ToolClass fileIsExist:downloadPath]){
        
        [self playVideoWithPath:downloadPath];
    }
    else
    {
        if (self.recordUrl && [self.recordUrl length] > 5) {
            
            [self alertImageOrRecordUrl:self.recordUrl type:0];
        }
        else
        {
            [[MYDataManager shareManager].imageUrlEngine sendRecordRequest:self.cameraInfo fileName:self.cellData.videoFileName delegate:self];
        }
        
    }
        
        

    
    [[AppDelegate getAppDelegate].window hideCustomBottomBar];
    [MobClick event:@"WRV"];
}

- (void)notisfyActon:(NSNotification *)notification
{
    
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            DebugLog(@"playbackFinished. Reason: Playback Ended");
            break;
        case MPMovieFinishReasonPlaybackError:
            DebugLog(@"playbackFinished. Reason: Playback Error");
            break;
        case MPMovieFinishReasonUserExited:
            DebugLog(@"playbackFinished. Reason: User Exited");
            [self customDismissModalViewControllerAnimated:YES];
            break;
        default:
            break;
    }
    
}

- (void)customDismissModalViewControllerAnimated:(BOOL)animated{
        
    if ([ToolClass systemVersionFloat] >= 5.0) {
        
        [self dismissViewControllerAnimated:animated completion:^{
            
        }];
    }
    else {
        
        [self dismissModalViewControllerAnimated:animated];
    }
    
}

- (void)moviePlayerLoadStateChanged:(NSNotification *)sender{
    
    DebugLog(@"loadState%d",self.moviePlayer.loadState);
}

- (void)showAlertView:(NSString *)title msg:(NSString *)msg userInfo:(NSDictionary *)userInfo{
    
    MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:title
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
    alertView.userInfo = userInfo;
    [alertView show];
    [alertView release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self customDismissModalViewControllerAnimated:YES];

}

- (void)playVideoWithPath:(NSString *)path{
    
    
    //---play movie---
    MPMoviePlayerController *player = [self moviePlayer];
    [player setContentURL:[NSURL fileURLWithPath:path]];
    player.controlStyle = MPMovieControlStyleFullscreen;
    [player play];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(customDismissModalViewControllerAnimated:)
                                                 name:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(customDismissModalViewControllerAnimated:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

- (void)alertImageOrRecordUrl:(NSString *)url type:(NSInteger)type{
    
    DebugLog(@"videoPlay%@",url);
    
    if (!url || [url length] < 10) {
        
        [self showAlertView:@"Sorry" msg:KUPNPErrorTip userInfo:nil];
        return;
    }

    //---play movie---
    MPMoviePlayerController *player = [self moviePlayer];
    [player setContentURL:[NSURL URLWithString:url]];
    player.controlStyle = MPMovieControlStyleFullscreen;
    [player play];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    DebugLog(@"loadState%d",self.moviePlayer.loadState);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(customDismissModalViewControllerAnimated:)
                                                 name:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(customDismissModalViewControllerAnimated:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
