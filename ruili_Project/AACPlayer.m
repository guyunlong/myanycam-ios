//
//  AACPlayer.m
//  Myanycam
//
//  Created by myanycam on 13/6/4.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AACPlayer.h"

BOOL flagDecodeAudio;

void MyAudioQueueOutputCallback(void* inClientData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer);
void MyAudioQueueIsRunningCallback(void *inUserData, AudioQueueRef inAQ, AudioQueuePropertyID inID);

void MyPropertyListenerProc(	void *							inClientData,
                            AudioFileStreamID				inAudioFileStream,
                            AudioFileStreamPropertyID		inPropertyID,
                            UInt32 *						ioFlags);

void MyPacketsProc(				void *							inClientData,
                   UInt32							inNumberBytes,
                   UInt32							inNumberPackets,
                   const void *					inInputData,
                   AudioStreamPacketDescription	*inPacketDescriptions);

void MyEnqueueBuffer(MyData* myData);
void WaitForFreeBuffer(MyData* myData);



@implementation AACPlayer

@synthesize dataArray;
@synthesize selectData = _selectData;
@synthesize myPlayData = _myPlayData;
@synthesize audioTimer = _audioTimer;

- (void)dealloc{
    
    [self.audioTimer invalidate];
    self.audioTimer = nil;
    self.myPlayData = nil;
    self.dataArray = nil;
    self.selectData = nil;
    _myPlayData = nil;
    [super dealloc];
}


- (void)stop{
    
     _decodeFlag = NO;
    flagDecodeAudio = NO;
    
    if (!_myPlayData || _myPlayData->audioDecodeFlag == AUDIO_PLAY_STATE_STOP) {
        return;
    }
    _myPlayData->audioDecodeFlag = AUDIO_PLAY_STATE_STOP;
    MyEnqueueBuffer(_myPlayData);

    // enqueue last buffer
    
	printf("flushing\n");
	OSStatus err  = AudioQueueFlush(_myPlayData->audioQueue);
	if (err) { DebugLog(@"AudioQueueFlush"); return ; }
    
	printf("stopping\n");
	err = AudioQueueStop(_myPlayData->audioQueue, YES);
	if (err) { DebugLog(@"AudioQueueStop"); return ; }
    
    usleep(100*1000);
//	printf("waiting until finished playing..\n");
//	pthread_mutex_lock(&_myPlayData->mutex);
//	pthread_cond_wait(&_myPlayData->done, &_myPlayData->mutex);
//	pthread_mutex_unlock(&_myPlayData->mutex);
//	printf("done\n");
    
	// cleanup
	err = AudioFileStreamClose(_myPlayData->audioFileStream);
    if (err) { DebugLog(@"AudioFileStreamClose"); return ; }
    
    DebugLog(@"AudioFileStreamClose");
	err = AudioQueueDispose(_myPlayData->audioQueue, false);
    if (err) { DebugLog(@"AudioQueueDispose"); return ; }
    DebugLog(@"AudioQueueDispose");
    
    free(_myPlayData->_pInuse);
    _myPlayData->_pInuse = nil;
    DebugLog(@"_pInuse");
    free(_myPlayData->_ppacketDescs);
    _myPlayData->_ppacketDescs = nil;
    
    DebugLog(@"_ppacketDescs");
    
    free(_myPlayData->_pAudioQueueBufferRef);
    _myPlayData->_pAudioQueueBufferRef = nil;
    
    DebugLog(@"_pAudioQueueBufferRef");
    
	free(_myPlayData);
	_myPlayData = nil;
    
    DebugLog(@"AudioQueueDispose end");
}

- (void)pause{
    
    if (_myPlayData->audioDecodeFlag == AUDIO_PLAY_STATE_PAUSE) {
        return;
    }
    
    _myPlayData->audioDecodeFlag = AUDIO_PLAY_STATE_PAUSE;
    AudioQueuePause(_myPlayData->audioQueue);
}

- (void)play{
    

    if(_myPlayData->audioDecodeFlag != AUDIO_PLAY_STATE_PLAY){
        
        _myPlayData->audioDecodeFlag = AUDIO_PLAY_STATE_PLAY;
        
        Float32 gain = 10.0;
        AudioQueueSetParameter(_myPlayData->audioQueue, kAudioQueueParam_Volume, gain);
        AudioQueueStart(_myPlayData->audioQueue, NULL);
    }
}

