//
//  WeekData.h
//  Myanycam
//
//  Created by myanycam on 13-3-13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekData : NSObject
@property (assign, nonatomic) NSInteger monday;
@property (assign, nonatomic) NSInteger tuesday;
@property (assign, nonatomic) NSInteger wednesday;
@property (assign, nonatomic) NSInteger thursday;
@property (assign, nonatomic) NSInteger friday;
@property (assign, nonatomic) NSInteger saturday;
@property (assign, nonatomic) NSInteger sunday;

+ (WeekData *)weekDataBuildWithRepeat:(NSInteger)repeat;

- (NSInteger)repeatInt;


@end
