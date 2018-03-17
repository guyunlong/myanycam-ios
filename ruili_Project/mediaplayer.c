

#import "mediaplayer.h"




/* Cheat to keep things simple and just use some globals. */

AVFormatContext *pFormatCtx;
AVCodecContext *pCodecCtx;
AVFrame *pFrame;
AVFrame *pFrameRGB;
int videoStream;
struct SwsContext *img_convert_ctx;

/*record*/
bool _capture = false;
bool _record = false;// 是否要录制
bool _recordstate = false; // 如果第一次录制，置为true ，然后置为false
bool _recordchanged = false;//从开 到 关 为 true 其他都为 false


/* 5 seconds stream duration */
#define STREAM_DURATION   5.0
#define STREAM_FRAME_RATE 30 /* 25 images/s */
#define STREAM_NB_FRAMES  ((int)(STREAM_DURATION * STREAM_FRAME_RATE))
#define STREAM_PIX_FMT PIX_FMT_YUV420P /* default pix_fmt */

static int sws_flags = SWS_POINT;

bool highfreq;// 手机主频是不是达到要求


AVOutputFormat *fmt;
AVFormatContext *oc;
AVStream *audio_st, *video_st;
double audio_pts, video_pts;
int i;
int count = 0;


/**************************************************************/
/* video output */

static AVFrame *picture, *tmp_picture;
static uint8_t *video_outbuf;
static int frame_count, video_outbuf_size;




///////////////////////////

static uint16_t *s_pixels = 0;
int TEXTURE_WIDTH = 512;//the texture width and height
int TEXTURE_HEIGHT = 256;
int s_w = 480;//the device width and height
int s_h = 360;
int pix_size;


