//
//  UINavigationItem+UINavigationItemTitle.m
//  Myanycam
//
//  Created by myanycam on 13/8/27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "UINavigationItem+UINavigationItemTitle.h"

@implementation UINavigationItem (UINavigationItemTitle)


- (void)setCustomTitle:(NSString *)title
{
    UILabel *titleView = (UILabel *)self.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        titleView.textColor = [UIColor colorWithWhite:255.0 alpha:1.0]; // Change to desired color
        
        self.titleView = titleView;
        [titleView release];
    }
    titleView.text = title;
    [titleView sizeToFit];
}


@end
