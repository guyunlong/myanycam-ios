//
//  UdpVideoData.m
//  Myanycam
//
//  Created by myanycam on 13/6/8.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "UdpVideoData.h"

@implementation UdpVideoData
@synthesize buffer = _buffer;
@synthesize actuallyLength =_actuallyLength;
@synthesize havePacketCount = _havePacketCount;
@synthesize allPacketCount  = _allPacketCount;

- (void)dealloc{
    free(_buffer);
    _buffer = nil;
    [super dealloc];
}

- (id)initWithLength:(NSInteger)allLength mgsId:(NSInteger)udpMsgId{
    self = [super init];
    if (self) {
        currentId = udpMsgId;
        _buffer =  malloc(allLength * sizeof(char));
        _actuallyLength = 0;
    }
    return self;
}

- (void)changeActuallyLength:(NSInteger)length{
    _actuallyLength += length;
}

- (void)addhavePacketCount{
    _havePacketCount = _havePacketCount +1;
}

@end
