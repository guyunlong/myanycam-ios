//
//  AlertandRecordVideoViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-23.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlertandRecordVideoViewController.h"
#import "AppDelegate.h"

@interface AlertandRecordVideoViewController ()

@end

@implementation AlertandRecordVideoViewController
@synthesize videoUrl;
@synthesize playerViewController;
@synthesize cameraInfo;
@synthesize fileName;
@synthesize videoUrlData;
@synthesize cellData;

- (void)dealloc {
    self.cellData = nil;
    self.videoUrl = nil;
    self.cameraInfo = nil;
    self.fileName = nil;
    self.videoUrlData = nil;
    [_topNavigationItem release];
    [_topNavigationBar release];
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
    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"Back", nil) size:CGSizeMake(32, 32) target:self  action:@selector(goToBack)];
    self.topNavigationItem.leftBarButtonItem = backButton;
    [self.topNavigationBar setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];
    
    MPMoviePlayerViewController * playerViewController1 = [[MPMoviePlayerViewController alloc] init];
    self.playerViewController = playerViewController1;
    self.playerViewController.view.frame = CGRectMake(0, 44, 320, 436);
    //-- add to view---
    [self.view insertSubview:playerViewController1.view belowSubview:self.topNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToBack)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [playerViewController1 release];
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.alertandRecordVideoUrlDelegate = self;
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetVideoDownloadUrl:self.cameraInfo.cameraId fileName:self.cellData.fileName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setTopNavigationItem:nil];
    [self setTopNavigationBar:nil];
    [super viewDidUnload];
}

- (void)getAlertandRecordVideoUrl:(NSDictionary *)dat{
    
    VideoDownloadUrlData * data = [[VideoDownloadUrlData alloc] initWithDictInfo:dat];
    self.videoUrlData = data;
    [data release];
    
    self.videoUrl = self.videoUrlData.localUrl;
    //---play movie---
    MPMoviePlayerController *player = [self.playerViewController moviePlayer];
    [player setContentURL:[NSURL URLWithString:self.videoUrl]];
    player.controlStyle = MPMovieControlStyleEmbedded;
    [player play];

}

- (void)moviePlayerLoadStateChanged:(NSNotification *)sender{

#ifdef DEBUG
    MPMovieLoadState type = self.playerViewController.moviePlayer.loadState;
    DebugLog(@"loadState%d",type);

#endif
    

}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;  // 可以修改为任何方向
}

- (BOOL)shouldAutorotate{
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (UIInterfaceOrientationPortrait == orientation) {
        [self.topNavigationBar setHidden:NO];
        return YES;
    }
    
    if (UIInterfaceOrientationLandscapeLeft == orientation ||
        UIInterfaceOrientationLandscapeRight == orientation) {
        [self.topNavigationBar setHidden:YES];
        return YES;
    }
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if (UIInterfaceOrientationPortrait == toInterfaceOrientation) {
        [self.topNavigationBar setHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        return YES;
    }
    
    if (UIInterfaceOrientationLandscapeLeft == toInterfaceOrientation ||
        UIInterfaceOrientationLandscapeRight == toInterfaceOrientation) {
        [self.topNavigationBar setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        return YES;
    }
    
    return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
//    if (UIInterfaceOrientationLandscapeLeft == fromInterfaceOrientation ||
//        UIInterfaceOrientationLandscapeRight == fromInterfaceOrientation) {
//        [self.topNavigationBar setHidden:YES];
//    }
//    
//    if (UIInterfaceOrientationPortrait == fromInterfaceOrientation) {
//        [self.topNavigationBar setHidden:NO];
//    }
    
}


@end
