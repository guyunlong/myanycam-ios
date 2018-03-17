//
//  CameraUdpDataDelegate.h
//  Myanycam
//
//  Created by myanycam on 13/8/14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraUdpDataDelegate <NSObject>

- (void)udpData:(NSData *)data;
- (void)videoData:(NSData *)videoData;

@end
