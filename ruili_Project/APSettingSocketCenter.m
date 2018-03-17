////
////  APSettingSocketCenter.m
////  ruili_Project
////
////  Created by myanycam on 13-2-26.
////  Copyright (c) 2013年 Myanycam. All rights reserved.
////
//
//#import "APSettingSocketCenter.h"
//#import "dealWithCommend.h"
//#import "AppDelegate.h"
//
//static APSettingSocketCenter * _shareAPSettingSocket = nil;
//
//@implementation APSettingSocketCenter
//@synthesize apSettingSocket = _apSettingSocket;
//@synthesize dealDataObject = _dealDataObject;
//@synthesize apnetCheckDelegate;
//@synthesize currentBuffer;
//@synthesize recordSetDelegate;
//@synthesize alertSettingDelegate;
//
//
//- (void)dealloc{
//    [self.apSettingSocket cancelSocket];
//    self.apSettingSocket = nil;
//    self.dealDataObject = nil;
//    self.apnetCheckDelegate = nil;
//    self.recordSetDelegate = nil;
//    self.alertSettingDelegate = nil;
//    self.currentBuffer = nil;
//
//    [super dealloc];
//}
//
//+ (APSettingSocketCenter *)shareAPSettingSocket{
//    if (_shareAPSettingSocket == nil) {
//        _shareAPSettingSocket = [[super allocWithZone:NULL] init];
//    }
//    return _shareAPSettingSocket;
//}
//+ (id)allocWithZone:(NSZone *)zone
//{
//    return [[self shareAPSettingSocket] retain];
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    return self;
//}
//
//- (id)retain
//{
//    return self;
//}
//
//- (NSUInteger)retainCount
//{
//    return NSUIntegerMax;  //denotes an object that cannot be released
//}
//
//- (oneway void)release
//{
//    //do nothing
//}
//- (id)autorelease
//{
//    return self;
//}
//- (id)init{
//    self = [super init];
//    if (self) {
//        [self prepareData];
//    }
//    return self;
//}
//
///****************************************/
//-(AppDelegate *)appDelegate
//{
//    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
//}
//
//- (void)prepareData{
//    
//    dealWithData * deal = [[dealWithData alloc] init];
//    self.dealDataObject = deal;
//    [deal release];
//    
//    self.currentBuffer = [NSMutableData dataWithCapacity:10];
//
//}
//
//- (BOOL)openSocket{
//    
//    MYAsycSocket * socket = [[MYAsycSocket alloc] initWithDelegate:self];
//    self.apSettingSocket = socket;
//    [socket release];
//    
//    [self.apSettingSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
//    
//    if ([self.apSettingSocket SocketOpen:ApHostIp port:ApHostPort] == 0) {
//        
//        return YES;
//    }
//  
//    return NO;
//}
//
//#pragma mark reciveDelegate
//-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
//{
//    NSLog(@"willDisconnectWithError:%@",err);
//    if (self.apnetCheckDelegate && [self.apnetCheckDelegate respondsToSelector:@selector(apnetIsOpen:)])
//    {
//        [self.apnetCheckDelegate apnetIsOpen:NO];
//    }
//}
//
//-(void)onSocketDidDisconnect:(AsyncSocket *)sock
//{
//    NSLog(@"ap set onSocketDidDisconnect");
//    
//    if (self.apnetCheckDelegate && [self.apnetCheckDelegate respondsToSelector:@selector(checkTokenIsRight:)])
//    {
//        [self.apnetCheckDelegate checkTokenIsRight:NO];
//    }
//}
//
//- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
//{
//    
//    NSLog(@"didConnectToHost");
//    if (!_flagCheckToken) {
//        
//        _flagCheckToken = YES;
//        [self.apSettingSocket  checkBeforeCommunicate];
//    }
//    
//    //这是异步返回的连接成功，
//    
//    [sock readDataWithTimeout:-1 tag:0];
//    
//}
//
//- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
//{
//    //    NSLog(@"data:%@,datalength:%d",data,data.length);
//    if ([data isEqualToData:self.apSettingSocket.checkData]) {
//        //联网验证
//        
//        if (self.apnetCheckDelegate && [self.apnetCheckDelegate respondsToSelector:@selector(checkTokenIsRight:)])
//        {
//            [self.apnetCheckDelegate checkTokenIsRight:YES];
//        }
//        
//    }
//    else if(data.length>8)
//    {
//        
//        NSData * reData = [NSData dataWithData:data];
//        [self.currentBuffer appendData:reData];
//        
//        while ([self.currentBuffer length] > 4) {
//            
//            NSData * lengthData = [self.currentBuffer subdataWithRange:NSMakeRange(0, 4)];
//            NSInteger length = [dealWithCommend headerDataToLength:lengthData];
//            
//            
//            if ([self.currentBuffer length] -4 >= length) {
//                //必然有一个完整的包
//                NSData * subData = [[self.currentBuffer subdataWithRange:NSMakeRange(4, length)] copy];
//                
////                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//                NSString * msg = [[NSString alloc] initWithData:subData encoding:NSASCIIStringEncoding];
//                if(msg.length!=0)
//                {
//                    //处理受到的数据
//                    NSMutableDictionary * dataDealed=[self.dealDataObject analyzeData:msg];
//                    NSLog(@"%@",dataDealed);
//                    NSDictionary * cmdType = [MYDataManager shareManager].cmdType;
//                    switch ([[cmdType objectForKey:[dataDealed objectForKey:@"cmd"]] integerValue]) {
//                        case 15:
//                            [self.dealDataObject responseToGetNetworkInfo:dataDealed];
//                            break;
//                        case 16:
//                        {
//                            [self.dealDataObject responseToSetEthernetInfo:dataDealed];
//                        }
//                            break;
//                        case 17:
//                        case 18:
//                            [self.dealDataObject responseToGetWifiInfo:dataDealed];
//                            break;
//                        case 19:
//                            [self.dealDataObject responseToGetDeviceInfo:dataDealed];
//                            break;
//                        case 22:
//                            [self.recordSetDelegate getRecordInfoRespond:dataDealed];
//                            break;
//                        case 23:
//                            [self.recordSetDelegate setRecordInfoRespond:dataDealed];
//                            break;
//                        case 24:
//                            [self.alertSettingDelegate getAlertSettingInfo:dataDealed];
//                            break;
//                        case 25:
//                            [self.alertSettingDelegate setAlertRspInfo:dataDealed];
//                            break;
//                        case 26:
//                        {
//                            [self.dealDataObject rspSetWifiInfo:dataDealed];
//                        }
//                            break;
//                        case 27:
//                        {
//                            [self.dealDataObject responseToSetCameraDeviceInfo:dataDealed];
//                        }
//                            break;
//                        default:
//                            break;
//                    }
//                }
//                else
//                {
//                    
//                    NSLog(@"Error converting received data into UTF-8 String");
//                    
//                    
//                }
//                
//                [msg release];
//                
//                [subData release];
//                
//                [self.currentBuffer replaceBytesInRange:NSMakeRange(0, length + 4) withBytes:NULL length:0];
//            }
//            
//        }
//
//    }
//    
//    [sock readDataWithTimeout:-1 tag:0];
//}
//
//-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
//{
//    NSLog(@"didWriteDataWithTag:%ld",tag);
//    [sock readDataWithTimeout:-1 tag:0];
//}
//
//- (NSTimeInterval)onSocket:(AsyncSocket *)sock  shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed  bytesDone:(NSUInteger)length{
//    
//    if (self.apnetCheckDelegate && [self.apnetCheckDelegate respondsToSelector:@selector(checkTokenIsRight:)])
//    {
//        [self.apnetCheckDelegate checkTokenIsRight:NO];
//    }
//    
//    return 0.0;
//}
//
//- (void)sendGetWifiInfoRequest{
//    NSString * cmd = [BuildSocketData buildGetWifiInfoString];
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//}
//
//- (void)sendSetWifiInfoRequest:(NSString *)wifiOpen ssid:(NSString *)ssid safety:(NSString *)safety password:(NSString *)password{
//    NSString * cmd = [BuildSocketData buildSetWifiInfoString:wifiOpen ssid:ssid safety:safety password:password];
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//}
//
//- (void)sendGetNetInfoRequest{
//    NSString * cmd = [BuildSocketData buildGetNetSettingInfoString];
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//}
//
//- (void)sendGetRecordInfoRequest{
//    
//    NSString * cmd = [BuildSocketData buildGetRecordConfig:0 password:@""];
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//}
//
//- (void)sendGetAlertInfoRequest{
//    
//    NSString * cmd = [BuildSocketData buildGetAlertConfig:0 password:@""];
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//}
//
//- (void)sendSetRecordSettingRequest:(NSInteger)policy cameraid:(NSInteger)cameraid password:(NSString *)password repeat:(NSInteger)repeat beginAndEndTimes:(NSArray *)times{
//    
//    NSString * cmd = [BuildSocketData buildRecordConfig:policy cameraid:cameraid password:password repeat:repeat beginAndEndTimes:times];
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//}
//
//- (void)sendSetAlertInfoRequest:(AlertSettingData *)alertSetData cameradata:(CameraInfoData *)cameraData{
//    
//    NSString * cmd = [BuildSocketData buildAlertConfig:alertSetData.alertType cameraid:cameraData.cameraId password:cameraData.password repeat:[alertSetData.repeatWeekData repeatInt] beginAndEndTimes:alertSetData.timePeriodArray voicealarm:alertSetData.isNoiseAlert movealarm:alertSetData.isMotionAlert record:alertSetData.isAlertRecord alertSwitch:0];
//    
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//}
//
//- (void)sendSetEthernetRequest:(NSString *)dhcp ip:(NSString *)ipAddress mask:(NSString *)maskAddress gateWay:(NSString *)gateWay dns1:(NSString *)dns1 dns2:(NSString *)dns2
//{
//    NSString * cmd = [BuildSocketData buildSettingEthernetString:dhcp ip:ipAddress mask:maskAddress gateWay:gateWay dns1:dns1 dns2:dns2];
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//}
//
//- (void)sendGetDeviceInfoString{
//    
//    NSString * cmd = [BuildSocketData buildGetDeviceInfoString];
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//}
//
//- (void)sendbuildSetDeviceInfoRequest:(NSString *)password timeZone:(NSString *)timeZone{
//    
//    NSString * cmd = [BuildSocketData buildSetDeviceInfoString:password timeZone:timeZone];
//    [self.apSettingSocket writeDataOnMainThread:cmd];
//    
//}
//
//
//@end
