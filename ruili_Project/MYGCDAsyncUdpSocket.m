//
//  MYGCDAsyncUdpSocket.m
//  Myanycam
//
//  Created by myanycam on 13/8/13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYGCDAsyncUdpSocket.h"
#import "AppDelegate.h"

@implementation MYGCDAsyncUdpSocket

@synthesize udpSocket = _udpSocket;
@synthesize mcuIpInfo = _mcuIpInfo;
@synthesize udpSendDataArray = _udpSendDataArray;
@synthesize udpReciveDataArray = _udpReciveDataArray;
@synthesize channelId = _channelId;
@synthesize localIpAndPort;
@synthesize portArray;
@synthesize natip = _natip;
@synthesize localIp = _localIp;
@synthesize natPort = _natPort;
@synthesize localPort = _localPort;

@synthesize cameraNatip = _cameraNatip;
@synthesize cameraLocalIp = _cameraLocalIp;
@synthesize cameraLocalPort = _cameraLocalPort;
@synthesize cameraNatPort = _cameraNatPort;

@synthesize videoDataDictionary = _videoDataDictionary;
@synthesize udpAddress = _udpAddress;
@synthesize mcuIp = _mcuIp;
@synthesize mcuPort = _mcuPort;

@synthesize dataChannel = _dataChannel;
@synthesize isP2pSuccess = _isP2pSuccess;
@synthesize cameraVideoDataDelegate = _cameraVideoDataDelegate;
@synthesize cameraInfo = _cameraInfo;
@synthesize audioMutableData = _audioMutableData;
@synthesize flagStartPlayVideo = _flagStartPlayVideo;

@synthesize upnp_ip = _upnp_ip;
@synthesize upnp_port = _upnp_port;

@synthesize allFrameCountInTenSeconds = _allFrameCountInTenSeconds;
@synthesize decodeFrameCountInTenSeconds = _decodeFrameCountInTenSeconds;
@synthesize checkTimeCount = _checkTimeCount;
@synthesize allTcpDataBuffer = _allTcpDataBuffer;
@synthesize tcpDataSocket;




- (void)dealloc{
    
    if (_udpDispatch_queue) {
        dispatch_release(_udpDispatch_queue);
        _udpDispatch_queue = NULL;
    }
    
    if (_tokenDispatch_queue) {
        dispatch_release(_tokenDispatch_queue);
        _tokenDispatch_queue = NULL;
    }
    
    if (_udpDataParse_queue) {
        dispatch_release(_udpDataParse_queue);
        _udpDataParse_queue = NULL;
    }
    
    if (_tcpDataParse_queue) {
        dispatch_release(_tcpDataParse_queue);
        _tcpDataParse_queue = NULL;
    }
    
    
    self.cameraVideoDataDelegate = nil;
    self.videoDataDictionary = nil;
    self.audioMutableData = nil;
    
    
    self.allTcpDataBuffer = nil;
    self.tcpDataSocket.delegate = nil;
    [self.tcpDataSocket disconnect];
    self.tcpDataSocket = nil;

    
    [self.udpSocket close];
    self.udpSocket.delegate = nil;
    self.udpSocket = nil;
    self.udpReciveDataArray = nil;
    self.mcuIpInfo = nil;
    
    self.channelId = nil;
    self.localIpAndPort = nil;
    self.portArray = nil;
    self.udpAddress = nil;
    
    self.natip =  nil;
    self.localIp = nil;
    
    self.cameraLocalIp = nil;
    self.cameraNatip = nil;
    
    self.mcuIp = nil;
    self.cameraInfo = nil;
    
    DNSServiceRefDeallocate(_sdRef);
    self.upnp_ip = nil;
    
    [super dealloc];
}



/** CFSocket callback, informing us that _socket has data available, which means
 that the DNS service has an incoming result to be processed. This will end up invoking
 the portMapCallback. */
static void serviceCallback(CFSocketRef s,
                            CFSocketCallBackType type,
                            CFDataRef address, const void *data, void *clientCallBackInfo)
{
    MYGCDAsyncUdpSocket *mapper = (MYGCDAsyncUdpSocket*)clientCallBackInfo;
    DNSServiceRef service = mapper->_sdRef;
    DNSServiceErrorType err = DNSServiceProcessResult(service);
    if( err ) {
        // An error here means the socket has failed and should be closed.
    }
}

void DNSServiceNATPortMappingCreate_callback(
                                             DNSServiceRef sdRef,
                                             DNSServiceFlags flags,
                                             uint32_t interfaceIndex,
                                             DNSServiceErrorType errorCode,
                                             uint32_t externalAddress,
                                             DNSServiceProtocol protocol,
                                             uint16_t internalPort,
                                             uint16_t externalPort,
                                             uint32_t ttl,
                                             void *context )
{
    
    DebugLog(@"internalPort %d",ntohs(internalPort));
    DebugLog(@"externalPort %d",ntohs(externalPort));
    
    uint32_t newIP = ntohl(externalAddress);
    NSString *newIPStr = [NSString stringWithFormat:@"%u.%u.%u.%u",
                          ((newIP >> 24) & 0xFF),
                          ((newIP >> 16) & 0xFF),
                          ((newIP >> 8) & 0xFF),
                          ((newIP >> 0) & 0xFF)];
    
    DebugLog(@"newIPStr %@",newIPStr);

    [MYDataManager shareManager].myUdpSocket.upnp_ip = newIPStr;
    [MYDataManager shareManager].myUdpSocket.upnp_port = ntohs(externalPort);
}


