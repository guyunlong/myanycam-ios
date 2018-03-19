//
//  Video.m
//  iFrameExtractor
//
//  Created by lajos on 1/10/10.
//  Copyright 2010 www.codza.com. All rights reserved.
//

#import "VideoFrameExtractor.h"
#import "KxMovieDecoder.h"

@implementation VideoSpsPps;
-(id)init{
    self = [super init];
    _spsSize = _ppsSize = 0;
    return self;
}
-(void)dealloc{
    if (_sps) {
        free(_sps);
    }
    if (_pps) {
        free(_pps);
    }
    [super dealloc];
}
-(void)getSpsAndPpsInfo:(uint8_t*)buf size:(NSUInteger)size{
    //主要是解析idr前面的sps pps
    if (_ppsSize >0 && _spsSize > 0) {
        return;
    }
    int last = 0;
    for (int i = 2; i <= size; ++i){
        if (i == size) {
            if (last) {
                [self parseFrame:buf+last len:i - last];
            }
        } else if (buf[i - 2]== 0x00 && buf[i - 1]== 0x00 && buf[i] == 0x01) {
            if (last) {
                int size = i - last - 3;
                if (buf[i - 3]) ++size;
                [self parseFrame:buf + last len:size];
            }
            last = i + 1;
        }
    }
}
-(void)parseFrame:(uint8_t*)buf len:(int)len{
    
    switch (buf[0] & 0x1f){
        case 7: // SPS
            NSLog(@"sps len is %d",len);
            [self setSps:buf size:len];
            break;
            
        case 8: // PPS
            NSLog(@"pps len is %d",len);
            [self setPps:buf size:len];
            break;
            
        case 5:
            NSLog(@"idr len is %d",len);
            
            break;
        case 1:
            NSLog(@"B/P len is %d",len);
            break;
            
        default:
            break;
    }
    
    return ;
}
-(void)setSps:(uint8_t*)sps size:(int)size{
    if (_spsSize > 0) {
        return;
    }
    _spsSize = size;
    _sps = malloc(_spsSize);
    memcpy(_sps, sps, _spsSize);
}
-(void)setPps:(uint8_t*)pps size:(int)size{
    if (_ppsSize > 0) {
        return;
    }
    _ppsSize = size;
    _pps = malloc(_ppsSize);
    memcpy(_pps, pps, _ppsSize);
}
@end

@interface VideoFrameExtractor (private)
-(void)convertFrameToRGB;
-(UIImage *)imageFromAVPicture:(AVPicture)pict width:(int)width height:(int)height;
-(void)savePicture:(AVPicture)pFrame width:(int)width height:(int)height index:(int)iFrame;
-(void)setupScaler;
@end

@implementation VideoFrameExtractor

@synthesize outputWidth, outputHeight;
@synthesize currentFrame = pFrame;

-(void)setOutputWidth:(int)newValue {
	if (outputWidth == newValue) return;
	outputWidth = newValue;
    
    pCodecCtx->width = newValue;
    [self setupScaler];
}

-(void)setOutputHeight:(int)newValue {
	if (outputHeight == newValue) return;
	outputHeight = newValue;
    pCodecCtx->height = newValue;
	[self setupScaler];
}

-(UIImage *)currentImage {

 	if (pFrame && !pFrame->data[0]) return nil;
    [self convertFrameToRGB];
	return [self imageFromAVPicture:picture width:outputWidth height:outputHeight];
}


-(double)duration {
	return (double)pFormatCtx->duration / AV_TIME_BASE;
}

-(int)sourceWidth {
	return pCodecCtx->width;
}

-(int)sourceHeight {
	return pCodecCtx->height;
}

