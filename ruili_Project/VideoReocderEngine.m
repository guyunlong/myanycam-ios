////
////  VideoReocderEngine.m
////  Myanycam
////
////  Created by myanycam on 13-3-29.
////  Copyright (c) 2013年 Myanycam. All rights reserved.
////
//
////#define STREAM_NB_FRAMES  ((int)(STREAM_DURATION * STREAM_FRAME_RATE))
//////#define M_PI   3.14159265358979323846
////#define AV_PKT_FLAG_KEY   0x0001
////#define STREAM_PIX_FMT PIX_FMT_YUV420P /* default pix_fmt */
//
//
//
//
//#import "VideoReocderEngine.h"
//#import "ak_adpcm.h"
//#define STREAM_DURATION   5.0
//#define STREAM_FRAME_RATE 25 /* 25 images/s */
//#define STREAM_NB_FRAMES  ((int)(STREAM_DURATION * STREAM_FRAME_RATE))
//#define STREAM_PIX_FMT PIX_FMT_YUV420P /* default pix_fmt */
//
////static int sws_flags = SWS_POINT;
//
//
//
//
//@implementation VideoReocderEngine
//
///**************************************************************/
///* audio output */
//
//float t, tincr, tincr2;
//int16_t *samples;
//uint8_t *audio_outbuf;
//int audio_outbuf_size;
//int audio_input_frame_size;
//
//AVOutputFormat *fmt;
//AVFormatContext *oc;
//AVStream *audio_st, *video_st;
//
//
//int video_width = 320;
//int video_height = 240;
//int video_fram = 25;
//
//
//
///*
// * add an audio output stream
// */
//static AVStream *add_audio_stream(AVFormatContext *oc, enum CodecID codec_id)
//{
//    AVCodecContext *c;
//    AVStream *st;
//    
//    
//    st = avformat_new_stream(oc, NULL);
//    if (!st)
//	{
//        fprintf(stderr, "Could not alloc stream\n");
//        return NULL;
//    }
//    
//    st->id = 1;
//    c = st->codec;
//    c->codec_id = codec_id;
//    c->codec_type = AVMEDIA_TYPE_AUDIO;
//    
//    /* put sample parameters */
//    c->sample_fmt = AV_SAMPLE_FMT_S16;
//    //c->sample_fmt = AV_SAMPLE_FMT_FLT;//SAMPLE_FMT_S16;
//    c->bit_rate = 24000;
//    c->sample_rate = 8000;
//    c->channels = 1;
//    
//    
//    // some formats want stream headers to be separate
//    if(oc->oformat->flags & AVFMT_GLOBALHEADER)
//	{
//        c->flags |= CODEC_FLAG_GLOBAL_HEADER;
//	}
//    
//    return st;
//}
//
//static void open_audio(AVFormatContext *oc, AVStream *st)
//{
//    AVCodecContext *c;
//    AVCodec *codec;
//    
////	avcodec_init();
////	avcodec_register_all();
//    
//    c = st->codec;
//    
//    /* find the audio encoder */
//    codec = avcodec_find_encoder(c->codec_id);
//    if (!codec)
//	{
//        fprintf(stderr, "codec not found\n");
//        return ;
//    }
//    
//    /* open it */
////    c->strict_std_compliance = FF_COMPLIANCE_EXPERIMENTAL;
//    if (avcodec_open2(c, codec, NULL)< 0)
//	{
//        fprintf(stderr, "could not open codec\n");
//        return ;
//    }
//    
//    /* init signal generator */
//    t = 0;
//    tincr = 2 * M_PI * 110.0 / c->sample_rate;
//    /* increment frequency by 110 Hz per second */
//    tincr2 = 2 * M_PI * 110.0 / c->sample_rate / c->sample_rate;
//    
//    audio_outbuf_size = 200000;
//    audio_outbuf = av_malloc(audio_outbuf_size);
//    
//    
//    /* ugly hack for PCM codecs (will be removed ASAP with new PCM
//     support to compute the input frame size in samples */
//    if (c->frame_size <= 1) {
//        audio_input_frame_size = audio_outbuf_size / c->channels;
//        switch(st->codec->codec_id) {
//            case CODEC_ID_PCM_S16LE:
//            case CODEC_ID_PCM_S16BE:
//            case CODEC_ID_PCM_U16LE:
//            case CODEC_ID_PCM_U16BE:
//                audio_input_frame_size >>= 1;
//                break;
//            default:
//                break;
//        }
//    } else {
//        audio_input_frame_size = c->frame_size;
//    }
//    samples = av_malloc(audio_input_frame_size * 2 * c->channels);
//}
//
//static void close_audio(AVFormatContext *oc, AVStream *st)
//{
//    avcodec_close(st->codec);
//    
//    av_free(samples);
//    av_free(audio_outbuf);
//}
//
///**************************************************************/
///* video output */
//
//AVFrame *picture, *tmp_picture;
//uint8_t *video_outbuf;
//int frame_count, video_outbuf_size;
//
///* add a video output stream */
//static AVStream *add_video_stream(AVFormatContext *oc, enum CodecID codec_id)
//{
//    AVCodecContext *c;
//    AVStream *st;
//    
//    st = av_new_stream(oc, NULL);
//    if (!st)
//	{
//        fprintf(stderr, "Could not alloc stream\n");
//        return NULL;
//    }
//    
//    c = st->codec;
//    c->codec_id = codec_id;
//    c->codec_type = AVMEDIA_TYPE_VIDEO;//CODEC_TYPE_VIDEO;
//    
//    /* put sample parameters */
//    c->bit_rate = 0; //3000000;
//    /* resolution must be a multiple of two */
//    c->width = video_width;
//    c->height = video_height;
//    /* time base: this is the fundamental unit of time (in seconds) in terms
//     of which frame timestamps are represented. for fixed-fps content,
//     timebase should be 1/framerate and timestamp increments should be
//     identically 1. */
//    c->time_base.den = video_fram;
//    c->time_base.num = 1;
//	c->frame_number = 1;
//    c->gop_size = 12; /* emit one intra frame every twelve frames at most */
//    c->pix_fmt = STREAM_PIX_FMT;
//    if (c->codec_id == CODEC_ID_MPEG2VIDEO) {
//        /* just for testing, we also add B frames */
//        c->max_b_frames = 2;
//    }
//    if (c->codec_id == CODEC_ID_MPEG1VIDEO){
//        /* Needed to avoid using macroblocks in which some coeffs overflow.
//         This does not happen with normal video, it just happens here as
//         the motion of the chroma plane does not match the luma plane. */
//        c->mb_decision=2;
//    }
//    // some formats want stream headers to be separate
//    if(oc->oformat->flags & AVFMT_GLOBALHEADER)
//        c->flags |= CODEC_FLAG_GLOBAL_HEADER;
//    
//    c->me_range = 16;
//    c->max_qdiff = 4;
//    c->qmin = 10;
//    c->qmax = 51;
//    c->qcompress = 0.6;
//
//    
//    return st;
//}
//
//static AVFrame *alloc_picture(enum PixelFormat pix_fmt, int width, int height)
//{
//    AVFrame *picture;
//    uint8_t *picture_buf;
//    int size;
//    
//    picture = avcodec_alloc_frame();
//    if (!picture)
//        return NULL;
//    size = avpicture_get_size(pix_fmt, width, height);
//    picture_buf = (uint8_t *)av_malloc(size);
//    if (!picture_buf) {
//        av_free(picture);
//        return NULL;
//    }
//    avpicture_fill((AVPicture *)picture, picture_buf,
//                   pix_fmt, width, height);
//    return picture;
//}
//
//static void open_video(AVFormatContext *oc, AVStream *st)
//{
//    AVCodec *codec;
//    AVCodecContext *c;
//    
////	avcodec_init();
//	avcodec_register_all();
//    
//    c = st->codec;
//    
//    /* find the video encoder */
//    codec = avcodec_find_encoder(c->codec_id);
//    if (!codec)
//	{
//        fprintf(stderr, "codec not found\n");
//        return;
//    }
//    
//    /* open the codec */
//    if (avcodec_open(c, codec) < 0) {
//        fprintf(stderr, "could not open codec\n");
//        return;
//    }
//    
//    video_outbuf = NULL;
//    if (!(oc->oformat->flags & AVFMT_RAWPICTURE)) {
//        /* allocate output buffer */
//        /* XXX: API change will be done */
//        /* buffers passed into lav* can be allocated any way you prefer,
//         as long as they're aligned enough for the architecture, and
//         they're freed appropriately (such as using av_free for buffers
//         allocated with av_malloc) */
//        video_outbuf_size = 200000;
//        video_outbuf = (uint8_t *)av_malloc(video_outbuf_size);
//    }
//    
//    /* allocate the encoded raw picture */
//    picture = alloc_picture(c->pix_fmt, c->width, c->height);
//    if (!picture)
//	{
//        fprintf(stderr, "Could not allocate picture\n");
//        return;
//    }
//    
//    /* if the output format is not YUV420P, then a temporary YUV420P
//     picture is needed too. It is then converted to the required
//     output format */
//    tmp_picture = NULL;
//    if (c->pix_fmt != PIX_FMT_YUV420P)
//	{
//        tmp_picture = alloc_picture(PIX_FMT_YUV420P, c->width, c->height);
//        if (!tmp_picture)
//		{
//            fprintf(stderr, "Could not allocate temporary picture\n");
//            exit(1);
//        }
//    }
//}
//
//static void close_video(AVFormatContext *oc, AVStream *st)
//{
//    avcodec_close(st->codec);
//    av_free(picture->data[0]);
//    av_free(picture);
//    if (tmp_picture) {
//        av_free(tmp_picture->data[0]);
//        av_free(tmp_picture);
//    }
//    av_free(video_outbuf);
//}
//
//- (id)init{
//    
//    self = [super init];
//    if (self) {
//        m_pAVCodec= NULL;
//        m_pAVCodecContext = NULL;
//        m_pAVFrame = NULL;
//        m_nWidth = 320;
//        m_nHeight = 240;
//        m_pAudioBuff = (char *)malloc(sizeof(char)*100*1024);
//        m_ulAudioLen = 0;
//        _flagCreate = NO;
//        
//    }
//    
//    return self;
//}
///**************************************************************/
///* media file output */
//- (BOOL)Create:(int)cx cy:(int)cy video:(int)videotype audioType:(int)audiotype frame:(int)frame pfileName:(char *)pfilename
//{
//    
//	/* initialize libavcodec, and register all codecs and formats */
//    av_register_all();
//    
//	//avcodec_register_all();
//    
//	video_width = cx;
//	video_height = cy;
//	video_fram = frame;
//    
//    /* auto detect the output format from the name. default is                                                                         mpeg. */
////    fmt = guess_format(NULL, pfilename, NULL);
//    fmt = av_guess_format(NULL, pfilename, NULL);
//    if (!fmt)
//	{
//        printf("Could not deduce output format from file extension: using MPEG.\n");
//		return false;
//    }
//    
//    /* allocate the output media context */
////    oc = av_alloc_format_context();
//    oc = avformat_alloc_context();
////    oc = avformat_alloc_output_context2(&oc, NULL, NULL, pfilename);
//    if (!oc) {
//        fprintf(stderr, "Memory error\n");
//        exit(1);
//    }
//    
//	//CODEC_ID_MJPEG            =  8,
//	//CODEC_ID_H264
//    
//	fmt->video_codec = CODEC_ID_H264;
//	fmt->audio_codec = CODEC_ID_AAC;
//    //fmt->audio_codec = CODEC_ID_ADPCM_MS;
//    oc->oformat = fmt;
//    
//    snprintf(oc->filename, sizeof(oc->filename), "%s", pfilename);
//    
//    /* add the audio and video streams using the default format codecs
//     and initialize the codecs */
//    video_st = NULL;
//    audio_st = NULL;
//    if (fmt->video_codec != CODEC_ID_NONE)
//	{
//        video_st = add_video_stream(oc, fmt->video_codec);
//    }
//    
//    if (fmt->audio_codec != CODEC_ID_NONE)
//    {
//        audio_st = add_audio_stream(oc, fmt->audio_codec);
//    }
//    
//    /* set the output parameters (must be done even if no
//     parameters). */
////    if (av_set_parameters(oc, NULL) < 0)
//    
////    if (av_set_parameters(oc, NULL) < 0)
////	{
////        fprintf(stderr, "Invalid output format parameters\n");
////        return false;
////    }
//    
////    dump_format(oc, 0, pfilename, 1);
//    av_dump_format(oc, 0, pfilename, 1);
//    
//    /* now that all the parameters are set, we can open the audio and
//     video codecs and allocate the necessary encode buffers */
//    if (video_st)
//        open_video(oc, video_st);
//    if (audio_st)
//        open_audio(oc, audio_st);
//    
//    /* open the output file, if needed */
//    if (!(fmt->flags & AVFMT_NOFILE))
//	{
////        if (url_fopen(&oc->pb, pfilename, URL_WRONLY) < 0)
//        if (avio_open(&oc->pb, pfilename, AVIO_FLAG_READ_WRITE) < 0)
//        {
//            fprintf(stderr, "Could not open '%s'\n", pfilename);
//            return false;
//        }
//    }
//    
//    /* write the stream header, if any */
////    av_write_header(oc);
//    avformat_write_header(oc, NULL);
//    
//	v_flag = 0;
//	v_pts = 0;
//    _flagCreate = YES;
//	return true;
//}
//
//- (BOOL)WriteH264Video:(char*)pVideoBuff len:(int)nLen
//{
//    if (_flagCreate) {
//  
//	AVPacket pkt;
//	av_init_packet(&pkt);
//    
//	pkt.stream_index = video_st->index;
//	pkt.data = (uint8_t *)pVideoBuff;
//	pkt.size = nLen;
//    
//    
//    
//    
//	//v_time=++v_flag==1?av_gettime()/1000000:v_time;//取得第一次保存的时间
//	//pkt.pts=(av_gettime()/1000000-v_time)*video_st->codec->time_base.den; //用当前系统时间减去第一次的系统时间再进行转化为新的pts
//	//pkt.duration=pkt.pts-v_pts;//这个是这一次的pts和上一次的pts的差
//	//v_pts=pkt.pts;
//	//pkt.dts=pkt.pts;
//    
//	v_time=++v_flag==1?av_gettime():v_time;//取得第一次保存的时间
//    
//    
//	pkt.pts=v_pts++;
//	//pkt.duration= (av_gettime()/1000000-v_time)*video_st->codec->time_base.den/1000000 + 1;
//	pkt.dts=pkt.pts;
//    
//    /*pkt.duration = (av_gettime()-v_time)/1000000*video_st->codec->time_base.den + 1;
//     v_pts += pkt.duration;
//     pkt.pts = v_pts;
//     pkt.dts = pkt.pts;*/
//    
//    
//    if(oc->oformat->video_codec == CODEC_ID_H264)
//	{
//        
//		char szHead[5] = {0};
//		memcpy(szHead,pVideoBuff,5);
//        
//		if((szHead[0] == 0x00) && (szHead[1] == 0x00) && (szHead[2] == 0x00)&& (szHead[3] == 0x01)&& (szHead[4] == 0x67))
//		{
//			pkt.flags|= AV_PKT_FLAG_KEY;
//		}
//	}
//	else
//	{
//		pkt.flags|= AV_PKT_FLAG_KEY;
//	}
//    
//	av_interleaved_write_frame(oc, &pkt); 
//        
//    }
//    
//	return true;
//}
//
//
//- (BOOL)WriteVideo:(char *)pVideoBuff nlen:(int)nLen;
//{
//
//    if (_flagClose) {
//        return NO;
//    }
//		AVPacket pkt;
//		av_init_packet(&pkt);
//        
//		AVCodecContext *c;
//        
//        c = video_st->codec;
//        
//		picture->data[0]=(u_int8_t*)pVideoBuff;
//	    picture->data[2]=picture->data[0]+320*240;
//	    picture->data[1]=picture->data[2]+((320*240)>>2);
//        
////		char *pData = new char[200*1024];
//        char *pData = (char*)malloc(sizeof(char)*200*1024);
//    
//		pkt.size = avcodec_encode_video(c,(uint8_t *)pData,200*1024,picture);
//        
//		pkt.stream_index = video_st->index;
//		pkt.data = (uint8_t *)pData;
//		//pkt.size = nLen;
//    
//		if(c->coded_frame->key_frame)
//		{
//			pkt.flags|= AV_PKT_FLAG_KEY;
//		}
//        
//		av_interleaved_write_frame(oc, &pkt);
//        
//		free(pData);
//
//	return true;
//}
//
///* prepare a 16 bit dummy audio frame of 'frame_size' samples and
// 'nb_channels' channels */
//static void get_audio_frame(int16_t *samples, int frame_size, int nb_channels)
//{
//    int j, i, v;
//    int16_t *q;
//    
//    q = samples;
//    for (j = 0; j < frame_size; j++) {
//        v = (int)(sin(t) * 10000);
//        for(i = 0; i < nb_channels; i++)
//            *q++ = v;
//        t += tincr;
//        tincr += tincr2;
//    }
//}
//
//- (BOOL)WriteAudio:(char *)pAudioBuff nlen:(int)nLen;
//{
//    if (_flagClose) {
//        return NO;
//    }
//	AVPacket pkt;
//	av_init_packet(&pkt);
//    pkt.data = NULL;
//    pkt.size = 0;
//    
//    AVCodecContext *c;
//    c = audio_st->codec;
//    DebugLog(@"nLen  === %d",nLen);
//    memcpy(m_pAudioBuff+m_ulAudioLen, pAudioBuff,nLen);
//    m_ulAudioLen = m_ulAudioLen+nLen;
//    if(m_ulAudioLen < c->frame_size * c->channels*2)
//    {
//        return false;
//    }
//
//    pkt.size = avcodec_encode_audio(c, audio_outbuf, audio_outbuf_size, (const short *)m_pAudioBuff);
//    
//    memcpy(m_pAudioBuff,m_pAudioBuff+c->frame_size * c->channels *2,m_ulAudioLen-c->frame_size * c->channels*2);
//    m_ulAudioLen = m_ulAudioLen - c->frame_size * c->channels *2;
//    
////    FF_MIN_BUFFER_SIZE
//    pkt.flags |= AV_PKT_FLAG_KEY;
//    pkt.stream_index = audio_st->index;
//    pkt.data = (uint8_t *)audio_outbuf;
//    
//    if (c->coded_frame && c->coded_frame->pts != AV_NOPTS_VALUE)
//    {
//        pkt.pts= av_rescale_q(c->coded_frame->pts, c->time_base, audio_st->time_base);
//    }
//    
//    if(pkt.size > 0)
//    {
//        av_interleaved_write_frame(oc, &pkt); 
//    }
//	
//    
//	return true;
//
//}
//
//
//- (void)Close;
//{
//    if (!_flagClose) {
//        _flagClose = YES;
//    }
//    
// 	av_write_trailer(oc);
//    
//    /* close each codec */
//    if (video_st)
//        close_video(oc, video_st);
//    if (audio_st)
//        close_audio(oc, audio_st);
//    
//    /* free the streams */
//	int i = 0;
//    for(i = 0; i < oc->nb_streams; i++) {
//        av_freep(&oc->streams[i]->codec);
//        av_freep(&oc->streams[i]);
//    }
//    
//    if (!(fmt->flags & AVFMT_NOFILE)) {
//        /* close the output file */
////        url_fclose(oc->pb);
//        avio_close(oc->pb);
//    }
//    
//    /* free the stream */
//    av_free(oc);
//}
//
//
////////////////////////////////////////////////////////////////////////
//// Construction/Destruction
////////////////////////////////////////////////////////////////////////
//
//@end
