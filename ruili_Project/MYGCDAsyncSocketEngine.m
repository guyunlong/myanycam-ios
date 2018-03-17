//
//  MYGCDAsyncSocketEngine.m
//  Myanycam
//
//  Created by andida on 13-3-20.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYGCDAsyncSocketEngine.h"
#import "AppDelegate.h"

@implementation MYGCDAsyncSocketEngine
@synthesize gcdAsyncsocket = _gcdAsyncsocket;
@synthesize delegate = _delegate;
@synthesize port = _port;
@synthesize ipStr = _ipStr;
@synthesize dealObject = _dealObject;
@synthesize cmdType = _cmdType;
@synthesize step = _step;
@synthesize socketConnectCount = _socketConnectCount;
@synthesize remainLengthToRead = _remainLengthToRead;
@synthesize needBuffer  = _needBuffer;
@synthesize currentBuffer = _currentBuffer;
@synthesize gcdSocketSendDataArray = _gcdSocketSendDataArray;
@synthesize heartTimer;
@synthesize ipType;
@synthesize alertEvent;
@synthesize heartTokenCount = _heartTokenCount;
@synthesize flagNeedSendHeartData;


- (void)dealloc{
    
    [self.heartTimer invalidate];
    self.heartTimer = nil;
    self.alertEvent = nil;
    self.gcdAsyncsocket = nil;
    self.gcdSocketSendDataArray = nil;
    self.delegate = nil;
    self.ipStr = nil;
    self.dealObject = nil;
    self.cmdType = nil;
    self.needBuffer = nil;
    self.currentBuffer = nil;
    
    [super dealloc];
}

+ (id)myGcdSocketEngine:(id<GCDAsyncSocketEngineDelegate>) delegate socketDelegateQueueName:(const char *)name{
    MYGCDAsyncSocketEngine * engine = [[[MYGCDAsyncSocketEngine alloc] initWithDelegate:delegate socketDelegateQueueName:name ] autorelease];
    return engine;
}

-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)initWithDelegate:(id<GCDAsyncSocketEngineDelegate>)delegate socketDelegateQueueName:(const char *)name{
    
    self = [super init];
    if (self) {
        
        self.delegate = delegate;
        GCDAsyncSocket * socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create(name, NULL)];
        self.gcdAsyncsocket = socket;
        [socket release];
        
        [self prepareData];

    }
    return self;
}

- (void)prepareData{
    
    self.cmdType = [MYDataManager shareManager].cmdType;
    
    dealWithData * data = [[dealWithData alloc] init];
    self.dealObject = data;
    [data release];
    
    self.currentBuffer = [NSMutableData dataWithCapacity:100];
    _flagFirstPackage = YES;
    self.gcdSocketSendDataArray = [NSMutableArray arrayWithCapacity:10];
    
}

- (void)startHeartSendData{
    
    self.flagNeedSendHeartData = YES;
    
}

- (void)stopHeartTimer{
    
    self.heartTokenCount  = 0;
    self.flagNeedSendHeartData = NO;
}

- (void)socketClose{
    
    if ([self.gcdAsyncsocket isConnected]) {
        [self.gcdAsyncsocket disconnect];
    }
}

- (void)openSocketWithTimeOut:(NSTimeInterval)timeOut ip:(NSString *)ipStr port:(NSInteger)port {
    
    [self socketClose];
    
    self.ipStr = ipStr;
    self.port = port;
    
    if (![self.gcdAsyncsocket isConnected]) {
        
        NSError * err = nil;
        if ([self.gcdAsyncsocket connectToHost:self.ipStr onPort:self.port withTimeout:timeOut error:&err]) {
            
            DebugLog(@" connectToHost IP:%@ PORT: %d",self.ipStr,self.port);
        }
    }
}

