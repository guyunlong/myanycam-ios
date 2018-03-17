//
//  dealWithCommend.h
//  myanycam
//
//  Created by 中程 on 13-1-14.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dealWithCommend : NSObject

+(NSString *)addElement:(NSString *)oldData eName:(NSString *)eName eData:(NSString *)eData;
+(NSString *)addToken:(NSString *)oldData xns:(NSString *)xns cmd:(NSString *)cmd time:(NSString *)time;
+(void)noticeAlertView:(NSString *)noti;
+(void)createHistoryFolder:(NSString *)folderName;
+(NSString *)getDate;
//+(void)intToData:(NSMutableData *)oldData num:(int)num;
+(void)getData:(NSMutableData *)result oldData:(NSData *)oldData;
+(NSInteger)getMcuData:(NSMutableData *)result Channel:(NSMutableData *)channel oldData:(NSData *)oldData;
+ (NSInteger)headerDataToLength:(NSData *)headerData;
+(int)DataToInt:(NSData *)oldData;
+(void)disperateMcuMsg:(NSMutableData *)result remainData:(NSMutableData *)remainData;
+(NSMutableDictionary *)getIpAndPort:(NSMutableData *)oldData;
@end
