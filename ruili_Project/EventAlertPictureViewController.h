//
//  EventAlertPictureViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-23.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "EventAlertPictureDelegate.h"
#import "PictureDownloadUrlData.h"
#import "EventAlertTableViewCell.h"
@interface EventAlertPictureViewController : BaseViewController<EventAlertPictureDelegate>

@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) PictureDownloadUrlData * alertPicture;
@property (retain, nonatomic) EventAlertTableViewCellData * cellData;
@property (retain, nonatomic) NSString  * fileName;
@property (retain, nonatomic) IBOutlet UINavigationBar *topNavigationBarView;
@property (retain, nonatomic) IBOutlet UINavigationItem *topNavigationItem;

@property (retain, nonatomic) IBOutlet MYImageView *alertEventPicture;

@end
