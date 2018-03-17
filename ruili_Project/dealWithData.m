//
//  dealWithData.m
//  myanycam
//
//  Created by 中程 on 13-1-10.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "dealWithData.h"
#import "AppDelegate.h"

@implementation dealWithData

//@synthesize carmeraListDelegate;
//@synthesize registDelegate;
//@synthesize loginDelegate;
//@synthesize cameraDelegate;
//@synthesize cameraAddDegate;
//@synthesize correctPasswordDelegate;
//@synthesize cameraViewDelegate;

@synthesize wifiSelectDelegate;
@synthesize wifiSettingDelegate;
@synthesize checkapnetDelegate;
@synthesize cameraDeviceDelegate;


@synthesize recordSetDelegate;
@synthesize alertSettingDelegate;

@synthesize eventAlertdelegate;
@synthesize alertEventPictureDelegate;
@synthesize alertandRecordVideoUrlDelegate;
@synthesize apsystemsetdelegate;
@synthesize checkCameraPwdDelegate;
@synthesize checkCameraPwdAlertViewDelegate;

@synthesize cameraSettingDelegate;
@synthesize cloudModelVideoQualityDelegate;
@synthesize finedPwdDelegate;

@synthesize a;

- (id)initWithData:(NSString *)dat
{
    self = [super init];
    if (self) {
        a=dat;
    }
    return self;
}
-(void)test
{
//    DebugLog(@"A:%@",a);
}
#pragma mark -
#pragma mark TCP_deal
-(NSMutableDictionary *)analyzeData:(NSString *)dat
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:5];

    
    NSArray *arr=[dat componentsSeparatedByString:@"<"];
    
    for (NSInteger i=1; i<arr.count; i++) {
        
//        [resultDict setObject:[arr[i] substringToIndex:[arr[i] rangeOfString:@"="].location] forKey:[arr[i-1] substringFromIndex:[arr[i-1] rangeOfString:@">"].location+1]];
        
        NSString * keyStr = [arr[i] substringToIndex:[arr[i] rangeOfString:@"="].location];
        NSString * value = [arr[i] substringWithRange:NSMakeRange([arr[i] rangeOfString:@"="].location+1, [arr[i] length] - [keyStr length]-2)];
        [resultDict setObject:value forKey:keyStr];
    }
    
    return resultDict;
}

-(void)dealloc
{
    self.wifiSettingDelegate = nil;
    self.wifiSelectDelegate = nil;
    self.apsystemsetdelegate = nil;
    self.checkCameraPwdDelegate = nil;
    self.cameraSettingDelegate = nil;
    self.finedPwdDelegate = nil;
    [resultArray release];
//    [resultDict release];
    [cameraDict release];
    [super dealloc];
}

- (void)responseTogetSeverIp:(NSMutableDictionary *)dat{
    
}

//
-(void)responseToRegist:(NSMutableDictionary *)dat
{
    if ([[dat objectForKey:@"ret"] integerValue]==0) {
        [self.registDelegate registSuccess];
    }
    else
    {
        [self.registDelegate registFailed];
    }
    
}

- (void)responseToTokenSuccess{
    
    [self.loginDelegate tokenSuccess];
}

//- (void)responseToStartLogin{
//    
//    [_loginDelegate startLogin];
//}

//
-(void)responseToLogin:(NSMutableDictionary *)dat
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate * appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate.window hideWaitAlertView];
        
        NSInteger ret = [[dat objectForKey:@"ret"] integerValue];
        switch (ret) {
            case 0:
                [self.loginDelegate loginSuccess:dat];
                break;
            case 1:
                
                [self.loginDelegate loginFailedAlert:NSLocalizedString(@"account does not exist", nil) ret:ret];
                break;
            case 2:
                [self.loginDelegate loginFailedAlert:NSLocalizedString(@"Password Error", nil) ret:ret];
                break;
            case 3:
                [self.loginDelegate loginFailedAlert:NSLocalizedString(@"Login Elsewhere", nil) ret:ret];
                break;
            default:
                break;
        }
    });

}
//
-(void)responseToDownloadCamera:(NSMutableDictionary *)dat
{
    [_carmeraListDelegate cameraListInfo:dat];
}

-(void)responseToCameraStatus:(NSMutableDictionary *)dat{
    [_carmeraListDelegate cameraStateInfo:dat];
}
//
-(void)responseToAddCamera:(NSMutableDictionary *)dat
{
    if ([[dat objectForKey:@"ret"] integerValue]==0) {
        [_cameraAddDegate cameraAddSuccess];
    }
    else if ([[dat objectForKey:@"ret"] integerValue]==1)
    {
        [_cameraAddDegate cameraAddFailed:NSLocalizedString(@"camera sn error", nil)];
    }
    else
    {
        [_cameraAddDegate cameraAddFailed:NSLocalizedString(@"camera has used", nil)];
    }
}
//
-(void)responseToModifyCamera:(NSMutableDictionary *)dat
{
    if ([[dat objectForKey:@"ret"] integerValue]==0) {
        
        [_cameraDelegate modifySuccess];
    }
    else
    {
        [_cameraDelegate modifyFailed];
    }
}

