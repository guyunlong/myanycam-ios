//
//  RecordVideoSettingData.h
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WeekData.h"

@interface RecordVideoSettingData : NSObject

@property (retain, nonatomic) NSMutableArray * recordTimeSelectArray;
@property (assign, nonatomic) int  recordPolicy;
@property (assign, nonatomic) int  recordSwitch;
@property (assign, nonatomic) BOOL  isLoopRecord;
@property (retain, nonatomic) WeekData * repeatWeekData;

- (id)initWithDictionary:(NSDictionary *)info;


@end
