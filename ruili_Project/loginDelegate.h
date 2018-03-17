//
//  loginDelegate.h
//  myanycam
//
//  Created by 中程 on 13-1-14.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol loginDelegate <NSObject>

- (void)loginSuccess:(NSMutableDictionary *)userid;
- (void)loginFailedAlert:(NSString *)err ret:(NSInteger)ret;
- (void)tokenSuccess;

//- (void)startLogin;
@end
