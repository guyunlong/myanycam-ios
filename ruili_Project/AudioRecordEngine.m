//
//  AudioRecordEngine.m
//  Myanycam
//
//  Created by myanycam on 13-3-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AudioRecordEngine.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ak_adpcm.h"
#import "MYDataManager.h"


#define kOutputBus 0
#define kInputBus 1

AudioRecordEngine* iosAudio;


void checkStatus(int status){
	if (status) {
		printf("Status not 0! %d\n", status);
        
#ifdef DEBUG
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
#endif
        
//        DebugLog(@"error ===%@",error);
        //		exit(1);
	}
}





/**
 This callback is called when new audio data from the microphone is
 available.
 */
static OSStatus recordingCallback(void *inRefCon,
                                  AudioUnitRenderActionFlags *ioActionFlags,
                                  const AudioTimeStamp *inTimeStamp,
                                  UInt32 inBusNumber,
                                  UInt32 inNumberFrames,
                                  AudioBufferList *ioData) {
	
	// Because of the way our audio format (setup below) is chosen:
	// we only need 1 buffer, since it is mono
	// Samples are 16 bits = 2 bytes.
	// 1 frame includes only 1 sample

	// Put buffer in a AudioBufferList
    
    AudioBufferList* abl = &iosAudio->_input_buffer_list;
    abl->mNumberBuffers = 1;
    abl->mBuffers[0].mNumberChannels = 1;
    abl->mBuffers[0].mData = NULL;
    abl->mBuffers[0].mDataByteSize = inNumberFrames * 2;
	
    // Then:
    // Obtain recorded samples
	
    OSStatus status;
    
    status = AudioUnitRender([iosAudio audioUnit],
                             ioActionFlags,
                             inTimeStamp,
                                      1,
                             inNumberFrames,
                             abl);
    if(status != noErr) {
        return status;
    }
	checkStatus(status);
	
    // Now, we have the samples we just read sitting in buffers in bufferList
	// Process the new data
	[iosAudio processAudio:abl];
	
	// release the malloc'ed data in the buffer we created earlier
//	free(abl->mBuffers[0].mData);
	
    return noErr;
}

@implementation AudioRecordEngine

@synthesize audioUnit, tempBuffer;
@synthesize delegate = _delegate;
@synthesize currentData = _currentData;
@synthesize pcmDataBuffer = _pcmDataBuffer;
@synthesize novalPcmDataBuffer = _novalPcmDataBuffer;

/**
 Initialize the audioUnit and allocate our own temporary buffer.
 The temporary buffer will hold the latest data coming in from the microphone,
 and will be copied to the output when this is requested.
 */
- (id) init {
	self = [super init];
    
	self.pcmDataBuffer = [NSMutableData dataWithCapacity:1000];
    self.novalPcmDataBuffer = [NSMutableData  dataWithCapacity:1000];
    
	OSStatus status;
	
	// Describe audio component
	AudioComponentDescription desc;
	desc.componentType = kAudioUnitType_Output;
	desc.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
	desc.componentFlags = 0;
	desc.componentFlagsMask = 0;
	desc.componentManufacturer = kAudioUnitManufacturer_Apple;
	// Get component
	AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
	
	// Get audio units
	status = AudioComponentInstanceNew(inputComponent, &audioUnit);
	checkStatus(status);
	
	// Enable IO for recording
	UInt32 flag = 1;
	status = AudioUnitSetProperty(audioUnit,
								  kAudioOutputUnitProperty_EnableIO,
								  kAudioUnitScope_Input,
								  kInputBus,
								  &flag,
								  sizeof(flag));
	checkStatus(status);
    
//    int zero = 0;
    int one = 1;
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Output,
                                  one,
                                  &one,
                                  sizeof(UInt32));
    checkStatus(status);

    
    // Describe format
	AudioStreamBasicDescription audioFormat;
	audioFormat.mSampleRate			= 8000;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagsCanonical;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 1;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 2;
	audioFormat.mBytesPerFrame		= 2;
    audioFormat.mReserved           = 0;
	    
    // Apply format

	status = AudioUnitSetProperty(audioUnit,
								  kAudioUnitProperty_StreamFormat,
								  kAudioUnitScope_Input,
								  kOutputBus,
								  &audioFormat,
								  sizeof(audioFormat));
	checkStatus(status);
    
    status = AudioUnitSetProperty(audioUnit,
								  kAudioUnitProperty_StreamFormat,
								  kAudioUnitScope_Output,
								  kInputBus,
								  &audioFormat,
								  sizeof(audioFormat));
	checkStatus(status);
    
    
    
	
	// Set input callback
	AURenderCallbackStruct callbackStruct;
	// Set output callback
	callbackStruct.inputProc = recordingCallback;
	callbackStruct.inputProcRefCon = self;
	status = AudioUnitSetProperty(audioUnit,
								  kAudioOutputUnitProperty_SetInputCallback,//kAudioUnitProperty_SetRenderCallback,
								  kAudioUnitScope_Global,//kAudioUnitScope_Input,
								  kOutputBus,
								  &callbackStruct,
								  sizeof(AURenderCallbackStruct));
	checkStatus(status);
	
	// Initialise
	status = AudioUnitInitialize(audioUnit);
	checkStatus(status);
    
    [self initAudioSession];

    iosAudio = self;
    
