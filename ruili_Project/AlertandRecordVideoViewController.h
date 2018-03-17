//
//  AlertandRecordVideoViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-23.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "AlertandRecordVideoDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoDownloadUrlData.h"
#import "EventAlertTableViewCellData.h"

@interface AlertandRecordVideoViewController : BaseViewController<AlertandRecordVideoDelegate>


@property (retain, nonatomic) EventAlertTableViewCellData * cellData;
@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) VideoDownloadUrlData * videoUrlData;
@property (retain, nonatomic) NSString  * fileName;
@property (retain, nonatomic) NSString * videoUrl;
@property (retain, nonatomic) IBOutlet UINavigationBar *topNavigationBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *topNavigationItem;
@property (retain, nonatomic) MPMoviePlayerViewController *playerViewController;

@end
