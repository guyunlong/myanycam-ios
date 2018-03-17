//
//  CameraGridImageDownload.m
//  Myanycam
//
//  Created by myanycam on 13/10/25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraGridImageDownload.h"

@implementation CameraGridImageDownload
@synthesize checkSocket;


- (void)dealloc
{
    self.cameraInfo = nil;
    [self.checkSocket disconnect];
    self.checkSocket.delegate = nil;
    self.checkSocket = nil;
    
    [super dealloc];
    
}

- (void)prepareData:(CameraInfoData *)acameraInfo URLDict:(NSDictionary *)cameraUrlDict{
    
    if (!self.checkSocket) {
        
        AsyncSocket * socket = [[AsyncSocket alloc] initWithDelegate:self];
        self.checkSocket = socket;
        [socket release];
    }
    
    self.cameraInfo = acameraInfo;
    
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    
    _checkStateing = NO;
    self.cameraInfo.flagCheckIP = 1;
    
    
    [sock disconnect];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    
    DebugLog(@"err %@",err);
    _checkStateing = NO;
    self.cameraInfo.flagCheckIP = 0;
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    
    _checkStateing = NO;
    
    if (self.cameraInfo.flagCheckIP != 1) {
        
        
    }
    
}



@end
