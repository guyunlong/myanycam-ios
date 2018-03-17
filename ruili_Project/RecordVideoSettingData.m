//
//  RecordVideoSettingData.m
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

//25.	录像设置
//Xns = XNS_CLIENT
//Cmd = RECORD_CONFIG
//policy= 0; //录像策略 0：不录像 1：循环录像 2：分段录像
//repeat=1110011;  //重复周期 7位数字分别代表周一到周日，0：不录像 1：录像
//begintime1=00:00:00
//endtime1=00:00:00
//switch1=0        //时段是否有效
//begintime2=00:00:00
//endtime2=00:00:00
//switch2=0        //时段是否有效
//begintime3=00:00:00
//endtime3=00:00:00
//switch3=0        //时段是否有效
//begintime4=00:00:00
//endtime4=00:00:00
//switch4=0        //时段是否有效


#import "RecordVideoSettingData.h"

@implementation RecordVideoSettingData
@synthesize recordTimeSelectArray;
@synthesize recordPolicy;
@synthesize isLoopRecord;
@synthesize repeatWeekData;
@synthesize recordSwitch;

- (void)dealloc{
    self.recordTimeSelectArray = nil;
    self.repeatWeekData = nil;
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)info{
    
    self = [super init];
    
    if (self) {
        
        self.recordPolicy = [[info objectForKey:@"policy"] intValue];
        self.recordSwitch = [[info objectForKey:@"switch"] intValue];
        
        self.repeatWeekData = [WeekData weekDataBuildWithRepeat:[[info objectForKey:@"repeat"] intValue]];
        self.recordTimeSelectArray = [NSMutableArray arrayWithCapacity:4];
        
        TimePeriodSelectData * data =  [TimePeriodSelectData timePeriodSelectData:[info objectForKey:@"begintime1"] endStr:[info objectForKey:@"endtime1"] switchFlag:[[info objectForKey:@"switch1"] intValue] index:1]; // ;
        [self.recordTimeSelectArray addObject:data];
        data =  [TimePeriodSelectData timePeriodSelectData:[info objectForKey:@"begintime2"] endStr:[info objectForKey:@"endtime2"] switchFlag:[[info objectForKey:@"switch2"] intValue] index:2];
        [self.recordTimeSelectArray addObject:data];
        data =  [TimePeriodSelectData timePeriodSelectData:[info objectForKey:@"begintime3"] endStr:[info objectForKey:@"endtime3"] switchFlag:[[info objectForKey:@"switch3"] intValue] index:3];
        [self.recordTimeSelectArray addObject:data];
        data =  [TimePeriodSelectData timePeriodSelectData:[info objectForKey:@"begintime4"] endStr:[info objectForKey:@"endtime4"] switchFlag:[[info objectForKey:@"switch4"] intValue] index:4];
        [self.recordTimeSelectArray addObject:data];
        
        
    }
    
    return self;

}


@end
