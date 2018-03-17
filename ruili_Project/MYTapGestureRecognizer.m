//
//  MYTapGestureRecognizer.m
//  Myanycam
//
//  Created by myanycam on 13-3-8.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYTapGestureRecognizer.h"

@implementation MYTapGestureRecognizer

@synthesize target              = _target;
@synthesize selector            = _selector;


- (void)dealloc {
    self.target = nil;
    self.selector = nil;
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
        [self.target performSelector:self.selector];
    }
}

+ (MYTapGestureRecognizer *)myTapGestureRecognizer:(id)target action:(SEL)action{
    
    MYTapGestureRecognizer * gesture = [[MYTapGestureRecognizer alloc] initWithTarget:target action:action] ;
    return [gesture autorelease];
   
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end
