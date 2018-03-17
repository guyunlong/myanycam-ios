//
//  EventAlertPictureViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-23.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "EventAlertPictureViewController.h"
#import "AppDelegate.h"


@interface EventAlertPictureViewController ()

@end

@implementation EventAlertPictureViewController

@synthesize alertPicture;
@synthesize cameraInfo;
@synthesize cellData;
@synthesize fileName;

- (void)dealloc {
    [_topNavigationBarView release];
    [_topNavigationItem release];
    
    self.cellData = nil;
    self.alertPicture = nil;
    self.cameraInfo = nil;
    self.fileName = nil;
    
    [_alertEventPicture release];
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
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"", nil) size:CGSizeMake(32, 32) target:self  action:@selector(goToBack)];
    self.topNavigationItem.leftBarButtonItem = backButton;
    [self.topNavigationBarView setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];

    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.alertEventPictureDelegate = self;
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetImageDownloadUrl:self.cameraInfo.cameraId fileName:self.cellData.fileName];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getPictureDownloadUrlRsp:(NSDictionary *)dat{
    
    PictureDownloadUrlData * data = [[PictureDownloadUrlData alloc] initWithDictInfo:dat];
    self.alertPicture = data;
    [data release];
    DebugLog(@"self.alertPicture.proxyurl %@",self.alertPicture.proxyurl);
    self.alertEventPicture.imageURL = self.alertPicture.proxyurl;
    [[AppDelegate getAppDelegate].window hideWaitAlertView];

}

- (void)viewDidUnload {
    [self setTopNavigationBarView:nil];
    [self setTopNavigationItem:nil];
    [self setAlertEventPicture:nil];
    [super viewDidUnload];
}
@end
