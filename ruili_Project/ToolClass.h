//
//  ToolClass.h
//  Myanycam
//
//  Created by myanycam on 13-2-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolClass : NSObject

+ (CGFloat)systemVersionFloat;

+ (BOOL)checkEmail:(NSString*)emailStr;

+ (NSString*)documentDirectoryPath;

+ (uint32_t)stringToIp:(NSString *)ipStr;

+ (NSString *)getEqualString:(NSString *)tokenStr;

+ (int)wifiLevelFormat:(int)signal;

//+ (NSString * )decodeBase64:(NSData*)base64Data;
+ (NSString*)encodeBase64:(NSString*)input;

+ (NSString*)decodeBase64:(NSString*)input;

+ (id)fetchSSIDInfo;

+ (void)deleteFileWithPath:(NSString *)path;

+ (BOOL)fileIsExist:(NSString *)path;

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;

+ (NSString*)encodeURL:(NSString *)string;

@end
