//
//  navButton.h
//  myanycam
//
//  Created by 中程 on 13-1-30.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface navButton : UIView

@property (nonatomic,retain) UIButton *btn;

- (id)initWithFrame:(CGRect)frame bgImage:(NSString *)imageString title:(NSString *)title target:(id)target select:(SEL)sel;

@end
