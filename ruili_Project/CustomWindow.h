//
//  CustomWindow.h
//  Myanycam
//
//  Created by myanycam on 13-3-14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBottomBarView.h"
#import "MyWaitAlertView.h"

#import "RootViewController.h"



@interface CustomWindow : UIWindow<CustomBottomBarViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    CustomBottomBarView      * _bottomBarView;
    RootViewController       * _myRootViewController;
    BaseViewController       * _topViewController;
    int                        _currentButtonTag;
}

@property (assign, nonatomic) int   currentButtonTag;
@property (assign, nonatomic) RootViewController        * myRootViewController;
@property (assign, nonatomic) BaseViewController        * topViewController;
@property (retain, nonatomic) CustomBottomBarView       * bottomBarView;
@property (retain, nonatomic) UIActivityIndicatorView   * activityIndicatorView;
@property (retain, nonatomic) UIImageView               * activityIndicatorBackImageView;

@property (retain, nonatomic) MyWaitAlertView           * waitAlertView;
@property (retain, nonatomic) UIAlertView               * timeOutAlertView;


- (void)initCustomBottomBar;

- (void)bringBottomToFront;
- (void)showCustomBottomBar;
- (void)hideCustomBottomBar;
- (void)addActivityView;
- (void)removeActivityView;
- (void)removeActivityViewInMainThread;

- (void)showWaitAlertView;
- (void)hideWaitAlertView;


//- (void)twitterPerformReverseAuth:(id)sender;
- (void)jumpToRootViewControllerWithOutAnimation;

- (void)exitApplication;

@end