-(id)initCnx:(int)type wid:(int)width hei:(int)height{
//	if (!(self=[super init])) return nil;
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _ppsSps = [[[VideoSpsPps alloc] init] retain];
    DebugLog(@"~~~~~~~~~~~~~~~wid is %d ,het is %d",width,height);
    
    av_register_all();
    avcodec_register_all();
    AVCodec * pCodec = nil;
    if(type == 0)
    {
        pCodec = avcodec_find_decoder(AV_CODEC_ID_MJPEG);
        DebugLog(@"%@",@"MJPEG");
    }
    if(type == 1)
    {
        pCodec = avcodec_find_decoder(AV_CODEC_ID_H264);
        DebugLog(@"%@",@"264");
    }
    
    if (pCodec) {
        
        pCodecCtx = avcodec_alloc_context3(pCodec);
        pCodecCtx->time_base.num = 1; // 分子
        pCodecCtx->time_base.den = 15;// 分母  代表帧率
        pCodecCtx->bit_rate = 0; //初始化为0
        pCodecCtx->frame_number = 1; //每包一个视频帧
        pCodecCtx->codec_type = AVMEDIA_TYPE_VIDEO;
        pCodecCtx->width = width; //这两行：视频的宽度和高度
        pCodecCtx->height = height;
        pCodecCtx->pix_fmt=AV_PIX_FMT_YUV420P;
        
        if(avcodec_open2(pCodecCtx, pCodec,NULL)<0)
        {
            [self release];
            return nil;
        }
        
        pFrame=av_frame_alloc();

        self.outputWidth = pCodecCtx->width;
        self.outputHeight = pCodecCtx->height;
        DebugLog(@"----------------wid is %d ,het is %d",pCodecCtx->width,pCodecCtx->height);
    }
        
    return self;
}


-(void)setupScaler {
    // Release old picture and scaler
	avpicture_free(&picture);
	sws_freeContext(img_convert_ctx);
	
	// Allocate RGB picture
	avpicture_alloc(&picture, AV_PIX_FMT_RGB24, outputWidth, outputHeight);
    DebugLog(@"set up height or width %d",outputHeight);
    
	// Setup scaler
	static int sws_flags =  SWS_FAST_BILINEAR;
	img_convert_ctx = sws_getContext(pCodecCtx->width,
									 pCodecCtx->height,
									 pCodecCtx->pix_fmt,
									 outputWidth,
									 outputHeight,
									 AV_PIX_FMT_RGB24,
									 sws_flags, NULL, NULL, NULL);
}

-(void)dealloc {
	// Free scaler
	sws_freeContext(img_convert_ctx);
    
	// Free RGB picture
	avpicture_free(&picture);
	
    // Free the YUV frame
    av_free(pFrame);
    self.currentFrame = nil;
    if (_imageFrame) {
        av_free(_imageFrame);
        _imageFrame = nil;
    }
    // Close the codec
    if (pCodecCtx) avcodec_close(pCodecCtx);
	
    // Close the video file
//    if (pFormatCtx) av_close_input_file(pFormatCtx);
    if (pFormatCtx) avformat_close_input(&pFormatCtx);
    
//    pFormatCtx->pb
	[super dealloc];
}
-(int)manageData:(NSData *)dataBuffer
{
//    DebugLog(@"decode video");
    
    [_ppsSps getSpsAndPpsInfo:(uint8_t*)[dataBuffer bytes] size:[dataBuffer length]];
    
    int frameFinished=0;

	packet.data = (uint8_t*)[dataBuffer bytes];//
	packet.size = ([dataBuffer length]);//
    
    
//    NSDate* tmpStartData = [[NSDate date] retain];
    bytesDecoded = avcodec_decode_video2(pCodecCtx, pFrame, &frameFinished, &packet);
//    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    
//    DebugLog(@">>>>>>>>>>cost time = %f", deltaTime);
    
    if (bytesDecoded < 0)   return -1;
    //add by gyl
    if(_startRecord){
        _recordEngine = [[recordvideo alloc] initRec:15 cnx:pCodecCtx];
        [_recordEngine writeHeader];
        _startRecord = NO;
    }
    if (_recording) {
        [_recordEngine writeVidBuffer:pFrame];
    }
    if (_endRecord) {
        _endRecord = NO;
        [_recordEngine writeTrailer];
    }
//    av_free_packet(&packet);
    return  1;
}

