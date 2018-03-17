//
//  MYGCDAsyncSocketEngine.h
//  Myanycam
//
//  Created by andida on 13-3-20.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dealWithCommend.h"
#import "GCDAsyncSocket.h"
#import "dealWithData.h"
#import "AlertSettingData.h"
#import "CameraInfoData.h"
#import "AlertEventData.h"


@protocol GCDAsyncSocketEngineDelegate ;


@interface MYGCDAsyncSocketEngine : NSObject<GCDAsyncSocketDelegate>{
    
    GCDAsyncSocket * _gcdAsyncsocket;
//    dispatch_queue_t    socketQueue;
    id<GCDAsyncSocketEngineDelegate>    _delegate;
    NSInteger      _step;
    NSInteger      _socketConnectCount;
    NSInteger      _remainLengthToRead;
    BOOL           _flagFirstPackage;
    NSInteger      _needToRead;
    NSMutableData   *_currentBuffer;
    NSMutableData   *_needBuffer;
    NSMutableArray  *_gcdSocketSendDataArray;
    NSInteger       _ipType;
    NSInteger       _heartTokenCount;
    
}
@property (retain, nonatomic) NSMutableArray  *gcdSocketSendDataArray;
@property (assign, nonatomic) NSInteger       remainLengthToRead;
@property (retain, nonatomic) NSMutableData  * needBuffer;
@property (retain, nonatomic) NSMutableData  * currentBuffer;
@property (retain, nonatomic) GCDAsyncSocket * gcdAsyncsocket;
@property (assign, nonatomic) id<GCDAsyncSocketEngineDelegate> delegate;
@property (retain, nonatomic) NSString * ipStr;
@property (assign, nonatomic) NSInteger  port;
@property (assign, nonatomic) NSInteger  step;
@property (retain, nonatomic) dealWithData *dealObject;
@property (retain, nonatomic) NSDictionary *cmdType;
@property (retain, nonatomic) NSTimer   * heartTimer;
@property (assign, nonatomic) NSInteger   ipType;// 1 模式  2 非ap 模式
@property (retain, nonatomic) AlertEventData * alertEvent;
@property (assign, nonatomic) NSInteger heartTokenCount;
@property (assign, nonatomic) NSInteger socketConnectCount;
@property (assign, nonatomic) BOOL      flagNeedSendHeartData;




+ (id)myGcdSocketEngine:(id<GCDAsyncSocketEngineDelegate>) delegate socketDelegateQueueName:(const char *)name;
- (id)initWithDelegate:(id<GCDAsyncSocketEngineDelegate>)delegate socketDelegateQueueName:(const char *)name;
- (void)openSocketWithTimeOut:(NSTimeInterval)timeOut ip:(NSString *)ipStr port:(NSInteger)port;
- (void)socketClose;

- (void)writeDataOnMainThread:(NSString *)string tag:(long)tag waitView:(BOOL)flagWatiView;
- (void)readHeaderForLength;

- (void)checkBeforeCommunicate;
- (void)startHeartSendData;
- (void)stopHeartTimer;
- (BOOL)isConnect;

- (void)sendHeartData;


- (void)sendGetWifiInfoRequest:(NSInteger)cameraid;
- (void)sendSetWifiInfoRequest:(NSString *)wifiOpen ssid:(NSString *)ssid safety:(NSString *)safety password:(NSString *)password cameraid:(NSInteger)cameraid;
- (void)sendGetNetInfoRequest:(NSInteger)cameraid;
- (void)sendSetEthernetRequest:(NSString *)dhcp ip:(NSString *)ipAddress mask:(NSString *)maskAddress gateWay:(NSString *)gateWay dns1:(NSString *)dns1 dns2:(NSString *)dns2 cameraid:(NSInteger)cameraid;

- (void)sendGetRecordInfoRequest:(CameraInfoData *)cameradata;
- (void)sendSetRecordSettingRequest:(NSInteger)policy cameraid:(NSInteger)cameraid password:(NSString *)password repeat:(NSInteger)repeat beginAndEndTimes:(NSArray *)times recordSwitch:(NSInteger)recordSwitch;

- (void)sendGetAlertInfoRequest:(CameraInfoData *)cameradata;
- (void)sendSetAlertInfoRequest:(AlertSettingData *)alertSetData cameradata:(CameraInfoData *)cameraData;

