////
////  VideoReocderEngine.h
////  Myanycam
////
////  Created by myanycam on 13-3-29.
////  Copyright (c) 2013年 Myanycam. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "avformat.h"
//#import "avcodec.h"
//#import "avutil.h"
//#import "swscale.h"
//
////#include <libavutil/opt.h>
//
//@interface VideoReocderEngine : NSObject{
//    
//    AVCodec*		m_pAVCodec;
//    AVCodecContext*	m_pAVCodecContext;
//	struct SwsContext *m_pSwsContext;
//    AVFrame*		m_pAVFrame;
//	AVFrame*		m_pRGBFrame;
//	int				m_nWidth;
//	int				m_nHeight;
//	unsigned short  m_usFrameRate;
//	unsigned char   m_ucMediaType;
//	unsigned char   m_ucMediaSize;
//    
//    int64_t v_time;
//	int64_t  v_pts;
//	int v_flag;
//    
//	char * m_pAudioBuff;
//	unsigned long m_ulAudioLen;
//    BOOL            _flagCreate;
//    BOOL            _flagClose;
//}
//
//
//- (BOOL)Create:(int)cx cy:(int)cy video:(int)videotype audioType:(int)audiotype frame:(int)frame pfileName:(char *)pfilename;
//- (BOOL)WriteVideo:(char *)pVideoBuff nlen:(int)nLen;
//- (BOOL)WriteAudio:(char *)pAudioBuff nlen:(int)nLen;
//- (BOOL)WriteH264Video:(char*)pVideoBuff len:(int)nLen;
//- (void)Close;
//
//
//@end
