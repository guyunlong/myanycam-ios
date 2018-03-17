//
//  EthernetSettingViewDelegate.h
//  Myanycam
//
//  Created by myanycam on 13-2-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EthernetSettingViewDelegate <NSObject>

- (void)getEthernetInfoSuccess:(NSDictionary*)dat;
- (void)ethernetSettingSuccess:(NSDictionary*)dat;

@end
