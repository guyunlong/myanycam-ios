//
//  BaseAlertViewDelegate.h
//  Myanycam
//
//  Created by myanycam on 13/8/22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseAlertViewDelegate <NSObject>

- (void)alertView:(id)alertView clickButtonAtIndex:(NSInteger)index;

@end