- (id)initWithFormat:(int )aFormat{
    
    self = [super init];
    if (self) {
        
        _format = aFormat;
    }
    
    return self;
}

- (void)aacplay{
    
    flagDecodeAudio = YES;
    
    [self initAudioSession];
    DebugLog(@"aacplay init");
	// allocate a struct for storing our state
	MyData* myData = (MyData*)calloc(1, sizeof(MyData));
    _myPlayData = myData;
    _myPlayData->audioDecodeFlag = AUDIO_PLAY_STATE_PREPARE;
    if (_format == 3) {
        
        _myPlayData->_AQBufSize = 1 * 512;
        _myPlayData->_numAQBufs = 6 ;
        _myPlayData->_AQMaxPacketDescs = 3;
        
    }
    
    if (_format == 4) {
        
        _myPlayData->_AQBufSize = 1 * 384;
        _myPlayData->_numAQBufs = 3 ;
        _myPlayData->_AQMaxPacketDescs = 3;
    }
    
    _myPlayData->_pInuse = (bool *)calloc(_myPlayData->_numAQBufs,sizeof(bool));
    _myPlayData->_pAudioQueueBufferRef = (AudioQueueBufferRef *)calloc(_myPlayData->_AQBufSize,sizeof(AudioQueueBufferRef));
    _myPlayData->_ppacketDescs = (AudioStreamPacketDescription *)calloc(_myPlayData->_AQMaxPacketDescs,sizeof(AudioStreamPacketDescription));
    
    
    self.audioDecodeFlag = AUDIO_PLAY_STATE_PREPARE;
	// initialize a mutex and condition so that we can block on buffers in use.
	pthread_mutex_init(&myData->mutex, NULL);
    pthread_mutex_init(&myData->mutex2, NULL);
	pthread_cond_init(&myData->cond, NULL);
	pthread_cond_init(&myData->done, NULL);
	
    
    // create an audio file stream parser
	OSStatus err = AudioFileStreamOpen(myData,
                                       MyPropertyListenerProc,
                                       MyPacketsProc,
                                       kAudioFileAAC_ADTSType,
                                       &myData->audioFileStream
                                       );
	if (err) {
        
        DebugLog(@"AudioFileStreamOpen");
        return ;
    }
	
   
    _hasReceiveAudio = YES;
    _decodeFlag = YES;
    
    [NSThread detachNewThreadSelector:@selector(startDecodeAac) toTarget:self withObject:nil];
}

- (void)startCheckBufferState{
    
    
    OSStatus err = nil;
    //
    // If there are no queued buffers, we need to check here since the
    // handleBufferCompleteForQueue:buffer: should not change the state
    // (may not enter the synchronized section).
    //

    if (_myPlayData && _myPlayData->audioDecodeFlag == AUDIO_PLAY_STATE_PLAY)
    {
        if (_myPlayData->audioQueue && _myPlayData->started && ( _myPlayData->buffersUsed == 0 )) {
            
            err = AudioQueuePause(_myPlayData->audioQueue);
            if (err)
            {
                DebugLog(@"AudioQueuePause err %ld",err);
            }
            else{
                
                _myPlayData->audioDecodeFlag = AUDIO_PLAY_STATE_WaitBuffering;
                _myPlayData->started = NO;
                DebugLog(@"AudioQueuePause");
            }
        }
    }
}

- (void)resetPlayer
{
        if (_hasReceiveAudio )
        {
            //OSStatus err = AudioQueuePause(myData->audioQueue);
            OSStatus err = AudioQueueReset(_myPlayData ->audioQueue);
            err = AudioQueueStart(_myPlayData->audioQueue, NULL);
        }
}

- (void)startDecodeAac{
    
    OSStatus err = nil;
    
        while ( _decodeFlag ) {
            
            if (_selectData) {
                
                @synchronized(self.dataArray)
                {
                    [self.dataArray removeObject:_selectData];
                    self.selectData =nil;
                }
            }
            
            //成功读取时
            MediaData * mediaData = nil;
            if (_decodeFlag && self.dataArray && [self.dataArray count] > 0) {
                
                mediaData = [self.dataArray objectAtIndex:0];
                _selectData = mediaData;
                
            }
            
            if(_myPlayData && mediaData && (_myPlayData->audioDecodeFlag == AUDIO_PLAY_STATE_PLAY||_myPlayData->audioDecodeFlag == AUDIO_PLAY_STATE_PREPARE || _myPlayData->audioDecodeFlag == AUDIO_PLAY_STATE_WaitBuffering) && _decodeFlag){
                
                NSData * data = mediaData.mediaData;
                // parse the data. this will call MyPropertyListenerProc and MyPacketsProc
                
                if (_myPlayData&&_myPlayData->audioFileStream&&_decodeFlag && data) {
                    
                    //开始解析aac 数据
                    err = AudioFileStreamParseBytes(_myPlayData->audioFileStream, [data length], [data bytes], 0);
                    
                }
                
                if (err) {
                    
                    DebugLog(@"AudioFileStreamParseBytes err %ld",err);
                    break;
                }
            }
        }
    
}

