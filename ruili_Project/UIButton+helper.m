//
//  UIButton+helper.m
//  Myanycam
//
//  Created by myanycam on 13-5-17.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "UIButton+helper.h"

@implementation UIButton (helper)

- (void)setTitleWithStr:(NSString *)str fontSize:(CGFloat)fontSize{
    
    [self setTitle:str forState:UIControlStateNormal];
    [self setTitle:str forState:UIControlStateHighlighted];
    [self.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
}

@end