- (void)startParseUdpData{
    
    _udpDataParse_queue = dispatch_queue_create("udpParse", NULL);
    
    dispatch_async(_udpDataParse_queue, ^{
        
        while (_flagStartParseUdpData) {
                
                if ([self.udpReciveDataArray count] > 0) {
                
                    @synchronized(self.udpReciveDataArray)
                    {
                        NSData * data = [self.udpReciveDataArray objectAtIndex:0];

                        @synchronized(data)
                        {
                            if (data&&[data length] > 0) {

                            [self parseUdpData:data];
                            [self.udpReciveDataArray removeObject:data];

                            }
                        }
                    }
                }
                else
                {
                    usleep(6*1000);
                }
            }
        
    });
}

- (void)parseUdpData:(NSData *)data{
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    //  消息头 4字节 | 消息ID 4字节 | 总包数 2字节 | 当前包号 2字节| 数据1024字节
    NSMutableData * reData = [[NSMutableData alloc ] initWithData:data];
    char * msg = [reData mutableBytes];
//    if ((msg[0] == '@') && (msg[1] == '%') && (msg[2] == '^') && (msg[3] == '!'))
    {
        
        struct UdpMediaHeader udpHeader;
        
        memcpy(&udpHeader, msg, sizeof(udpHeader));
        unsigned long ulMsgId  = ntohl(udpHeader.msgId);
        unsigned short usPackCount = ntohs(udpHeader.totalPacket);//总共包个数
        unsigned short usNowPackNo = ntohs(udpHeader.currentPacketNo);
        int msgLen = [reData length] - 12;
        
        NSNumber * msgIdKey = [NSNumber numberWithUnsignedLong:ulMsgId];
//        DebugLog(@"msgIdKey %@ usPackCount %d usNowPackNo %d",msgIdKey,usPackCount,usNowPackNo);
        UdpVideoData * currentData = [self.videoDataDictionary objectForKey:msgIdKey];
        if (!currentData) {
            currentData = [[UdpVideoData alloc] initWithLength:1024 * usPackCount mgsId:ulMsgId];
            [self.videoDataDictionary setObject:currentData forKey:msgIdKey];
            currentData.allPacketCount = usPackCount;
            [currentData release];
            
            _allFrameCountInTenSeconds ++;//统计个数
        }
        
        if (usPackCount > usNowPackNo) {
            if (msgLen > 0) {
                
                memcpy((currentData.buffer + (usNowPackNo * 1024)), msg + 12, msgLen);
                [currentData changeActuallyLength:msgLen];
                [currentData addhavePacketCount];
            }

        }
        
        if (usPackCount == currentData.havePacketCount) {
            //一帧数据完整了
            NSMutableData * videoData = [NSMutableData dataWithBytes:currentData.buffer length:currentData.actuallyLength];
            if ([videoData length] >= 4) {
                
                [self parseData:[videoData subdataWithRange:NSMakeRange(4, [videoData length] - 4)]];
                _decodeFrameCountInTenSeconds ++;
            }
            
            [self.videoDataDictionary removeObjectForKey:msgIdKey];
        }
    }
    
    [reData release];
    
    
    if ([self.videoDataDictionary count] >  60) {
        
//        [self sendChangeVideoSizeRequest];
        
        DebugLog(@"[self.videoDataDictionary count] === %d",[self.videoDataDictionary count]);
        
        NSArray * timeArray = [self.videoDataDictionary allKeys];
        timeArray = [timeArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:
                                                            [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES],
                                                            nil]];
        @synchronized(self.videoDataDictionary)
        {
            [self.videoDataDictionary removeObjectsForKeys:[timeArray subarrayWithRange:NSMakeRange(0, 50)]];
        }
        
//        for (NSNumber * msgIdKey in timeArray) {
//            
//            UdpVideoData * udpVideoData = [self.videoDataDictionary objectForKey:msgIdKey];
//            CGFloat progress = (CGFloat)(udpVideoData.havePacketCount * 1.0 / (udpVideoData.allPacketCount*1.0));
//            if (progress > 0.9) {
//                
//                NSMutableData * videoData = [NSMutableData dataWithBytes:udpVideoData.buffer length:udpVideoData.actuallyLength];
//                [self parseData:[videoData subdataWithRange:NSMakeRange(4, [videoData length] - 4)]];
//                [self.videoDataDictionary removeObjectForKey:msgIdKey];
//            }
//        }
    }
    
    [pool release];
    
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    @synchronized(self.udpSendDataArray)
    {
        [self.udpSendDataArray removeAllObjects];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
//    DebugLog(@"udpSocket data length %d",[data length]);
    
    NSData * reData = [[NSData alloc ] initWithData:data];
    
    if ([reData length] > 4) {
        
        char * msg = (char *)[reData bytes];
        
        if ((msg[0] == '@') && (msg[1] == '%') && (msg[2] == '^') && (msg[3] == '!')) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                NSData * reData1 = [NSData dataWithData:[reData subdataWithRange:NSMakeRange(4, [reData length] - 4)]];
                [self parseData:reData1];
                
            });

        }
        else
        {

//            DebugLog(@"视频数据 ip %@  :port %d",[GCDAsyncUdpSocket hostFromAddress:address],[GCDAsyncUdpSocket portFromAddress:address]);

            //视频数据
            NSData *    lengthData = [reData subdataWithRange:NSMakeRange(0, 4)];
            NSInteger   channelid  = [dealWithCommend headerDataToLength:lengthData];
            if (channelid == self.channelId)
            {
                
                if (_flagParseUdpData) {
                    
                    @synchronized(self.udpReciveDataArray)
                    {
                        [self.udpReciveDataArray addObject:reData];
                    }
                    
                    if (!self.udpAddress) {
                        
                        self.udpAddress = address;
                            DebugLog(@"self.udpAddress ip %@  :port %d",[GCDAsyncUdpSocket hostFromAddress:address],[GCDAsyncUdpSocket portFromAddress:address]);
                    }

                    
                    if (!_flagStartParseUdpData) {
                        
                        _flagStartParseUdpData = YES;
                        [self startParseUdpData];
                    }
                }
                
            }
            
        }
    }
    else{
        
        if([reData length] == 1)
        {
            
            @synchronized(self.udpAddress){
                self.udpAddress = address;
            }

            
            if (_flagStartPlayVideo) {
                
                if ( _flagReciveToken < 4) {
                    
                    _isP2pSuccess = YES;
                    _flagReciveToken ++ ;
                    
                    char p2pData='1';
                    NSData *dataForCheckP2p=[[NSData alloc] initWithBytes:&p2pData length:1];
                    [self.udpSocket sendData:dataForCheckP2p toAddress:address withTimeout:-1 tag:0];
                    [dataForCheckP2p release];
                    
                    @synchronized(self.udpAddress){
                        self.udpAddress = address;                        
                    }
                    
                    DebugLog(@"_isP2pSuccess recive 1");
                    DebugLog(@"ip %@  :port %d",[GCDAsyncUdpSocket hostFromAddress:address],[GCDAsyncUdpSocket portFromAddress:address]);

                }
            }
            
        }
    }
    
    [reData release];
    
    [self.udpSocket beginReceiving:nil];

}

