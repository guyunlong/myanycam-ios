//
//  PCMplayEngine.m
//  MyAnyCam
//
//  Created by andida on 13-1-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PCMplayEngine.h"
#import "MYDataManager.h"

//#define AVCODEC_MAX_AUDIO_FRAME_SIZE  480//4096*2// (0x10000)/4
//static UInt32 gBufferSizeBytes=0x10000;//65536
static UInt32 gBufferSizeBytes=0x100000;//It must be pow(2,x)

@implementation PCMplayEngine
@synthesize  dataArray = _dataArray;
@synthesize audioDeocdeFlag = _audioDeocdeFlag;
@synthesize queue;
@synthesize selectData = _selectData;
//@synthesize m_pEchoState = _pEchoState;
//@synthesize m_pPreprocessState = _pPreprocessState;

//回调函数(Callback)的实现
static void BufferCallback(void *inUserData,AudioQueueRef inAQ,
                           AudioQueueBufferRef buffer){
    
    PCMplayEngine* player=( PCMplayEngine*)inUserData;
    [player audioQueueOutputWithQueue:inAQ queueBuffer:buffer];
//    DebugLog(@"*****BufferCallback");
}


//缓存数据读取方法的实现
-(void) audioQueueOutputWithQueue:(AudioQueueRef)audioQueue queueBuffer:(AudioQueueBufferRef)audioQueueBuffer{
    //读取包数据
    
        if (_selectData) {
            @synchronized(self.dataArray)
            {
                [self.dataArray removeObject:_selectData];
                _selectData = nil;
            }
        }
        //成功读取时
        AudioQueueBufferRef outBufferRef=audioQueueBuffer;
        MediaData * mediaData = nil;
        
        if ([self.dataArray count] >3 ) {
            
//            if ([self.dataArray count] < 10) {
//                float sleepTime = 10 - [self.dataArray count];
//                usleep(sleepTime * 1000 * 10);
//            }
            
            mediaData = [self.dataArray objectAtIndex:0];
            while ( [self.dataArray count] > 50 && mediaData.time < [MYDataManager shareManager].currentVideoFrameTimeStamp ) {
                
                [self.dataArray removeObject:mediaData];
                mediaData = [self.dataArray objectAtIndex:0];

            }
            
            _selectData = mediaData;
        }
        
        DebugLog(@"BufferCallback[self.dataArray count]  === %d",[self.dataArray count] );
        
        if(mediaData){
            
            short * indata =  (short*) malloc( mediaData.mediaData.length *4);
            unsigned long ulAdpcmLen = mediaData.mediaData.length;
            unsigned long ulPcmLen = 0;
            
            int ccc  = DecodeAdpcm((char *)[mediaData.mediaData bytes], ulAdpcmLen, indata, &ulPcmLen);
            if (ccc == 0) {
                
//                DebugLog(@"ulPcmLen %lu",ulPcmLen);
                
//                if (ulPcmLen == 320 && self.m_pPreprocessState) {
//                    speex_preprocess_run(self.m_pPreprocessState, (spx_int16_t *)indata);   //消除噪音
//                }

                
                memcpy(outBufferRef->mAudioData, indata, ulPcmLen);
                outBufferRef->mAudioDataByteSize = ulPcmLen;
                AudioQueueEnqueueBuffer(audioQueue, outBufferRef, 0, nil);
                
                if ([self.dataArray count] == 4) {
                    
                    [self pause];
                }
            }
            
            free(indata);
        }
        else{
            
            [self pause];
        }
    

}

-(void)initAudioSession
{
    //初始化：如果这个忘了的话，可能会第一次播放不了
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    OSStatus error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    if (error) {
        
    }
    
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride),&audioRouteOverride);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
    AudioSessionSetActive(true);
    
}


