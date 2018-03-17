//
//  AACPlayer.h
//  Myanycam
//
//  Created by myanycam on 13/6/4.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaData.h"
#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <netinet/in.h>
#include <unistd.h>
#include <pthread.h>
#include <AudioToolbox/AudioToolbox.h>

//#define kNumAQBufs   3			// number of audio queue buffers we allocate
//#define kAQBufSize   1 * 384		// number of bytes in each audio queue buffer
//#define kAQMaxPacketDescs   3//512;		// number of packet descriptions in our array

//#define kNumAQBufs   6			// number of audio queue buffers we allocate
//#define kAQBufSize   1 * 512		// number of bytes in each audio queue buffer
//#define kAQMaxPacketDescs   3//512;		// number of packet descriptions in our array

struct MyData
{
	AudioFileStreamID audioFileStream;	// the audio file stream parser
    
	AudioQueueRef audioQueue;								// the audio queue
//	AudioQueueBufferRef audioQueueBuffer[kNumAQBufs];		// audio queue buffers andida
//	AudioStreamPacketDescription packetDescs[kAQMaxPacketDescs];	// packet descriptions for enqueuing audio andida
	
	unsigned int fillBufferIndex;	// the index of the audioQueueBuffer that is being filled
	size_t bytesFilled;				// how many bytes have been filled
	size_t packetsFilled;			// how many packets have been filled
    
//	bool inuse[kNumAQBufs];			// flags to indicate that a buffer is still in use   andida
	bool started;					// flag to indicate that the queue has been started
	bool failed;					// flag to indicate an error occurred
    
	pthread_mutex_t mutex;			// a mutex to protect the inuse flags
	pthread_cond_t cond;			// a condition varable for handling the inuse flags
	pthread_cond_t done;			// a condition varable for handling the inuse flags
    pthread_mutex_t mutex2;
    
    NSInteger     buffersUsed;
    enum AUDIO_PLAY_STATE    audioDecodeFlag;
    BOOL          needCheckBuffersUsed;
    
    NSInteger   _numAQBufs;
    NSInteger   _AQBufSize;
    NSInteger   _AQMaxPacketDescs;
    
    bool * _pInuse;
    AudioQueueBufferRef *_pAudioQueueBufferRef;
    AudioStreamPacketDescription * _ppacketDescs;
    
    
};

typedef struct MyData MyData;


@interface AACPlayer : NSObject{
    
    MediaData * _selectData;
    enum AUDIO_PLAY_STATE    _audioDecodeFlag;
    BOOL                     _decodeFlag;
    MyData *                 _myPlayData;
    NSTimer     * _audioTimer;
    BOOL          _hasReceiveAudio;
    NSInteger     _format;
    
    NSMutableData * _aacDataTest;
    
    NSInteger      _count;

    
}

@property (retain, nonatomic) NSTimer * audioTimer;
@property (retain, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) MediaData * selectData;
@property (assign, nonatomic) MyData * myPlayData;
@property (assign, nonatomic) enum AUDIO_PLAY_STATE audioDecodeFlag;
//@property (assign, nonatomic) NSInteger buffersUsed;

- (id)initWithFormat:(int)aFormat;

- (void)aacplay;
- (void)stop;
- (void)pause;
- (void)play;
- (void)resetPlayer;
- (void)startCheckBufferState;



@end
