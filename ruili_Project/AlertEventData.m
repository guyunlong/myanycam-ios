//
//  AlertEventData.m
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

#import "AlertEventData.h"

@implementation AlertEventData

@synthesize userid;
@synthesize cameraid;
@synthesize type;
@synthesize time;
@synthesize pitureFileName;
@synthesize videoFileName;
@synthesize recordData;
@synthesize alertData;

- (void)dealloc{
    
    self.pitureFileName = nil;
    self.videoFileName = nil;
    self.recordData = nil;
    self.alertData = nil;
    [super dealloc];
}

- (id)initWithDictInfo:(NSDictionary *)info{
    
    self = [super init];
    if (self) {
        
        self.userid = [[info objectForKey:@"userid"] intValue];
        self.cameraid = [[info objectForKey:@"cameraid"] intValue];
        self.type = [[info objectForKey:@"type"] intValue];
        self.time = [[info objectForKey:@"time"] unsignedIntValue];
        self.pitureFileName = [info objectForKey:@"piture"];
        self.videoFileName = nil;
        if (self.pitureFileName) {
            
            EventAlertTableViewCellData * data = [[EventAlertTableViewCellData alloc] initWithString:self.pitureFileName];
            self.alertData = data;
            [data release];
            
            if ([data.videoFileName length] > 0) {
                
                self.videoFileName = data.videoFileName;
            }
        }
        
        if ([self.videoFileName length] > 0) {
            
            EventAlertTableViewCellData * data = [[EventAlertTableViewCellData alloc] initWithString:self.videoFileName];
            self.recordData = data;
            [data release];
        }
    }
    
    return self;

}

@end
