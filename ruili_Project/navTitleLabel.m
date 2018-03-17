//
//  navTitleLabel.m
//  myanycam
//
//  Created by 中程 on 13-1-30.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "navTitleLabel.h"

@implementation navTitleLabel

- (id)initWithFrame:(CGRect)frame title:(NSString *)titleString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor whiteColor];//[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        self.text=titleString;
        self.textAlignment=UITextAlignmentCenter;
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
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