-(int) bytesDecoded{
    
    return bytesDecoded;
}

- (KxVideoFrame *) handleVideoFrame
{
    if (!pFrame->data[0])
        return nil;
    
    
    KxVideoFrame *frame;
 
        
    KxVideoFrameYUV * yuvFrame = [[KxVideoFrameYUV alloc] init];
    
    yuvFrame.luma = copyFrameData(pFrame->data[0],
                                  pFrame->linesize[0],
                                  pCodecCtx->width,
                                  pCodecCtx->height);
    
    yuvFrame.chromaB = copyFrameData(pFrame->data[1],
                                     pFrame->linesize[1],
                                     pCodecCtx->width / 2,
                                     pCodecCtx->height / 2);
    
    yuvFrame.chromaR = copyFrameData(pFrame->data[2],
                                     pFrame->linesize[2],
                                     pCodecCtx->width / 2,
                                     pCodecCtx->height / 2);
    
    frame = yuvFrame;
    
    
    frame.width = pCodecCtx->width;
    frame.height = pCodecCtx->height;
 
    return [frame autorelease];
}



-(void)convertFrameToRGB {
    
	sws_scale (img_convert_ctx, pFrame->data, pFrame->linesize,
			   0, pCodecCtx->height,
			   picture.data, picture.linesize);
    
}

-(UIImage *)imageFromAVPicture:(AVPicture)pict width:(int)width height:(int)height {
    
//    DebugLog(@"imagefromavpicture,height is %d,width is %d",height,width);
    
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pict.data[0], pict.linesize[0]*height,kCFAllocatorNull);
	CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef cgImage = CGImageCreate(width,
									   height,
									   8,
									   24,
									   pict.linesize[0],
									   colorSpace,
									   bitmapInfo,
									   provider,
									   NULL,
									   NO,
									   kCGRenderingIntentDefault);
	CGColorSpaceRelease(colorSpace);
	UIImage *image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	CGDataProviderRelease(provider);
	CFRelease(data);
	
	return image;
}

static NSArray *collectStreams(AVFormatContext *formatCtx, enum FFMAVMediaType codecType)
{
    NSMutableArray *ma = [NSMutableArray array];
    for (NSInteger i = 0; i < formatCtx->nb_streams; ++i)
        if (codecType == formatCtx->streams[i]->codec->codec_type)
            [ma addObject: [NSNumber numberWithInteger: i]];
    return [ma copy];
}

static NSData * copyFrameData(UInt8 *src, int linesize, int width, int height)
{
    width = MIN(linesize, width);
    NSMutableData *md = [NSMutableData dataWithLength: width * height];
    Byte *dst = md.mutableBytes;
    for (NSUInteger i = 0; i < height; ++i) {
        memcpy(dst, src, width);
        dst += width;
        src += linesize;
    }
    return md;
}

- (char *)getYUVDATA {
    
    AVFrame * frame = self.currentFrame;
    char * output = (char *)malloc(sizeof(char)*pCodecCtx->width * pCodecCtx->height * 3);
//    int outputSizeBytes = pCodecCtx->width * pCodecCtx->height * 3 /2;
    if (frame->data[0])
	{
		int i = 0;
		int p=0;
		
		for(i=0; i<pCodecCtx->height; i++)
		{
			memcpy(output+p,frame->data[0] + i * frame->linesize[0], pCodecCtx->width);
			p+=pCodecCtx->width;
		}
		for(i=0; i<pCodecCtx->height/2; i++)
		{
			memcpy(output+p,frame->data[1] + i * frame->linesize[1], pCodecCtx->width/2);
			p+=pCodecCtx->width/2;
		}
		for(i=0; i<pCodecCtx->height/2; i++)
		{
			memcpy(output+p,frame->data[2] + i * frame->linesize[2], pCodecCtx->width/2);
			p+=pCodecCtx->width/2;
		}
    }
    
        return output;
}

@end