- (void)connectSocket{
    
    NSError * err = nil;
    [self.gcdAsyncsocket connectToHost:self.ipStr onPort:self.port withTimeout:KSOCKET_CONNECT_TIMEOUT error:&err];

}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    DebugLog(@"socketDidDisconnect err %@ ",err);
    if (err) {
        
        [self stopHeartTimer];

        if (self.ipType == 1) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(socketDisconnect:err:)]) {
                [self.delegate socketDisconnect:self err:err];
            }
        }
        
        
        [[self appDelegate].window removeActivityView];
        
        if (self.ipType == 2) {
            
            if (self.step == 0 && self.socketConnectCount < 3) {
                
                if ( [err code] == GCDAsyncSocketConnectTimeoutError || [err code] == GCDAsyncSocketOtherError) {
                    
                    DebugLog(@"socketDidDisconnect err %d ",[err code]);
                    self.ipStr = HostIp_Ip;
                }
                
                self.socketConnectCount  = self.socketConnectCount +1;
                [self connectSocket];
                return;
                
            }

            
            if (self.step == 1 && self.socketConnectCount < 3) {
                
                self.socketConnectCount  = self.socketConnectCount +1;
                [self connectSocket];
                return;
            }
            
            if ([AppDelegate getAppDelegate].flagBackgroundToFront != 1) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationMYNetAsynsocketError object:nil];
                    
                });
            }



        }
    }
    
    
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    
    [[self appDelegate].window removeActivityView];
    DebugLog(@"shouldTimeoutWriteWithTag %f",elapsed);
    return 0;
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    
    [[self appDelegate].window removeActivityView];
    DebugLog(@"shouldTimeoutReadWithTag %f",elapsed);
    return 0;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    DebugLog(@"GCDAsyncSocket didConnectToHost");
    
    [self checkBeforeCommunicate];
    
    [sock readDataWithTimeout:-1 tag:0];
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
//    DebugLog(@"didWriteDataWithTag");
    [sock readDataWithTimeout:-1 tag:0];
    @synchronized(self.gcdSocketSendDataArray){
        
        [self.gcdSocketSendDataArray removeAllObjects];
        
    }

}
/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
//    DebugLog(@"Recive DATA LENGTH %d |||||  %@",[data length],data);
    
    NSMutableData * reData = [NSMutableData dataWithData:data];
    [self.currentBuffer appendData:reData];
    
    //处理header and response data
    while ([self.currentBuffer length] > 4) {
        
        BOOL flag = NO;
        NSData * lengthData = [self.currentBuffer subdataWithRange:NSMakeRange(0, 4)];
        NSInteger length = [dealWithCommend headerDataToLength:lengthData];
        if (length == 1002 && self.step == 0) {
            //第一次验证
            NSData * value = [self.currentBuffer subdataWithRange:NSMakeRange(4, 4)];
            NSInteger valueInt = [dealWithCommend headerDataToLength:value];
            if (valueInt == 0) {
                
                DebugLog(@"第一次验证");
                [self.currentBuffer replaceBytesInRange:NSMakeRange(0, 8) withBytes:NULL length:0];
                
                if (self.ipType == 1) {
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(checkTokenSuccess)]) {
                        [self.delegate checkTokenSuccess];
                    }
                }
                else{
                    
                    NSString *initCmd= [BuildSocketData buildAgentAddressData];
                    [self writeDataOnMainThread:initCmd tag:0 waitView:NO];
                }

                continue;
            }
            
            flag = YES;
        }
        if (length == 1002 && self.step == 1) {
            //第二次验证
            DebugLog(@"第二次验证");
            NSData * value = [self.currentBuffer subdataWithRange:NSMakeRange(4, 4)];
            NSInteger valueInt = [dealWithCommend headerDataToLength:value];
            if (valueInt == 0) {
                self.step = 2;
                self.socketConnectCount = 0;
                [self.dealObject responseToTokenSuccess];
                [self.currentBuffer replaceBytesInRange:NSMakeRange(0, 8) withBytes:NULL length:0];
                continue;
            }
            
            flag = YES;
        }
        
        if ([self.currentBuffer length] -4 >= length) {
            
            flag = YES;
            
            //必然有一个完整的包
            NSData * subData = [[self.currentBuffer subdataWithRange:NSMakeRange(4, length)] copy];
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self dealFromAppserver:subData tag:tag];
            });
            
            [subData release];
            [self.currentBuffer replaceBytesInRange:NSMakeRange(0, length + 4) withBytes:NULL length:0];
        }
    
        if (!flag) {
            break;
        }
        
    }
    
    [sock readDataWithTimeout:-1 tag:0];
    
    [[self appDelegate].window removeActivityViewInMainThread];
}