void MyPropertyListenerProc(	void *							inClientData,
                            AudioFileStreamID				inAudioFileStream,
                            AudioFileStreamPropertyID		inPropertyID,
                            UInt32 *						ioFlags)
{
	// this is called by audio file stream when it finds property values
	MyData* myData = (MyData*)inClientData;
	OSStatus err = noErr;
    
	printf("found property '%lu%lu%lu%lu'\n", (inPropertyID>>24)&255, (inPropertyID>>16)&255, (inPropertyID>>8)&255, inPropertyID&255);
    
    switch (inPropertyID)
    {
        case kAudioFileStreamProperty_DataOffset:
        {
            SInt64 offset;
            UInt32 offsetSize = sizeof(offset);
            
            AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_DataOffset, &offsetSize, &offset);
            

        }
            break;
        case kAudioFileStreamProperty_DataFormat:
        {

        }
            break;
        case kAudioFileStreamProperty_AudioDataByteCount:
        {
            UInt64 audioDataByteCount;
            UInt32 byteCountSize = sizeof(audioDataByteCount);
            
            AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_AudioDataByteCount, &byteCountSize, &audioDataByteCount);
            

        }
            break;
		case kAudioFileStreamProperty_ReadyToProducePackets:
        {
            
			// the file stream parser is now ready to produce audio packets.
			// get the stream format.
			AudioStreamBasicDescription asbd;
			UInt32 asbdSize = sizeof(asbd);
			err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_DataFormat, &asbdSize, &asbd);
			if (err) { DebugLog(@"get kAudioFileStreamProperty_DataFormat"); myData->failed = true; break; }

			// create the audio queue
			err = AudioQueueNewOutput(&asbd, MyAudioQueueOutputCallback, myData, NULL, NULL, 0, &myData->audioQueue);
			if (err) { DebugLog(@"AudioQueueNewOutput"); myData->failed = true; break; }

			// allocate audio queue buffers 
//			for (unsigned int i = 0; i < kNumAQBufs; ++i) {
//				err = AudioQueueAllocateBuffer(myData->audioQueue, kAQBufSize, &myData->audioQueueBuffer[i]);
//				if (err) { DebugLog(@"AudioQueueAllocateBuffer"); myData->failed = true; break; }
//			}
            
            //andida
			for (unsigned int i = 0; i < myData->_numAQBufs; ++i) {
				err = AudioQueueAllocateBuffer(myData->audioQueue, myData->_AQBufSize, &myData->_pAudioQueueBufferRef[i]);
				if (err) { DebugLog(@"AudioQueueAllocateBuffer"); myData->failed = true; break; }
			}

            
			// get the cookie size
			UInt32 cookieSize;
			Boolean writable;
			err = AudioFileStreamGetPropertyInfo(inAudioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, &writable);
			if (err) { DebugLog(@"info kAudioFileStreamProperty_MagicCookieData"); break; }
			printf("cookieSize %d\n", (unsigned int)cookieSize);

			// get the cookie data
			void* cookieData = calloc(1, cookieSize);
			err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, cookieData);
			if (err) { DebugLog(@"get kAudioFileStreamProperty_MagicCookieData"); free(cookieData); break; }

			// set the cookie on the queue.
			err = AudioQueueSetProperty(myData->audioQueue, kAudioQueueProperty_MagicCookie, cookieData, cookieSize);
			free(cookieData);
			if (err) { DebugLog(@"set kAudioQueueProperty_MagicCookie"); break; }
            
            
            UInt32 val = kAudioQueueHardwareCodecPolicy_PreferSoftware;//在软解码不可用的情况下用硬解码
            OSStatus ignorableError;
            ignorableError = AudioQueueSetProperty(myData->audioQueue, kAudioQueueProperty_HardwareCodecPolicy, &val, sizeof(UInt32));
            DebugLog(@"set kAudioQueueProperty_MagicCookie %ld",ignorableError);
            

			// listen for kAudioQueueProperty_IsRunning
			err = AudioQueueAddPropertyListener(myData->audioQueue, kAudioQueueProperty_IsRunning, MyAudioQueueIsRunningCallback, myData);
			if (err) { DebugLog(@"AudioQueueAddPropertyListener"); myData->failed = true; break; }
            
        }
            break;
        case kAudioFileStreamProperty_FormatList:
        {
            Boolean outWriteable;
            UInt32 formatListSize;
            OSStatus err = AudioFileStreamGetPropertyInfo(inAudioFileStream, kAudioFileStreamProperty_FormatList, &formatListSize, &outWriteable);
            if (err)
            {
                break;
            }
            
            AudioFormatListItem *formatList = malloc(formatListSize);
            err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_FormatList, &formatListSize, formatList);
            if (err)
            {
                free(formatList);
                break;
            }
            
            for (int i = 0; i * sizeof(AudioFormatListItem) < formatListSize; i += sizeof(AudioFormatListItem))
            {
                AudioStreamBasicDescription pasbd = formatList[i].mASBD;
                
                if (pasbd.mFormatID == kAudioFormatMPEG4AAC_HE ||
                    pasbd.mFormatID == kAudioFormatMPEG4AAC_HE_V2)
                {
                    //
                    // We've found HE-AAC, remember this to tell the audio queue
                    // when we construct it.
                    //
                    break;
                }
            }
            free(formatList);
        }
            break;
    }
}

