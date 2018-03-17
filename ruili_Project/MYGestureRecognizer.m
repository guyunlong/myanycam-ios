//
//  MYGestureRecognizer.m
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYGestureRecognizer.h"

@implementation MYGestureRecognizer
@synthesize target              = _target;
@synthesize selector            = _selector;
@synthesize userInfo            = _userInfo;


- (void)dealloc {
    self.target = nil;
    self.selector = nil;
    self.userInfo = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.target = target;
        self.selector = action;
    }
    
    return self;
}


- (void)performAction {
    if (self.target && [self.target respondsToSelector:self.selector]) {
        [self.target performSelector:self.selector withObject:self];
    }
}

@end
