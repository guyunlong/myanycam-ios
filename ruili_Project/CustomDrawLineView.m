//
//  CustomDrawLineView.m
//  Myanycam
//
//  Created by myanycam on 13-3-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CustomDrawLineView.h"

@implementation CustomDrawLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //画长方形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置颜色，仅填充4条边
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] CGColor]);
    //设置线宽为1
    CGContextSetLineWidth(ctx, 1.0);
    //设置长方形4个顶点
    CGPoint poins[] = {CGPointMake(0, 0),CGPointMake(200, 0),CGPointMake(200, 200),CGPointMake(0, 200)};
    CGContextAddLines(ctx,poins,4);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}
 */


@end
