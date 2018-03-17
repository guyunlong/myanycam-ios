//
//  KxMovieDecoder.h
//  kxmovie
//
//  Created by Kolyvan on 15.10.12.
//  Copyright (c) 2012 Konstantin Boukreev . All rights reserved.
//
//  https://github.com/kolyvan/kxmovie
//  this file is part of KxMovie
//  KxMovie is licenced under the LGPL v3, see lgpl-3.0.txt

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#include "libavformat/avformat.h"


extern NSString * kxmovieErrorDomain;

typedef enum {
    
    kxMovieErrorNone,
    kxMovieErrorOpenFile,
    kxMovieErrorStreamInfoNotFound,
    kxMovieErrorStreamNotFound,
    kxMovieErrorCodecNotFound,
    kxMovieErrorOpenCodec,
    kxMovieErrorAllocateFrame,
    kxMovieErroSetupScaler,
    kxMovieErroReSampler,
    kxMovieErroUnsupported,
    
} kxMovieError;

typedef enum {
    
    KxMovieFrameTypeAudio,
    KxMovieFrameTypeVideo,
    KxMovieFrameTypeArtwork,
    KxMovieFrameTypeSubtitle,
    
} KxMovieFrameType;

typedef enum {
        
    KxVideoFrameFormatRGB,
    KxVideoFrameFormatYUV,
    
} KxVideoFrameFormat;

@interface KxMovieFrame : NSObject
@property (readonly, nonatomic) KxMovieFrameType type;
@property (readonly, nonatomic) CGFloat position;
@property (readonly, nonatomic) CGFloat duration;
@end

@interface KxAudioFrame : KxMovieFrame
@property (nonatomic, retain) NSData *samples;
@end

@interface KxVideoFrame : KxMovieFrame
@property (readonly, nonatomic) KxVideoFrameFormat format;
@property (readwrite, nonatomic) NSUInteger width;
@property (readwrite, nonatomic) NSUInteger height;
@property (readwrite, nonatomic) unsigned long timeStamp;

@end

@interface KxVideoFrameRGB : KxVideoFrame
@property (readwrite, nonatomic) NSUInteger linesize;
@property (nonatomic, retain) NSData *rgb;
- (UIImage *) asImage;
@end

@interface KxVideoFrameYUV : KxVideoFrame
{
    NSData *_luma;
    NSData *_chromaB;
    NSData *_chromaR;
}
@property (nonatomic, retain) NSData *luma;
@property (nonatomic, retain) NSData *chromaB;
@property (nonatomic, retain) NSData *chromaR;
@end

@interface KxArtworkFrame : KxMovieFrame
@property (readwrite, nonatomic, retain) NSData *picture;
- (UIImage *) asImage;
@end

@interface KxSubtitleFrame : KxMovieFrame
@property (nonatomic, retain) NSString *text;
@end

typedef BOOL(^KxMovieDecoderInterruptCallback)();

@interface KxMovieDecoder : NSObject

@property (readonly, nonatomic) NSUInteger frameWidth;
@property (readonly, nonatomic) NSUInteger frameHeight;

- (void)handleVieoFrameWithFrame:(AVFrame *)avframe andvideoCodecCtx:(AVCodecContext *)videoCodecCtx andKxVideoFrameYUV:(KxVideoFrameYUV *)vFrameYUV;

@end
