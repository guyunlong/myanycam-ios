//
//  MyWaitAlertView.h
//  Myanycam
//
//  Created by myanycam on 13-5-13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAlertView.h"
@interface MyWaitAlertView : BaseAlertView

@property (retain, nonatomic) IBOutlet UIImageView *smallWaitImageView;
@property (retain, nonatomic) NSTimer  * timer;
@property (assign, nonatomic) CGFloat  myangle;
@property (assign, nonatomic) CGFloat  minTimeForWait;

@property (retain, nonatomic) IBOutlet UILabel *waitDesLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *waitActivityDicatorView;
- (void)prepareView:(NSString *)titleStr;
- (void)show;
- (void)hide;

@end
