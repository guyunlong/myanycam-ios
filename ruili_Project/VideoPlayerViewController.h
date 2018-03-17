//
//  VideoPlayerViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "VideoDownloadUrlData.h"
#import "EventAlertTableViewCellData.h"
#import "AlertImageUrlEngine.h"

@interface VideoPlayerViewController : MPMoviePlayerViewController<AlertImageUrlEngineDelegate,UIAlertViewDelegate>{
    
    
}

@property (retain, nonatomic) EventAlertTableViewCellData * cellData;
@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) VideoDownloadUrlData * videoUrlData;
@property (retain, nonatomic) NSString * recordUrl;

- (void)customDismissModalViewControllerAnimated:(BOOL)animated;


@end
