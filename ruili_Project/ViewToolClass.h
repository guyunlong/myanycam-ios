//
//  ViewToolClass.h
//  Myanycam
//
//  Created by myanycam on 13-2-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewToolClass : NSObject

+ (UIBarButtonItem *)customBarButtonItem:(NSString *)buttonNormalImage buttonSelectImage:(NSString *)buttonSelectImage title:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action;
+ (void)showDialogView:(UIView *)view point:(CGPoint)point;
+ (void)closeDialogView:(UIView *)view point:(CGPoint)point;
+ (void)showViewWithDropDownAnimation:(UIView *)view;
+ (void)hideViewWithDropDownAnimation:(UIView *)view;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
@end
