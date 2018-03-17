//
//  cameraListDelegate.h
//  myanycam
//
//  Created by 中程 on 13-1-14.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol cameraListDelegate <NSObject>

- (void)cameraListInfo:(NSMutableDictionary *)info;
- (void)cameraStateInfo:(NSMutableDictionary  *)info;
- (void)calling:(NSMutableDictionary *)info;

@end
