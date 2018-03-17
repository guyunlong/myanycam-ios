//
//  VideoQualitySettingViewController.m
//  Myanycam
//
//  Created by myanycam on 13/7/15.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "VideoQualitySettingViewController.h"
#import "AppDelegate.h"

@interface VideoQualitySettingViewController ()

@end

@implementation VideoQualitySettingViewController

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
    [self showBackButton:self action:nil buttonTitle:nil];
    self.liveQualityLabel.text = NSLocalizedString(@"Live Quality Setting", nil);
    self.recordQualityLabel.text = NSLocalizedString(@"Record Quality Setting", nil);
    
    [self.videoQualitySettingControl setTitle:NSLocalizedString(@"VGA", nil) forSegmentAtIndex:0];
    [self.videoQualitySettingControl setTitle:NSLocalizedString(@"480P", nil) forSegmentAtIndex:1];
    [self.videoQualitySettingControl setTitle:NSLocalizedString(@"720P", nil) forSegmentAtIndex:2];
    
    [self.recordQualityControl setTitle:NSLocalizedString(@"VGA", nil) forSegmentAtIndex:0];
    [self.recordQualityControl setTitle:NSLocalizedString(@"480P", nil) forSegmentAtIndex:1];
    [self.recordQualityControl setTitle:NSLocalizedString(@"720P", nil) forSegmentAtIndex:2];
    
    
    if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.apsystemsetdelegate = self;
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetLiveVideoSize:0 cameraid:0];
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetRecordVideoSize:0 cameraid:0];
    }
    else
    {
        [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cloudModelVideoQualityDelegate = self;
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetLiveVideoSize:[MYDataManager shareManager].userInfoData.userId cameraid:[MYDataManager shareManager].currentCameraData.cameraId];
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetRecordVideoSize:[MYDataManager shareManager].userInfoData.userId cameraid:[MYDataManager shareManager].currentCameraData.cameraId];
    }

//    [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetLiveVideoSize];
//    [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetRecordVideoSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark videosize=  1:低  2:中  3:高

- (IBAction)videoSizeSettingAction:(id)sender {
    
    UISegmentedControl * control = (UISegmentedControl *)sender;
    
    NSInteger  videoSize  = 0;
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            videoSize = 1;
        }
            break;
        case 1:
        {
            videoSize = 2;
        }
            break;
        case 2:
        {
            videoSize = 3;
        }
            break;
            
        default:
            break;
    }
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendModifyRecordQualityWithSize:videoSize userid:[MYDataManager shareManager].userInfoData.userId cameraid:[MYDataManager shareManager].currentCameraData.cameraId];
    
}


#pragma mark videosize=  1:低  2:中  3:高 
- (IBAction)liveQualitySettingAction:(id)sender {
    
    UISegmentedControl * control = (UISegmentedControl *)sender;
    
    NSInteger  videoSize  = 0;
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            videoSize = 1;
        }
            break;
        case 1:
        {
            videoSize = 2;
        }
            break;
        case 2:
        {
            videoSize = 3;
        }
            break;
            
        default:
            break;
    }
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendApModifyCameraVideoSize:videoSize waitView:YES userid:[MYDataManager shareManager].userInfoData.userId cameraid:[MYDataManager shareManager].currentCameraData.cameraId];
    
}

- (void)getLiveVideoSizeCloudModel:(NSDictionary *)dictInfo{
    
    [self getLiveVideoSize:dictInfo];
}


- (void)getRecordVideoSizeCloudModel:(NSDictionary *)dictInfo{
    
    [self getRecordVideoSize:dictInfo];
}


- (void)getLiveVideoSize:(NSDictionary *)dictInfo{
    
    NSInteger index = 0;
    if ([[dictInfo objectForKey:@"ret"] intValue] == 0) {
        
        
        NSInteger videosize = [[dictInfo objectForKey:@"videosize"] intValue];
        switch (videosize) {
            case 1:
                index = 0;
                break;
            case 2:
                index = 1;
                break;
            case 3:
                index = 2;
                break;
            default:
                break;
        }
    }
    
    [self.videoQualitySettingControl setSelectedSegmentIndex:index];
}

- (void)getRecordVideoSize:(NSDictionary *)dictInfo{
    
    NSInteger index = 0;
    
    if ([[dictInfo objectForKey:@"ret"] intValue] == 0) {
        
        NSInteger videosize = [[dictInfo objectForKey:@"videosize"] intValue];
        switch (videosize) {
            case 1:
                index = 0;
                break;
            case 2:
                index = 1;
                break;
            case 3:
                index = 2;
                break;
            default:
                break;
        }
    }
    
    [self.recordQualityControl setSelectedSegmentIndex:index];
}

- (void)dealloc {
    
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.apsystemsetdelegate = nil;
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cloudModelVideoQualityDelegate = nil;
    
    [_recordQualityLabel release];
    [_liveQualityLabel release];
    [_recordQualityControl release];
    [_videoQualitySettingControl release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setRecordQualityLabel:nil];
    [self setLiveQualityLabel:nil];
    [self setRecordQualityControl:nil];
    [self setVideoQualitySettingControl:nil];
    [super viewDidUnload];
}
@end
