//
//  VideoDownloadUrlData.h
//  Myanycam
//
//  Created by myanycam on 13-5-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoDownloadUrlData : NSObject

@property (assign, nonatomic) NSInteger  userid;
@property (assign, nonatomic) NSInteger  cameraid;
@property (retain, nonatomic) NSString * localUrl;
@property (retain, nonatomic) NSString * proxyurl;
@property (retain, nonatomic) NSString * localUrlIp;
@property (assign, nonatomic) NSInteger  localPort;




- (id)initWithDictInfo:(NSDictionary *)info;


@end
