////
////  APSettingSocketCenter.h
////  ruili_Project
////
////  Created by myanycam on 13-2-26.
////  Copyright (c) 2013年 Myanycam. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
//#import "dealWithData.h"
//#import "AppDelegate.h"
//#import "CheckApNetDelegate.h"
//#import "RecordSetDelegate.h"
//#import "AlertSettingData.h"
//#import "AlertSettingDelegate.h"
//
//@interface APSettingSocketCenter : NSObject<AsyncSocketDelegate>{
//    MYAsycSocket        *_apSettingSocket;
//    dealWithData        *_dealDataObject;
//    
//    BOOL                 _flagCheckToken;
//    NSMutableData       *_currentBuffer;
//}
//
//
//@property (retain, nonatomic) dealWithData  * dealDataObject;
//@property (retain, nonatomic) MYAsycSocket * apSettingSocket;
//@property (retain, nonatomic) NSMutableData * currentBuffer;
//
//@property (assign, nonatomic) id<CheckApNetDelegate> apnetCheckDelegate;
//@property (assign, nonatomic) id<RecordSetDelegate> recordSetDelegate;
//@property (assign, nonatomic) id<AlertSettingDelegate> alertSettingDelegate;
//
//
//
//+ (APSettingSocketCenter *) shareAPSettingSocket;
//
//- (AppDelegate *)appDelegate;
//- (BOOL)openSocket;
//
//- (void)sendGetWifiInfoRequest;
//- (void)sendSetWifiInfoRequest:(NSString *)wifiOpen ssid:(NSString *)ssid safety:(NSString *)safety password:(NSString *)password;
//- (void)sendGetNetInfoRequest;
//- (void)sendSetEthernetRequest:(NSString *)dhcp ip:(NSString *)ipAddress mask:(NSString *)maskAddress gateWay:(NSString *)gateWay dns1:(NSString *)dns1 dns2:(NSString *)dns2;
//
//- (void)sendGetRecordInfoRequest;
//- (void)sendSetRecordSettingRequest:(NSInteger)policy cameraid:(NSInteger)cameraid password:(NSString *)password repeat:(NSInteger)repeat beginAndEndTimes:(NSArray *)times;
//
//- (void)sendGetAlertInfoRequest;
//- (void)sendSetAlertInfoRequest:(AlertSettingData *)alertSetData cameradata:(CameraInfoData *)cameraData;
//
//- (void)sendGetDeviceInfoString;
//- (void)sendbuildSetDeviceInfoRequest:(NSString *)password timeZone:(NSString *)timeZone;
//
//@end
