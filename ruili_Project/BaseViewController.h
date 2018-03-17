//
//  BaseViewController.h
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHAlertView.h"
#import "MyWaitAlertView.h"
#import <ShareSDK/ShareSDK.h>

@interface BaseViewController : UIViewController<AHAlertViewDelegate>
{
    BOOL    _isShowBottomBar;
}

@property (retain, nonatomic) UIActivityIndicatorView   * activityIndicatorView;
@property (assign, nonatomic) BOOL      isShowBottomBar;
@property (retain, nonatomic) MyWaitAlertView   * waitAlertView;



- (void)customDismissModalViewControllerAnimated:(BOOL)animated;
- (void)customPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
//- (AppDelegate *)appDelegate;
- (UIAlertView *)showAlertView:(NSString *)titleStr alertMsg:(NSString *)alertMsg userInfo:(NSDictionary *)userInfo delegate:(id<UIAlertViewDelegate>)delegate canclButtonStr:(NSString *)canclButtonStr otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (void)hideBottomBar;


- (void)ShowWaitAlertView:(NSString *)titleStr;
- (void)hideWaitAlertView;

- (void)showBackButton:(id)target action:(SEL)action buttonTitle:(NSString *)title;

- (void)goBack;

- (void)showAskAlertView:(NSString *)title msg:(NSString *)msg userInfo:(NSDictionary *)userInfo;
- (void)showAskAlertViewWithButton:(NSString *)title msg:(NSString *)msg userInfo:(NSDictionary *)userInfo okBtn:(NSString *)btnStr;


- (void)showCustomAutoDismssAlertView:(NSString *)tip;
- (void)showAutoDismissAlertView:(NSString *)tip;


- (void)shareIphoneWithShareSdk:(NSString * )content image:(UIImage *)image title:(NSString *)title shareUrl:(NSString *)shareUrl viewController:(UIViewController *)viewController  shareMediaType:(SSPublishContentMediaType)mediaType;

- (void)shareWithShareSdk:(NSString * )content image:(UIImage *)image title:(NSString *)title shareUrl:(NSString *)shareUrl view:(id)view arrowDirect:(UIPopoverArrowDirection)arrowDirect shareMediaType:(SSPublishContentMediaType)mediaType;


@end
