//
//  cameraAddDelegate.h
//  myanycam
//
//  Created by 中程 on 13-1-15.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol cameraAddDelegate <NSObject>

-(void)cameraAddSuccess;
-(void)cameraAddFailed:(NSString *)res;

@end