#pragma mark connect&send
-(void)checkBeforeCommunicate
{
    int nType = 1002;
    int nLen = 0;
    long netnType = htonl(nType);
    
    NSMutableData *cmdData=[[NSMutableData alloc] init];
    [cmdData appendBytes:&netnType length:4];
    [cmdData appendBytes:&nLen length:4];
    [self.gcdAsyncsocket writeData:cmdData withTimeout:-1 tag:0];
//    [self.gcdAsyncsocket readDataToLength:8 withTimeout:-1 tag:SOCKET_TAG_INIT];
    [self.gcdAsyncsocket readDataWithTimeout:KSOCKET_READ_TIMEOUT tag:0];
    [self.gcdSocketSendDataArray addObject:cmdData];
    [cmdData release];
    
}

- (void)sendHeartData{
    
    if (!self.flagNeedSendHeartData) {
        
//        return;
    }
    
    DebugLog(@"心跳 sendHeartData");
    
    if (self.heartTokenCount < 4 ) {
        
        if (![AppDelegate getAppDelegate].apModelOrCloudModel) {
            
            self.heartTokenCount = self.heartTokenCount + 1;
        }
        
        int len = 1;
        char heart = 0;
        long llen = htonl(len);
        NSMutableData *cmdData=[[NSMutableData alloc] init];
        [cmdData appendBytes:&llen length:4];
        [cmdData appendBytes:&heart length:1];
        [self.gcdAsyncsocket writeData:cmdData withTimeout:10 tag:0];
        [self.gcdAsyncsocket readDataWithTimeout:-1 tag:0];
        
        @synchronized(self.gcdSocketSendDataArray){
            [self.gcdSocketSendDataArray addObject:cmdData];
        }
        
        [cmdData release];
    }
    else
    {
        
        if ([self.gcdAsyncsocket isConnected]) {
            
            [self.gcdAsyncsocket disconnect];
            [self stopHeartTimer];
        }
        else
        {
            DebugLog(@"heartTokenCount %d",self.heartTokenCount);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationMYNetAsynsocketError object:nil];
                
            });
            
            [self stopHeartTimer];  
        }

    }
    
}

//发送数据
-(void)writeDataOnMainThread:(NSString *)string tag:(long)tag waitView:(BOOL)flagWatiView
{
    if ([self isConnect]) {
        
        if (flagWatiView) {
            
            [[self appDelegate].window showWaitAlertView];
        }
        
        
        DebugLog(@"%@",string);
        int zNum=0;
        int totalLength=[string length]+5;
        int msgLength=[string length]+1;
        long netTotalLength = htonl(totalLength);
        long netMsgLength = htonl(msgLength);
        NSData *cmd = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableData *cmdData=[[NSMutableData alloc] init];
        [cmdData appendBytes:&netTotalLength length:4];
        [cmdData appendBytes:&netMsgLength length:4];
        [cmdData appendData:cmd];
        [cmdData appendBytes:&zNum length:1];
        [self.gcdAsyncsocket writeData:cmdData withTimeout:KSOCKET_TIMEOUT tag:tag];
        [self.gcdAsyncsocket readDataWithTimeout:-1 tag:tag];
        [self.gcdSocketSendDataArray addObject:cmdData];
        [cmdData release];
        
    }
    else{
        
        
    }
        
}

- (BOOL)isConnect{
    return [self.gcdAsyncsocket isConnected];
}
- (void)readHeaderForLength{
    
//    [self.gcdAsyncsocket readDataToLength:4 withTimeout:-1 tag:SOCKET_TAG_HEADER];
}

