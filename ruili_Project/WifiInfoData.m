//
//  WifiInfoData.m
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "WifiInfoData.h"

@implementation WifiInfoData
@synthesize ssid;
@synthesize safety;
@synthesize signal;
@synthesize password;
@synthesize isManualAdd;

- (void)dealloc{
    
    self.ssid = nil;
    self.password = nil;
    [super dealloc];
}
@end
