//
//  MYBaseButton.m
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYBaseButton.h"

@implementation MYBaseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)hideWithAnimation:(BOOL)animation{
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
    else{
        self.hidden = YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
