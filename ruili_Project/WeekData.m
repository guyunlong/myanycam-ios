//
//  WeekData.m
//  Myanycam
//
//  Created by myanycam on 13-3-13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "WeekData.h"

@implementation WeekData
@synthesize monday;
@synthesize tuesday;
@synthesize wednesday;
@synthesize thursday;
@synthesize friday;
@synthesize saturday;
@synthesize sunday;

+ (WeekData *)weekDataBuildWithRepeat:(NSInteger)repeat{
    
    WeekData * data = [[[WeekData alloc] init] autorelease];

    data.monday = repeat/1000000;
    data.tuesday = (repeat/100000)%10;
    data.wednesday = (repeat/10000)%10;
    data.thursday = (repeat/1000)%10;
    data.friday = (repeat/100)%10;
    data.saturday = (repeat/10)%10;
    data.sunday = repeat%10;
    
    return data;
    
}

- (NSInteger)repeatInt{
    
    int repeat = 0;
    repeat += self.monday*1000000;
    repeat += self.tuesday * 100000;
    repeat += self.wednesday * 10000;
    repeat += self.thursday * 1000;
    repeat += self.friday * 100;
    repeat += self.saturday * 10;
    repeat += self.sunday;
    
    return repeat;
    
}

@end