//音频播放方法的实现
-(id) initWithAudio:(NSMutableArray *)dataArray{
    if (!(self=[super init])) return nil;
    
    
    [self initAudioSession];
    self.dataArray = dataArray;

    for (int i=0; i<NUM_BUFFERS; i++) {
        AudioQueueEnqueueBuffer(queue, buffers[i], 0, nil);
    }
    
    //取得音频数据格式
    {
        dataFormat.mSampleRate = 8000;//采样频率
        dataFormat.mFormatID = kAudioFormatLinearPCM;
        dataFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        dataFormat.mFramesPerPacket = 1;//wav 通常为1
        dataFormat.mChannelsPerFrame =1 ;//通道数
        dataFormat.mBitsPerChannel = 16;//采样的位数
        dataFormat.mBytesPerPacket = dataFormat.mBytesPerFrame = (dataFormat.mBitsPerChannel / 8) * dataFormat.mChannelsPerFrame;
        dataFormat.mReserved=0;
    }
    
    //创建播放用的音频队列
    AudioQueueNewOutput(&dataFormat, BufferCallback, self,
                        nil, nil, 0, &queue);  

    //创建并分配缓冲控件
    [self prepareAudioBuffer];
    
    Float32 gain= 10.0;
    //设置音量
    AudioQueueSetParameter(queue, kAudioQueueParam_Volume, gain);
    //队列处理开始，此后系统开始自动调用回调(Callback)函数
    AudioQueueStart(queue, nil);
    
//    int nSampRate = 8000;
//    SpeexEchoState *  m_pEchoState = speex_echo_state_init(160,1280);
//	SpeexPreprocessState * m_pPreprocessState = speex_preprocess_state_init(160, nSampRate);
//    speex_echo_ctl(m_pEchoState, SPEEX_ECHO_SET_SAMPLING_RATE, &nSampRate);
//    speex_preprocess_ctl(m_pPreprocessState, SPEEX_PREPROCESS_SET_ECHO_STATE, m_pEchoState);
    
    //降噪
//	int denoise = 1;
//    int noiseSuppress = -25;
//    speex_preprocess_ctl(m_pPreprocessState, SPEEX_PREPROCESS_SET_DENOISE, &denoise); //降噪
//    speex_preprocess_ctl(m_pPreprocessState, SPEEX_PREPROCESS_SET_NOISE_SUPPRESS, &noiseSuppress); //设置噪声的dB
    
    
//    int agc = 1;
//    int level = 24000;
    //actually default is 8000(0,32768),here make it louder for voice is not loudy enough by default.
//    speex_preprocess_ctl(m_pPreprocessState, SPEEX_PREPROCESS_SET_AGC, &agc);// 增益
//    speex_preprocess_ctl(m_pPreprocessState, SPEEX_PREPROCESS_SET_AGC_LEVEL,&level);
    
//    self.m_pEchoState = m_pEchoState;
//    self.m_pPreprocessState = m_pPreprocessState;
    
    return self;
}

- (void)prepareAudioBuffer{
    
    for (int i=0; i<NUM_BUFFERS; i++) {
        AudioQueueAllocateBuffer(queue, gBufferSizeBytes, &buffers[i]);
        //读取包数据
        if ([self readPacketsIntoBuffer:buffers[i]]==1) {
            break;
        }
    }
}

-(void)play{
    
    if (queue != NULL) {
        
        if (self.audioDeocdeFlag == AUDIO_PLAY_STATE_STOP) {
            [self prepareAudioBuffer];
        }

       OSStatus status =  AudioQueueStart(queue, nil);
        if (status < 0) {
            
            self.audioDeocdeFlag = AUDIO_PLAY_STATE_STOP;
        }
        else{
            self.audioDeocdeFlag = AUDIO_PLAY_STATE_PLAY;
        }
        
    }
}

- (void)stop{
    
    AudioQueueStop(queue, NO);
    self.audioDeocdeFlag = AUDIO_PLAY_STATE_STOP;
}

- (void)pause{
    
    AudioQueuePause(queue);
    self.audioDeocdeFlag = AUDIO_PLAY_STATE_PAUSE;
    _selectData = nil;
}

-(UInt32)readPacketsIntoBuffer:(AudioQueueBufferRef)buffer {

    AudioQueueBufferRef outBufferRef = buffer;  
    MediaData  * mediaData = nil;
    if ([self.dataArray count] > 0) {
        mediaData = [self.dataArray objectAtIndex:0];
        
    }
    
    if(mediaData){
        
        short * indata =  (short*) malloc( mediaData.mediaData.length *4);
        unsigned long ulAdpcmLen = mediaData.mediaData.length;
        unsigned long ulPcmLen = 0;
        int ccc  = DecodeAdpcm((char *)[mediaData.mediaData bytes], ulAdpcmLen, indata, &ulPcmLen);
        if (ccc == 0) {
            memcpy(outBufferRef->mAudioData, indata, mediaData.mediaData.length * 4);
            outBufferRef->mAudioDataByteSize= mediaData.mediaData.length;
            AudioQueueEnqueueBuffer(queue, outBufferRef, 0, nil);
        }
        free(indata);
    }
    else{
        
        return 1;//意味着我们没有读到任何的包
    }
    return 0;//0代表正常的退出
}

- (void)dealloc{
    
    AudioQueueStop(queue, YES);
    AudioQueueDispose(queue, true);
    queue = NULL;
    self.dataArray = nil;
    self.selectData = nil;
    
//    speex_echo_state_destroy(self.m_pEchoState);
//    speex_preprocess_state_destroy(self.m_pPreprocessState);
    
    [super dealloc];
    
}
@end
