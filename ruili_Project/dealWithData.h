//
//  dealWithData.h
//  myanycam
//
//  Created by 中程 on 13-1-10.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cameraListDelegate.h"
#import "registDelegate.h"
#import "loginDelegate.h"
#import "cameraDelegate.h"
#import "cameraAddDelegate.h"
#import "correctPasswordDelegate.h"
#import "cameraViewDelegate.h"
#import "CheckApNetDelegate.h"
#import "EthernetSettingViewDelegate.h"
#import "CameraDeviceSetDelegate.h"
#import "RecordSetDelegate.h"
#import "AlertSettingDelegate.h"
#import "WifiSettingDelegate.h"
#import "WifiSelectDelegate.h"
#import "EventAlertViewDelegate.h"
#import "EventAlertPictureDelegate.h"
#import "AlertandRecordVideoDelegate.h"
#import "ApsystemsetgetVideoSizeDelegate.h"
#import "CheckCameraPasswordDelegate.h"
#import "CameraSettingViewControllerDelegate.h"
#import "CloudModelVideoQualitySetDelegate.h"
#import "FindPasswordDelegate.h"

@interface dealWithData : NSObject
{
    NSMutableArray *resultArray;
//    NSMutableDictionary *resultDict;
    NSMutableDictionary *cameraDict;
}


@property (nonatomic,assign) id<cameraListDelegate> carmeraListDelegate;
@property (nonatomic,assign) id<registDelegate> registDelegate;
@property (nonatomic,assign) id<loginDelegate> loginDelegate;
@property (nonatomic,assign) id<cameraDelegate> cameraDelegate;
@property (nonatomic,assign) id<cameraAddDelegate> cameraAddDegate;
@property (nonatomic,assign) id<correctPasswordDelegate> correctPasswordDelegate;
@property (nonatomic,assign) id<cameraViewDelegate> cameraViewDelegate;

@property (nonatomic,assign) id<WifiSelectDelegate> wifiSelectDelegate;
@property (nonatomic,assign) id<WifiSettingDelegate> wifiSettingDelegate;
@property (nonatomic,assign) id<EthernetSettingViewDelegate> ethernetSettingDelegate;

@property (nonatomic,assign) id<CheckApNetDelegate> checkapnetDelegate;
@property (nonatomic,assign) id<CameraDeviceSetDelegate> cameraDeviceDelegate;

@property (assign, nonatomic) id<RecordSetDelegate> recordSetDelegate;
@property (assign, nonatomic) id<AlertSettingDelegate> alertSettingDelegate;

@property (assign, nonatomic) id<EventAlertViewDelegate> eventAlertdelegate;
@property (assign, nonatomic) id<EventAlertPictureDelegate> alertEventPictureDelegate;
@property (assign, nonatomic) id<AlertandRecordVideoDelegate> alertandRecordVideoUrlDelegate;

@property (assign, nonatomic) id<ApsystemsetgetVideoSizeDelegate> apsystemsetdelegate;
@property (assign, nonatomic) id<CloudModelVideoQualitySetDelegate> cloudModelVideoQualityDelegate;

@property (assign, nonatomic) id<CheckCameraPasswordDelegate>   checkCameraPwdDelegate;
@property (assign, nonatomic) id<CheckCameraPasswordDelegate>   checkCameraPwdAlertViewDelegate;
@property (assign, nonatomic) id<CameraSettingViewControllerDelegate>  cameraSettingDelegate;
@property (assign, nonatomic) id<FindPasswordDelegate>  finedPwdDelegate;

@property (nonatomic,copy) NSString *a;

- (id)initWithData:(NSString *)dat;
-(NSMutableDictionary *)analyzeData:(NSString *)dat;

-(void)test;

-(void)responseToRegist:(NSMutableDictionary *)dat;
-(void)responseToLogin:(NSMutableDictionary *)dat;
-(void)responseToDownloadCamera:(NSMutableDictionary *)dat;
-(void)responseToCameraStatus:(NSMutableDictionary *)dat;
-(void)responseToAddCamera:(NSMutableDictionary *)dat;
-(void)responseToModifyCamera:(NSMutableDictionary *)dat;
//-(void)responseToDeleteCamera:(NSMutableDictionary *)dat;
-(void)responseToModifyPwd:(NSMutableDictionary *)dat;
-(void)responseToGetPwd:(NSMutableDictionary *)dat;
//-(void)responseToGetMcu:(NSMutableDictionary *)dat;
-(void)responseToWatchCamera:(NSMutableDictionary *)dat;
-(void)responseToGetNetworkInfo:(NSMutableDictionary *)dat;
-(void)responseToGetWifiInfo:(NSMutableDictionary *)dat;
-(void)responseToGetDeviceInfo:(NSMutableDictionary *)dat;
-(void)responseToSetEthernetInfo:(NSMutableDictionary *)dat;
-(void)responseToTokenSuccess;
//- (void)responseToStartLogin;
-(void)responseToSetCameraDeviceInfo:(NSMutableDictionary *)dat;
-(void)rspSetWifiInfo:(NSMutableDictionary *)dat;

- (void)responseToGetRecordConfig:(NSMutableDictionary *)dat;
- (void)responseToSetRecordConfig:(NSMutableDictionary *)dat;
- (void)responseToGetAlertConfig:(NSMutableDictionary *)dat;
- (void)responseToSetAlertConfig:(NSMutableDictionary *)dat;
- (void)responseToGetAlertPictureInfo:(NSMutableDictionary *)dat;
- (void)responseToGetEventAlertPictureInfo:(NSMutableDictionary *)dat;
- (void)responseToGetAlertandRecord:(NSMutableDictionary *)dat;
- (void)responseToGetRecordFileList:(NSMutableDictionary *)dat;

@end
