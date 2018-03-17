//
//  AlarmEventData.h
//  Myanycam
//
//  Created by myanycam on 13/6/3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

//bvideo = 1;
//cameraid = 10;
//cmd = "ALARM_EVENT";
//fromuid = 10;
//piture = "0_20130603060746_1_1_20130603060746.mp4.jpg";
//sessionid = 95009501;
//time = 0;
//touid = 10;
//type = 0;
//userid = 10;
//video = "1_20130603060746.mp4";
//xns = "XNS_CLIENT";

#import <Foundation/Foundation.h>

@interface AlarmEventData : NSObject

@property (assign, nonatomic) NSInteger bvideo;
@property (assign, nonatomic) NSInteger cameraid;
@property (assign, nonatomic) NSInteger fromuid;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger userid;
@property (retain, nonatomic) NSString * picture;
@property (retain, nonatomic) NSString * video;


@end
