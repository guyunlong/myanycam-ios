//
//  FindPasswordDelegate.h
//  KCam
//
//  Created by myanycam on 2014/6/3.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FindPasswordDelegate <NSObject>

- (void)getPasswordRespone:(NSDictionary *)data;

@end