- (void)sendDataToKeepNatip{
    
    if ([self.natip length] > 10) {
        
        [self sendUdpSocketRequest:[NSData dataWithBytes:"0" length:1] host:@"223.226.3.129" port:5200 tag:0];
    }
}

- (void)checkUdpDataLose{
    
    CGFloat lose_v = 0;
    if (_allFrameCountInTenSeconds > 0) {
        
        lose_v = (_allFrameCountInTenSeconds - _decodeFrameCountInTenSeconds)/_allFrameCountInTenSeconds;
    }
    
    DebugLog(@"lose_v %f _decodeFrameCountInTenSeconds %f _allFrameCountInTenSeconds %f",lose_v,_decodeFrameCountInTenSeconds,_allFrameCountInTenSeconds);

    if (lose_v > 0.1 ) {
        
        _checkLoseVTimeCount ++;
        if (_checkLoseVTimeCount >= 2) {
            
            _checkLoseVTimeCount = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationNeedChangeVideoQuality object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"needChangeVideoSize"]];
        }
        
        _checkTimeCount = 0;
        
    }
    
    if (lose_v < 0.01 && _decodeFrameCountInTenSeconds > 50) {
        
        _checkTimeCount ++;
        _checkLoseVTimeCount = 0;
        if (_checkTimeCount >= 2) {
            
            _checkTimeCount = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationNeedChangeVideoQuality object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"needChangeVideoSize"]];
        }
    }
    
    _decodeFrameCountInTenSeconds = 0;
    _allFrameCountInTenSeconds = 0;

}

- (void)prepareData{
    
    self.udpSendDataArray = [NSMutableArray arrayWithCapacity:100];
    self.udpReciveDataArray = [NSMutableArray arrayWithCapacity:10];
    self.portArray = [NSMutableArray arrayWithCapacity:1];
    self.localIpAndPort = [NSMutableData dataWithCapacity:12];
    self.videoDataDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    self.allTcpDataBuffer = [NSMutableData dataWithCapacity:1000];

    
}

- (void)cleanData{
    
    self.udpAddress = nil;
    self.checkTimeCount = 0;
    _checkLoseVTimeCount = 0;
    _flagStartP2p = NO;
    _flagStartPlayVideo = NO;
    _flagHadChangeVideoSize = NO;
    [[MYDataManager shareManager].audioRecordEngine stop];
    _flagStartParseUdpData = NO;
    _flagStartParseTcpData = NO;
    _flagParseUdpData = NO;
    _flagParseTcpData = NO;
    [self.tcpDataSocket disconnect];
    _flagReciveToken = 0;
    self.dataChannel = 0;
    _isP2pSuccess = NO;
    _flagSendAllPortToken = NO;
    
    usleep(10*1000);
    self.cameraNatip = nil;
    self.cameraNatPort = 0;
    self.cameraLocalIp = nil;
    self.cameraLocalPort = 0;
    self.mcuIp = nil;
    self.mcuPort = 0;
    self.channelId = 0;
    
    
    @synchronized(_udpReciveDataArray)
    {
        [_udpReciveDataArray removeAllObjects];
    }
    
    @synchronized(_allTcpDataBuffer)
    {
        if ([_allTcpDataBuffer length] > 0) {
            self.allTcpDataBuffer = nil;
            self.allTcpDataBuffer = [NSMutableData dataWithCapacity:1000];
        }
    }
    
    if (_udpDataParse_queue) {
        dispatch_release(_udpDataParse_queue);
        _udpDataParse_queue = NULL;
    }
    
    if (_tcpDataParse_queue) {
        dispatch_release(_tcpDataParse_queue);
        _tcpDataParse_queue = NULL;
    }
    
    @synchronized(self.udpSendDataArray)
    {
        [self.udpSendDataArray removeAllObjects];
    }
    
    @synchronized(self.videoDataDictionary)
    {
        [self.videoDataDictionary removeAllObjects];
    }
    
    if (_tokenDispatch_queue) {
        usleep(6*1000);
        dispatch_release(_tokenDispatch_queue);
        _tokenDispatch_queue = NULL;
    }
    
    [MYDataManager shareManager].myUdpSocket.cameraVideoDataDelegate = nil;
    [MYDataManager shareManager].myUdpSocket.cameraInfo = nil;
}

