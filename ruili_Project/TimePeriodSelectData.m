//
//  TimePeriodSelectData.m
//  Myanycam
//
//  Created by myanycam on 13-3-13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "TimePeriodSelectData.h"

@implementation TimePeriodSelectData

@synthesize beginHour;
@synthesize beginmin;
@synthesize beginsec;
@synthesize overHour;
@synthesize overmin;
@synthesize oversec;
@synthesize index;
@synthesize isOn;

//+ (TimePeriodSelectData *)timePeriodSelectData:(NSInteger)beginHour overHour:(NSInteger)overHour index:(NSInteger)index{
//    
//    TimePeriodSelectData * data = [[[TimePeriodSelectData alloc] init] autorelease];
//    data.beginHour = beginHour;
//    data.overHour = overHour;
//    data.index = index;
//    data.isOn = YES;
//    return data;
//}

+ (TimePeriodSelectData *)timePeriodSelectData:(NSString *)beginTime endStr:(NSString *)endTime switchFlag:(NSInteger)switchFlag index:(NSInteger)index{
    
    NSArray * begins = [beginTime componentsSeparatedByString:@":"];
    NSArray * ends = [endTime componentsSeparatedByString:@":"];
    
    
    
    
    TimePeriodSelectData * data = [[[TimePeriodSelectData alloc] init] autorelease];
    if ([begins count] == 3) {
        
        data.beginHour = [[begins objectAtIndex:0] intValue];
        data.beginmin = [[begins objectAtIndex:1] intValue];
        data.beginsec = [[begins objectAtIndex:2] intValue];
    }
    
    if ([ends count] == 3) {
        
        data.overHour = [[ends objectAtIndex:0] intValue];
        data.overmin = [[ends objectAtIndex:1] intValue];
        data.oversec = [[ends objectAtIndex:2] intValue];
    }
    
    data.index = index;
    data.isOn = switchFlag ;
    return data;
}

- (void)initDataZero{
    
    self.beginHour = 0;
    self.beginmin = 0;
    self.beginsec = 0;
    
    self.overHour = 0;
    self.overmin = 0;
    self.oversec = 0;
}

@end
