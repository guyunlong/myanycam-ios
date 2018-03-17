//
//  UIViewController+Helper.m
//  Myanycam
//
//  Created by myanycam on 13/6/22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "UIViewController+Helper.h"
#import "ToolClass.h"
//#import "CustomWindow.h"
#import "AppDelegate.h"

@implementation UIViewController (Helper)

- (void)customPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    
    if ([ToolClass systemVersionFloat] >= 5.0) {
        [self presentViewController:modalViewController animated:animated completion:^{
        }];
    }
    else {
        [self presentModalViewController:modalViewController animated:animated];
    }
}

- (void)customDismissModalViewControllerAnimated:(BOOL)animated{
    
    if ([ToolClass systemVersionFloat] >= 5.0) {
        [self dismissViewControllerAnimated:animated completion:^{
        }];
    }
    else {
        
        [self dismissModalViewControllerAnimated:animated];
    }
}

+ (UIViewController *)topViewController {
    
   CustomWindow *keyWindow = [[AppDelegate getAppDelegate] window];
    
//    if (keyWindow.topViewController) {
//        return keyWindow.topViewController;
//    }
    
    UIViewController *controller = keyWindow.rootViewController;
    
    while (controller.modalViewController) {
        controller = controller.modalViewController;
    }
    return controller;
}

- (UIViewController *)getParentViewController
{
    UIViewController *controller = nil;
    if ([ToolClass systemVersionFloat] >= 5.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
        controller = self.presentingViewController;
#endif
    }
    else {
        controller = self.parentViewController;
    }
    
    return controller;
}

@end
