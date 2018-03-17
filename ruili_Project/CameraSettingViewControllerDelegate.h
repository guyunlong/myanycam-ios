//
//  CameraSettingViewControllerDelegate.h
//  Myanycam
//
//  Created by myanycam on 13/10/15.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraSettingViewControllerDelegate <NSObject>

- (void)getCameraVersion:(NSDictionary *)dat;
- (void)updateCameraVersion:(NSDictionary *)dat;

#pragma mark 图像旋转180度响应
- (void)setRotateCameraRespon:(NSDictionary *)dat;

@end
