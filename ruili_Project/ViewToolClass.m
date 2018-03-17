//
//  ViewToolClass.m
//  Myanycam
//
//  Created by myanycam on 13-2-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "ViewToolClass.h"
#import "MYDataManager.h"

@implementation ViewToolClass

+ (UIBarButtonItem *)customBarButtonItem:(NSString *)buttonNormalImage buttonSelectImage:(NSString *)buttonSelectImage title:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action {
    
    UIImage * buttonImage = [[UIImage imageNamed:buttonNormalImage] resizableImage];
    UIImage * buttonImageSelect = [[UIImage imageNamed:buttonSelectImage] resizableImage];
    UIButton * playNowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [playNowButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [playNowButton setBackgroundImage:buttonImageSelect forState:UIControlStateHighlighted];
    [playNowButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (title) {
        [playNowButton setTitle:title forState:UIControlStateNormal];
    }
    [playNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    playNowButton.titleLabel.font = [UIFont systemFontOfSize:12];
    if (DeviceLanaguage_RU == [[MYDataManager shareManager] currentSystemLanguage]) {
        
         playNowButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    UIBarButtonItem * finishButton =[[[UIBarButtonItem alloc] initWithCustomView:playNowButton] autorelease];
    [playNowButton release];
    return finishButton;
}


+(void)showDialogView:(UIView *)view point:(CGPoint)point
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Dialog" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    CGRect rect = [view frame];
    rect.origin.x = point.x;
    rect.origin.y = point.y;
    [view setFrame:rect];
    [UIView commitAnimations];
}

+(void)closeDialogView:(UIView *)view point:(CGPoint)point
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Dialog" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    CGRect rect = [view frame];
    rect.origin.x = point.x;
    rect.origin.y = point.y;
    [view setFrame:rect];
    [UIView commitAnimations];
}

+(void)showViewWithDropDownAnimation:(UIView *)view{
    
    if (view.hidden == NO) {
        return;
    }
    
    CGRect orginRect = view.frame;
    CGRect rect = view.frame;
    rect.size.height = 0;
    view.frame = rect;
    
    [UIView animateWithDuration:1 animations:^{
        view.frame = orginRect;
        view.hidden = NO;
    } completion:^(BOOL finished) {
        view.hidden = NO;
    }];
}

+(void)hideViewWithDropDownAnimation:(UIView *)view{
    
    if (view.hidden == YES) {
        return;
    }
    
    CGRect orginRect = view.frame;
    view.alpha = 1.0;
    [UIView animateWithDuration:1 animations:^{
        CGRect rect = view.frame;
        rect.size.height = 0;
        view.frame = rect;
        view.alpha = 0.0;
        view.hidden = YES;
    } completion:^(BOOL finished) {
        view.hidden = YES;
        view.alpha = 1.0;
        view.frame = orginRect;

    }];
    
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
{
    UIImage *img = nil;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    [img retain];
    UIGraphicsEndImageContext();
    
    [pool release];
    
    return img;
}



//UIImage* tableViewCellTopImage = [[UIImage imageNamed:@"tableview_top_press@2x.png"] resizableImage];
//UIImage* tableViewCellBottomImage = [[UIImage imageNamed:@"tableview_bottom_press@2x.png"] resizableImage];
//UIImage* tableViewCellMiddleImage = [[UIImage imageNamed:@"tableview_press@2x.png"] resizableImage];
//UIImage* tableViewSingleCellImaage = [[UIImage imageNamed:@"tableview_single_press@2x.png"]resizableImage];

@end