//    int result = WebRtcVad_Create(&vadInt);
//    if (result < 0) {
//        DebugLog(@"WebRtcVad_InitCore error %d",result);
//    }
//    
//    result = WebRtcVad_Init(vadInt);
//    DebugLog(@"WebRtcVad_Init error %d",result);
//
//    result = WebRtcVad_set_mode(vadInt,2);
//    DebugLog(@"WebRtcVad_set_mode error %d",result);

    
    return self;
}

/**
 Start the audioUnit. This means data will be provided from
 the microphone, and requested for feeding to the speakers, by
 use of the provided callbacks.
 */
- (void) start {
    
	OSStatus status = AudioOutputUnitStart(audioUnit);
	checkStatus(status);
    
//    [NSThread detachNewThreadSelector:@selector(checkVadData) toTarget:self withObject:nil];
//    [NSThread detachNewThreadSelector:@selector(sendAudioData) toTarget:self withObject:nil];
}

/**
 Stop the audioUnit
 */
- (void) stop {
    
	OSStatus status = AudioOutputUnitStop(audioUnit);
	checkStatus(status);
}

- (void)initAudioSession
{
    //初始化：如果这个忘了的话，可能会第一次播放不了
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    OSStatus error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    if (error) {
        DebugLog(@"kAudioSessionCategory_PlayAndRecord error %ld",error);
    }

    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    error =  AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
    
    audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (audioRouteOverride),&audioRouteOverride);
    
    if (error) {
        DebugLog(@"kAudioSessionOverrideAudioRoute_None error %ld",error);
    }
    
    
//    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
//    if(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
//                               sizeof(UInt32), &sessionCategory) != noErr) {
//
//    }
    
    Float32 bufferSizeInSec = 0.06f;
    if(AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration,
                               sizeof(Float32), &bufferSizeInSec) != noErr) {

    }
    
//    Float64 sampleRate = 8000;
//    AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate,
//                                     sizeof(sampleRate), &sampleRate);
    
     AudioSessionSetActive(true);
    
}


/**
 Change this funtion to decide what is done with incoming
 audio data from the microphone.
 Right now we copy it to our own temporary buffer.
 */
- (void) processAudio: (AudioBufferList*) bufferList{
    
	AudioBuffer sourceBuffer = bufferList->mBuffers[0];
    
//    @synchronized(self.pcmDataBuffer){
    
//        [self.pcmDataBuffer appendBytes:sourceBuffer.mData length:sourceBuffer.mDataByteSize];
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordCompleteWithData:)])
    {
        
        char * outdata =  (char*) malloc( sourceBuffer.mDataByteSize /4 );
        unsigned long ulAdpcmLen = 0;
        
        int ddd  = EncodeAdpcm((short *)(sourceBuffer.mData),sourceBuffer.mDataByteSize/2,outdata,&ulAdpcmLen);
        if (ddd == 0) {
            
            NSData * data = [[NSData alloc] initWithBytes:outdata length:ulAdpcmLen];
//            DebugLog(@"data length== %d  sourceBuffer.mDataByteSize == %d",[data length],(int)sourceBuffer.mDataByteSize);
            [self.delegate audioRecordCompleteWithData:data];
            _leng = [data length];
            DebugLog(@"leng = %d",_leng);
            [data release];
        }
        free(outdata);
    }

}

- (void)checkVadData{
    
    @synchronized(self.pcmDataBuffer){
        
        NSRange range = NSMakeRange(0, 240);
        
        while (1) {
            
            if ([self.pcmDataBuffer length] >240) {
                
                NSData * data = [self.pcmDataBuffer subdataWithRange:range];
                int error = 0;//WebRtcVad_Process(vadInt, 8000, (int16_t*)data.bytes, 240);
                
                if (error > 0) {
                    
                    [self.novalPcmDataBuffer appendData:data];
                   
                }
                
                DebugLog(@"error %d data == %@",error, data);
                
                @synchronized(self.pcmDataBuffer)
                {
                    [self.pcmDataBuffer replaceBytesInRange:range withBytes:NULL length:0];
                }
            }
        }
    }
}

- (void)sendAudioData{
    
    
    int len = 512;
    while (1) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordCompleteWithData:)])
        {
            
            if ([self.novalPcmDataBuffer length] > len) {
                
                NSData * pcmdata = [self.novalPcmDataBuffer subdataWithRange:NSMakeRange(0, len)];
                
                char * outdata =  (char*) malloc( len /4 );
                unsigned long ulAdpcmLen = 0;
                
                int ddd  = EncodeAdpcm((short *)[pcmdata bytes],len/2,outdata,&ulAdpcmLen);
                if (ddd == 0) {
                    
                    NSData * data = [[NSData alloc] initWithBytes:outdata length:ulAdpcmLen];
                    DebugLog(@"data length== %d  sourceBuffer.mDataByteSize == %d",[data length],(int)len);
                    [self.delegate audioRecordCompleteWithData:data];
                    [data release];
                }
                free(outdata);
                
                @synchronized(self.novalPcmDataBuffer)
                {
                    [self.novalPcmDataBuffer replaceBytesInRange:NSMakeRange(0, len) withBytes:NULL length:0];
                }

            }

        }
    }
}

/**
 Clean up.
 */
- (void) dealloc {
    

    AudioUnitUninitialize(audioUnit);
	free(tempBuffer.mData);
//    WebRtcVad_Free(vadInt);
    self.currentData = nil;
    self.pcmDataBuffer = nil;
    self.novalPcmDataBuffer = nil;
	[super	dealloc];

}


@end
