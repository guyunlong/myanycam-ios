//
//  CloudModelVideoQualitySetDelegate.h
//  Myanycam
//
//  Created by myanycam on 13/11/20.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CloudModelVideoQualitySetDelegate <NSObject>

- (void)getLiveVideoSizeCloudModel:(NSDictionary *)dictInfo;
- (void)getRecordVideoSizeCloudModel:(NSDictionary *)dictInfo;

@end
