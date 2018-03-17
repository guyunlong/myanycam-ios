//
//  EthernetInfoData.h
//  Myanycam
//
//  Created by myanycam on 13-2-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface EthernetInfoData : NSObject

@property (assign, nonatomic)  NSInteger  dhcp;
@property (retain, nonatomic)  NSString * ipAddress;
@property (retain, nonatomic)  NSString * maskAddress;
@property (retain, nonatomic)  NSString * netgateAddress;
@property (retain, nonatomic)  NSString * dns1Address;
@property (retain, nonatomic)  NSString * dns2Address;
@property (retain, nonatomic)  NSString * macAddress;


- (id)initWithDictionary:(NSDictionary *)info;

@end
