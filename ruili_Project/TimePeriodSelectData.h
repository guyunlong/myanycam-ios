//
//  TimePeriodSelectData.h
//  Myanycam
//
//  Created by myanycam on 13-3-13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimePeriodSelectData : NSObject


@property (assign, nonatomic) NSInteger beginHour;
@property (assign, nonatomic) NSInteger beginmin;
@property (assign, nonatomic) NSInteger beginsec;

@property (assign, nonatomic) NSInteger overHour;
@property (assign, nonatomic) NSInteger overmin;
@property (assign, nonatomic) NSInteger oversec;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger  isOn;

+ (TimePeriodSelectData *)timePeriodSelectData:(NSString *)beginTime endStr:(NSString *)endTime switchFlag:(NSInteger)switchFlag index:(NSInteger)index;

- (void)initDataZero;

@end
