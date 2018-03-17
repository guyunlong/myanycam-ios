//
//  PCMplayEngine.h
//  MyAnyCam
//
//  Created by andida on 13-1-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/AudioQueue.h>
#import "ak_adpcm.h"
#define NUM_BUFFERS 3



@interface PCMplayEngine : NSObject{
    //音频流描述对象
    AudioStreamBasicDescription dataFormat;
    //音频队列
    AudioQueueRef queue;
    UInt32 bufferByteSize;
    AudioStreamPacketDescription *packetDescs;
    AudioQueueBufferRef buffers[NUM_BUFFERS];
    NSMutableArray * _dataArray;
    MediaData * _selectData;
    enum AUDIO_PLAY_STATE    _audioDeocdeFlag;
    NSMutableData * _aacDataTest;
    
//    SpeexEchoState * _pEchoState;                       //消除回音
//	SpeexPreprocessState * _pPreprocessState;			//噪声抑制
    
}
@property (assign, nonatomic) MediaData * selectData;
//定义队列为实例属性
@property (assign,nonatomic)    enum AUDIO_PLAY_STATE audioDeocdeFlag;
@property AudioQueueRef queue;
@property (assign,nonatomic) NSMutableArray * dataArray;

//@property (assign, nonatomic) SpeexEchoState * m_pEchoState;
//@property (assign, nonatomic) SpeexPreprocessState * m_pPreprocessState;			//噪声抑制
//播放方法定义
-(id)initWithAudio:(NSMutableArray *) path;
//定义缓存数据读取方法
-(void) audioQueueOutputWithQueue:(AudioQueueRef)audioQueue
                      queueBuffer:(AudioQueueBufferRef)audioQueueBuffer;
-(UInt32)readPacketsIntoBuffer:(AudioQueueBufferRef)buffer;
//定义回调(Callback)函数
static void BufferCallack(void *inUserData,AudioQueueRef inAQ,
                          AudioQueueBufferRef buffer);
- (void)play;
- (void)pause;
- (void)stop;

@end