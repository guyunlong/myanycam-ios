//
//  MYGestureRecognizer.h
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYGestureRecognizer : UITapGestureRecognizer{
    id                      _target;
    SEL                     _selector;
    NSDictionary            *_userInfo;
}

@property (nonatomic, assign) id            target;
@property (nonatomic, assign) SEL           selector;
@property (nonatomic, retain) NSDictionary  *userInfo;

- (void)performAction;


@end