//解析aac 音频包,  解析音频数据回调
void MyPacketsProc(void *							inClientData,
                   UInt32							inNumberBytes,
                   UInt32							inNumberPackets,
                   const void *					inInputData,
                   AudioStreamPacketDescription	*inPacketDescriptions)
{
	// this is called by audio file stream when it finds packets of audio
	MyData* myData = (MyData*)inClientData;
//	printf("got data.  bytes: %d  packets: %d\n", (unsigned int)inNumberBytes, (unsigned int)inNumberPackets);
    
    // the following code assumes we're streaming VBR data. for CBR data, the second branch is used.
	if (inPacketDescriptions)//格式化音频数据数组
	{
        
        for (int i = 0; i < inNumberPackets; ++i) {
            
            SInt64 packetOffset = inPacketDescriptions[i].mStartOffset;
            SInt64 packetSize   = inPacketDescriptions[i].mDataByteSize;//音频数据长度
            
            // if the space remaining in the buffer is not enough for this packet, then enqueue the buffer.
            
//            size_t bufSpaceRemaining = kAQBufSize - myData->bytesFilled;
            //andida
            size_t bufSpaceRemaining = myData->_AQBufSize - myData->bytesFilled;
            if (bufSpaceRemaining < packetSize) {
                MyEnqueueBuffer(myData);
                WaitForFreeBuffer(myData);
            }
            
            pthread_mutex_lock(&myData->mutex2);
            // copy data to the audio queue buffer
//            AudioQueueBufferRef fillBuf = myData->audioQueueBuffer[myData->fillBufferIndex];
            //andida
//            if (!myData->_pAudioQueueBufferRef) {
//                
//                pthread_mutex_unlock(&myData->mutex2);
//                return;
//            }
//            if (myData->audioDecodeFlag == AUDIO_PLAY_STATE_STOP) {
//                return;
//            }
            AudioQueueBufferRef fillBuf = myData->_pAudioQueueBufferRef[myData->fillBufferIndex];
            memcpy((char*)fillBuf->mAudioData + myData->bytesFilled, (const char*)inInputData + packetOffset, packetSize);//填充音频数据到缓存区
            pthread_mutex_unlock(&myData->mutex2);
//            DebugLog(@"myData->fillBufferIndex %d",myData->fillBufferIndex);
            
            // fill out packet description
//            myData->packetDescs[myData->packetsFilled] = inPacketDescriptions[i];
//            myData->packetDescs[myData->packetsFilled].mStartOffset = myData->bytesFilled;
            //andida
//            if (!myData->_ppacketDescs) {
//                return;
//            }
            myData->_ppacketDescs[myData->packetsFilled] = inPacketDescriptions[i];//填充音频格式化数据
            myData->_ppacketDescs[myData->packetsFilled].mStartOffset = myData->bytesFilled;
            
            // keep track of bytes filled and packets filled
            myData->bytesFilled += packetSize;
            myData->packetsFilled += 1;
            
            // if that was the last free packet description, then enqueue the buffer.
//            size_t packetsDescsRemaining = kAQMaxPacketDescs - myData->packetsFilled;
            //andida
            size_t packetsDescsRemaining = myData->_AQMaxPacketDescs - myData->packetsFilled;
            if (packetsDescsRemaining == 0) {
                MyEnqueueBuffer(myData);
                WaitForFreeBuffer(myData);
            }
        }
        
	}
	else
	{
		size_t offset = 0;
		while (inNumberBytes)
		{
			// if the space remaining in the buffer is not enough for this packet, then enqueue the buffer.
//			size_t bufSpaceRemaining = kAQBufSize - myData->bytesFilled;
			size_t bufSpaceRemaining = myData->_AQBufSize - myData->bytesFilled;
			if (bufSpaceRemaining < inNumberBytes) {
				MyEnqueueBuffer(myData);
			}
			
			pthread_mutex_lock(&myData->mutex2);
			
			// copy data to the audio queue buffer
            //andida
//            AudioQueueBufferRef fillBuf = myData->audioQueueBuffer[myData->fillBufferIndex];
			AudioQueueBufferRef fillBuf = myData->_pAudioQueueBufferRef[myData->fillBufferIndex];
//			bufSpaceRemaining = kAQBufSize - myData->bytesFilled;
            //andida
            bufSpaceRemaining = myData->_AQBufSize - myData->bytesFilled;
			size_t copySize;
			if (bufSpaceRemaining < inNumberBytes)
			{
				copySize = bufSpaceRemaining;
			}
			else
			{
				copySize = inNumberBytes;
			}
			memcpy((char*)fillBuf->mAudioData + myData->bytesFilled, (const char*)(inInputData + offset), copySize);
            
			pthread_mutex_unlock(&myData->mutex2);
            
			// keep track of bytes filled and packets filled
			myData->bytesFilled += copySize;
			myData->packetsFilled = 0;
			inNumberBytes -= copySize;
			offset += copySize;
		}
	}
}

