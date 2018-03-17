//
//  MYRecordAudioEngine.m
//  Myanycam
//
//  Created by myanycam on 13-3-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYRecordAudioEngine.h"
#import "ak_adpcm.h"

@implementation MYRecordAudioEngine


@synthesize aqc;
@synthesize delegate = _delegate;

static void AQInputCallback (void                   * inUserData,
                             AudioQueueRef          inAudioQueue,
                             AudioQueueBufferRef    inBuffer,
                             const AudioTimeStamp   * inStartTime,
                             unsigned long          inNumPackets,
                             const AudioStreamPacketDescription * inPacketDesc)
{
    
    MYRecordAudioEngine * engine = (MYRecordAudioEngine *) inUserData;
    if (inNumPackets > 0)
    {
        [engine processAudioBuffer:inBuffer withQueue:inAudioQueue];
    }
    
    if (engine.aqc.run)
    {
        AudioQueueEnqueueBuffer(engine.aqc.queue, inBuffer, 0, NULL);
    }
}

-(void)initAudioSession
{

    //初始化：如果这个忘了的话，可能会第一次播放不了
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    OSStatus error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    if (error) {
        DebugLog(@"kAudioSessionCategory_PlayAndRecord error %ld",error);
    }
    
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
//    error = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride),&audioRouteOverride);
//    if (error) {
//        DebugLog(@"kAudioSessionOverrideAudioRoute_None error %ld",error);
//    }
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
    
    audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (audioRouteOverride),&audioRouteOverride);
    
    
    UInt32 mode = kAudioSessionMode_VoiceChat;
    error = AudioSessionSetProperty(kAudioSessionProperty_Mode, sizeof(mode), &mode);
    if (error) printf("couldn't set audio session mode!");
    
    AudioSessionSetActive(true);
    
}


- (id) init
{
    self = [super init];
    
    if (self)
    {
        
        aqc.mDataFormat.mSampleRate = kSamplingRate;
        aqc.mDataFormat.mFormatID = kAudioFormatLinearPCM;
        aqc.mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        aqc.mDataFormat.mFramesPerPacket = 1;
        aqc.mDataFormat.mChannelsPerFrame = kNumberChannels;
        
        aqc.mDataFormat.mBitsPerChannel = kBitsPerChannels;
        
        aqc.mDataFormat.mBytesPerPacket = kBytesPerFrame;
        aqc.mDataFormat.mBytesPerFrame = kBytesPerFrame;
        
        aqc.frameSize = kFrameSize;
        
        AudioQueueNewInput(&aqc.mDataFormat, AQInputCallback, self, NULL, kCFRunLoopCommonModes, 0, &aqc.queue);
        
        for (int i=0;i<kNumberBuffers;i++)
        {
            AudioQueueAllocateBuffer(aqc.queue, aqc.frameSize, &aqc.mBuffers[i]);
            AudioQueueEnqueueBuffer(aqc.queue, aqc.mBuffers[i], 0, NULL);
        }
        
        aqc.recPtr = 0;
        aqc.run = 1;
        
//        handle = NULL;
//        
//        WebRtcNs_Create(&handle);
//        WebRtcNs_Init(handle,kSamplingRate);
//        WebRtcNs_set_policy(handle,2);
//        
//        aecmCore = NULL;
//        WebRtcAecm_CreateCore(&aecmCore);
//        WebRtcAecm_InitCore(aecmCore, kSamplingRate);
//        WebRtcAecm_BufferFarend
        [self initAudioSession];

    }
    
    return self;
}

- (void) dealloc
{
    AudioQueueStop(aqc.queue, true);
    aqc.run = 0;
    AudioQueueDispose(aqc.queue, true);
    self.delegate = nil;
    
//    WebRtcNs_Free(handle);
//    handle = NULL;
    
    [super dealloc];
}


- (void) start
{
    AudioQueueStart(aqc.queue, NULL);
}

- (void) stop
{
    self.delegate = nil;
    AudioQueueStop(aqc.queue, true);
}

- (void) pause
{
    AudioQueuePause(aqc.queue);
}

- (void) processAudioBuffer:(AudioQueueBufferRef) buffer withQueue:(AudioQueueRef) queue
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    long size = buffer->mAudioDataByteSize ;/// aqc.mDataFormat.mBytesPerPacket;
    t_sample * data = (t_sample *) buffer->mAudioData;
    
    //DebugLog(@"processAudioData :%ld", buffer->mAudioDataByteSize);
    //处理data
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordCompleteWithData:)])
    {

        
//        int ret = WebRtcNs_Process(handle, data, nil, data, nil);
//        NSLog(@"%d",ret);
        
        char * outdata =  (char*) malloc( size/4 );
        unsigned long ulAdpcmLen = 0;
        
        int ddd  = EncodeAdpcm((short *)(data),size/2,outdata,&ulAdpcmLen);
        if (ddd == 0) {
            
            NSData * data = [[NSData alloc] initWithBytes:outdata length:ulAdpcmLen];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.delegate audioRecordCompleteWithData:data];

            });
            [data release];
        }
        free(outdata);
        
    }
    
    [pool release];
}

- (void)popDataByDelegate:(id)sender{
    
//    [self.delegate audioRecordCompleteWithData:sender];

}

@end
