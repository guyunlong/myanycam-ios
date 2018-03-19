//
//  recordvideo.m
//  SouIpcam
//
//  Created by my on 14-9-1.
//  Copyright (c) 2014年 gyl. All rights reserved.
//

#import "recordvideo.h"
@interface recordvideo()
@property(nonatomic,retain)NSString *filename;
@end
@implementation recordvideo
@synthesize pCodecCtx;
@synthesize filename;
-(BOOL)generateRecordFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径,参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//获得需要的路径
    NSLog(documentsDirectory);
    //切换成当前目录
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    
    [fileManager createFileAtPath:@"./1.mp4" contents:nil attributes:nil];
    
    NSString *appPath=[documentsDirectory stringByAppendingPathComponent:@"./1.mp4"];
    filename = [appPath retain];
    return YES;
}
-(id)initRec:(int)framerate  cnx:(AVCodecContext *)CodecCtx{
    if (!(self=[super init])) return nil;
    if (![self generateRecordFile]) {
        return nil;
    }
    STREAM_DURATION =  5.0;
    STREAM_FRAME_RATE = 20; /* 25 images/s */
    STREAM_NB_FRAMES = ((int)(STREAM_DURATION * STREAM_FRAME_RATE));
   
    [self setPCodecCtx:CodecCtx];
    STREAM_FRAME_RATE = framerate;
    return self;
}
-(AVStream *)add_video_stream:(AVFormatContext*)oc codecid:(int)codec_id
{
    AVCodecContext *c;
    AVStream *st;
    AVCodec *codec;
    
    st = avformat_new_stream(oc, NULL);
    if (!st) {
        fprintf(stderr, "Could not alloc stream\n");
        exit(1);
    }
    
    c = st->codec;
    
    /* find the video encoder */
    codec = avcodec_find_encoder(codec_id);
    if (!codec) {
        fprintf(stderr, "codec not found\n");
        exit(1);
    }
    avcodec_get_context_defaults3(c, codec);
    
    c->codec_id = codec_id;
    
    /* put sample parameters */
    c->bit_rate = /*400000*/3000000;
    /* resolution must be a multiple of two */
    
    c->width = pCodecCtx->width;
    c->height = pCodecCtx->height;
    
    /* time base: this is the fundamental unit of time (in seconds) in terms
     of which frame timestamps are represented. for fixed-fps content,
     timebase should be 1/framerate and timestamp increments should be
     identically 1. */
    c->time_base.den = STREAM_FRAME_RATE;
    c->time_base.num = 1;
    c->gop_size = 12; /* emit one intra frame every twelve frames at most */
    c->pix_fmt = AV_PIX_FMT_YUV420P;
    if (c->codec_id == AV_CODEC_ID_MPEG2VIDEO) {
        /* just for testing, we also add B frames */
        c->max_b_frames = 2;
    }
    if (c->codec_id == AV_CODEC_ID_MPEG1VIDEO){
        /* Needed to avoid using macroblocks in which some coeffs overflow.
         This does not happen with normal video, it just happens here as
         the motion of the chroma plane does not match the luma plane. */
        c->mb_decision=2;
    }
    // some formats want stream headers to be separate
    if (oc->oformat->flags & AVFMT_GLOBALHEADER)
        c->flags |= CODEC_FLAG_GLOBAL_HEADER;
    
    
    
    return st;
}
-(AVFrame *)alloc_picture:(enum AVPixelFormat)pix_fmt wid:(int)width hei:(int)height
{
    AVFrame *picture;
    uint8_t *picture_buf;
    int size;
    
    picture = av_frame_alloc();
    if (!picture)
        return NULL;
    size = avpicture_get_size(pix_fmt, width, height);
    picture_buf = (uint8_t *)av_malloc(size);
    if (!picture_buf) {
        av_free(picture);
        return NULL;
    }
    avpicture_fill((AVPicture *)picture, picture_buf,
                   pix_fmt, width, height);
    return picture;
}

-(void)open_video:(AVFormatContext*)oc stream:(AVStream *)st
{
    AVCodec *codec;
    AVCodecContext *c;
    
    c = st->codec;
    
    /* find the video encoder */
    codec = avcodec_find_encoder(c->codec_id);
    if (!codec) {
        fprintf(stderr, "codec not found\n");
        exit(1);
    }
    
    /* open the codec */
    if (avcodec_open2(c, codec,NULL) < 0) {
        fprintf(stderr, "could not open codec\n");
        exit(1);
    }
    
    video_outbuf = NULL;
    if (!(oc->oformat->flags & AVFMT_RAWPICTURE)) {
        /* allocate output buffer */
        /* XXX: API change will be done */
        /* buffers passed into lav* can be allocated any way you prefer,
         as long as they're aligned enough for the architecture, and
         they're freed appropriately (such as using av_free for buffers
         allocated with av_malloc) */
        video_outbuf_size = 200000;
        video_outbuf = (uint8_t *)av_malloc(video_outbuf_size);
    }
    
    /* allocate the encoded raw picture */
    s_picture = [self alloc_picture:c->pix_fmt wid:c->width hei:c->height];
    if (!s_picture) {
        fprintf(stderr, "Could not allocate picture\n");
        exit(1);
    }
    tmp_picture = NULL;
    /* if the output format is not YUV420P, then a temporary YUV420P
     picture is needed too. It is then converted to the required
     output format */
    if (c->pix_fmt != AV_PIX_FMT_YUV420P) {
        tmp_picture = [self alloc_picture:AV_PIX_FMT_YUV420P wid:c->width hei:c->height];
        if (!tmp_picture) {
            fprintf(stderr, "Could not allocate temporary picture\n");
            exit(1);
        }
    }
}
-(void)close_video:(AVFormatContext *)oc stream:(AVStream *)st
{
    avcodec_close(st->codec);
    av_free(s_picture->data[0]);
    av_free(s_picture);
    if (tmp_picture) {
        av_free(tmp_picture->data[0]);
        av_free(tmp_picture);
    }
    av_free(video_outbuf);
}

