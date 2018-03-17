//
//  MediaData.m
//  Myanycam
//
//  Created by myanycam on 13-4-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MediaData.h"

@implementation MediaData
@synthesize mediaData = _mediaData;
@synthesize header = _header;
@synthesize time;

- (void)dealloc{
    
    free(_header);
    _header = nil;
    self.mediaData = nil;
    self.time = nil;
    [super dealloc];
}


@end