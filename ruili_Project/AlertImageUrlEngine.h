//
//  AlertImageUrlEngine.h
//  Myanycam
//
//  Created by myanycam on 13/10/19.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventAlertPictureDelegate.h"
#import "PictureDownloadUrlData.h"
#import "VideoDownloadUrlData.h"
#import "AlertandRecordVideoDelegate.h"

@protocol AlertImageUrlEngineDelegate;


@interface AlertImageUrlEngine : NSObject <EventAlertPictureDelegate,AlertandRecordVideoDelegate,AsyncSocketDelegate>
{
    BOOL            _currentFileType;//NO Image; YES:Video
    BOOL            _checkStateing;
    BOOL            _checkIp;//是否在同一个路由器下
    
}

@property (retain, nonatomic) PictureDownloadUrlData * alertPicture;
@property (retain, nonatomic) VideoDownloadUrlData * videoUrlData;
@property (retain, nonatomic) CameraInfoData       * cameraInfo;
@property (retain, nonatomic) AsyncSocket * checkSocket;
@property (assign, nonatomic) id<AlertImageUrlEngineDelegate> delegate;

- (void)sendAlertPictureRequest:(CameraInfoData *)cameraInfo fileName:(NSString *)fileName delegate:(id<AlertImageUrlEngineDelegate>)adelegate;
- (void)sendRecordRequest:(CameraInfoData *)cameraInfo fileName:(NSString *)fileName delegate:(id<AlertImageUrlEngineDelegate>)adelegate;

@end



@protocol AlertImageUrlEngineDelegate <NSObject>

- (void)alertImageOrRecordUrl:(NSString *)url type:(NSInteger)type;

@end