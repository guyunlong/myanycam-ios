//
//  MYDataManager.h
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "RecordVideoSettingData.h"
#import "EthernetInfoData.h"
#import "CameraDeviceData.h"
#import "AlertPictureListData.h"
#import "RecordListData.h"
#import "UserInfoData.h"
#import "WifiInfoData.h"
#import "MYGCDAsyncUdpSocket.h"
#import "AudioRecordEngine.h"

#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK/ShareSDK.h>



@interface MYDataManager : NSObject <ASIHTTPRequestDelegate,TencentSessionDelegate>{
    
    AlertSettingData * _alertSettingData;
    RecordVideoSettingData  *_recordVideoSettingData;
    
    MYGCDAsyncUdpSocket  *_myUdpSocket;
    
    AudioRecordEngine    *_audioRecordEngine;

    NSString  *   _accountIdStr;
    NSString  *   _passwordStr;
    unsigned long _currentVideoFrameTimeStamp;
    BOOL      _flagLoginSuccess;
    BOOL      _flagLocalLogin;//NO 外网 YES:内网
    BOOL      _flagNeedToUpdateEventState;
    
    ASINetworkQueue * _downLoadQueue;
    AlertImageUrlEngine  *_imageUrlEngine;
    
//    TencentOAuth* _tencentOAuth;
    NSMutableArray * _qqPermissions;

}

@property (retain, nonatomic) NSMutableArray * qqPermissions;
@property (retain, nonatomic) TencentOAuth *    tencentOAuth;
@property (retain, nonatomic) AlertImageUrlEngine  * imageUrlEngine;
@property (retain, nonatomic) ASINetworkQueue      * downLoadQueue;
@property (retain, nonatomic) MYGCDAsyncUdpSocket  * myUdpSocket;
@property (retain, nonatomic) AudioRecordEngine    * audioRecordEngine;
@property (retain, nonatomic) UserInfoData * userInfoData;
@property (assign, nonatomic) BOOL     flagNeedToUpdateEventState;
@property (assign, nonatomic) BOOL     flagLocalLogin;
@property (assign, nonatomic) BOOL     flagLoginSuccess;
@property (assign, nonatomic) BOOL     flagKickOff;
@property (assign, nonatomic) VIDEO_SIZE_TYPE currentVideoType;
@property (assign, nonatomic) unsigned long     currentVideoFrameTimeStamp;
@property (retain, nonatomic) AlertSettingData * alertSettingData;
@property (retain, nonatomic) RecordVideoSettingData * recordVideoSettingData;
@property (retain, nonatomic) EthernetInfoData  * ethernetInfo;
@property (retain, nonatomic) CameraDeviceData  * cameraDeviceInfo;
@property (retain, nonatomic) NSMutableArray    *pcmDataArray;
@property (retain, nonatomic) NSDictionary   * cmdType;
@property (assign, nonatomic) CameraInfoData * currentCameraData;
@property (assign, nonatomic) BOOL           flagNeedToWobble;
@property (retain, nonatomic) NSString   * currentWifi;
@property (retain, nonatomic) WifiInfoData   *currnetWifiData;
@property (assign, nonatomic) DeviceType      deviceTpye;
@property (retain, nonatomic) NSMutableDictionary * downloadVideoFileNameDic;
@property (retain, nonatomic) NSDictionary  * apnsDict;
@property (retain, nonatomic) NSMutableDictionary  * apnsAlertPictureDict;
@property (retain, nonatomic) NSMutableArray    * apnsDataArray;
@property (retain, nonatomic) NSMutableDictionary   * haveDownloadVideoFile;
@property (retain, nonatomic) NSMutableDictionary   * haveDownloadImageFile;



//--------------------------------------------
#pragma mark file  data array
@property (retain, nonatomic) NSMutableArray * imageFileArray;
@property (retain, nonatomic) NSMutableArray * videoFileArray;
@property (retain, nonatomic) NSMutableArray * imageSourceArray;
#pragma mark camera data array
@property (retain, nonatomic) NSMutableArray * cameraListArray;
@property (retain, nonatomic) NSMutableDictionary   * cameraListDiction;
#pragma mark timezone
@property (retain, nonatomic) NSArray * timezoneArray;

