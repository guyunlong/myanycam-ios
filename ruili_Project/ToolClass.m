//
//  ToolClass.m
//  Myanycam
//
//  Created by myanycam on 13-2-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "ToolClass.h"
#import "base64.h"
#import "GTMBase64.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation ToolClass

+ (CGFloat)systemVersionFloat {
    
    return [[UIDevice currentDevice].systemVersion floatValue];
}

+ (BOOL)checkEmail:(NSString*)emailStr{
    
    BOOL infoRightOrNot = NO;
    
    if ([emailStr length] > 4 && [emailStr length]< 33) {
        NSString *regex = @"([\\d|a-z|A-Z|-|_|\\.])*([\\d|a-z|A-Z])+(@)+([\\d|a-z|A-Z|])*(-)*(_)*([\\d|a-z|A-Z|])+(\\.[a-z|A-Z]{2,3})*(\\.[a-z|A-Z]{2,3})";
        NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([regextest evaluateWithObject:emailStr] == YES) {
            infoRightOrNot = YES;
        }
    }
    return infoRightOrNot;
}

+ (NSString*)documentDirectoryPath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([path count] > 0) {
		NSString *userDocumentsPath = [path objectAtIndex:0];
		return userDocumentsPath;
	}
	return nil;
}


+ (uint32_t)stringToIp:(NSString *)ipStr{
    
    NSArray *ipExplode = [ipStr componentsSeparatedByString:@"."];
    int seg1 = [ipExplode[0] intValue];
    int seg2 = [ipExplode[1] intValue];
    int seg3 = [ipExplode[2] intValue];
    int seg4 = [ipExplode[3] intValue];
    
    uint32_t newIP = 0;
    newIP |= (uint32_t)((seg1 & 0xFF) << 24);
    newIP |= (uint32_t)((seg2 & 0xFF) << 16);
    newIP |= (uint32_t)((seg3 & 0xFF) << 8);
    newIP |= (uint32_t)((seg4 & 0xFF) << 0);
    return newIP;
    
//    uint32_t newIP = ip;
//    NSString *newIPStr = [NSString stringWithFormat:@"%u.%u.%u.%u",
//                          ((newIP >> 24) & 0xFF),
//                          ((newIP >> 16) & 0xFF),
//                          ((newIP >> 8) & 0xFF),
//                          ((newIP >> 0) & 0xFF)];
//    DebugLog(@"%@",newIPStr);
}

+ (NSString *)getEqualString:(NSString *)tokenStr{
    
    NSRange range = [tokenStr rangeOfString:@"="];
    NSString * oauthToken = [tokenStr substringWithRange:NSMakeRange(range.location+1, tokenStr.length - range.location - 1)];
    return oauthToken;
}

+ (int)wifiLevelFormat:(int)signal{
    

    if (signal < 10) {
        
        return  1;
    }
    
    if (signal < 30) {
        return 2;
    }
    
    if (signal < 45) {
        return 3;
    }
    
    return 4;
    
}

//+ (NSString * )decodeBase64:(NSString *)base64Data{
//    
//    NSString *stringValue = base64Data;/*the UTF8 string parsed from xml data*/
//    Byte inputData[[stringValue lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];//prepare a Byte[]
//    [[stringValue dataUsingEncoding:NSUTF8StringEncoding] getBytes:inputData];//get the pointer of the data
//    size_t inputDataSize = (size_t)[stringValue length];
//    size_t outputDataSize = EstimateBas64DecodedDataSize(inputDataSize);//calculate the decoded data size
//    Byte outputData[outputDataSize];//prepare a Byte[] for the decoded data
//    Base64DecodeData(inputData, inputDataSize, outputData, &outputDataSize);//decode the data
//    NSData *theData = [[NSData alloc] initWithBytes:outputData length:outputDataSize];//create a NSData object from the decoded data
//    NSString * string = [NSString stringWithCString:[theData bytes] encoding:NSASCIIStringEncoding];
//    return string;
//}

+ (NSString*)encodeBase64:(NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    return base64String;
}

+ (NSString*)decodeBase64:(NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 decodeData:data];
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    
    if ([base64String length] == 0) {
        
        return input;
    }
    
    return base64String;
}



+ (id)fetchSSIDInfo
{
    NSArray *ifs = (id)CNCopySupportedInterfaces();
//    DebugLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
//        DebugLog(@"%s: %@ => %@", __func__, ifnam, info);
        if (info && [info count]) {
            break;
        }
        [info release];
    }
    [ifs release];
    return [info autorelease];
}


+ (void)deleteFileWithPath:(NSString *)path{
    
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString *fileName;
    while (fileName= [dirEnum nextObject]) {
        
        NSString * filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
        DebugLog(@"filePath %@",filePath);
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        
    }
}

+ (BOOL)fileIsExist:(NSString *)path{
    
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

+ (NSString*)encodeURL:(NSString *)string
{
	NSString *result = (NSString*)CFURLCreateStringByAddingPercentEscapes(nil,
                                                                          (CFStringRef)string, nil,
                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    return result;
}


@end
