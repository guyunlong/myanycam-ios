//
//  AudioRecordEngine.h
//  Myanycam
//
//  Created by myanycam on 13-3-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioRecordDelegate.h"
//#import "webrtc_vad.h"
#ifndef max
#define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

#ifndef min
#define min( a, b ) ( ((a) < (b)) ? (a) : (b) )
#endif


@interface AudioRecordEngine : NSObject{
    
    AudioComponentInstance audioUnit;
	AudioBuffer tempBuffer; // this will hold the latest data from the microphone
    id<AudioRecordDelegate>     _delegate;
    NSData * _currentData;
    
    @public
    AudioBufferList    _input_buffer_list;
//    struct WebRtcVadInst    * vadInt;
    NSMutableData       *_pcmDataBuffer;
    NSMutableData       *_novalPcmDataBuffer;
    
    NSMutableData       *_pcmData;
    NSMutableData       *_adpcmData;
    NSInteger            _count;
    NSInteger            _leng;
    
}
@property (retain, nonatomic) NSMutableData * pcmDataBuffer;
@property (retain, nonatomic) NSMutableData * novalPcmDataBuffer;
@property (retain, nonatomic) NSData    * currentData;
@property (assign, nonatomic) id<AudioRecordDelegate>   delegate;
@property (readonly) AudioComponentInstance audioUnit;
@property (readonly) AudioBuffer tempBuffer;


- (id) init;

- (void) start;
- (void) stop;
- (void) processAudio: (AudioBufferList*) bufferList;

@end

// setup a global iosAudio variable, accessible everywhere
extern AudioRecordEngine* iosAudio;

