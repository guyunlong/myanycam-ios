//
//  AlertEventData.h
//  Myanycam
//
//  Created by myanycam on 13-5-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

//cameraid = 215;
//cmd = "ALARM_EVENT";
//fromuid = 215;
//piture = "1_20130615160842_1_20130615160655.mp4.jpg ";
//remoteip = "54.235.154.234";
//serverid = 2997413410;
//sessionid = 1153795570;
//time = 1371312522;
//touid = 268;
//type = 1;
//userid = 268;
//xns = "XNS_CLIENT";

#import <Foundation/Foundation.h>
#import "EventAlertTableViewCellData.h"

@interface AlertEventData : NSObject

@property (assign, nonatomic) NSInteger userid;
@property (assign, nonatomic) NSInteger cameraid;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSUInteger time;
@property (retain, nonatomic) NSString * pitureFileName;
@property (retain, nonatomic) NSString * videoFileName;

@property (retain, nonatomic) EventAlertTableViewCellData * alertData;
@property (retain, nonatomic) EventAlertTableViewCellData * recordData;


- (id)initWithDictInfo:(NSDictionary *)info;


@end
