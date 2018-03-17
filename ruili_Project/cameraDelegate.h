//
//  cameraDelegate.h
//  myanycam
//
//  Created by 中程 on 13-1-14.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol cameraDelegate <NSObject>

-(void)modifySuccess;
-(void)modifyFailed;

//-(void)deleteSuccess;
//-(void)deleteFailed;

@end
