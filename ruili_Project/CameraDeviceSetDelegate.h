//
//  CameraDeviceSetDelegate.h
//  Myanycam
//
//  Created by myanycam on 13-5-16.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraDeviceSetDelegate <NSObject>

- (void)getDeviceInfoRsp:(NSDictionary *)info;

@optional

- (void)setDeviceInfoRsp:(NSDictionary *)info;

@end
