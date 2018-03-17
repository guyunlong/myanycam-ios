//
//  WifiSettingDelegate.h
//  myanycam
//
//  Created by myanycam on 13-2-26.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WifiSettingDelegate <NSObject>

-(void)wifiSettingSuccess:(NSMutableDictionary *)dat;

@end
