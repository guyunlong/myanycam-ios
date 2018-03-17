//
//  VideoRecodeEngine.h
//  Myanycam
//
//  Created by myanycam on 13-3-29.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#ifndef __Myanycam__VideoRecodeEngine__
#define __Myanycam__VideoRecodeEngine__

#include <iostream>


#import "avformat.h"
#import "avcodec.h"
#import "avutil.h"
#import "swscale.h"


//#pragma comment(lib,".//FFMEPG//lib//avcodec.lib")
//#pragma comment(lib,".//FFMEPG//lib//avformat.lib")
//#pragma comment(lib,".//FFMEPG//lib//avdevice.lib")
//#pragma comment(lib,".//FFMEPG//lib//avfilter.lib")
//#pragma comment(lib,".//FFMEPG//lib//avutil.lib")
//#pragma comment(lib,".//FFMEPG//lib//swscale.lib")

class CVideoRecorder
{
public:
	CVideoRecorder(void);
	virtual ~CVideoRecorder(void);
public:
	bool Create(int cx,int cy, int videotype, int audiotype, int frame,char *pfilename);
	bool WriteVideo(char *pVideoBuff, int nLen);
	bool WriteAudio(char *pAudioBuff, int nLen);
	void Close(void);
    
protected:
	AVCodec*		m_pAVCodec;
    AVCodecContext*	m_pAVCodecContext;
	struct SwsContext *m_pSwsContext;
    AVFrame*		m_pAVFrame;
	AVFrame*		m_pRGBFrame;
	int				m_nWidth;
	int				m_nHeight;
	unsigned short  m_usFrameRate;
	unsigned char   m_ucMediaType;
	unsigned char   m_ucMediaSize;
};





#endif /* defined(__Myanycam__VideoRecodeEngine__) */
