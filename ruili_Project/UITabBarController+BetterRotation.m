//
//  UITabBarController+BetterRotation.m
//  TabBarRotation
//
//  Created by Pierluigi Cifani on 8/18/12.
//  Copyright (c) 2012 Pierluigi Cifani. All rights reserved.
//

// Based in NSObject+RNSwizzle from "iOS 5 Programming Pushing the Limits" http://iosptl.com/

#import "UITabBarController+BetterRotation.h"
#import <objc/runtime.h>

@implementation UITabBarController (BetterRotation)

+ (void)load
{
    [super load];

    SEL oldRotationSelector = @selector(shouldAutorotateToInterfaceOrientation:);
    SEL newRotationSelector = @selector(newShouldAutorotateToInterfaceOrientation:);
    
    Class class = [self class];
    Method origMethod = class_getInstanceMethod(class, oldRotationSelector);

    Method newMethod = class_getInstanceMethod(class, newRotationSelector);
    IMP newIMP = method_getImplementation(newMethod);
        
    if (class_addMethod(self, oldRotationSelector, newIMP, method_getTypeEncoding(origMethod))) {
        class_replaceMethod(self, newRotationSelector, newIMP, method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }

}

- (BOOL)newShouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    UIViewController *topViewController = self.selectedViewController;
    
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navControl = (UINavigationController *)topViewController;
        topViewController = [navControl topViewController];
    }
    
    
    return [topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