OSStatus StartQueueIfNeeded(MyData* myData)
{
	OSStatus err = noErr;
	if (!myData->started) {		// start the queue if it has not been started already
        
        //设置音量
        Float32 gain = 10.0;
        AudioQueueSetParameter(myData->audioQueue, kAudioQueueParam_Volume, gain);
        
        if (myData->buffersUsed == myData->_numAQBufs) {
            
            err = AudioQueueStart(myData->audioQueue, NULL);
            if (err) { DebugLog(@"AudioQueueStart err"); myData->failed = true; return err; }
            myData->started = true;
            
            myData->audioDecodeFlag = AUDIO_PLAY_STATE_PLAY;
            
            DebugLog(@"AudioQueueStart started");
        }
        

	}
	return err;
}

//buffer  加入 音频队列
void MyEnqueueBuffer(MyData* myData)
{

    if (!flagDecodeAudio) {
//        return;
    }
    
	OSStatus err = noErr;
//	myData->inuse[myData->fillBufferIndex] = true;		// set in use flag
//    andida
	myData->_pInuse[myData->fillBufferIndex] = true;		// set in use flag
    
    
	myData->buffersUsed ++;
    
	// enqueue buffer
//	AudioQueueBufferRef fillBuf = myData->audioQueueBuffer[myData->fillBufferIndex];
   	AudioQueueBufferRef fillBuf = myData->_pAudioQueueBufferRef[myData->fillBufferIndex];
    
	fillBuf->mAudioDataByteSize = myData->bytesFilled;
    
    if (myData->packetsFilled)
	{
        //andida
//        err = AudioQueueEnqueueBuffer(myData->audioQueue, fillBuf, myData->packetsFilled, myData->packetDescs);
		err = AudioQueueEnqueueBuffer(myData->audioQueue, fillBuf, myData->packetsFilled, myData->_ppacketDescs);
        DebugLog(@"AudioQueueEnqueueBuffer");
	}
	else
	{
		err = AudioQueueEnqueueBuffer(myData->audioQueue, fillBuf, 0, NULL);
	}
    
//	err = AudioQueueEnqueueBuffer(myData->audioQueue, fillBuf, myData->packetsFilled, myData->packetDescs);
    
	if (err) {
        DebugLog(@"AudioQueueEnqueueBuffer err %ld" ,err);
        myData->failed = true;
//        return err;
    }
	
//    DebugLog(@"AudioQueueEnqueueBuffer MyEnqueueBuffer");

	StartQueueIfNeeded(myData);
}


