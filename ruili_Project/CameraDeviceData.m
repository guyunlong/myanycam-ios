//
//  CameraDeviceData.m
//  Myanycam
//
//  Created by myanycam on 13-5-16.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraDeviceData.h"
//cmd = "DEVICE_INFO";
//mode = "ip camera";
//password = test;
//producter = wanchen;
//sn = 1234567896;
//timezone = "";
//xns = "XNS_CAMERA";

@implementation CameraDeviceData

@synthesize sn;
@synthesize timezone;
@synthesize producter;
@synthesize mode;
@synthesize password;


- (void)dealloc{
    self.sn = nil;
    self.timezone = nil;
    self.producter = nil;
    self.mode = nil;
    self.password = nil;
    [super dealloc];
}


- (id)initWithInfo:(NSDictionary *)info{
    
    self = [super init];
    if (self) {
        
        self.sn = [info objectForKey:@"sn"];
        self.timezone = [info objectForKey:@"timezone"];
        self.mode = [info objectForKey:@"mode"];
        self.producter = [info objectForKey:@"producter"];
        self.password = [info objectForKey:@"password"];
    }
    
    return self;
}

@end
