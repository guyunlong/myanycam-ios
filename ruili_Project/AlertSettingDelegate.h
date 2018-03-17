//
//  AlertSettingDelegate.h
//  Myanycam
//
//  Created by myanycam on 13-5-15.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertSettingDelegate <NSObject>

- (void)getAlertSettingInfo:(NSDictionary *)info;

- (void)setAlertRspInfo:(NSDictionary *)info;

@end
