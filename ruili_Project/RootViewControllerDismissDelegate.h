//
//  RootViewControllerDismissDelegate.h
//  Myanycam
//
//  Created by myanycam on 13/6/22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RootViewControllerDismissDelegate <NSObject>

- (void)backToCameraListViewController:(UIViewController *)controller;

@end