- (void)parseData:(NSData *)data{
    
    NSMutableData * reData = [[NSMutableData alloc] initWithData:data];
    NSData * cmdData = [reData subdataWithRange:NSMakeRange(0, 1)];
    NSInteger cmdType = 0;
    memcpy(&cmdType, [cmdData bytes], 1);
    
    long channel = 0;
    memcpy(&channel, [[reData subdataWithRange:NSMakeRange(1, 4)] bytes], 4);
    NSInteger channelValue = htonl(channel);
    
    NSData *mcuData = nil;
    if ([reData length] >= 9) {
        mcuData = [reData subdataWithRange:NSMakeRange(5, [reData length] - 5)];
    }
    
    switch (cmdType) {
        case CMD_INIT_DATA_CHANNEL:
        {
//            [self sendCmd:nil cmdType:CMD_CREATE_DATA_CHANNEL socketType:NO];
        }
            break;
            
        case CMD_CREATE_DATA_CHANNEL:
        {
            self.dataChannel = channelValue;
//            [self watchCameraCommend];
        }
            
            break;
        case CMD_JOIN_DATA_CHANNEL:
        {
            DebugLog(@"CMD_JOIN_DATA_CHANNEL");
        }
            break;
        case CMD_SEND_DATA:
        {
            //to do decode video data
            [self.cameraVideoDataDelegate videoData:mcuData];

        }
            break;
        case CMD_START_TCP_P2P:
            
            break;
        case CMD_CLOSE_DATA_CHANNEL:
            
            break;
        case CMD_TCP_P2P_OK:
            
            break;
        case CMD_START_UDP_P2P:
        {
            
            if (mcuData != nil) {
                NSInteger netIp = 0;
                memcpy(&netIp, (char *)[mcuData bytes], 4);
                unsigned long localip = ntohl(netIp);
                unsigned short netPort = -1;
                memcpy(&netPort, [mcuData bytes]+4, 2);
                unsigned short localport = ntohs(netPort);
                
                self.cameraLocalIp = [NSString stringWithFormat:@"%lu",localip];
                self.cameraLocalPort = localport;
                
                uint32_t newIP = localip;
                NSString *newIPStr = [NSString stringWithFormat:@"%u.%u.%u.%u",
                                      ((newIP >> 24) & 0xFF),
                                      ((newIP >> 16) & 0xFF),
                                      ((newIP >> 8) & 0xFF),
                                      ((newIP >> 0) & 0xFF)];
                
                DebugLog(@"摄像头 localIpStr %@",newIPStr);
                DebugLog(@"摄像头  %d",localport);
                
                
                netIp = 0;
                netPort = -1;
                memcpy(&netIp, [mcuData bytes]+6, 4);
                unsigned long ip = ntohl(netIp);
                memcpy(&netPort, [mcuData bytes] +10, 2);
                unsigned short port = ntohs(netPort);
                
                self.cameraNatip = [NSString stringWithFormat:@"%lu",ip];
                self.cameraNatPort = port;
                
                
                newIP = ip;
                newIPStr = [NSString stringWithFormat:@"%u.%u.%u.%u",
                            ((newIP >> 24) & 0xFF),
                            ((newIP >> 16) & 0xFF),
                            ((newIP >> 8) & 0xFF),
                            ((newIP >> 0) & 0xFF)];
                DebugLog(@"摄像头 natIpStr %@",newIPStr);
                DebugLog(@"摄像头 natIpPort %d",port);
                
                
                if (!_isP2pSuccess) {
                    
                    if (port == 0) {
                        
                        if (!_flagSendAllPortToken) {
                            
                            
                            _flagSendAllPortToken = YES;
                            [self sendUdpTokenInfoWithip:localip port:localport];
                            
                            char p2pData='1';
                            NSData *dataForCheckP2p=[[NSData alloc] initWithBytes:&p2pData length:1];
                            NSString * host = [[NSString alloc] initWithFormat:@"%lu",ip];
                            unsigned short usPort = 0;
                            DebugLog(@"TOKEN START");
                            for (int i= 0; i < 32256; i ++) {
                                
                                if (_isP2pSuccess) {
                                    break;
                                }
                                usleep(1*1000);
                                usPort = 33280+i;
                                [self.udpSocket sendData:dataForCheckP2p toHost:host  port:usPort  withTimeout:-1 tag:0];
                                usPort = 33280-i;
                                [self.udpSocket sendData:dataForCheckP2p toHost:host  port:usPort  withTimeout:-1 tag:0];
                                
                            }
                            DebugLog(@"TOKEN OVER");
                            [dataForCheckP2p release];
                            [host release];
                        }
                        else{
                            //TODO....
                        }
                    }
                    else{
                        //
                        _tokenDispatch_queue = dispatch_queue_create("token", NULL);
                        dispatch_async(_tokenDispatch_queue, ^{
                            [self sendLoopUdpToken];
                        });
                        
                    }
                }
            }
        }
            
            break;
        case CMD_UDP_P2P_OK:
            
            break;
        case CMD_GET_UDP_ADDR:
        {
            if ([mcuData length] >= 6) {
                
                int len = [self.localIpAndPort length];
                [self.localIpAndPort replaceBytesInRange:NSMakeRange(0, len) withBytes:NULL length:0];
                
                NSString * local  = [[AppDelegate getAppDelegate].mygcdSocketEngine.gcdAsyncsocket localHost];
                if (!local) {
                    
                    [reData release];
                    return;
                }
                
                NSString * localStr =  [[NSString alloc] initWithString:local];
                self.localIp = localStr;
                
                NSInteger localipPort =  [self.udpSocket localPort_IPv4];
                self.localPort = localipPort;
                
                DebugLog(@"客户端 local ip  == %@  localPort == %d",localStr, localipPort);
                [localStr release];
                
                NSInteger netIp = 0;
                memcpy(&netIp, (char *)[mcuData bytes], 4);
                unsigned long ip = ntohl(netIp);
                unsigned short netPort = 0;
                memcpy(&netPort, [mcuData bytes]+4, 2);
                unsigned short port = ntohs(netPort);
                
                uint32_t newIP = ip;
                
                NSString * newIPStr = [NSString stringWithFormat:@"%u.%u.%u.%u",
                                       ((newIP >> 24) & 0xFF),
                                       ((newIP >> 16) & 0xFF),
                                       ((newIP >> 8) & 0xFF),
                                       ((newIP >> 0) & 0xFF)];
                
                self.natip = newIPStr;
                self.natPort = port;
                
                NSNumber * portNumber = [NSNumber numberWithInt:port];
                DebugLog(@"客户端 Natip == %@  Natport == %d",newIPStr, port);
                
                int portCount = [self.portArray count];
                if (portCount > 0) {
                    
                    for (NSNumber *number in self.portArray) {
                        if ([number intValue] != port) {
                            
                            port = 0;
                            self.natPort = port;
                            break;
                        }
                    }
                }
                
                [self.portArray addObject:portNumber];
                
            }
            
        }
            
            break;

            
        default:
            break;
    }
    
    [reData release];
}


