//
//  UIViewController+Helper.h
//  Myanycam
//
//  Created by myanycam on 13/6/22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helper)

- (void)customDismissModalViewControllerAnimated:(BOOL)animated;
- (void)customPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;


+ (UIViewController *)topViewController ;
- (UIViewController *)getParentViewController;
@end
