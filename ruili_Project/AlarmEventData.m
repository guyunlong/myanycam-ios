//
//  AlarmEventData.m
//  Myanycam
//
//  Created by myanycam on 13/6/3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlarmEventData.h"

@implementation AlarmEventData

@synthesize bvideo;
@synthesize cameraid;
@synthesize fromuid;
@synthesize type;
@synthesize userid;
@synthesize picture;
@synthesize video;

- (void)dealloc{
    
    self.picture = nil;
    self.video = nil;
    [super dealloc];
}

@end