-(void)dealFromAppserver:(NSData *)dataDeal tag:(long)tag
{
//    NSString *msg = [[NSString alloc] initWithData:dataDeal encoding:NSUTF8StringEncoding];
    if ([dataDeal length] == 1) {
        NSInteger heartInt = [dealWithCommend DataToInt:dataDeal];
        if (heartInt == 0) {
            //心跳
            self.heartTokenCount = 0;
            DebugLog(@"心跳 self.heartTokenCount %d",self.heartTokenCount);
            return;
        }
    }
    
    NSString * msg = [[NSString alloc] initWithData:[dataDeal subdataWithRange:NSMakeRange(4, [dataDeal length]- 5)] encoding:NSASCIIStringEncoding];
    DebugLog(@"msg:%@",msg);

    if(msg.length!=0)
    {
        //处理受到的数据
        NSMutableDictionary *dataDealed = [self.dealObject analyzeData:msg];
        //DebugLog(@"datadealed:%@",dataDealed);
        [[self appDelegate].window hideWaitAlertView];
        
        switch ([[self.cmdType objectForKey:[dataDealed objectForKey:@"cmd"]] integerValue]) {
            case 1:
            {
                if ([[dataDealed objectForKey:@"ret"] intValue] == 0) {
                    
                    [self socketClose];
                    self.socketConnectCount = 0;
                    self.gcdAsyncsocket = nil;
                    self.ipStr = [dataDealed objectForKey:@"serverip"];
                    self.port = [[dataDealed objectForKey:@"serverport"] intValue];
                    self.step = 1;
                    
                    GCDAsyncSocket * socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("appServer", NULL)];
                    self.gcdAsyncsocket = socket;
                    [socket release];
                    [self openSocketWithTimeOut:KSOCKET_TIMEOUT ip:self.ipStr port:self.port];
                    
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationGetAgentError  object:nil userInfo:dataDealed];
                }
            }

                break;
            case 2:
                [self.dealObject responseToRegist:dataDealed];
                break;
            case 3:
                [self.dealObject responseToLogin:dataDealed];
                break;
            case 5:
            {
                [self.dealObject responseToDownloadCamera:dataDealed];
            }
                break;
            case 6:
            {
                [self.dealObject responseToCameraStatus:dataDealed];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationCameraState  object:nil userInfo:dataDealed];
            }
                break;
            case 7:
                [self.dealObject responseToAddCamera:dataDealed];
                break;
            case 8://MODIFY_CAMERA_RESP
                [self.dealObject responseToModifyCamera:dataDealed];
                break;
            case 9:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteCameraSuccess object:nil];

            }
                break;
            case 10:
                [self.dealObject responseToModifyPwd:dataDealed];
                break;
            case 11://GET_PWD_RESP
                [self.dealObject responseToGetPwd:dataDealed];
                break;
            case 12://get mcu 
            {
//                [self.dealObject responseToGetMcu:dataDealed];
                [[MYDataManager shareManager] initMyUdpSocket:dataDealed];

            }
                break;
            case 13://WATCH_CAMERA_RESP
            {
                [self.dealObject responseToWatchCamera:dataDealed];
            }
                break;
            case 20:
            {
                //开启音频
            }
                break;
            case 21:{
                
                //KICK_OFF 账户在其他地方登陆
                [MYDataManager shareManager].flagKickOff = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationKICK_OFF object:nil];
                
            }
                break;
            case 15:
            {
                [self.dealObject responseToGetNetworkInfo:dataDealed];
            }
                break;
            case 16:
            {
                [self.dealObject responseToSetEthernetInfo:dataDealed];
            }
                break;
            case 17:
            case 18:
            {
                [self.dealObject responseToGetWifiInfo:dataDealed];
            }
                break;
            case 19://DEVICE_INFO
                [self.dealObject responseToGetDeviceInfo:dataDealed];
                break;
            case 22:
                [self.dealObject responseToGetRecordConfig:dataDealed];
                break;
            case 23:
                [self.dealObject responseToSetRecordConfig:dataDealed];
                break;
            case 24:
                [self.dealObject responseToGetAlertConfig:dataDealed];
                break;
            case 25:
                [self.dealObject responseToSetAlertConfig:dataDealed];
                break;
            case 26://SET_WIFI_INFO_RESP
            {
                [self.dealObject rspSetWifiInfo:dataDealed];
            }
                break;
            case 27:
            {
                [self.dealObject responseToSetCameraDeviceInfo:dataDealed];
            }
                break;
            case 28:
            {
                [self.dealObject responseToGetAlertPictureInfo:dataDealed];
            }
                break;
            case 29:
            {
                [self.dealObject responseToGetRecordFileList:dataDealed];
            }
                break;
            case 30://DOWNLOAD_PICTURE_RESP
            {
                [self.dealObject responseToGetEventAlertPictureInfo:dataDealed];
                
            }
                break;
            case 31://DOWNLOAD_VIDEO_RESP
            {
                [self.dealObject responseToGetAlertandRecord:dataDealed];
            }
                break;
            case 32://ALARM_EVENT
            {

                DebugLog(@"dataDealed %@",dataDealed);
                AlertEventData * data = [[AlertEventData alloc] initWithDictInfo:dataDealed];
                self.alertEvent = data;
                [[MYDataManager shareManager] addAlertEventToAlertListData:self.alertEvent];
                [data release];

                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCameraInfoAlertEvent object:nil userInfo:dataDealed];
                    
                
            }
                break;
            case 33:
            {
                if ([[dataDealed objectForKey:@"ret"] intValue]== 0) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeletePictureSuccess object:nil userInfo:dataDealed];
                }
            }
                break;
                
            case 34:
            {
                if ([[dataDealed objectForKey:@"ret"] intValue]== 0) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeleteVideoSuccess  object:nil userInfo:dataDealed];
                }
            }
                break;
            case 35://GET_LIVE_VIDEO_SIZE_QUALITY_RSP
            {
                
                if ([[dataDealed objectForKey:@"ret"] intValue]== 0) {
                    
                    if (self.dealObject.cloudModelVideoQualityDelegate) {
                        
                        [self.dealObject.cloudModelVideoQualityDelegate getLiveVideoSizeCloudModel:dataDealed];
                    }
                    else
                    {
                        [self.dealObject.apsystemsetdelegate getLiveVideoSize:dataDealed];
                    }
                }
            }
                
                break;
            case 36://GET_RECORD_VIDEO_SIZE_QUALITY_RSP
            {
 
                if ([[dataDealed objectForKey:@"ret"] intValue]== 0) {
                    
                    if (self.dealObject.cloudModelVideoQualityDelegate) {
                        
                        [self.dealObject.cloudModelVideoQualityDelegate getRecordVideoSizeCloudModel:dataDealed];
                    }
                    else
                    {
                        [self.dealObject.apsystemsetdelegate getRecordVideoSize:dataDealed];
                    }
                }
            }
                break;
                
            case 37://USER_PROVEN_RESP
            {
                
                if (self.dealObject.checkCameraPwdAlertViewDelegate) { 
                    
                    [self.dealObject.checkCameraPwdAlertViewDelegate checkCameraPasswordRespond:dataDealed];
                }
                else
                {
                    [self.dealObject.checkCameraPwdDelegate  checkCameraPasswordRespond:dataDealed];
                }

            }
                break;
                
            case 38://CALL_MASTER
            {
                if (self.dealObject.carmeraListDelegate) {
                    
                    [self.dealObject.carmeraListDelegate calling:dataDealed];
                }
                
            }
                
                break;
                
            case 39:
            {
                
                if (self.dealObject.cameraViewDelegate) {
                    
                    [self.dealObject.cameraViewDelegate callHangUp:dataDealed];
                }
                
            }
                
            case 40:
            {
                
                if (self.dealObject.cameraSettingDelegate) {
                    
                    [self.dealObject.cameraSettingDelegate  getCameraVersion:dataDealed];
                }
                
            }
                
            case 41://GET_CAMERA_SNAP_RESP
            {
                [[MYDataManager shareManager] downloadCameraGridImage:dataDealed];
            }
                
                break;
                
            case 42://MANUAL_RECORD_RESP
            {
                
                if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
                    
                    [self.dealObject.cameraViewDelegate manualRecordResp:dataDealed];
                }
                else
                {
                    [self.dealObject.cameraViewDelegate manualRecordResp:dataDealed];
                }
            }
                
                break;
                
            case 43://MANUAL_SNAP_RESP
            {
                
//                if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
                
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationAPmodeManualTakePhoto object:dataDealed];
//                }
            }
                
                break;
                
            case 44://UPDATE_CAMERA_RESP
            {
                [self.dealObject.cameraSettingDelegate updateCameraVersion:dataDealed];
            }
                
                break;
                
            case 45://WATCH_CAMERA_TCP_RESP
            {
               [self.dealObject responseToWatchCamera:dataDealed];
            }
                
                break;
                
            case 46://SET_VIDEO_ROTATE_RESP
            {
                [self.dealObject.cameraSettingDelegate setRotateCameraRespon:dataDealed];
            }
                break;
                
            case 47://DEVICE_STATUS
            {
                if (self.dealObject.cameraViewDelegate) {
                    
                    [self.dealObject.cameraViewDelegate deviceStatus:dataDealed];
                }
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        
        DebugLog(@"Error converting received data into UTF-8 String");
        
    }
    
    [msg release];
    
}




