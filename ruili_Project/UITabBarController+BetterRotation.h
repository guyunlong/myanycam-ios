//
//  UITabBarController+BetterRotation.h
//  TabBarRotation
//
//  Created by Pierluigi Cifani on 8/18/12.
//  Copyright (c) 2012 Pierluigi Cifani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (BetterRotation)

- (BOOL)newShouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