void WaitForFreeBuffer(MyData* myData)
{
    if (!flagDecodeAudio) {
        return;
    }
    
    
	// go to next buffer
    //andida
//	if (++myData->fillBufferIndex >= kNumAQBufs) myData->fillBufferIndex = 0;
	if (++myData->fillBufferIndex >= myData->_numAQBufs)
        myData->fillBufferIndex = 0;
	myData->bytesFilled = 0;		// reset bytes filled
	myData->packetsFilled = 0;		// reset packets filled
    
	// wait until next buffer is not in use
#ifdef DEBUG
    printf("->lock\n");
#endif
	pthread_mutex_lock(&myData->mutex);
    
    if (flagDecodeAudio) {
        
//        while (myData->inuse[myData->fillBufferIndex])
//        andida
        
        while (flagDecodeAudio && myData->_pInuse && myData->_pInuse[myData->fillBufferIndex])
        {
            pthread_cond_wait(&myData->cond, &myData->mutex);
        }
    }

	pthread_mutex_unlock(&myData->mutex);
#ifdef DEBUG
    printf("<-unlock\n");
#endif
}

//查找 给定的 buffer 在 缓存队列中的索引位置
int MyFindQueueBuffer(MyData* myData, AudioQueueBufferRef inBuffer)
{
//    	for (unsigned int i = 0; i < kNumAQBufs; ++i)
//    andida
	for (unsigned int i = 0; i < myData->_numAQBufs; ++i)
    {
//   		if (inBuffer == myData->audioQueueBuffer[i])
		if (inBuffer == myData->_pAudioQueueBufferRef[i])
            
			return i;
	}
	return -1;
}


//播放完一帧aac 回调函数
void MyAudioQueueOutputCallback(	void*					inClientData,
                                AudioQueueRef			inAQ,
                                AudioQueueBufferRef		inBuffer)
{
	// this is called by the audio queue when it has finished decoding our data.
	// The buffer is now free to be reused.
	MyData* myData = (MyData*)inClientData;
    //播放完毕的 buffer
	unsigned int bufIndex = MyFindQueueBuffer(myData, inBuffer);
	
	// signal waiting thread that the buffer is free.
	pthread_mutex_lock(&myData->mutex);
    
//    myData->inuse[bufIndex] = false;
//    andida
    myData->_pInuse[bufIndex] = false;
    
    myData->buffersUsed--;
    
	pthread_cond_signal(&myData->cond);
	pthread_mutex_unlock(&myData->mutex);
}

void MyAudioQueueIsRunningCallback(	void* inClientData,
                                   AudioQueueRef inAQ,
                                   AudioQueuePropertyID	inID)
{
    
    DebugLog(@"get kAudioQueueProperty_IsRunning 1");
	MyData* myData = (MyData*)inClientData;
	UInt32 running;
	UInt32 size;
	OSStatus err = AudioQueueGetProperty(inAQ, kAudioQueueProperty_IsRunning, &running, &size);
	if (err) {
        DebugLog(@"get kAudioQueueProperty_IsRunning");
        return;
    }
    
	if (!running || !flagDecodeAudio) {
		pthread_mutex_lock(&myData->mutex);
		pthread_cond_signal(&myData->done);
		pthread_mutex_unlock(&myData->mutex);
	}
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
    
    if (error) {
        DebugLog(@"kAudioSessionOverrideAudioRoute_None error %ld",error);
    }
    
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeCallback, self);
    
    AudioSessionSetActive(true);
    
}

//事件
void audioRouteChangeCallback(void*inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void* inData) {
    
    CFDictionaryRef routeChangeDictionary = inData;
    CFNumberRef routeChangeReasonRef = CFDictionaryGetValue(routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
    SInt32 routeChangeReason;
    CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
    NSLog(@" ======================= RouteChangeReason : %ld", routeChangeReason);
    AACPlayer * self = (AACPlayer *)inClientData;
    
//    AudioQueueStart(self.myPlayData->audioQueue, NULL);
    
    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
        
    } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
        
    } else if (routeChangeReason == kAudioSessionRouteChangeReason_NoSuitableRouteForCategory) {
        
    } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable){
        
    }
}

@end
