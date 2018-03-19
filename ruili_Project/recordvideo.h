//
//  recordvideo.h
//  SouIpcam
//
//  Created by my on 14-9-1.
//  Copyright (c) 2014年 gyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libavcodec/avcodec.h"
@interface recordvideo : NSObject{
    bool _startRecord;
    bool _recording;
    bool _endRecord;
    NSString * filename;
    AVFormatContext *ocx;
    AVOutputFormat *fmt;
    AVStream *video_st;
    AVFrame *s_picture;
    AVFrame* tmp_picture;
    
    float STREAM_DURATION ;
    int STREAM_FRAME_RATE;
    int STREAM_NB_FRAMES;
    int frame_count;
    int video_outbuf_size;
    uint8_t *video_outbuf;
   
}
-(AVStream *)add_video_stream:(AVFormatContext*)oc codecid:(int)codec_id;
-(void)writeHeader;
-(void)writeVidBuffer:(AVFrame *)pFrame;
-(void)writeAudBuffer;
-(void)writeTrailer;

/**
 初始化编码器，并且生成文件

 @param framerate
 @param pCodecCtx
 @return
 */
-(id)initRec:(int)framerate  cnx:(AVCodecContext*)pCodecCtx;
@property (nonatomic)AVCodecContext *pCodecCtx;

@end
