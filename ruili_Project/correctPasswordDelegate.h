//
//  correctPasswordDelegate.h
//  myanycam
//
//  Created by 中程 on 13-1-15.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol correctPasswordDelegate <NSObject>

-(void)correctPasswordSuccess;
-(void)correctPasswordFailed;

@end
