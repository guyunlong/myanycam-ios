//
//  CheckCameraPasswordDelegate.h
//  Myanycam
//
//  Created by myanycam on 13/8/21.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckCameraPasswordDelegate <NSObject>

- (void)checkCameraPasswordRespond:(NSDictionary *)data;

@end