- (void)close{
    
    [self cleanData];
    [self.udpSocket close];
    self.udpSocket.delegate = nil;
    
    if (_udpDispatch_queue) {
        
        dispatch_release(_udpDispatch_queue);
        _udpDispatch_queue = NULL;
    }

}

- (void)initUdpSocket:(NSDictionary *)dat{
    
    self.mcuIpInfo = dat;
    _udpDispatch_queue = dispatch_queue_create("udp", NULL);
    
    GCDAsyncUdpSocket * udp = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:_udpDispatch_queue];
    self.udpSocket = udp;
    [udp release];
    
    if (dat) {
       
        [self getUdpAddress];
    }
    
    [self prepareData];

 
}

- (void)upnpPortMaping{
    
    void ( *DNSServiceNATPortMappingReply) (DNSServiceRef sdRef,
                                            DNSServiceFlags flags,
                                            uint32_t interfaceIndex,
                                            DNSServiceErrorType errorCode,
                                            uint32_t externalAddress,
                                            DNSServiceProtocol protocol,
                                            uint16_t internalPort,
                                            uint16_t externalPort,
                                            uint32_t ttl,
                                            void *context );
    
    DNSServiceNATPortMappingReply = &DNSServiceNATPortMappingCreate_callback ;
    
    DNSServiceErrorType error = DNSServiceNATPortMappingCreate(&_sdRef,
                                                               0,
                                                               0,
                                                               kDNSServiceProtocol_UDP,
                                                               htons(5168),
                                                               htons(5268),
                                                               0,
                                                               DNSServiceNATPortMappingReply,
                                                               NULL
                                                               ) ;
    
    DebugLog(@"err %d",error);
    if (error == 0) {
        
        self.upnp_port = 5268;
    }
    
//    CFRunLoopSourceRef _socketSource = NULL;
//    // Wrap a CFSocket around the service's socket:
//    CFSocketContext ctxt = { 0, self, CFRetain, CFRelease, NULL };
//    CFSocketRef _socket = CFSocketCreateWithNative(NULL,
//                                                   DNSServiceRefSockFD(_sdRef),
//                                                   kCFSocketReadCallBack,
//                                                   &serviceCallback, &ctxt);
//    if( _socket ) {
//        CFSocketSetSocketFlags(_socket, CFSocketGetSocketFlags(_socket) & ~kCFSocketCloseOnInvalidate);
//        // Attach the socket to the runloop so the serviceCallback will be invoked:
//        _socketSource = CFSocketCreateRunLoopSource(NULL, _socket, 0);
//        if( _socketSource )
//            CFRunLoopAddSource(CFRunLoopGetCurrent(), _socketSource, kCFRunLoopCommonModes);
//    }
//    
//    if( _socketSource ) {
//        DebugLog(@"Opening PortMapper");
//    } else {
//        DebugLog(@"Failed to open PortMapper");
//    }
}