-(void)responseToModifyPwd:(NSMutableDictionary*)dat
{
    if ([[dat objectForKey:@"ret"] integerValue]==0) {
        [_correctPasswordDelegate correctPasswordSuccess];
    }
    else
    {
        [_correctPasswordDelegate correctPasswordFailed];
    }
}
//
-(void)responseToGetPwd:(NSMutableDictionary *)dat
{
    [self.finedPwdDelegate getPasswordRespone:dat];
}
//
//-(void)responseToGetMcu:(NSMutableDictionary *)dat
//{
//    [_cameraViewDelegate McuResponse:dat];
//}
//
-(void)responseToWatchCamera:(NSMutableDictionary *)dat
{
    if ([[dat objectForKey:@"ret"] integerValue]==0) {
        
        [_cameraViewDelegate watchCameraSuccess:dat];
    }
    else 
    {
        [_cameraViewDelegate watchCameraFailed:dat];

    }

}

//
-(void)responseToGetWifiInfo:(NSMutableDictionary *)dat
{
    if (self.wifiSelectDelegate && [self.wifiSelectDelegate respondsToSelector:@selector(wifiInfoListInfo:)]) {
        [self.wifiSelectDelegate wifiInfoListInfo:dat];
    }
}

- (void)rspSetWifiInfo:(NSMutableDictionary *)dat{
    
    if (self.wifiSettingDelegate && [self.wifiSettingDelegate respondsToSelector:@selector(wifiSettingSuccess:)])
    {
        [self.wifiSettingDelegate wifiSettingSuccess:dat];
    }
}
//
-(void)responseToGetDeviceInfo:(NSMutableDictionary *)dat
{
    if (self.cameraDeviceDelegate && [self.cameraDeviceDelegate respondsToSelector:@selector(getDeviceInfoRsp:)]) {
        
        [self.cameraDeviceDelegate getDeviceInfoRsp:dat];
    }
}

- (void)responseToSetCameraDeviceInfo:(NSMutableDictionary *)dat{
    
    if (self.cameraDeviceDelegate && [self.cameraDeviceDelegate respondsToSelector:@selector(setDeviceInfoRsp:)]) {
        
        [self.cameraDeviceDelegate setDeviceInfoRsp:dat];
    }
}

-(void)responseToSetEthernetInfo:(NSMutableDictionary *)dat{
    
    if (self.ethernetSettingDelegate && [self.ethernetSettingDelegate respondsToSelector:@selector(ethernetSettingSuccess:)]) {
        [self.ethernetSettingDelegate ethernetSettingSuccess:dat];
    }
}

//
-(void)responseToGetNetworkInfo:(NSMutableDictionary *)dat
{
    if (self.ethernetSettingDelegate && [self.ethernetSettingDelegate respondsToSelector:@selector(getEthernetInfoSuccess:)]) {
        [self.ethernetSettingDelegate getEthernetInfoSuccess:dat];
    }
}

- (void)responseToGetRecordConfig:(NSMutableDictionary *)dat
{
    if (self.recordSetDelegate && [self.recordSetDelegate respondsToSelector:@selector(getRecordInfoRespond:)]) {
        
        [self.recordSetDelegate getRecordInfoRespond:dat];
    }
}

- (void)responseToSetRecordConfig:(NSMutableDictionary *)dat{

    if (self.recordSetDelegate && [self.recordSetDelegate respondsToSelector:@selector(setRecordInfoRespond:)]) {
        
        [self.recordSetDelegate setRecordInfoRespond:dat];
    }
}

- (void)responseToGetAlertConfig:(NSMutableDictionary *)dat{
    
    if (self.alertSettingDelegate && [self.alertSettingDelegate respondsToSelector:@selector(getAlertSettingInfo:)]) {
        
        [self.alertSettingDelegate getAlertSettingInfo:dat];
    }
}

- (void)responseToSetAlertConfig:(NSMutableDictionary *)dat{
    
    if (self.alertSettingDelegate && [self.alertSettingDelegate respondsToSelector:@selector(setAlertRspInfo:)]) {
        
        [self.alertSettingDelegate setAlertRspInfo:dat];
    }
    
}
//- (void)responseToSetDeviceInfo:(NSMutableDictionary *)dat{
//    
//    if (self.cameraDeviceDelegate && [self.cameraDeviceDelegate respondsToSelector:@selector(setDeviceInfoRsp:)]) {
//        
//        [self.cameraDeviceDelegate setDeviceInfoRsp:dat];
//    }
//}

- (void)responseToGetAlertPictureInfo:(NSMutableDictionary *)dat{
    
    if (self.eventAlertdelegate && [self.eventAlertdelegate respondsToSelector:@selector(getEventAlertPictureRsp:)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.eventAlertdelegate getEventAlertPictureRsp:dat];            
        });

    }
}

- (void)responseToGetRecordFileList:(NSMutableDictionary *)dat{
    
    if (self.eventAlertdelegate && [self.eventAlertdelegate respondsToSelector:@selector(getRecordFileNameRsp:)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.eventAlertdelegate getRecordFileNameRsp:dat];
        });
    }
    
}

- (void)responseToGetEventAlertPictureInfo:(NSMutableDictionary *)dat{
    
    if (self.alertEventPictureDelegate && [self.alertEventPictureDelegate respondsToSelector:@selector(getPictureDownloadUrlRsp:)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertEventPictureDelegate getPictureDownloadUrlRsp:dat];
        });
    }
}

- (void)responseToGetAlertandRecord:(NSMutableDictionary *)dat{
    
    if (self.alertandRecordVideoUrlDelegate && [self.alertandRecordVideoUrlDelegate respondsToSelector:@selector(getAlertandRecordVideoUrl:)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertandRecordVideoUrlDelegate getAlertandRecordVideoUrl:dat];
        });
    }
}


#pragma mark -
#pragma mark UDP_deal
@end
