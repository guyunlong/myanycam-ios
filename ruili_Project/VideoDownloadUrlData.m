//
//  VideoDownloadUrlData.m
//  Myanycam
//
//  Created by myanycam on 13-5-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "VideoDownloadUrlData.h"

@implementation VideoDownloadUrlData


@synthesize  userid;
@synthesize cameraid;
@synthesize localUrl;
@synthesize proxyurl;
@synthesize localUrlIp;
@synthesize localPort;

- (void)dealloc{
    
    self.localUrl = nil;
    self.proxyurl = nil;
    self.localUrlIp = nil;
    [super dealloc];
}


- (id)initWithDictInfo:(NSDictionary *)info{
    
    self = [super init];
    if (self) {
        
        self.userid = [[info objectForKey:@"userid"] intValue];
        self.cameraid = [[info objectForKey:@"cameraid"] intValue];
        self.localUrl = [info objectForKey:@"loaclurl"];
        self.proxyurl = [info objectForKey:@"proxyurl"];
        
        NSRange range = [self.localUrl rangeOfString:@"http://"];
        NSString * subStr = [self.localUrl substringWithRange:NSMakeRange(range.location + range.length, self.localUrl.length - range.length)];
        range = [subStr rangeOfString:@":"];
        
        self.localPort = LOCALPORT ;
        if (range.location > 1000) {
            
            range = [subStr rangeOfString:@"/"];
            self.localPort = 80;
        }
        
        subStr = [subStr substringWithRange:NSMakeRange(0, range.location)];
        self.localUrlIp = subStr;
        
    }
    
    return self;
    
}

@end