- (void)getUdpAddress{

    //获取 客户端自己的 local nat  ip port
    
    int zeroData=0;
    int channelForHere=0/*3452816845*/;
    char cmdType=CMD_GET_UDP_ADDR;
    NSMutableData *dataData=[[NSMutableData alloc] initWithBytes:&zeroData length:4];
    [dataData appendBytes:&zeroData length:2];
//    int totalLength=[dataData length]+5;
//    unsigned long netTotalLength = htonl(totalLength);
    
    unsigned char szPackHead[4] = {'@','%','^','!'};
    
    NSMutableData *cmdData=[[NSMutableData alloc] init];
    
//    [cmdData appendBytes:&netTotalLength length:4];

    [cmdData appendBytes:szPackHead length:4];
    [cmdData appendBytes:&cmdType length:1];
    [cmdData appendBytes:&channelForHere length:4];
    [cmdData appendData:dataData];
    
    
    
    if ([self.mcuIpInfo objectForKey:@"mcuip1"]) {
        
        NSString * mcuip1 = [[NSString alloc] initWithString:[self.mcuIpInfo objectForKey:@"mcuip1"]];
        NSInteger mcuport1 = [[self.mcuIpInfo objectForKey:@"mcuport1"] intValue];
        [self sendUdpSocketRequest:cmdData host:mcuip1 port:mcuport1 tag:CMD_GET_UDP_ADDR];
        [mcuip1 release];
        DebugLog(@"getUdpAddr mcuip1");
    }
    
    if ([self.mcuIpInfo objectForKey:@"mcuip2"]) {
        
        NSString * mcuip2 = [[NSString alloc] initWithString:[self.mcuIpInfo objectForKey:@"mcuip2"]];
        NSInteger mcuport2 = [[self.mcuIpInfo objectForKey:@"mcuport2"] intValue];
        [self sendUdpSocketRequest:cmdData host:mcuip2 port:mcuport2 tag:CMD_GET_UDP_ADDR];
        [mcuip2 release];
        DebugLog(@"getUdpAddr mcuip2");
        
    }
    
    if ([self.mcuIpInfo objectForKey:@"mcuip3"]) {
        
        NSString * mcuip3 = [[NSString alloc] initWithString:[self.mcuIpInfo objectForKey:@"mcuip3"]];
        NSInteger mcuport3 = [[self.mcuIpInfo objectForKey:@"mcuport3"] intValue];
        [self sendUdpSocketRequest:cmdData host:mcuip3 port:mcuport3 tag:CMD_GET_UDP_ADDR];
        [mcuip3 release];
        DebugLog(@"getUdpAddr mcuip3");
    }
    
    [dataData release];
    [cmdData release];
    
}


- (void)sendUdpSocketRequest:(NSData *)data host:(NSString *)hostIp port:(NSInteger)port tag:(long)tag{
    
    NSString * host = [[NSString alloc] initWithString:hostIp];
    [self.udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self.udpSocket receiveOnce:nil];
    [self.udpSendDataArray addObject:data];
    [self.udpSendDataArray addObject:hostIp];
    [host release];
}


- (void)sendUdpSocketData:(NSData *)data tag:(long)tag{
    
//    DebugLog(@"ip %@  :port %d",[GCDAsyncUdpSocket hostFromAddress:self.udpAddress],[GCDAsyncUdpSocket portFromAddress:self.udpAddress]);
    [self.udpSocket sendData:data toAddress:self.udpAddress withTimeout:-1 tag:0];
    [self.udpSocket receiveOnce:nil];
    
//    NSLock * lock = [[NSLock alloc] init];
//    [lock tryLock];
//    [self.udpSendDataArray addObject:data];
//    [lock unlock];
//    [lock release];
    @synchronized(self.udpSendDataArray)
    {
        [self.udpSendDataArray addObject:data];
    }
}

- (void)sendLoopUdpToken{
    
    _flagStartP2p = YES;
    DebugLog(@"sendUdpTokenInfo loop 100");
    
    DebugLog(@"udpSocket.localPort = %d",self.udpSocket.localPort);
    
    char p2pData='1';
    NSData *dataForCheckP2p=[[NSData alloc] initWithBytes:&p2pData length:1];
    for (int i = 0; i < 50; i ++) {
        
        if (_isP2pSuccess) {
            break;
        }
        
        if (!_flagStartP2p) {
            break;
        }
        
        usleep(20*1000);
        [self.udpSocket sendData:dataForCheckP2p toHost:self.cameraLocalIp  port:self.cameraLocalPort  withTimeout:-1 tag:0];
        usleep(20*1000);
        [self.udpSocket sendData:dataForCheckP2p toHost:self.cameraNatip port:self.cameraNatPort withTimeout:-1 tag:0];
        
    }
    
    [self.udpSocket beginReceiving:nil];

    DebugLog(@"摄像头 local:%@ port: %d 摄像头natip: %@ port:%d",self.cameraLocalIp,self.cameraLocalPort,self.cameraNatip,self.cameraNatPort );
    DebugLog(@"sendUdpTokenInfo loop over 100");
    [dataForCheckP2p release];
}


- (void)sendUdpTokenInfoWithip:(unsigned long)ip port:(short)port{
    
    char p2pData='1';
    NSData *dataForCheckP2p=[[NSData alloc] initWithBytes:&p2pData length:1];
    NSString * host = [[NSString alloc] initWithFormat:@"%lu",ip];
    [self.udpSocket sendData:dataForCheckP2p toHost:host  port:port  withTimeout:-1 tag:0];
    [self.udpSocket beginReceiving:nil];
    [host release];
    [dataForCheckP2p release];
}

-(void)sendCmd:(enum CMD)cmdType
{

    NSMutableData *cmdData=[[NSMutableData alloc] init];
    unsigned char szPackHead[4] = {'@','%','^','!'};
    long netChannel = htonl(self.channelId);
    [cmdData appendBytes:szPackHead length:4];
    [cmdData appendBytes:&cmdType length:1];
    [cmdData appendBytes:&netChannel length:4];
    [self.udpSocket sendData:cmdData toHost:self.mcuIp port:self.mcuPort withTimeout:-1 tag:0];
    DebugLog(@"udp self.mcuIp %@  self.mcuPort %d",self.mcuIp,self.mcuPort);
    [self.udpSocket receiveOnce:nil];
    [self.udpSendDataArray addObject:cmdData];
    [cmdData release];
    
}

