//
//  navButton.m
//  myanycam
//
//  Created by 中程 on 13-1-30.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "navButton.h"

@implementation navButton

@synthesize btn;

- (id)initWithFrame:(CGRect)frame bgImage:(NSString *)imageString title:(NSString *)title target:(id)target select:(SEL)sel
{
    self = [super initWithFrame:frame];
    if (self) {
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=frame;
        [btn setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
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
