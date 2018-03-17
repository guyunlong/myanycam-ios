//
//  getPasswordDelegate.h
//  myanycam
//
//  Created by 中程 on 13-1-14.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getPasswordDelegate <NSObject>

-(void)getPasswordSuccess;
-(void)getPasswordFailed;

@end
