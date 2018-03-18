//
//  Video.h
//  iFrameExtractor
//
//  Created by lajos on 1/10/10.
//
//  Copyright 2010 Lajos Kamocsay
//
//  lajos at codza dot com
//
//  iFrameExtractor is free software; you can redistribute it and/or
//  modify it under the terms of the GNU Lesser General Public
//  License as published by the Free Software Foundation; either
//  version 2.1 of the License, or (at your option) any later version.
// 
//  iFrameExtractor is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Lesser General Public License for more details.
//


#import <Foundation/Foundation.h>
#import "CustomMovieGLView.h"
#import "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libavcodec/avcodec.h"


@interface VideoSpsPps:NSObject{
    uint8_t *_sps;
    NSInteger _spsSize;
    uint8_t *_pps;
    NSInteger _ppsSize;
}
-(void)setSps:(uint8_t*)sps size:(int)size;
-(void)setPps:(uint8_t*)pps size:(int)size;
@end

@interface VideoFrameExtractor : NSObject {
	AVFormatContext *pFormatCtx;//存储格式信息
	AVCodecContext *pCodecCtx;//存储编解码信息
    AVFrame *pFrame; //帧
	AVPicture picture;//
    AVPacket packet;//包
	int videoStream;
	struct SwsContext *img_convert_ctx;
	int sourceWidth, sourceHeight;
	int outputWidth, outputHeight;
	UIImage *currentImage;
	double duration;
    uint8_t  *rawData;
    int bytesDecoded;
    AVFrame  *_imageFrame;
    
}

@property (assign, nonatomic) AVFrame * currentFrame;


-(int) bytesDecoded;

/* Last decoded picture as UIImage */
@property (nonatomic, readonly) UIImage *currentImage;
@property (retain, nonatomic) VideoSpsPps *ppsSps;

/* Size of video frame */
@property (nonatomic, readonly) int sourceWidth, sourceHeight;

/* Output image size. Set to the source size by default. */
@property (nonatomic) int outputWidth, outputHeight;

/* Length of video in seconds */
@property (nonatomic, readonly) double duration;

/* Initialize with movie at moviePath. Output dimensions are set to source dimensions. */
-(id)initCnx:(int)type wid:(int)width hei:(int)height;
-(int)manageData:(NSData *)dataBuffer;
/* Read the next frame from the video stream. Returns false if no frame read (video over). */
//-(BOOL)stepFrame;

/* Seek to closest keyframe near specified time */
//-(void)seekTime:(double)seconds;
- (KxVideoFrame *) handleVideoFrame;
- (char *)getYUVDATA;


@end
