//
//  MYImageViewAnimation.m
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYImageViewAnimation.h"

@implementation MYImageViewAnimation

@synthesize animation = _animation;
@synthesize animationKey = _animationKey;

- (void)dealloc {
    if (self.animation) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:kNotificationAppWillResignActive
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:kNotificationAppDidBecomeActive
                                                      object:nil];
    }
    self.animation = nil;
    self.animationKey = nil;
    [super dealloc];
}

- (void)removeAnimations {
    [self.layer removeAllAnimations];
    self.animation.delegate = nil;
    self.animation = nil;
    self.animationKey = nil;
}

- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key {
    self.animation = animation;
    self.animationKey = key;
    if (self.animation) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:kNotificationAppWillResignActive
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:kNotificationAppDidBecomeActive
                                                   object:nil];
    }
    [self.layer addAnimation:animation forKey:key];
}

- (void)restartAnimation {
    if (self.animation && self.animationKey) {
        if (![self.layer animationForKey:self.animationKey]) {
            [self.layer addAnimation:self.animation forKey:self.animationKey];
        }
    }
}

#pragma mark - Notification
- (void)applicationWillResignActive:(NSNotification *)notificate {
    
}

- (void)applicationDidBecomeActive:(NSNotification *)notificate {
    [self restartAnimation];
}

@end
