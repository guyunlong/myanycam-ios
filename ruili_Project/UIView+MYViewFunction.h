//
//  UIView+MYViewFunction.h
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CoreGraphics/CGBase.h>


@interface UIView (MYViewFunction)

- (void)customHideWithAnimation:(BOOL)anmation duration:(NSTimeInterval)duration;
- (void)customShowWithAnimation:(BOOL)anmation duration:(NSTimeInterval)duration;
- (void)customShowWithAnimation:(BOOL)anmation duration:(NSTimeInterval)duration alpha:(CGFloat)alpha;
- (void)customHideWithAnimation:(BOOL)anmation duration:(NSTimeInterval)duration alpha:(CGFloat)alpha;
- (void)customMoveYWithAnimation:(CGPoint)point;
- (void)customaddOffsetYWithAnimation:(float)offset_Y;
- (void)addBorderToView:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

@end
