//
//  loginViewController.h
//  myanycam
//
//  Created by 中程 on 13-1-9.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loginDelegate.h"
#import "registViewController.h"
#import <ShareSDK/ShareSDK.h>


@interface loginViewController : BaseViewController<loginDelegate,UITextFieldDelegate,RegistViewControllerDelegate,UIAlertViewDelegate,ISSViewDelegate>
{
    BOOL isRemberUserInfo;
    UINavigationController *   _navigation;
    NSInteger                  _startWallTime;
}

@property (retain, nonatomic) IBOutlet UIButton *registerButton;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UITextField *accountTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UIButton *remberCheckbox;
@property (retain, nonatomic) UINavigationController *  navigation;
@property (retain, nonatomic) IBOutlet UIImageView *remeberStateImageView;
@property (retain, nonatomic) IBOutlet UIImageView *inputBgImageView;
@property (retain, nonatomic) IBOutlet UIButton *faceBookButton;
@property (retain, nonatomic) IBOutlet UIView *startWallPaperView;
@property (retain, nonatomic) NSTimer  *startWallViewTimer;
@property (retain, nonatomic) IBOutlet UIView *loginInputView;
@property (retain, nonatomic) IBOutlet UILabel *rememberPasswordLabel;
@property (retain, nonatomic) IBOutlet UIImageView *logoImageVIew;
@property (retain, nonatomic) IBOutlet UIImageView *logoNameImageView;
@property (retain, nonatomic) IBOutlet UIButton *twitterLoginButton;
@property (retain, nonatomic) IBOutlet UIImageView *waitImageView;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *waitFlowerView;

@property (retain, nonatomic) NSString * hostip;
@property (assign, nonatomic) NSInteger port;
@property (retain, nonatomic) IBOutlet UIButton *helpButton;



- (IBAction)loginAction:(id)sender;
- (IBAction)getPasswordAction:(id)sender;
- (IBAction)newAccountAction:(id)sender;
- (IBAction)faceBookButtonAction:(id)sender;
- (IBAction)twitterLoginAction:(id)sender;
-(void)remberUserInfo;

@property (retain, nonatomic) IBOutlet UIButton *testPostImage;

@end
