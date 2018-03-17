// AVH264Encoder.h: interface for the AVH264Encoder class.
//
//////////////////////////////////////////////////////////////////////

#ifndef __VIDEORECORDER_H__
#define __VIDEORECORDER_H__

#include ".\FFMEPG\include\libavformat\avformat.h"
#include ".\FFMEPG\include\libavcodec\avcodec.h"
#include ".\FFMEPG\include\libavutil\avutil.h"
#include ".\FFMEPG\include\libswscale\swscale.h"  

#pragma comment(lib,".//FFMEPG//lib//avcodec.lib")
#pragma comment(lib,".//FFMEPG//lib//avformat.lib")
#pragma comment(lib,".//FFMEPG//lib//avdevice.lib")
#pragma comment(lib,".//FFMEPG//lib//avfilter.lib")
#pragma comment(lib,".//FFMEPG//lib//avutil.lib")
#pragma comment(lib,".//FFMEPG//lib//swscale.lib")

class CVideoRecorder  
{
public:
	CVideoRecorder(void);
	virtual ~CVideoRecorder(void);
public:
	bool Create(int cx,int cy, int frame,char *pfilename);
	bool WriteH264Video(char *pVideoBuff, int nLen);
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

	int64_t v_time;
	int64_t  v_pts;
	int v_flag;

	char * m_pAudioBuff;
	unsigned long m_ulAudioLen;
};

#endif