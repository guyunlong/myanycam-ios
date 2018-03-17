//
//  CameraSettingNavigationController.h
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraSettingViewController.h"


@interface CameraSettingNavigationController : UINavigationController
@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (assign, nonatomic) id<CameraStartDecodeVideoDelegate> cameraDelegate;

@end

