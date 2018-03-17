//
//  CameraInfoData.m
//  Myanycam
//
//  Created by myanycam on 13-5-17.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraInfoData.h"

@implementation CameraInfoData

@synthesize  cameraIndex;//当前是第几个

@synthesize  cameraName;
@synthesize  cameraId;
@synthesize  type;
@synthesize  status;
@synthesize  cameraSn;
@synthesize  memo;
@synthesize  password;
@synthesize  cameraCount;
@synthesize  touid;
@synthesize  sessionid;
@synthesize  fromuid;
@synthesize  nowcount;
@synthesize  accesskey;
@synthesize  sharePassword;
@synthesize  vflip;

@synthesize timezone;
@synthesize producter;
@synthesize mode;

@synthesize iSselect;
@synthesize chipType;
@synthesize flagListen;

@synthesize romVersionStr;
@synthesize downloadurlStr;
@synthesize versioninfoStr;
@synthesize needUpdate;

@synthesize videoQualitySize;
@synthesize flagCheckIP;
@synthesize flagLock;
@synthesize shareswitch;
@synthesize flagUpnp_success;
@synthesize flagUserProvenResp;

@synthesize cameraNatip;


- (void)dealloc{
    
    self.cameraName = nil;
    self.cameraSn = nil;
    self.memo = nil;
    self.password = nil;
    self.cameraId = nil;
    self.sessionid = nil;
    self.flagListen = NO;
    self.needUpdate = nil;
    self.accesskey = nil;
    self.producter = nil;
    self.mode = nil;
    self.romVersionStr = nil;
    self.downloadurlStr = nil;
    self.versioninfoStr = nil;
    self.videoQualitySize = nil;
    
    self.cameraNatip = nil;
    
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)info{
    
    self = [super init];
    if (self) {
        
        self.cameraName = [ToolClass decodeBase64:[info objectForKey:@"name"]];
        self.memo = [ToolClass decodeBase64:[info objectForKey:@"memo"]];
        self.cameraSn = [info objectForKey:@"sn"];
        self.cameraId = [[info objectForKey:@"cameraid"] intValue];
        self.touid = [[info objectForKey:@"touid"] intValue];
        self.fromuid = [[info objectForKey:@"fromuid"] intValue];
        self.nowcount = [[info objectForKey:@"nowcount"] intValue];
        self.type = [[info objectForKey:@"type"] intValue];
        self.cameraCount = [[info objectForKey:@"count"] intValue];
        self.password = [info objectForKey:@"password"];
        self.videoQualitySize = 2;//标清
        self.needUpdate = -1;
        self.flagCheckIP = -1;
        self.romVersionStr = @"";
        self.sharePassword = @"";
        self.accesskey = @"";
        self.flagUpnp_success = -1;
        self.flagUserProvenResp = NO;
        self.flagLock = NO;
        
        NSString * typeStr = [self.cameraSn substringWithRange:NSMakeRange(0, 4)];
        
        if ([typeStr isEqualToString:@"0101"]) {
            
            self.chipType = ChipTypeAmbarella;
        }
        
        if ([typeStr isEqualToString:@"0102"]) {
            
            self.chipType = ChipTypeAnyka;
        }
        
    }
    
    return self;
}

- (void)updateCameraStatus:(NSDictionary *)info{
    
    self.sessionid = [info objectForKey:@"sessionid"];
    self.status = [[info objectForKey:@"status"] intValue];
}

+ (id)cameraDataWithDict:(NSDictionary *)info{
    
    CameraInfoData * data = [[[CameraInfoData alloc] initWithDictionary:info] autorelease];
    return data;
}



@end
