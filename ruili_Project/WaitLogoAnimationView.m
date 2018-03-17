//
//  WaitLogoAnimationView.m
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "WaitLogoAnimationView.h"

@implementation WaitLogoAnimationView
@synthesize tipLabel;
//@synthesize tipStr;
@synthesize logoAnimationImageView;

- (void)dealloc{
    
    self.tipLabel= nil;
//    self.tipStr = nil;
    self.logoAnimationImageView = nil;
    [super dealloc];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        MYImageViewAnimation * imageView = [[MYImageViewAnimation alloc] initWithFrame:CGRectMake((frame.size.width-57)/2, -10, 57, 57)];
        self.logoAnimationImageView = imageView;
        imageView.hidden = YES;
        imageView.image = [UIImage imageNamed:@"orangelogowait.png"];
        [self addSubview:imageView];
        [imageView release];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-200)/2, 40,200,20)];
        label.text = NSLocalizedString(@"Release to refresh",nil);
        self.tipLabel = label;
        self.tipLabel.backgroundColor = [UIColor clearColor];
        self.tipLabel.textColor = [UIColor orangeColor];
        self.tipLabel.font = [UIFont systemFontOfSize:15];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label release];
        
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}


- (void)startRotateAnimating{
    
    CAKeyframeAnimation *spinAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    spinAnim.duration = 0.6f; // some appropriate duration
    spinAnim.repeatCount = 999999.0f;
    spinAnim.values = [NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 2.0, 0, 0, 1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)],
                       nil];
    
    self.logoAnimationImageView.hidden = NO;
    
    [self.logoAnimationImageView addAnimation:spinAnim forKey:@"spin"];
    
    
}

- (void)stopRotateAnimation{
    
    self.logoAnimationImageView.hidden = YES;
    self.tipLabel.hidden = YES;
    [self.logoAnimationImageView removeAnimations];
    
}

- (void)showTipLable:(NSString *)tipStr;
{
    
    if (!tipStr) {
        
        tipStr = NSLocalizedString(@"Release to refresh",nil);
    }
    self.tipLabel.hidden = NO;
    self.tipLabel.text =  tipStr;
}

- (void)hideTipLable{
    
    self.tipLabel.hidden = YES;
}
@end
