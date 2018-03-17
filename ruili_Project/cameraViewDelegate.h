//
//  cameraViewDelegate.h
//  myanycam
//
//  Created by 中程 on 13-1-19.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol cameraViewDelegate <NSObject>

//-(void)McuResponse:(NSDictionary *)dat;

-(void)watchCameraSuccess:(NSDictionary *)dat;
-(void)watchCameraFailed:(NSDictionary *)dat;

- (void)callHangUp:(NSDictionary *)dat;
- (void)manualRecordResp:(NSDictionary *)dat;
- (void)deviceStatus:(NSDictionary *)dat;


@end
