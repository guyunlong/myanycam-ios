//
//  UIButton+ButtonToolClass.m
//  Myanycam
//
//  Created by myanycam on 13-3-4.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "UIButton+ButtonToolClass.h"

@implementation UIButton (ButtonToolClass)

- (void)setButtonBgImage:(UIImage *)imageNormal highlight:(UIImage *)highlightImage{
    
    [self setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
}

@end