-(void)writeHeader{
    
    NSLog(@"file path is %@",filename);
    
    fmt = av_guess_format(NULL, [filename cStringUsingEncoding:1], NULL);
    if (!fmt) {
        NSLog(@"Could not deduce output format from file extension: using MPEG");
        fmt = av_guess_format("mpeg", NULL, NULL);
    }
    if (!fmt) {
        fprintf(stderr, "Could not find suitable output format\n");
        exit(1);
    }
    
    /* allocate the output media context */
    ocx = avformat_alloc_context();
    if (!ocx) {
        fprintf(stderr, "Memory error\n");
        exit(1);
    }
    ocx->oformat = fmt;
    snprintf(ocx->filename, sizeof(ocx->filename), "%s", [filename cStringUsingEncoding:1]);
    
    ocx->oformat->video_codec = AV_CODEC_ID_MPEG4;
    
    fmt = ocx->oformat;
    video_st = NULL;
    
    if (fmt->video_codec != AV_CODEC_ID_NONE) {
        video_st = [self add_video_stream:ocx codecid:fmt->video_codec];
    }

    
    av_dump_format(ocx, 0, [filename cStringUsingEncoding:1], 1);
    
    if (video_st)
    {
        [self open_video:ocx stream:video_st];
    }
    //        if (audio_st)
    //            open_audio(oc, audio_st);
    
    /* open the output file, if needed */
    if (!(fmt->flags & AVFMT_NOFILE)) {
        if (avio_open(&ocx->pb, [filename cStringUsingEncoding:1], AVIO_FLAG_WRITE) < 0) {
            fprintf(stderr, "Could not open '%s'\n", [filename cStringUsingEncoding:1]);
            return;
        }
    }
    
    /* write the stream header, if any */
    avformat_write_header(ocx,NULL);
    s_picture->pts = 0;
    
    
    
}
-(void)writeVidBuffer:(AVFrame *)pFrame{
    static int enc_count = 0;
    pFrame->width = pCodecCtx->width;
    pFrame->height = pCodecCtx->height;
    pFrame->format = AV_PIX_FMT_YUV420P;
    pFrame->pts = enc_count++;
    
    int  ret;
    int got_output;
    AVPacket enc_pkt;
    av_init_packet(&enc_pkt);
    enc_pkt.data = NULL;    // packet data will be allocated by the encoder
    enc_pkt.size = 0;
    AVCodecContext *c;
    //static struct SwsContext *img_convert_ctx;
    c = video_st->codec;
   // int avcodec_encode_video2(AVCodecContext *avctx, AVPacket *avpkt,
                            //  const AVFrame *frame, int *got_packet_ptr);
    //out_size = avcodec_encode_video2(c, video_outbuf, video_outbuf_size, pFrame);
    
    ret = avcodec_encode_video2(c, &enc_pkt, pFrame, &got_output);
    NSLog(@"enc byte is %d,GotPicture is %d", ret,got_output);
    if(got_output == 0){
        return ;
    }
    //printf("============================================= 3 %lld,enc size is %d\n",current_timestamp(),enc_pkt.size );
    //    enc_pkt.stream_index =0;
    enc_pkt.flags |= AV_PKT_FLAG_KEY;
    enc_pkt.stream_index = video_st->index;
    if (enc_pkt.pts != AV_NOPTS_VALUE){
       // printf("pts -1 is %d\n",enc_pkt.pts );
        enc_pkt.pts =  av_rescale_q(enc_pkt.pts, c->time_base, video_st->time_base);
        //
       // printf("pts 0 is %d\n",enc_pkt.pts );
      //  int seek_ts = ((current_timestamp()-timestart)*(enc_video_st->time_base.den))/(enc_video_st->time_base.num)/1000;
       // printf("pts seek ts  is %d,enc_video_st->time_base.den %d,enc_video_st->time_base.num %d\n",seek_ts,enc_video_st->time_base.den,enc_video_st->time_base.num);
       // enc_pkt.pts = seek_ts;
        
       // printf("pts is %lld\n",enc_pkt.pts );
    }
    
    if (enc_pkt.dts != AV_NOPTS_VALUE){
        enc_pkt.dts = enc_pkt.pts;
        //enc_pkt.dts = av_rescale_q(enc_pkt.dts, cc->time_base, enc_video_st->time_base);
      //  printf("dts is %lld\n",enc_pkt.dts );
        
    }
    ret = av_interleaved_write_frame(ocx, &enc_pkt);
    av_free_packet(&enc_pkt);
}
-(void)saveVideo
{
    bool compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filename);
    if(compatible)
    {
        
        NSLog(@"UIVideoAtPathIsCompatibleWithSavedPhotosAlbum");
        UISaveVideoAtPathToSavedPhotosAlbum (filename, self, nil, nil);
    }
}
-(void)writeTrailer{
    av_write_trailer(ocx);
    if (video_st)
        [self close_video:ocx stream:video_st];
    int i = 0;
    for(i = 0; i < ocx->nb_streams; i++) {
        av_freep(&ocx->streams[i]->codec);
        av_freep(&ocx->streams[i]);
    }
    
    if (!(fmt->flags & AVFMT_NOFILE)) {
        avio_close(ocx->pb);
        
        [NSThread detachNewThreadSelector:@selector(saveVideo)
                                 toTarget:self
                               withObject:nil];
        
    }
    av_free(ocx);
}


@end
