//
//  WaitLogoAnimationView.h
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYImageViewAnimation.h"

#define WAITLOGOVIEWWIDTH 300
#define WAITLOGOVIEWHEIGTH 60

@interface WaitLogoAnimationView : UIView

@property (retain, nonatomic) MYImageViewAnimation * logoAnimationImageView;
@property (retain, nonatomic) UILabel * tipLabel;
//@property (retain, nonatomic) NSString * tipStr;

- (void)startRotateAnimating;
- (void)stopRotateAnimation;

- (void)showTipLable:(NSString *)tipStr;
- (void)hideTipLable;


@end
