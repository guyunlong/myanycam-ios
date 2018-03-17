//
//  UdpVideoData.h
//  Myanycam
//
//  Created by myanycam on 13/6/8.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdpVideoData : NSObject{
    char * _buffer;
    NSInteger   currentId;
    NSInteger   _actuallyLength;
    NSInteger   _havePacketCount;
    NSInteger   _allPacketCount;
}

@property (nonatomic, assign) NSInteger havePacketCount;
@property (nonatomic, assign) char * buffer;
@property (nonatomic, assign) NSInteger actuallyLength;
@property (nonatomic, assign) NSInteger allPacketCount;

- (id)initWithLength:(NSInteger)allLength mgsId:(NSInteger)udpMsgId;
- (void)changeActuallyLength:(NSInteger)length;
- (void)addhavePacketCount;

@end
