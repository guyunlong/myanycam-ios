//
//  MYRecordAudioEngine.h
//  Myanycam
//
//  Created by myanycam on 13-3-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "AudioRecordDelegate.h"
//#import "noise_suppression.h"
//#import "aecm_core.h"

@protocol  AudioRecordDelegate ;
// use Audio Queue

// Audio Settings
#define kNumberBuffers      3

#define t_sample             SInt16

#define kSamplingRate       8000
#define kNumberChannels     1
#define kBitsPerChannels    (sizeof(t_sample) * 8)
#define kBytesPerFrame      (kNumberChannels * sizeof(t_sample))
//#define kFrameSize          (kSamplingRate * sizeof(t_sample))
#define kFrameSize          480//1024*3


typedef struct AQCallbackStruct
{
    AudioStreamBasicDescription mDataFormat;
    AudioQueueRef               queue;
    AudioQueueBufferRef         mBuffers[kNumberBuffers];
    AudioFileID                 outputFile;
    id<AudioRecordDelegate>     _delegate;
    unsigned long               frameSize;
    long long                   recPtr;
    int                         run;
} AQCallbackStruct;


@interface MYRecordAudioEngine : NSObject
{
    AQCallbackStruct aqc;
    AudioFileTypeID fileFormat;
//    NsHandle    * handle;
//    AecmCore_t *aecmCore;
    
}

- (id) init;
- (void) start;
- (void) stop;
- (void) pause;

- (void) processAudioBuffer:(AudioQueueBufferRef) buffer withQueue:(AudioQueueRef) queue;

@property (nonatomic, assign) AQCallbackStruct aqc;
@property (assign, nonatomic) id<AudioRecordDelegate>   delegate;

@end