#pragma mark alert and record data dictionary
//@property (retain, nonatomic) AlertPictureListData * alertEventData;
//@property (retain, nonatomic) RecordListData * recordListData;
@property (retain, nonatomic) NSMutableDictionary * alertEventListDataDict;
@property (retain, nonatomic) NSMutableDictionary * recordListDataDict;
@property (retain, nonatomic) NSMutableDictionary * alertNumberDict;


- (void)resetData;

+ (MYDataManager *) shareManager;

- (NSString *)saveImagePath;
- (NSString *)getFilePathAtDocument:(NSString *)string;
- (NSString *)getFilePathAtUserIDPath:(NSString *)fileName;
- (NSString *)getVideoFileTempPath;
- (NSString *)getVideoFilePath:(NSString *)fileName;
- (void)addPcmDataToArray:(NSData *)pcmData;
- (void)deleteImageFromFileWithIndex:(NSInteger)index;
- (void)addImageFileWithImageName:(NSString *)imageName imagePath:(NSString *)imagePath;

#pragma mark camera data array operation
- (void)cameraListInfo:(NSMutableDictionary *)info;
- (void)cameraStateInfoUpdate:(NSMutableDictionary *)info;
- (void)deleteCameraWithCameraId:(NSInteger)cameraId;
- (void)updateRecordSetInfo:(NSDictionary *)info;
- (void)updateEthernetInfo:(NSDictionary *)info;
- (void)updateCameraInfo:(NSDictionary *)info;
- (CameraInfoData *)getCameraInfoWithCameraId:(NSInteger )cameraId;
- (void)updateAlertSetInfo:(NSDictionary *)info;
- (void)setCameraStateValueWithCameraId:(NSInteger)cameraid;

- (void)updateImageFile;
- (void)addTakePhotoImage:(NSString * )urlstr;

- (void)updateAlertEventFileListWithDict:(NSDictionary *)info;
- (void)updateRecordFileListWithDict:(NSDictionary *)info;
- (void)addAlertEventToAlertListData:(AlertEventData *)alertEventData;

- (void)deleteAlertEventDataFromDict:(NSInteger)cameraid;
- (void)deleteRecordDataFromDict:(NSInteger)cameraid;

- (AlertPictureListData *)getAlertEventListDataWithCameraID:(NSInteger)cameraid;
- (RecordListData *)getRecordDataWithCameraId:(NSInteger)cameraid;

- (DeviceLanaguage)currentSystemLanguage;
- (void)saveAccountInfo;
- (void)saveAccountAndPassword:(NSString *)account password:(NSString *)passwordStr;
- (void)deleteAccountFromkeychain:(NSString *)userName;
- (NSString *)getPassword:(NSString *)userName;

- (void)initMyUdpSocket:(NSDictionary *)mcuipdat;
- (void)initAudioRecordEngine;
- (void)addalertEventNumberWithCameraId:(NSInteger)cameraid;

- (void)prepareDataAfterLogin;
- (void)addDownloadFileName:(NSString *)fileName;
- (void)deleteDownloadFileName:(NSString *)fileName;
- (BOOL)checkHaveDownloadVideoWithFileName:(NSString *)fileName;
- (void)addAlertApnsDict:(NSDictionary *)userInfo cameraId:(NSInteger)cameraid;


//0:下载中 1:下载成功 2:下载失败
- (void)updateDownLoadVideoState:(NSString *)videoName state:(NSInteger)state;
- (NSInteger)getDownLoadVideoFileState:(NSString *)videoName;

- (void)addHaveDownImageFileName:(NSString *)fileName path:(NSString *)path;
- (void)saveSomeFile;

- (void)downloadCameraGridImage:(NSDictionary *)dataDict;
- (void)deleteImageCache;

//- (void)getAlarmImageUrlWithName:(NSString *)fileName;

#pragma mark QQ 登录  shareSdk
- (void)loginWithQQ;
- (NSArray * )getShareTypeArray;
- (id<ISSShareOptions>)getShareOptionsArray;

@end
