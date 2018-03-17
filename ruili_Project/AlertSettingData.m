//
//  AlertSettingData.m
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

//<xns=XNS_CAMERA><cmd=ALARM_CONFIG_INFO><switch=><policy=><repeat=><voicealarm=><movealarm=><record=><begintime1=><endtime1=><switch1=><begintime2=><endtime2=><switch2=><begintime3=><endtime3=><switch3=><begintime4=><endtime4=><switch4=>
#import "AlertSettingData.h"

@implementation AlertSettingData

@synthesize timePeriodArray;
@synthesize index;
@synthesize isNoiseAlert;
@synthesize alertType;
@synthesize isMotionAlert;
@synthesize repeatWeekData;
@synthesize isAlertRecord;
@synthesize alertSwitch;

- (void)dealloc{
    
    self.timePeriodArray = nil;
    self.repeatWeekData = nil;
    [super dealloc];
}

- (id)initWithDictInfo:(NSDictionary *)info{
    
    self = [super init];
    if (self) {
        
//      policy= 0; //报警策略 0：全天报警 1：分段报警
        self.alertType = [[info objectForKey:@"policy"] intValue];
        self.isMotionAlert = [[info objectForKey:@"movealarm"] intValue];
        self.isNoiseAlert = [[info objectForKey:@"voicealarm"] intValue];
        self.isAlertRecord = [[info objectForKey:@"record"] intValue];
        self.alertSwitch = [[info objectForKey:@"switch"] intValue];
        
        self.repeatWeekData = [WeekData weekDataBuildWithRepeat:[[info objectForKey:@"repeat"] intValue]];
        
        self.timePeriodArray = [NSMutableArray arrayWithCapacity:4];
        
        TimePeriodSelectData * data =  [TimePeriodSelectData timePeriodSelectData:[info objectForKey:@"begintime1"] endStr:[info objectForKey:@"endtime1"] switchFlag:[[info objectForKey:@"switch1"] intValue] index:1]; // ;
        [self.timePeriodArray addObject:data];
        data =  [TimePeriodSelectData timePeriodSelectData:[info objectForKey:@"begintime2"] endStr:[info objectForKey:@"endtime2"] switchFlag:[[info objectForKey:@"switch2"] intValue] index:2];
        [self.timePeriodArray addObject:data];
        data =  [TimePeriodSelectData timePeriodSelectData:[info objectForKey:@"begintime3"] endStr:[info objectForKey:@"endtime3"] switchFlag:[[info objectForKey:@"switch3"] intValue] index:3];
        [self.timePeriodArray addObject:data];
        data =  [TimePeriodSelectData timePeriodSelectData:[info objectForKey:@"begintime4"] endStr:[info objectForKey:@"endtime4"] switchFlag:[[info objectForKey:@"switch4"] intValue] index:4];
        [self.timePeriodArray addObject:data];
        
    }
    
    return self;
}

@end
