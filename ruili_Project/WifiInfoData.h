//
//  WifiInfoData.h
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

//ssid=TP-LINK; //当前使用的ssid
//safety= 0//安全类型 0：NONE 1:WPA 2:WP2
//signal=0; //信号强度
//password=********//wifi密码
@interface WifiInfoData : NSObject
@property (retain, nonatomic) NSString * ssid ;
@property (assign, nonatomic) int safety ;
@property (assign, nonatomic) NSInteger  signal;
@property (retain, nonatomic) NSString * password;
@property (assign, nonatomic) BOOL   isManualAdd;

@end
