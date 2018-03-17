//
//  EthernetInfoData.m
//  Myanycam
//
//  Created by myanycam on 13-2-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//
//xns= XNS_CAMERA
//cmd= NETWORK_INFO
//dhcp=0 //0:false 1:true
//ip=192.168.1.100 //IP地址
//mask=255.255.255.0 //子网掩码
//netgate= 192.168.1.1//默认网关
//dns1 = 202.96.134.133 //DNS
//dns2= 202.96.134.122 //备用DNS
//mac=AD-DB-FF-CC-87-CA-35-11 //网卡物理地址

//
//cmd = "NETWORK_INFO";
//dhcp = 0;
//dns1 = "202.96.134.133";
//dns2 = "202.96.134.133";
//ip = "192.168.1.168";
//mac = "";
//mask = "255.255.255.0";
//netgate = "192.168.1.1";
//xns = "XNS_CAMERA";
#import "EthernetInfoData.h"

@implementation EthernetInfoData

@synthesize dhcp;
@synthesize ipAddress;
@synthesize maskAddress;
@synthesize netgateAddress;
@synthesize dns1Address;
@synthesize dns2Address;
@synthesize macAddress;

- (id)initWithDictionary:(NSDictionary *)info{
    
    self = [super init];
    if (self) {
        
        self.dhcp = [[info objectForKey:@"dhcp"] intValue];
        self.ipAddress = [info objectForKey:@"ip"];
        self.maskAddress = [info objectForKey:@"mask"];
        self.dns1Address = [info objectForKey:@"dns1"];
        self.dns2Address = [info objectForKey:@"dns2"];
        self.netgateAddress = [info objectForKey:@"netgate"];
        self.macAddress = [info objectForKey:@"mac"];
    }
    
    return self;
}

- (void)dealloc{
    self.ipAddress = nil;
    self.maskAddress = nil;
    self.netgateAddress = nil;
    self.dns1Address = nil;
    self.dns2Address = nil;
    self.macAddress = nil;
    [super dealloc];
}
@end
