//
//  AlertImageUrlEngine.m
//  Myanycam
//
//  Created by myanycam on 13/10/19.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlertImageUrlEngine.h"
#import "AppDelegate.h"

@implementation AlertImageUrlEngine
@synthesize alertPicture;
@synthesize videoUrlData;
@synthesize checkSocket;
@synthesize delegate;
@synthesize cameraInfo;

- (void)dealloc
{
    
    self.alertPicture = nil;
    self.videoUrlData = nil;
    self.cameraInfo = nil;
    
    [self.checkSocket disconnect];
    self.checkSocket.delegate = nil;
    self.checkSocket = nil;
    self.delegate = nil;
    
    [super dealloc];

}

- (void)prepareData:(id<AlertImageUrlEngineDelegate>)adelegate cameraInfo:(CameraInfoData *)acameraInfo{
    
    if (!self.checkSocket) {
        
        AsyncSocket * socket = [[AsyncSocket alloc] initWithDelegate:self];
        self.checkSocket = socket;
        [socket release];
    }
    
    self.delegate = adelegate;
    self.cameraInfo = acameraInfo;

}

- (void)sendAlertPictureRequest:(CameraInfoData *)acameraInfo fileName:(NSString *)fileName delegate:(id<AlertImageUrlEngineDelegate>)adelegate{
    
    [self prepareData:adelegate cameraInfo:acameraInfo];
    _currentFileType = NO;
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.alertEventPictureDelegate = self;
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetImageDownloadUrl:cameraInfo.cameraId fileName:fileName];
    
}

- (void)sendRecordRequest:(CameraInfoData *)acameraInfo fileName:(NSString *)fileName delegate:(id<AlertImageUrlEngineDelegate>)adelegate{
    
     [self prepareData:adelegate cameraInfo:acameraInfo];
    _currentFileType = YES;
    
    [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.alertandRecordVideoUrlDelegate = self;
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendGetVideoDownloadUrl:acameraInfo.cameraId fileName:fileName];
    
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    
    _checkStateing = NO;
    self.cameraInfo.flagCheckIP = 1;
    
    if (!_currentFileType) {
        
        if (![[MYDataManager shareManager].myUdpSocket.natip isEqual:self.cameraInfo.cameraNatip]) {
            
            self.cameraInfo.flagCheckIP = 0;
            
            [self.delegate alertImageOrRecordUrl:self.alertPicture.proxyurl type:1];
            
        }
        else
        {
            [self.delegate alertImageOrRecordUrl:self.alertPicture.localUrl type:0];
        }
    }
    else
    {
        if (![[MYDataManager shareManager].myUdpSocket.natip isEqual:self.cameraInfo.cameraNatip]) {
            
            self.cameraInfo.flagCheckIP = 0;
            
            [self.delegate alertImageOrRecordUrl:self.videoUrlData.proxyurl type:1];
            
        }
        else
        {
            [self.delegate alertImageOrRecordUrl:self.videoUrlData.localUrl type:0];
            
        }
    }
    
    _checkIp = YES;
    [sock disconnect];
    
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    
    DebugLog(@"err %@",err);
    _checkStateing = NO;
    self.cameraInfo.flagCheckIP = 0;
    _checkIp = NO;
   
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    
    _checkStateing = NO;
    if (self.cameraInfo.flagCheckIP != 1 && !_checkIp) {
        
        if (!_currentFileType) {
            
            [self.delegate alertImageOrRecordUrl:self.alertPicture.proxyurl type:1];
            
        }
        else
        {
            [self.delegate alertImageOrRecordUrl:self.videoUrlData.proxyurl type:1];
        }

    }
    
}

- (void)getPictureDownloadUrlRsp:(NSDictionary *)dat{
    
    PictureDownloadUrlData * data = [[PictureDownloadUrlData alloc] initWithDictInfo:dat];
    self.alertPicture = data;
    [data release];
    
    if (_checkStateing ) {
        
        [self.delegate alertImageOrRecordUrl:self.alertPicture.proxyurl type:0];
    }
    else
    {
        if (self.cameraInfo.flagCheckIP == -1) {
            
//            [self.checkSocket connectToHost:self.alertPicture.localUrlIp onPort:self.alertPicture.localPort withTimeout:2 error:nil];
//            _checkStateing = YES;
            
            BOOL flag = [self.checkSocket connectToHost:self.alertPicture.localUrlIp onPort:self.alertPicture.localPort withTimeout:2 error:nil];
            
            if (!flag) {
                _checkStateing = NO;
                _checkIp = NO;
                self.cameraInfo.flagCheckIP = 0;
                [self.delegate alertImageOrRecordUrl:self.alertPicture.proxyurl type:0];
                
            }
            else
            {
                _checkStateing = YES;
            }
        }
        else
        {
            if (self.cameraInfo.flagCheckIP == 0) {
                
                [self.delegate alertImageOrRecordUrl:self.alertPicture.proxyurl type:0];
                
            }
            else
            {
                [self.delegate alertImageOrRecordUrl:self.alertPicture.localUrl type:1];
                
            }
        }
    }
    
    
}

- (void)getAlertandRecordVideoUrl:(NSDictionary *)dat{
    
    VideoDownloadUrlData * data = [[VideoDownloadUrlData alloc] initWithDictInfo:dat];
    self.videoUrlData = data;
    [data release];
    
    
    if (self.cameraInfo.flagCheckIP == -1) {
        
//        [self.checkSocket connectToHost:self.videoUrlData.localUrlIp onPort:self.videoUrlData.localPort withTimeout:2 error:nil];
        BOOL flag = [self.checkSocket connectToHost:self.videoUrlData.localUrlIp onPort:self.videoUrlData.localPort withTimeout:2 error:nil];
        if (!flag) {
            
            _checkStateing = NO;
            _checkIp = NO;
            self.cameraInfo.flagCheckIP = 0;
            [self.delegate alertImageOrRecordUrl:self.videoUrlData.proxyurl type:0];
            
        }
        
    }
    else
    {
        if (self.cameraInfo.flagCheckIP == 0) {
            
            [self.delegate alertImageOrRecordUrl:self.videoUrlData.proxyurl type:0];
        }
        else
        {
            [self.delegate alertImageOrRecordUrl:self.videoUrlData.localUrl type:1];
        }
    }
}


@end