- (void)sendGetWifiInfoRequest:(NSInteger)cameraid{
    
    NSString * cmd = [BuildSocketData buildGetWifiInfoString:[MYDataManager shareManager].userInfoData.userId cameraid:cameraid];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendSetWifiInfoRequest:(NSString *)wifiOpen ssid:(NSString *)ssid safety:(NSString *)safety password:(NSString *)password cameraid:(NSInteger)cameraid {
    
    NSString * cmd = [BuildSocketData buildSetWifiInfoString:wifiOpen ssid:ssid safety:safety password:password userid:[MYDataManager shareManager].userInfoData.userId cameraid:cameraid];
    
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendGetNetInfoRequest:(NSInteger)cameraid{
    
    NSString * cmd = [BuildSocketData buildGetNetSettingInfoString:[MYDataManager shareManager].userInfoData.userId cameraid:cameraid];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendGetRecordInfoRequest:(CameraInfoData *)cameradata{
    
    NSString * cmd = [BuildSocketData buildGetRecordConfig:cameradata.cameraId password:cameradata.password userId:[MYDataManager shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendGetAlertInfoRequest:(CameraInfoData *)cameradata{
    
    NSString * cmd = [BuildSocketData buildGetAlertConfig:cameradata.cameraId userid:[MYDataManager shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendSetRecordSettingRequest:(NSInteger)policy cameraid:(NSInteger)cameraid password:(NSString *)password repeat:(NSInteger)repeat beginAndEndTimes:(NSArray *)times recordSwitch:(NSInteger)recordSwitch{
    
    NSString * cmd = [BuildSocketData buildRecordConfig:policy cameraid:cameraid password:password repeat:repeat beginAndEndTimes:times recordSwitch:recordSwitch userId:[MYDataManager shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendSetAlertInfoRequest:(AlertSettingData *)alertSetData cameradata:(CameraInfoData *)cameraData{
    
    NSString * cmd = [BuildSocketData buildAlertConfig:alertSetData.alertType cameraid:cameraData.cameraId password:cameraData.password repeat:[alertSetData.repeatWeekData repeatInt] beginAndEndTimes:alertSetData.timePeriodArray voicealarm:alertSetData.isNoiseAlert movealarm:alertSetData.isMotionAlert record:alertSetData.isAlertRecord alertSwitch:alertSetData.alertSwitch userid:[MYDataManager shareManager].userInfoData.userId];
    
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendSetEthernetRequest:(NSString *)dhcp ip:(NSString *)ipAddress mask:(NSString *)maskAddress gateWay:(NSString *)gateWay dns1:(NSString *)dns1 dns2:(NSString *)dns2 cameraid:(NSInteger)cameraid
{
    NSString * cmd = [BuildSocketData buildSettingEthernetString:dhcp ip:ipAddress mask:maskAddress gateWay:gateWay dns1:dns1 dns2:dns2 userid:[MYDataManager shareManager].userInfoData.userId cameraid:cameraid];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendGetDeviceInfoString{
    
    NSString * cmd = [BuildSocketData buildGetDeviceInfoString];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendSetDeviceInfoRequest:(NSString *)password timeZone:(NSString *)timeZone{
    
    NSString * cmd = [BuildSocketData buildSetDeviceInfoString:password timeZone:timeZone];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
    
}

- (void)sendSetCameraTimezone{
    
    NSString * cmd = [BuildSocketData buildSetCameraTimeZone];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendGetAlertListRequest:(NSInteger)userid cameraid:(NSInteger)cameraId pos:(NSInteger)pos waitView:(BOOL)flagWatiView{
    
    NSString * cmd = [BuildSocketData buildGetAlertListString:userid cameraid:cameraId pos:pos];
    [self writeDataOnMainThread:cmd tag:0 waitView:flagWatiView];

}

- (void)sendGetRecordList:(NSInteger)cameraId pos:(NSInteger)pos waitView:(BOOL)flagWatiView{
    
    NSString * cmd = [BuildSocketData buildGetRecordListString:[MYDataManager shareManager].userInfoData.userId cameraid:cameraId pos:pos];
    [self writeDataOnMainThread:cmd tag:0 waitView:flagWatiView];
}

- (void)sendGetImageDownloadUrl:(NSInteger)cameraId fileName:(NSString *)fileName{
    
    NSString * cmd = [BuildSocketData buildGetImageDownLoadUrlString:[MYDataManager shareManager].userInfoData.userId cameraid:cameraId filename:fileName];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
    
}

- (void)sendGetVideoDownloadUrl:(NSInteger)cameraId fileName:(NSString *)fileName{
    
    NSString * cmd = [BuildSocketData buildGetVideoDownLoadUrlString:[MYDataManager shareManager].userInfoData.userId cameraid:cameraId filename:fileName];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendDeleteCameraRequestWithCameraId:(NSInteger)cameraid {
    
    NSString * cmd = [BuildSocketData buildDeleteCameraString:cameraid userid:[MYDataManager shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}


- (void)sendModifyCameraVideoSize:(CameraInfoData *)cameraInfo videoSize:(NSInteger)videoSize mcuIp:(NSString *)mcuip port:(NSInteger)port channelId:(NSInteger)channelId{
    
    NSString * cmd = [BuildSocketData buildModifyVideoSizeData:[MYDataManager shareManager].userInfoData.userId cameraId:cameraInfo.cameraId password:cameraInfo.password mcuIp:mcuip mcuPort:port channelId:channelId videoSize:videoSize];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendDeletePictureFromCamera:(CameraInfoData *)cameraInfo fileName:(NSString *)fileName{
    
    NSString * cmd = [BuildSocketData buildDeletePictureFromCamera:cameraInfo filename:fileName userid:[MYDataManager shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendDeleteVideoFromCamera:(CameraInfoData *)cameraInfo fileName:(NSString *)fileName{
    
    NSString * cmd = [BuildSocketData buildDeleteVideoFromCamera:cameraInfo filename:fileName userid:[MYDataManager shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendCameraSpeakerSwitch:(CameraInfoData *)cameraInfo flagSwitch:(NSInteger)flagSwitch mcuIp:(NSString *)mcuip port:(NSInteger)port{
    
    NSString * cmd = [BuildSocketData buildCameraSwitchSpeaker:cameraInfo mcuip:mcuip mcuPort:port userid:[MYDataManager shareManager].userInfoData.userId flagswitch:flagSwitch];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendInfoModifyCamera:(CameraInfoData *)cameraInfo cameraName:(NSString *)cameraName cameraMemo:(NSString *)cameraMemo password:(NSString *)passwordStr{
    
    NSString * cmd = [BuildSocketData buildModifyCamera:cameraInfo cameraName:cameraName cameraMemo:cameraMemo userid:[MYDataManager shareManager].userInfoData.userId password:passwordStr];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendModifyAccountPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword {
    
    NSString * cmd  = [BuildSocketData buildModifyAccountPassword:newPassword oldpassword:oldPassword userid:[MYDataManager shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

//videosize= //0:QQVGA 160*120 1：QCIF 176*144  2: QVG:320*240 3:CIF352*288 4:VGA640*480 5:720*480 6:720P 6:1080P
- (void)sendApModifyCameraVideoSize:(NSInteger)videoSize waitView:(BOOL)flag userid:(NSInteger)userid cameraid:(NSInteger)cameraid{

    NSString * cmd = [BuildSocketData buildApModifyVideoSizeWithSize:videoSize userid:userid cameraid:cameraid];
    [self writeDataOnMainThread:cmd tag:0 waitView:flag];
}

- (void)sendModifyRecordQualityWithSize:(NSInteger)videoSize userid:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString * cmd = [BuildSocketData buildModifyRecordQualityWithSize:videoSize userid:userid cameraid:cameraid];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
    
}

- (void)sendGetLiveVideoSize:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString * cmd = [BuildSocketData buildGetLiveVideoSize:userid cameraid:cameraid];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendGetRecordVideoSize:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString * cmd = [BuildSocketData buildGetRecordVideoSize:userid cameraid:cameraid];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendGetMcuRequest{
    
    NSString * cmd = [BuildSocketData buildGetMcu:[MYDataManager shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0  waitView:YES];
}

- (void)sendGetCameraListRequest{
    
    NSString *cmd = [BuildSocketData buildDownloadCamera:[MYDataManager  shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0  waitView:NO];
}


- (void)sendCheckCameraPasswordRequest:(CameraInfoData *)cameraInfo{
    
    NSString * cmd = [BuildSocketData buildUserProven:cameraInfo.password userid:[MYDataManager  shareManager].userInfoData.userId cameraid:cameraInfo.cameraId];
    [self writeDataOnMainThread:cmd tag:0  waitView:YES];
}


- (void)sendCheckCameraPasswordRequestWithPassword:(CameraInfoData *)cameraInfo password:(NSString *)password{
    
    NSString * cmd = [BuildSocketData buildUserProven:password userid:[MYDataManager  shareManager].userInfoData.userId cameraid:cameraInfo.cameraId];
    [self writeDataOnMainThread:cmd tag:SOCKET_TAG_CHECK_CAMERA_PWD_ALERTVIEW  waitView:YES];
}


- (void)sendCallingRsp:(NSInteger)userid cameraid:(NSInteger)cameraid ret:(NSInteger)ret{
    
    NSString * cmd = [BuildSocketData buildCallingRespone:userid cameraid:cameraid ret:ret];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendGetCameraVersionRequest:(NSInteger)cameraid{
    
    NSString * cmd = [BuildSocketData buildGetCameraVersion:[MYDataManager shareManager].userInfoData.userId cameraid:cameraid];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
    
}

- (void)sendUpdateCameraVersionRequest:(NSString *)downloadurl cameraid:(NSInteger)cameraid{
    
    NSString * cmd = [BuildSocketData buildUpdateCameraVersion:downloadurl cameraid:cameraid userid:[MYDataManager shareManager].userInfoData.userId];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
    
}


- (void)sendDownLoadCameraGridImageRequest:(NSInteger )userid cameraid:(NSInteger)cameraid password:(NSString *)password{
    
    NSString * cmd = [BuildSocketData buildDownCameraGridImage:userid cameraid:cameraid password:password];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
    
}

- (void)sendTakePhoto:(NSInteger )userid cameraid:(NSInteger)cameraid{
    
    NSString * cmd = [BuildSocketData buildTakePhotoStr:userid cameraid:cameraid];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendManualRecordWithSwith:(NSInteger )userid cameraid:(NSInteger)cameraid swithFlag:(NSInteger)swithFlag{
    
    NSString * cmd = [BuildSocketData buildStartTakeVideoStrWithFlag:userid cameraid:cameraid swithFlag:swithFlag];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendOpenShareSwitch:(NSInteger )userid cameraid:(NSInteger)cameraid swithFlag:(NSInteger)swithFlag password:(NSString *)password{
    
    NSString * cmd = [BuildSocketData buildOpenShareCameraStr:cameraid userid:userid swithFlag:swithFlag passwrod:password];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendRestartCameraRequest:(NSInteger)userid cameraid:(NSInteger)cameraid{
    
    NSString * cmd = [BuildSocketData buildRestartCameraStr:cameraid userid:userid];
    [self writeDataOnMainThread:cmd tag:0 waitView:NO];
}

- (void)sendRotateCameraRequest:(NSInteger)userid cameraid:(NSInteger)cameraid vflip:(NSInteger)vflip{
    
    NSString * cmd = [BuildSocketData buildRotateCameraStr:cameraid userid:userid vflip:vflip];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendPTZCameraRequest:(NSInteger)userid cameraid:(NSInteger)cameraid direction:(NSInteger)direction step:(NSInteger)step{
    
    NSString * cmd = [BuildSocketData buildPTZCameraStr:cameraid userid:userid direction:direction step:step];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendGetPwdRequest:(NSString *)account{
    
    NSString * cmd = [BuildSocketData buildGetPwdStr:account];
    [self writeDataOnMainThread:cmd tag:0 waitView:YES];
}


@end
