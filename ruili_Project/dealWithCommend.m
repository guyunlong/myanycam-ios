//
//  dealWithCommend.m
//  myanycam
//
//  Created by 中程 on 13-1-14.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "dealWithCommend.h"
#import "AESCrypt.h"

@implementation dealWithCommend

+(NSString *)addElement:(NSString *)oldData eName:(NSString *)eName eData:(NSString *)eData
{
    return [NSString stringWithFormat:@"%@<%@=%@>",oldData,eName,eData];
}
+(void)noticeAlertView:(NSString *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil
                                                          message:noti
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });

}
+(NSString *)addToken:(NSString *)oldData xns:(NSString *)xns cmd:(NSString *)cmd time:(NSString *)time
{
    return [NSString stringWithFormat:@"%@%@",oldData,[AESCrypt encrypt:[NSString stringWithFormat:@"<xns=%@><cmd=%@><time=%@>",xns,cmd,time] password:@"000"]];
}
+(NSString *)addHeader:(NSString *)oldData
{
    return oldData;
}

+(void)createHistoryFolder:(NSString *)folderName
{
    NSString *documentsDirectoty=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",folderName]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoty])
    {
        NSError *error=nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectoty withIntermediateDirectories:YES attributes:nil error:&error];
    }
}
+(NSString *)getDate
{
    NSString *result=@"";
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    unsigned long ulTime=time;
    result=[NSString stringWithFormat:@"%lu",ulTime];
    return result;
}
//+(void)intToData:(NSMutableData *)oldData num:(int)num
//{
//    Byte buff[1];
//    
//    NSData *data=[[NSData alloc] initWithBytes:&num length:4];
//    NSRange arange=NSMakeRange(4, 1);
//    for (int i=0; i<4; i++) {
//        arange.location=3-i;
//        [data getBytes:buff range:arange];
//        [oldData appendBytes:buff length:1];
//    }
//    [data release];
//}

+ (NSInteger)headerDataToLength:(NSData *)headerData{
    long length = 0;
    memcpy(&length, [headerData bytes], 4);
    NSInteger  l = htonl(length);
    return l;
}

+(int)DataToInt:(NSData *)oldData
{
    int result=0;
    Byte buff[1];
    int dataLength=[oldData length];
    NSRange arange=NSMakeRange(0, 1);
    NSMutableData *changedData=[[NSMutableData alloc] init];
    
    for (int i=0; i<dataLength; i++) {
        arange.location=dataLength-i-1;
        [oldData getBytes:buff range:arange];
        [changedData appendBytes:buff length:1];
    }
    [changedData getBytes:&result length:dataLength];
    [changedData release];
    return result;
    
}
+(void)getData:(NSMutableData *)result oldData:(NSData *)oldData
{
    int dataLength=0;
    Byte buff[1];
    NSMutableData *dataLengthData=[[NSMutableData alloc] init];
    NSRange arange=NSMakeRange(1, 1);
    for (int i=4; i<8; i++) {
        arange.location=i;
        [oldData getBytes:buff range:arange];
        [dataLengthData appendBytes:buff length:1];
    }
    dataLength=[self DataToInt:dataLengthData]-1;
    [dataLengthData release];
    
    for (int i=0; i<dataLength; i++) {
        arange.location=i+8;
        [oldData getBytes:buff range:arange];
        [result appendBytes:buff length:1];
    }
}
+(NSInteger)getMcuData:(NSMutableData *)result Channel:(NSMutableData *)channel oldData:(NSData *)oldData
{
    int dataLength=[oldData length];
    NSRange arange=NSMakeRange(0, 1);
    Byte buff[1];
    int cmdType=0;
    
    [oldData getBytes:&cmdType range:arange];
    
    for (int i=4; i>0; i--) {
        arange.location=i;
        [oldData getBytes:&buff range:arange];
        [channel appendBytes:buff length:1];
    }
    
    for (int i=5; i<dataLength; i++) {
        arange.location=i;
        [oldData getBytes:buff range:arange];
        [result appendBytes:buff length:1];
    }
    return cmdType;
    
}
+(void)disperateMcuMsg:(NSMutableData *)result remainData:(NSMutableData *)remainData
{
     NSMutableData *oldData=[remainData copy];
    int totalLength=[oldData length];
    int dataLength=[oldData length];
   
    NSRange arange=NSMakeRange(0,1);
    if (dataLength>4) {
        NSMutableData *dataLengthData=[[NSMutableData alloc] init];
        Byte buff[1];
        for (int i=0; i<4; i++) {
            arange.location=i;
            [oldData getBytes:buff range:arange];
            [dataLengthData appendBytes:buff length:1];
        }
        [result init];
        dataLength =[self DataToInt:dataLengthData];
        arange.location=4;
        for (int i=0; i<dataLength; i++) {
            arange.location=4+i;
            [oldData getBytes:buff range:arange];
            [result appendBytes:buff length:1];
        }
        [remainData init];
        for (int i=4+dataLength; i<totalLength; i++) {
            arange.location=i;
            [oldData getBytes:buff range:arange];
            [remainData appendBytes:buff length:1];
        }
    }
    
    [oldData release];
}
+(NSMutableDictionary *)getIpAndPort:(NSMutableData *)oldData
{
    NSInteger port=0;
    NSInteger ipPart=0;
    NSString *ip=@"";
    NSMutableDictionary *resultDict=[NSMutableDictionary dictionaryWithCapacity:10];
    NSRange arange=NSMakeRange(0, 1);
    for (int i=0; i<3; i++) {
        arange.location=i;
        [oldData getBytes:&ipPart range:arange];
        ip=[NSString stringWithFormat:@"%@%d.",ip,ipPart];
    }
    arange.location=3;
    [oldData getBytes:&ipPart range:arange];
    ip=[NSString stringWithFormat:@"%@%d",ip,ipPart];
    
    Byte buff[1];
    NSMutableData *portData=[[NSMutableData alloc] init];
    for (int i=0; i<2; i++) {
        arange.location=5-i;
        [oldData getBytes:buff range:arange];
        [portData appendBytes:buff length:1];
    }
    [portData getBytes:&port length:2];
    [resultDict setObject:ip forKey:@"ip"];
    [resultDict setObject:[NSNumber numberWithInt:port] forKey:@"port"];
    [portData release];
    return resultDict;
}

@end
