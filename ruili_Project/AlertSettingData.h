//
//  AlertSettingData.h
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeekData.h"

@interface AlertSettingData : NSObject

@property (retain, nonatomic) NSMutableArray  *timePeriodArray;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger alertType;
@property (assign, nonatomic) NSInteger  isMotionAlert;
@property (assign, nonatomic) NSInteger  isNoiseAlert;
@property (assign, nonatomic) NSInteger  isAlertRecord;
@property (assign, nonatomic) NSInteger  alertSwitch;
@property (retain, nonatomic) WeekData * repeatWeekData;


- (id)initWithDictInfo:(NSDictionary *)info;

@end
