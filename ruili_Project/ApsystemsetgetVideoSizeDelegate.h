//
//  ApsystemsetgetVideoSizeDelegate.h
//  Myanycam
//
//  Created by myanycam on 13/7/12.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApsystemsetgetVideoSizeDelegate <NSObject>

- (void)getLiveVideoSize:(NSDictionary *)dictInfo;
- (void)getRecordVideoSize:(NSDictionary *)dictInfo;

@end
