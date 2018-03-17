//
//  MYGCDAsyncUdpSocket.h
//  Myanycam
//
//  Created by myanycam on 13/8/13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDAsyncUdpSocket.h"
#import "cameraViewViewController.h"
#import <dns_sd.h>


@interface MYGCDAsyncUdpSocket : NSObject<GCDAsyncUdpSocketDelegate,AudioRecordDelegate>{
    
    GCDAsyncUdpSocket   * _udpSocket;
    NSDictionary        * _mcuIpInfo;
    NSMutableData       * _audioMutableData;
    NSMutableDictionary * _videoDataDictionary;
    
    NSMutableData       * _allTcpDataBuffer;
    
    dispatch_queue_t    _udpDispatch_queue;
    dispatch_queue_t    _tokenDispatch_queue;
    dispatch_queue_t    _udpDataParse_queue;
    dispatch_queue_t    _tcpDataParse_queue;
    
    NSMutableArray      *_udpSendDataArray;
    NSUInteger          _channelId;
    NSInteger           _flagWatchCamera;
    NSInteger           _startGetUpdTimerCount;

    NSString            *_natip;
    NSInteger           _natPort;
    NSString            *_localIp;
    NSInteger           _localPort;
    NSData              *_udpAddress;
    NSString            *_cameraNatip;
    NSInteger           _cameraNatPort;
    NSString            *_cameraLocalIp;
    NSInteger           _cameraLocalPort;
    NSMutableArray      * _udpReciveDataArray;
    
    NSString            *_mcuIp;
    NSInteger           _mcuPort;
    
    NSInteger          _dataChannel;
    
    DNSServiceRef      _sdRef;
    NSString           *_upnp_ip;
    NSInteger          _upnp_port;
    
    
    NSInteger           _flagReciveToken;
    BOOL                _isP2pSuccess;
    BOOL                _flagSendAllPortToken;
    BOOL                _flagStartP2p;
    BOOL                _flagStartParseUdpData;
    BOOL                _flagStartParseTcpData;
    BOOL                _flagParseUdpData;
    BOOL                _flagParseTcpData;
    BOOL                _flagHadChangeVideoSize;
    BOOL                _flagStartPlayVideo;

    CameraInfoData      *_cameraInfo;

    id<CameraUdpDataDelegate>   _cameraVideoDataDelegate;
    u_int32_t           msgid;
    CGFloat           _allFrameCountInTenSeconds;
    CGFloat           _decodeFrameCountInTenSeconds;
    NSInteger         _checkTimeCount;
    NSInteger         _checkLoseVTimeCount;
    
}

@property (retain, nonatomic) NSMutableData  * allTcpDataBuffer;
@property (retain, nonatomic) GCDAsyncSocket * tcpDataSocket;


@property (assign, nonatomic) id<CameraUdpDataDelegate> cameraVideoDataDelegate;
@property (retain, nonatomic) GCDAsyncUdpSocket * udpSocket;
@property (retain, nonatomic) NSDictionary      * mcuIpInfo;
@property (retain, nonatomic) NSMutableArray    * udpSendDataArray;
@property (retain, nonatomic) NSMutableArray    * udpReciveDataArray;
@property (retain, nonatomic) NSMutableDictionary * videoDataDictionary;
@property (assign, nonatomic) NSUInteger          channelId;
@property (retain, nonatomic) NSMutableData     * localIpAndPort;
@property (retain, nonatomic) NSMutableArray    * portArray;

@property (retain, nonatomic) NSString * natip;
@property (retain, nonatomic) NSString * localIp;
@property (assign, nonatomic) NSInteger  natPort;
@property (assign, nonatomic) NSInteger  localPort;
@property (retain, nonatomic) NSData *   udpAddress;

@property (retain, nonatomic) NSString * cameraNatip;
@property (retain, nonatomic) NSString * cameraLocalIp;
@property (assign, nonatomic) NSInteger  cameraNatPort;
@property (assign, nonatomic) NSInteger  cameraLocalPort;

@property (assign, nonatomic) NSInteger  dataChannel;
@property (retain, nonatomic) NSString  * mcuIp;
@property (assign, nonatomic) NSInteger mcuPort;
@property (assign, nonatomic) BOOL  isP2pSuccess;
@property (assign, nonatomic) BOOL  flagStartPlayVideo;

@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) NSMutableData  * audioMutableData;
@property (retain, nonatomic) NSString * upnp_ip;
@property (assign, nonatomic) NSInteger  upnp_port;
@property (assign, nonatomic) CGFloat  allFrameCountInTenSeconds;
@property (assign, nonatomic) CGFloat  decodeFrameCountInTenSeconds;
@property (assign, nonatomic) NSInteger  checkTimeCount;


- (void)close;
- (void)cleanData;

- (void)initUdpSocket:(NSDictionary *)dat;
- (void)updateCameraNatipWithDictionary:(NSDictionary *)data;
- (void)sendDataToKeepNatip;
- (void)checkUdpDataLose;
- (void)sendChangeVideoSizeRequest;
- (void)sendVideoQualityChange:(NSInteger)videoQuality;

- (void)sendUdpSocketData:(NSData *)data tag:(long)tag;
-(void)sendCmd:(enum CMD)cmdType;

@end
