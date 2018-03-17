//
//  CameraInfoData.h
//  Myanycam
//
//  Created by myanycam on 13-5-17.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraInfoData : NSObject


@property (assign, nonatomic) NSInteger   cameraIndex;//当前是第几个

@property (retain, nonatomic) NSString    *cameraName;
@property (retain, nonatomic) NSString    *cameraSn;
@property (retain, nonatomic) NSString    *memo;
@property (retain, nonatomic) NSString    *password;
@property (retain, nonatomic) NSString    *sessionid;
@property (retain, nonatomic) NSString    *accesskey;
@property (retain, nonatomic) NSString    *sharePassword;
@property (assign, nonatomic) BOOL      shareswitch;
@property (assign, nonatomic) NSInteger      flagUpnp_success;
@property (assign, nonatomic) BOOL      flagUserProvenResp;//USER_PROVEN_RESP


@property (assign, nonatomic) NSInteger   cameraId;
@property (assign, nonatomic) NSInteger   type;
@property (assign, nonatomic) NSInteger   status;
@property (assign, nonatomic) NSInteger   cameraCount;
@property (assign, nonatomic) NSInteger   touid;
@property (assign, nonatomic) NSInteger   fromuid;
@property (assign, nonatomic) NSInteger   nowcount;

@property (assign, nonatomic) BOOL        iSselect;//列表使用

@property (assign, nonatomic) ChipType    chipType;

//查看摄像头时的操作
@property (assign, nonatomic) BOOL        flagListen;

//ap 模式camera 数据
//@property (retain, nonatomic) NSString  * sn;
@property (retain, nonatomic) NSString  * timezone;
@property (retain, nonatomic) NSString  * producter;
@property (retain, nonatomic) NSString  * mode;
//@property (retain, nonatomic) NSString  * password;

@property (retain, nonatomic) NSString  * romVersionStr;
@property (retain, nonatomic) NSString  * downloadurlStr;  //程序的下载路径
@property (retain, nonatomic) NSString  * versioninfoStr;  //版本的更新信息
@property (assign, nonatomic) NSInteger   needUpdate;//-1 未知； 0 不升级； 1 不需要升级； 2 升级中。

@property (assign, nonatomic) NSInteger videoQualitySize;//0:自动 1：流畅 2:清晰 3:高清

@property (assign, nonatomic) BOOL      flagLock;
@property (assign, nonatomic) NSInteger flagCheckIP;

@property (retain, nonatomic) NSString  * cameraNatip;
@property (assign, nonatomic) NSInteger vflip;

#pragma mark 设备状态
@property (assign, nonatomic) NSInteger battery;//电量
@property (retain, nonatomic) NSString* sdcard;//sd卡 容量

- (id)initWithDictionary:(NSDictionary *)info;
- (void)updateCameraStatus:(NSDictionary *)info;
+ (id)cameraDataWithDict:(NSDictionary *)info;

@end