- (void)sendChangeVideoSizeRequest{
    
//    if (!_flagHadChangeVideoSize) {
//        
//        _flagHadChangeVideoSize = YES;
//        
//        [[AppDelegate getAppDelegate].mygcdSocketEngine sendModifyCameraVideoSize:self.cameraInfo videoSize:VIDEO_SIZE_TYPE_QVGA mcuIp:self.mcuIp port:self.mcuPort channelId:self.channelId];
//        
//    }
}

- (void)sendVideoQualityChange:(NSInteger)videoQuality{
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendModifyCameraVideoSize:self.cameraInfo videoSize:videoQuality mcuIp:self.mcuIp port:self.mcuPort channelId:self.channelId];
}

//serverip不为“”，或者serverport != 0
- (void)updateCameraNatipWithDictionary:(NSDictionary *)data{
    
    self.cameraNatip = [data objectForKey:@"natip"];
    self.cameraNatPort = ([[data objectForKey:@"natport"] intValue]);//ntohs
    self.cameraLocalIp = [data objectForKey:@"localip"];
    self.cameraLocalPort = ([[data objectForKey:@"localport"] intValue]);
    
    NSString * mcuIp = [data objectForKey:@"mcuip"];
    NSInteger  mcuPort = [[data objectForKey:@"mcuport"] intValue];
    
    if ([mcuIp length] > 5 && mcuPort != 0) {
        
        self.mcuIp = mcuIp;
        self.mcuPort = mcuPort;
    }
    else
    {
        self.mcuIp = @"";
    }
    
    self.channelId = [[data objectForKey:@"channelid"] unsignedIntValue];
    
    _flagStartPlayVideo = YES;
    
    NSString * tcpIp = [data objectForKey:@"serverip"];
    NSInteger port  = [[data objectForKey:@"serverport"] intValue];
    
    if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        tcpIp = [data objectForKey:@"localip"];
        port  = [[data objectForKey:@"localport"] intValue];
    }
    else
    {
        if ([[MYDataManager shareManager].myUdpSocket.natip isEqual:self.cameraInfo.cameraNatip])
        {

            if ([[data objectForKey:@"cmd"] isEqualToString:@"WATCH_CAMERA_TCP_RESP"]) {
                
                NSString * ip = [data objectForKey:@"localip"];
                NSInteger localport = [[data objectForKey:@"localport"] intValue];
                
                if ([ip length] > 6 && localport != 0)
                {
                    
                    tcpIp = ip;
                    port  = localport;
                }
            }
        }
    }
    
    if ([tcpIp length] > 6 && port != 0) {
        
        _flagParseTcpData = YES;
        [self initTcpDataSocketWith:tcpIp port:port];
    }
    else
    {
        _tokenDispatch_queue = dispatch_queue_create("token", NULL);
        dispatch_async(_tokenDispatch_queue, ^{
            
            [self sendCmd:CMD_JOIN_DATA_CHANNEL];
            [self startP2p];
            
        });
        
        [self sendCmd:CMD_JOIN_DATA_CHANNEL];
    }
    
    _flagParseUdpData = YES;
    
    [[MYDataManager shareManager] initAudioRecordEngine];
    
}

- (void)startP2p{
    
    DebugLog(@"CMD_START_UDP_P2P");
    
        if (!_isP2pSuccess) {
            
            if (self.cameraNatPort == 0) {
                
                if (!_flagSendAllPortToken) {
                    
                    _flagSendAllPortToken = YES;
                    [self sendUdpTokenInfoWithip:self.cameraLocalIp  port:self.cameraLocalPort];
                    
                        char p2pData='1';
                        NSData *dataForCheckP2p=[[NSData alloc] initWithBytes:&p2pData length:1];
                        unsigned short usPort = 0;
                        _flagStartP2p = YES;
                        DebugLog(@"TOKEN START");
                        for (int i= 0; i < 500; i ++) {//32256
                            
                            if (!_flagStartP2p) {
                                break;
                            }
                            
                            if (_isP2pSuccess) {
                                break;
                            }
                                                        
                            usleep(6*1000);
                            usPort = 33280+i;
                            [self.udpSocket sendData:dataForCheckP2p toHost:self.cameraNatip  port:usPort  withTimeout:-1 tag:0];
                            usPort = 33280-i;
                            usleep(6*1000);
                            [self.udpSocket sendData:dataForCheckP2p toHost:self.cameraNatip  port:usPort  withTimeout:-1 tag:0];
                            
                        }
                        DebugLog(@"TOKEN OVER");
                        [dataForCheckP2p release];

                }
                else{
                    
                }
            }
            else{

                [self sendLoopUdpToken];
                
            }
        }
        
        
}

- (void)sendAudioToCameraByUdp:(NSData *)audioData{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    
            [self sendUdpSocketData:audioData tag:0];
//    });

}