- (void)sendGetDeviceInfoString;
- (void)sendSetDeviceInfoRequest:(NSString *)password timeZone:(NSString *)timeZone;

- (void)sendGetAlertListRequest:(NSInteger)userid cameraid:(NSInteger)cameraId pos:(NSInteger)pos waitView:(BOOL)flagWatiView;
- (void)sendGetImageDownloadUrl:(NSInteger)cameraId fileName:(NSString *)fileName;
- (void)sendGetRecordList:(NSInteger)cameraId pos:(NSInteger)pos waitView:(BOOL)flagWatiView;
- (void)sendGetVideoDownloadUrl:(NSInteger)cameraId fileName:(NSString *)fileName;
- (void)sendDeleteCameraRequestWithCameraId:(NSInteger)cameraid;
- (void)sendModifyCameraVideoSize:(CameraInfoData *)cameraInfo videoSize:(NSInteger)videoSize mcuIp:(NSString *)mcuip port:(NSInteger)port channelId:(NSInteger)channelId;
- (void)sendDeletePictureFromCamera:(CameraInfoData *)cameraInfo fileName:(NSString *)fileName;
- (void)sendDeleteVideoFromCamera:(CameraInfoData *)cameraInfo fileName:(NSString *)fileName;
- (void)sendCameraSpeakerSwitch:(CameraInfoData *)cameraInfo flagSwitch:(NSInteger)flagSwitch mcuIp:(NSString *)mcuip port:(NSInteger)port;
- (void)sendInfoModifyCamera:(CameraInfoData *)cameraInfo cameraName:(NSString *)cameraName cameraMemo:(NSString *)cameraMemo password:(NSString *)passwordStr;

- (void)sendModifyAccountPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;
- (void)sendApModifyCameraVideoSize:(NSInteger)videoSize waitView:(BOOL)flag userid:(NSInteger)userid cameraid:(NSInteger)cameraid;
- (void)sendModifyRecordQualityWithSize:(NSInteger)videoSize userid:(NSInteger)userid cameraid:(NSInteger)cameraid;
- (void)sendGetLiveVideoSize:(NSInteger)userid cameraid:(NSInteger)cameraid;
- (void)sendGetRecordVideoSize:(NSInteger)userid cameraid:(NSInteger)cameraid;
- (void)sendSetCameraTimezone;
- (void)sendGetMcuRequest;
- (void)sendGetCameraListRequest;
- (void)sendCheckCameraPasswordRequest:(CameraInfoData *)cameraInfo;
- (void)sendCheckCameraPasswordRequestWithPassword:(CameraInfoData *)cameraInfo password:(NSString *)password;
- (void)sendCallingRsp:(NSInteger)userid cameraid:(NSInteger)cameraid ret:(NSInteger)ret;
- (void)sendGetCameraVersionRequest:(NSInteger)cameraid;
- (void)sendUpdateCameraVersionRequest:(NSString *)downloadurl cameraid:(NSInteger)cameraid;
- (void)sendDownLoadCameraGridImageRequest:(NSInteger )userid cameraid:(NSInteger)cameraid password:(NSString *)password;
- (void)sendTakePhoto:(NSInteger )userid cameraid:(NSInteger)cameraid;
- (void)sendManualRecordWithSwith:(NSInteger )userid cameraid:(NSInteger)cameraid swithFlag:(NSInteger)swithFlag;
- (void)sendOpenShareSwitch:(NSInteger )userid cameraid:(NSInteger)cameraid swithFlag:(NSInteger)swithFlag password:(NSString *)password;
- (void)sendRestartCameraRequest:(NSInteger)userid cameraid:(NSInteger)cameraid;
- (void)sendRotateCameraRequest:(NSInteger)userid cameraid:(NSInteger)cameraid vflip:(NSInteger)vflip;
- (void)sendPTZCameraRequest:(NSInteger)userid cameraid:(NSInteger)cameraid direction:(NSInteger)direction step:(NSInteger)step;
- (void)sendGetPwdRequest:(NSString *)account;


@end


@protocol GCDAsyncSocketEngineDelegate <NSObject>

- (void)AsyncSocketEngineDelegate:(MYGCDAsyncSocketEngine *)socket data:(NSDictionary *)dictInfo tag:(NSInteger)tag;
- (void)socketDisconnect:(MYGCDAsyncSocketEngine *)socket err:(NSError *)err;
- (void)checkTokenSuccess;


@end