#ifndef _AK_ADPCM_H_
#define _AK_ADPCM_H_


int DecodeAdpcm(char *indata,unsigned long len, short *outdata, unsigned long *ulPcmLen);
int EncodeAdpcm(short *indata,int len, char * outdata, unsigned long *ulAdpcmLen);


#endif