- (void)buildUdpData:(NSData *)data type:(int)type{

    if (type == 0) {//视频

    }

    if (type == 1) {//音频

        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

        NSMutableData * mediaTypeData = [NSMutableData dataWithCapacity:[data length]+7];
        char mediaType = 1;
        [mediaTypeData appendBytes:&mediaType length:1];
        char mediaFormat = Audio_Format_ADPCM;
        [mediaTypeData appendBytes:&mediaFormat length:1];

        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        int leng = start;
        unsigned long time = htonl(leng);

        [mediaTypeData appendBytes:&time length:4];
        char audioFomat = 0;
        [mediaTypeData appendBytes:&audioFomat length:1];
        [mediaTypeData appendData:data];

        NSMutableData * mcuMediaData = [NSMutableData dataWithCapacity:[mediaTypeData length]+9];
        int allLenght = 1+4+[mediaTypeData length];
        unsigned long total_len = htonl(allLenght);
        [mcuMediaData appendBytes:&total_len length:4];
        char cmd = CMD_SEND_DATA;
        [mcuMediaData appendBytes:&cmd length:1];
        unsigned long channel = htonl(self.channelId);
        [mcuMediaData appendBytes:&channel length:4];
        [mcuMediaData appendData:mediaTypeData];

//        NSMutableData * audioMutableData = [[[NSMutableData alloc] initWithCapacity:[mcuMediaData length]+12] autorelease];
        @synchronized(self.audioMutableData){
            
            if (self.cameraInfo.flagUpnp_success ==1 && [self.tcpDataSocket isConnected]) {
                
                self.audioMutableData = [[[NSMutableData alloc] initWithCapacity:[mcuMediaData length]] autorelease];
                [_audioMutableData appendBytes:[mcuMediaData bytes] length:[mcuMediaData length]];
                [self sendAudioDataWithTcp:_audioMutableData];
            }
            else
            {
                self.audioMutableData = [[[NSMutableData alloc] initWithCapacity:[mcuMediaData length]+12] autorelease];
                
                //        unsigned char szPackHead[4] = {'@','%','^','!'};
                unsigned long netTotalLength = htonl(_channelId);
                [_audioMutableData appendBytes:&netTotalLength length:4];
                
                u_int32_t uint = msgid ++; //arc4random();
                unsigned long  msgId = htonl(uint);
                //            DebugLog(@"uint msgid %u",uint);
                [_audioMutableData appendBytes:&msgId length:4];
                short allPacket = htons(1);
                [_audioMutableData appendBytes:&allPacket length:2];
                short currentPacketNo = htons(0);
                [_audioMutableData appendBytes:&currentPacketNo length:2];
                [_audioMutableData appendBytes:[mcuMediaData bytes] length:[mcuMediaData length]];
            }
            
            [self sendAudioToCameraByUdp:_audioMutableData];
        }

        
        [pool release];

    }

}
- (void)audioRecordCompleteWithData:(NSData *)data{

    [self buildUdpData:data type:1];
}

- (void)sendAudioDataWithTcp:(NSData *)data{
    
    [self.tcpDataSocket writeData:data withTimeout:KSOCKET_TIMEOUT tag:0];
}

-(void)sendTcpTokenCommunicate
{
    int nType = 1002;
    int nLen = 0;
    long netnType = htonl(nType);
    
    NSMutableData *cmdData=[[NSMutableData alloc] init];
    [cmdData appendBytes:&netnType length:4];
    [cmdData appendBytes:&nLen length:4];
    [self.tcpDataSocket writeData:cmdData withTimeout:-1 tag:0];
    [self.tcpDataSocket readDataWithTimeout:KSOCKET_READ_TIMEOUT tag:0];
    [self.udpSendDataArray addObject:cmdData];
    [cmdData release];
    
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    [self sendTcpTokenCommunicate];
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
//    DebugLog(@"socket DATA LENGTH %d |||||",[data length]);
    
    NSMutableData * reData = [[NSMutableData alloc] initWithData:data];
    if (_flagParseTcpData) {
        
        @synchronized(self.allTcpDataBuffer)
        {
            [self.allTcpDataBuffer appendData:reData];
        }
    }

    
    [reData release];
    
    [sock readDataWithTimeout:-1 tag:0];
    
    if (!_flagStartParseTcpData && _flagParseTcpData) {
        
        _flagStartParseTcpData = YES;
        [self startParseTcpData];
    }
    
}

- (void)startParseTcpData{
    
    _tcpDataParse_queue = dispatch_queue_create("tcpParse", NULL);
    
    dispatch_async(_tcpDataParse_queue, ^{
        
        while (_flagStartParseTcpData) {
            
            if ([self.allTcpDataBuffer length] > 4) {
                
                @synchronized(self.allTcpDataBuffer){
                    
                    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
                    
                    NSData * lengthData = [self.allTcpDataBuffer subdataWithRange:NSMakeRange(0, 4)];
                    NSInteger length = [dealWithCommend headerDataToLength:lengthData];
//                    DebugLog(@"length %d",length);
                    
                    if ([self.allTcpDataBuffer length] -4 >= length) {
                        
                        //必然有一个完整的包

                        NSData * subData = [self.allTcpDataBuffer subdataWithRange:NSMakeRange(4, length)];
                        if ([subData length] > 0) {
                            
                            @synchronized(subData)
                            {
                                [self parseData:subData];
                            }
                            
                        }

                        [self.allTcpDataBuffer replaceBytesInRange:NSMakeRange(0, length + 4) withBytes:NULL length:0];

                    }
                    
                    [pool release];
                }
            }
            else
            {
                usleep(6*1000);
            }
            
        }
        
    });
}



- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)initTcpDataSocketWith:(NSString *)ip port:(NSInteger)port{
    
    if (!self.tcpDataSocket) {
        
        GCDAsyncSocket * tcp = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_udpDispatch_queue];
        //dispatch_queue_create("tcpData", NULL)
        self.tcpDataSocket = tcp;
        [tcp release];
    }
    else
    {
        [self.tcpDataSocket disconnect];
    }
    
    NSError * error = nil;
    if ([self.tcpDataSocket connectToHost:ip onPort:port withTimeout:KSOCKET_CONNECT_TIMEOUT error:&error]) {
        
        DebugLog(@" connectToHost IP:%@ PORT: %d",ip,port);
    }
    
}



@end
