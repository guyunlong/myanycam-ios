//
//  BuildSocketData.h
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildSocketData : NSObject


+ (NSString *)buildGetNetSettingInfoString:(NSInteger)userid cameraid:(NSInteger)cameraid;

+ (NSString *)buildSettingEthernetString:(NSString *)dhcp ip:(NSString *)ipAddress mask:(NSString *)maskAddress gateWay:(NSString *)gateWay dns1:(NSString *)dns1 dns2:(NSString *)dns2 userid:(NSInteger)userid cameraid:(NSInteger)cameraid;

+ (NSString *)buildGetWifiInfoString:(NSInteger)userid cameraid:(NSInteger)cameraid;

+ (NSString *)buildSetWifiInfoString:(NSString *)wifiOpen ssid:(NSString *)ssid safety:(NSString *)safety password:(NSString *)password userid:(NSInteger)userid cameraid:(NSInteger)cameraid;

+ (NSString *)buildGetDeviceInfoString;

+ (NSString *)buildSetDeviceInfoString:(NSString *)password timeZone:(NSString *)timeZone;
+ (NSString *)buildRegisterString:(NSString *)accountString password:(NSString *)passwordStr;
+ (NSString *)buildLoginString:(NSString *)accountString password:(NSString *)passwordStr logintype:(NSInteger)logintype logintoken:(NSString *)logintoken devicetoken:(NSString *)devicetoken  partner:(NSInteger)partner;

+ (NSString *)buildAgentAddressData;
+ (NSString *)buildDownloadCamera:(NSInteger)userId;
+ (NSString *)buildGetMcu:(NSInteger)userId;
+ (NSString *)buildSwitchAudioStr:(NSString *)mcpIp mcuPort:(NSInteger)port channelId:(NSInteger)channelId userid:(NSInteger)userid cameraid:(NSInteger)cameraid switchFlag:(NSInteger)switchFlag;
+ (NSString *)buildStopWatchCamera:(NSInteger)userId cameraid:(NSString *)cameraid password:(NSString *)password;
+ (NSString *)buildAddCamera:(NSInteger)userId cameraSn:(NSString *)cameraSn password:(NSString *)password name:(NSString *)name type:(NSInteger)type timezone:(NSInteger)timezone;

+ (NSString *)buildModifyVideoSizeData:(NSInteger)userId cameraId:(NSInteger)cameraId password:(NSString *)password mcuIp:(NSString *)mcuIp mcuPort:(NSInteger)port channelId:(NSInteger)channelId videoSize:(NSInteger)videoSize;
+ (NSString *)buildRecordConfig:(NSInteger)policy cameraid:(NSInteger)cameraid password:(NSString *)password repeat:(NSInteger)repeat beginAndEndTimes:(NSArray *)times recordSwitch:(NSInteger)recordSwitch userId:(NSInteger)userId;

+ (NSString *)buildGetRecordConfig:(NSInteger )cameraid password:(NSString* )password userId:(NSInteger)userId;

+ (NSString *)buildGetAlertConfig:(NSInteger )cameraid userid:(NSInteger )userid;
+ (NSString *)buildAlertConfig:(NSInteger)policy cameraid:(NSInteger)cameraid password:(NSString *)password repeat:(NSInteger)repeat beginAndEndTimes:(NSArray *)times voicealarm:(NSInteger)voicealarm movealarm:(NSInteger)movealarm record:(NSInteger)record alertSwitch:(NSInteger)alertSwitch userid:(NSInteger)userid;

+ (NSString *)buildGetAlertListString:(NSInteger)userid cameraid:(NSInteger)cameraId pos:(NSInteger)pos;
+ (NSString *)buildGetRecordListString:(NSInteger)userid cameraid:(NSInteger)cameraId pos:(NSInteger)pos;
+ (NSString *)buildGetImageDownLoadUrlString:(NSInteger)userid cameraid:(NSInteger)cameraId filename:(NSString *)filename;
+ (NSString *)buildGetVideoDownLoadUrlString:(NSInteger)userid cameraid:(NSInteger)cameraId filename:(NSString *)filename;
+ (NSString *)buildDeleteCameraString:(NSInteger)cameraId userid:(NSInteger)userid;
+ (NSString *)buildModifyCamera:(CameraInfoData *)cameraInfo cameraName:(NSString *)cameraName cameraMemo:(NSString *)cameraMemo userid:(NSInteger)userid password:(NSString *)passwordStr;
+ (NSString *)buildDeletePictureFromCamera:(CameraInfoData *)cameraInfo filename:(NSString *)fileName userid:(NSInteger)userid;
+ (NSString *)buildDeleteVideoFromCamera:(CameraInfoData *)cameraInfo filename:(NSString *)fileName userid:(NSInteger)userid;
+ (NSString *)buildCameraSwitchSpeaker:(CameraInfoData *)cameraInfo mcuip:(NSString *)mcuIp mcuPort:(NSInteger)port userid:(NSInteger)userid flagswitch:(NSInteger)flagSwitch;
+ (NSString *)buildModifyAccountPassword:(NSString *)newpassword oldpassword:(NSString *)oldpassword userid:(NSInteger)userid;
+ (NSString *)buildApModifyVideoSizeWithSize:(NSInteger)videoSize userid:(NSInteger)userid cameraid:(NSInteger)cameraid;
+ (NSString *)buildModifyRecordQualityWithSize:(NSInteger)videoSize userid:(NSInteger)userid cameraid:(NSInteger)cameraid;
+ (NSString *)buildGetLiveVideoSize:(NSInteger)userid cameraid:(NSInteger)cameraid;
+ (NSString *)buildGetRecordVideoSize:(NSInteger)userid cameraid:(NSInteger)cameraid;

+ (NSString *)buildSetCameraTimeZone;
+ (NSString *)buildUserProven:(NSString *)password userid:(NSInteger)userid cameraid:(NSInteger)cameraid;
+ (NSString *)buildCallingRespone:(NSInteger)userid cameraid:(NSInteger)cameraid ret:(NSInteger)ret;
+ (NSString *)buildGetCameraVersion:(NSInteger)userid cameraid:(NSInteger)cameraid;
+ (NSString *)buildUpdateCameraVersion:(NSString *)downloadurl cameraid:(NSInteger)cameraid userid:(NSInteger)userid;
+ (NSString *)buildDownCameraGridImage:(NSInteger)userid cameraid:(NSInteger)cameraid password:(NSString *)password;

+ (NSString *)buildTakePhotoStr:(NSInteger )userid cameraid:(NSInteger)cameraid;
+ (NSString *)buildStartTakeVideoStrWithFlag:(NSInteger )userid cameraid:(NSInteger)cameraid swithFlag:(NSInteger)swithFlag;

+ (NSString *)shareUrlToken:(NSInteger)cameraid userid:(NSInteger)userid  validity:(NSInteger)validity type:(NSInteger)type shareName:(NSString *)shareName password:(NSString *)password accessKey:(NSString *)accessKey;
+ (NSString *)buildOpenShareCameraStr:(NSInteger)cameraid userid:(NSInteger)userid swithFlag:(NSInteger)swithFlag passwrod:(NSString *)password;
+ (NSString *)buildRestartCameraStr:(NSInteger)cameraid userid:(NSInteger)userid;
+ (NSString *)buildRotateCameraStr:(NSInteger)cameraid userid:(NSInteger)userid vflip:(NSInteger)vflip;
+ (NSString *)buildPTZCameraStr:(NSInteger)cameraid userid:(NSInteger)userid direction:(NSInteger)direction step:(NSInteger)step;
+ (NSString *)buildGetPwdStr:(NSString *)account;

@end