/* add a video output stream */
static AVStream *add_video_stream(AVFormatContext *oc, int codec_id)
{
    AVCodecContext *c;
    AVStream *st;
    AVCodec *codec;

    st = av_new_stream(oc, NULL);
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
    c->pix_fmt = STREAM_PIX_FMT;
    if (c->codec_id == CODEC_ID_MPEG2VIDEO) {
        /* just for testing, we also add B frames */
        c->max_b_frames = 2;
    }
    if (c->codec_id == CODEC_ID_MPEG1VIDEO){
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

static void write_video_frame(AVFormatContext *oc, AVStream *st)
{
    int out_size, ret;
    AVCodecContext *c;
    static struct SwsContext *img_convert_ctxmp;

    c = st->codec;

    if (frame_count >= STREAM_NB_FRAMES) {
      
        /* no more frame to compress. The codec has a latency of a few
        frames if using B frames, so we get the last frames by
        passing the same picture again */
    } else {
       
        if (c->pix_fmt != PIX_FMT_YUV420P) {
          
            /* as we only generate a YUV420P picture, we must convert it
            to the codec pixel format if needed */
            if (img_convert_ctxmp == NULL) {
                img_convert_ctxmp = sws_getContext(c->width, c->height,
                                                 PIX_FMT_YUV420P,
                                                 c->width, c->height,
                                                 c->pix_fmt,
                                                 sws_flags, NULL, NULL, NULL);
                if (img_convert_ctxmp == NULL) {
                    fprintf(stderr, "Cannot initialize the conversion context\n");
                    exit(1);
                }
            }
           
            sws_scale(img_convert_ctxmp, tmp_picture->data, tmp_picture->linesize,
                      0, c->height, picture->data, picture->linesize);
        } else {
           
            
        }
    }


    if (oc->oformat->flags & AVFMT_RAWPICTURE) {
       
        /* raw video case. The API will change slightly in the near
        future for that. */
        AVPacket pkt;
        av_init_packet(&pkt);

        pkt.flags |= AV_PKT_FLAG_KEY;
        pkt.stream_index = st->index;
        pkt.data = (uint8_t *)picture;
        pkt.size = sizeof(AVPicture);

        ret = av_interleaved_write_frame(oc, &pkt);
    } else {
        
        /* encode the image */
        out_size = avcodec_encode_video(c, video_outbuf, video_outbuf_size, picture);
        /* if zero size, it means the image was buffered */
        if (out_size > 0) {
            AVPacket pkt;
            av_init_packet(&pkt);

            if (c->coded_frame->pts != AV_NOPTS_VALUE)
                pkt.pts= av_rescale_q(c->coded_frame->pts, c->time_base, st->time_base);
            if(c->coded_frame->key_frame)
                pkt.flags |= AV_PKT_FLAG_KEY;
            pkt.stream_index = st->index;
            pkt.data = video_outbuf;
            pkt.size = out_size;

            //          printf("pts %d \n", c->coded_frame->pts);

            /* write the compressed frame in the media file */
            ret = av_interleaved_write_frame(oc, &pkt);
        } else {
            ret = 0;
        }
    }
    if (ret != 0) {
        fprintf(stderr, "Error while writing video frame\n");
        exit(1);
    }
    frame_count++;
}

static AVFrame *alloc_picture(enum PixelFormat pix_fmt, int width, int height)
{
    AVFrame *picture;
    uint8_t *picture_buf;
    int size;

    picture = avcodec_alloc_frame();
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

static void open_video(AVFormatContext *oc, AVStream *st)
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
    if (avcodec_open(c, codec) < 0) {
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
    picture = alloc_picture(c->pix_fmt, c->width, c->height);
    if (!picture) {
        fprintf(stderr, "Could not allocate picture\n");
        exit(1);
    }

    /* if the output format is not YUV420P, then a temporary YUV420P
    picture is needed too. It is then converted to the required
    output format */
    tmp_picture = NULL;
    if (c->pix_fmt != PIX_FMT_YUV420P) {
        tmp_picture = alloc_picture(PIX_FMT_YUV420P, c->width, c->height);
        if (!tmp_picture) {
            fprintf(stderr, "Could not allocate temporary picture\n");
            exit(1);
        }
    }
}

static void close_video(AVFormatContext *oc, AVStream *st)
{
    avcodec_close(st->codec);
    av_free(picture->data[0]);
    av_free(picture);
    if (tmp_picture) {
        av_free(tmp_picture->data[0]);
        av_free(tmp_picture);
    }
    av_free(video_outbuf);
}


void initDecoder(int width,int height)
{

  uint8_t *buffer;
  int numBytes;
  av_register_all();
 
  avcodec_init();

  AVCodec * pCodec = avcodec_find_decoder(CODEC_ID_H264);

  pCodecCtx = avcodec_alloc_context();

  pCodecCtx->time_base.num = 1; //这两行：一秒钟25帧
  pCodecCtx->time_base.den = 25;
  pCodecCtx->bit_rate = 0; //初始化为0
  pCodecCtx->frame_number = 1; //每包一个视频帧
  pCodecCtx->codec_type = CODEC_TYPE_VIDEO;
  pCodecCtx->width = width; //这两行：视频的宽度和高度
  pCodecCtx->height = height;
  pCodecCtx->pix_fmt=PIX_FMT_YUV420P;
  
  if(avcodec_open(pCodecCtx, pCodec)<0) {
      LOGE("Unable to open codec");
      return;
  }
  pFrame=avcodec_alloc_frame();
  img_convert_ctx = sws_getContext(pCodecCtx->width, pCodecCtx->height, 
                       pCodecCtx->pix_fmt, 
                       TEXTURE_WIDTH, TEXTURE_HEIGHT, PIX_FMT_RGB565, SWS_POINT, 
                       NULL, NULL, NULL);
  if(img_convert_ctx == NULL) {
        LOGE("could not initialize conversion contex,w is \n");
        return;
    }

}


int decode(uint8_t *Buf,int Len)
{
 
  
   AVPacket packet;
   static int      bytesRemaining;          
   static uint8_t  *rawData;                 
   int             bytesDecoded;            
   int             frameFinished =0;  
   bytesRemaining = Len;
   rawData = (uint8_t*)Buf;
  packet.data = rawData;
  packet.size = Len;
  bytesDecoded = avcodec_decode_video2(pCodecCtx, pFrame, &frameFinished, &packet);
  if (bytesDecoded>0)
  {
    LOGE("decode byte is %d \n",bytesDecoded);


     if(_record)
    {
        if (_recordstate)
        {   //第一次录制 初始化 编码引擎
            _recordstate = false;
             fmt = guess_format(NULL, _filename, NULL);
            if (!fmt) {
                printf("Could not deduce output format from file extension: using MPEG.\n");
                fmt = guess_format("mpeg", NULL, NULL);
            }
            if (!fmt) {
                fprintf(stderr, "Could not find suitable output format\n");
                exit(1);
            }

            /* allocate the output media context */
            oc = av_alloc_format_context();
            if (!oc) {
                fprintf(stderr, "Memory error\n");
                exit(1);
            }
            oc->oformat = fmt;
            snprintf(oc->filename, sizeof(oc->filename), "%s", _filename);

            oc->oformat->video_codec = CODEC_ID_MPEG4;

            fmt = oc->oformat;
            video_st = NULL;

            if (fmt->video_codec != CODEC_ID_NONE) {
                video_st = add_video_stream(oc, fmt->video_codec);
            }


            dump_format(oc, 0, _filename, 1);

            if (video_st)
            {
                open_video(oc, video_st);
            }

            /* open the output file, if needed */
            if (!(fmt->flags & AVFMT_NOFILE)) {
                if (url_fopen(&oc->pb, _filename, URL_WRONLY) < 0) {
                    fprintf(stderr, "Could not open '%s'\n",_filename);
                    return -1;
                }
            }

            /* write the stream header, if any */
            av_write_header(oc);
            picture->pts = 0;

        }
        int out_size, ret;
        AVCodecContext *c;
        //static struct SwsContext *img_convert_ctx;
        c = video_st->codec;
        out_size = avcodec_encode_video(c, video_outbuf, video_outbuf_size, pFrame);
      
        if (out_size > 0) {
            AVPacket pkt;
            av_init_packet(&pkt);

            if (c->coded_frame->pts != AV_NOPTS_VALUE)
                pkt.pts= av_rescale_q(c->coded_frame->pts, c->time_base, video_st->time_base);
            if(c->coded_frame->key_frame)
                pkt.flags |= AV_PKT_FLAG_KEY;
            pkt.stream_index = video_st->index;
            pkt.data = video_outbuf;
            pkt.size = out_size;

           
            ret = av_interleaved_write_frame(oc, &pkt);
        } else {
            ret = 0;
        }
       

    }
      if(_recordchanged)
      {
        _recordchanged = false;
        av_write_trailer(oc);
        if (video_st)
           close_video(oc, video_st);
        for(i = 0; i < oc->nb_streams; i++) {
            av_freep(&oc->streams[i]->codec);
            av_freep(&oc->streams[i]);
        }

        if (!(fmt->flags & AVFMT_NOFILE)) {
            url_fclose(oc->pb);
        }
      av_free(oc);
      }

      if(_capture)
      {
      
          _capture = false;
         
          unsigned char *rgbBuf = (unsigned char*)malloc(pCodecCtx->width*pCodecCtx->height*3);    
  
          struct SwsContext* img_convert_ctx_pic = 0;  
          int linesize[4] = {3*pCodecCtx->width, 0, 0, 0};  
        
          img_convert_ctx_pic = sws_getContext(pCodecCtx->width, pCodecCtx->height,  
              PIX_FMT_YUV420P,  
              pCodecCtx->width,  
              pCodecCtx->height,  
              PIX_FMT_BGR24, SWS_FAST_BILINEAR, 0, 0, 0);  
          if (img_convert_ctx_pic != 0)  
          {  
              
              sws_scale(img_convert_ctx_pic, pFrame->data, pFrame->linesize, 0, pCodecCtx->height, (uint8_t**)&rgbBuf, linesize);  
              sws_freeContext(img_convert_ctx_pic);  
             
              saveFrame(rgbBuf,_picname, pCodecCtx->width, pCodecCtx->height);//生成图片  
             
          }  
          free(rgbBuf);  
      }
    if(_firFrame)
    {
      _firFrame = false;
    }
 
    sws_scale(img_convert_ctx, (const uint16_t* const*)pFrame->data, pFrame->linesize, 0, pCodecCtx->height, pFrameRGB->data, pFrameRGB->linesize);

    /* show video*/
   
    LOGE("frame is %d \n",newFrame);
  }

  return bytesDecoded;
  
}

int TranseFmt(char *pinfilename, char *poutfilename)     
{

}