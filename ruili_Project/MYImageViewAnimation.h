//
//  MYImageViewAnimation.h
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYImageViewAnimation : UIImageView
{
    CAAnimation         *_animation;
    NSString            *_animationKey;
}
@property (nonatomic, retain) CAAnimation       *animation;
@property (nonatomic, retain) NSString          *animationKey;

- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key;
- (void)restartAnimation;
- (void)removeAnimations;

@end
