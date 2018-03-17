//
//  CheckApNetDelegate.h
//  Myanycam
//
//  Created by myanycam on 13-5-13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckApNetDelegate <NSObject>

- (void)apnetIsOpen:(BOOL)flag;

- (void)checkTokenIsRight:(BOOL)flag;

@end
