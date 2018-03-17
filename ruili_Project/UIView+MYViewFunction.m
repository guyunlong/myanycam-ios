//
//  UIView+MYViewFunction.m
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "UIView+MYViewFunction.h"

@implementation UIView (MYViewFunction)

- (void)customHideWithAnimation:(BOOL)anmation duration:(NSTimeInterval)duration{
    if (anmation) {
        
        if (self.hidden) {
            return;
        }
        
        [UIView animateWithDuration:duration animations:^{
            self.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.alpha = 1.0;
        }];
    }
}
- (void)customShowWithAnimation:(BOOL)anmation duration:(NSTimeInterval)duration{
    
    if (anmation) {
       
        if (!self.hidden) {
            return;
        }
        self.alpha = 0.0;
        self.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            self.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            self.hidden = NO;
            self.alpha = 1.0;
        }];
    }
    else{
        self.hidden = NO;
    }
}

- (void)customHideWithAnimation:(BOOL)anmation duration:(NSTimeInterval)duration alpha:(CGFloat)alpha{
    
    if (anmation) {
        
        if (self.hidden) {
            return;
        }
        
        [UIView animateWithDuration:duration animations:^{
            self.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.alpha = alpha;
        }];
    }
}

- (void)customShowWithAnimation:(BOOL)anmation duration:(NSTimeInterval)duration alpha:(CGFloat)alpha{
    
    if (anmation) {
        
        if (!self.hidden) {
            return;
        }
        self.alpha = 0.0;
        self.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            self.alpha = alpha;
            
        } completion:^(BOOL finished) {
            self.hidden = NO;
            self.alpha = alpha;
        }];
    }
    else{
        self.hidden = NO;
    }
}

- (void)customMoveYWithAnimation:(CGPoint)point{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin = point;
        self.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)customaddOffsetYWithAnimation:(float)offset_Y{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = rect.origin.y + offset_Y;
        self.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addBorderToView:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius{
    
    //设置layer
    CALayer *layer=[self layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:cornerRadius];
    //设置边框线的宽
    [layer setBorderWidth:borderWidth];
    //设置边框线的颜色
    [layer setBorderColor:[borderColor CGColor]];
}
@end
