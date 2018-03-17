//
//  loginViewController.m
//  myanycam
//
//  Created by 中程 on 13-1-9.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "loginViewController.h"
#import "AppDelegate.h"
#import "dealWithCommend.h"
#import "getPasswordViewController.h"
#import "SystemSetViewController.h"
#import "AlertSettingViewController.h"
#import "MYGestureRecognizer.h"
#import "MyMD5.h"
#import "ToolClass.h"
#import "CameraHLSDemoViewController.h"
#import "FindPasswordViewController.h"


@interface loginViewController ()

@end

@implementation loginViewController
@synthesize  navigation = _navigation;
@synthesize  startWallViewTimer;


//@synthesize accountStore = _accountStore;
//@synthesize accounts = _accounts;
//@synthesize apiManager = _apiManager;
//@synthesize flagTwitterCanLogin;


-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.waitFlowerView startAnimating];
    
    isRemberUserInfo = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbSessionOpenAction:) name:KNotificationFBSessionStateOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginNotification:) name:KNotificationTwitterSessionStateOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbSessionError:) name:KNotificationFBLoginError object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAgentIpError) name:KNotificationGetAgentError object:nil];
    
    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone) {
        
        self.waitImageView.image = [UIImage imageNamed:@"BG_960.png"];
    }
    
    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone5) {
        
        self.waitImageView.image = [UIImage imageNamed:@"BG.png"];
    }
    
    [self.accountTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.rememberPasswordLabel.text = NSLocalizedString(@"Remember Password", nil);
    [self.loginButton setTitleWithStr:NSLocalizedString(@"Login", nil) fontSize:FONT_SIZE];
    [self.registerButton setTitleWithStr:NSLocalizedString(@"Register", nil) fontSize:FONT_SIZE];
    self.accountTextField.placeholder = NSLocalizedString(@"Email", nil);
    [self.helpButton setTitle:NSLocalizedString(@"Find Password", nil) forState:UIControlStateNormal];

    [[AppDelegate getAppDelegate].window initCustomBottomBar];
    
    _accountTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    _passwordTextField.text=[[MYDataManager shareManager] getPassword:_accountTextField.text];
   
    _accountTextField.delegate=self;
    _passwordTextField.delegate=self;
    [_remberCheckbox addTarget:self action:@selector(remberUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [_remberCheckbox setShowsTouchWhenHighlighted:YES];
    
    self.loginInputView.layer.masksToBounds = YES;
    self.loginInputView.layer.cornerRadius = 6;
    
    [self appDelegate].mygcdSocketEngine.step = 0;
    [self appDelegate].mygcdSocketEngine.socketConnectCount = 0;
    
    [[self appDelegate] initAppdelegateSocket:HostIp port:HostPort type:CameraWorkTypeCloud timeOut:KSOCKET_CONNECT_TIMEOUT];
    [[self appDelegate] mygcdSocketEngine].dealObject.loginDelegate = self;
    
    
    self.startWallViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                        target:self
                                                      selector:@selector(waitTimeAdd)
                                                      userInfo:nil
                                                       repeats:YES];
    
    NSString* languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([languageCode isEqualToString:@"ru"]) {
        
        [self.registerButton.titleLabel  setFont:[UIFont systemFontOfSize:10]];
    }
    
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    
    if ([self.passwordTextField.text length] == 0) {
        
        self.loginButton.enabled = NO;
    }
    else{
        
        self.loginButton.enabled = YES;
    }
    
    
//    if([ToolClass systemVersionFloat] < 6.0)
//    {
//        self.faceBookButton.hidden = YES;
//        self.twitterLoginButton.hidden = YES;
//    }
    
//    if ( [[MYDataManager shareManager] currentSystemLanguage] == DeviceLanaguage_ZH_S)
//    {
    
        self.faceBookButton.hidden = YES;
    self.twitterLoginButton.hidden = YES;
        UIImage * twitterImage = [UIImage imageNamed:@"icon_hover.png"];
        [self.twitterLoginButton setBackgroundImage:twitterImage forState:UIControlStateNormal];
        self.twitterLoginButton.tag = LoginTypeQQ;
//    }
//    else
//    {
//        self.twitterLoginButton.tag = LoginTypeTwitter;
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tokenSuccess{
    
    if (_startWallTime > -1) {
        
        [self stopTimer];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[AppDelegate getAppDelegate] startTimerAction];
            [[AppDelegate getAppDelegate].mygcdSocketEngine startHeartSendData];
            [[MYDataManager shareManager] resetData];
            
            if ([MYDataManager shareManager].userInfoData.accountIdStr && [[MYDataManager shareManager].userInfoData.passwordStr length] > 1 && isRemberUserInfo && [MYDataManager shareManager].userInfoData.loginType == LoginTypeNone) {
                
                [self loginAction:nil];
                return ;
            }
            
            if ([MYDataManager shareManager].userInfoData.loginType == LoginTypeFacebook) {
                
                [self faceBookButtonAction:nil];
                return ;
            }
            
            if ([MYDataManager shareManager].userInfoData.loginType == LoginTypeTwitter) {
                
                [self twitterLoginAction:nil];
                return ;
            }
            
            if ([MYDataManager shareManager].userInfoData.loginType == LoginTypeQQ) {
                
                [self twitterLoginAction:nil];
                
                return ;
            }
            
            [self.startWallPaperView customHideWithAnimation:YES duration:0.2];
            
            
        });
    }
}

- (void)waitTimeAdd{
    
    _startWallTime ++;
}

- (void)stopTimer{
    
    _startWallTime = 0;
    [self.startWallViewTimer invalidate];
    self.startWallViewTimer = nil;
}

- (void)dealloc {
    
    [self.startWallViewTimer invalidate];
    self.startWallViewTimer = nil;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationFBSessionStateOpen object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationTwitterSessionStateOpen object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationFBLoginError object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationChooseTwitterAccountCancel object:nil];
    
    [_accountTextField release];
    [_passwordTextField release];
    [_remberCheckbox release];
    [_remeberStateImageView release];
    [_inputBgImageView release];
    [_faceBookButton release];
    [_startWallPaperView release];
    [_loginInputView release];
    [_rememberPasswordLabel release];
    [_twitterLoginButton release];
    [_testPostImage release];
    [_loginButton release];
    [_registerButton release];
    [_logoImageVIew release];
    [_logoNameImageView release];
    [_waitImageView release];
    [_helpButton release];
    [_waitFlowerView release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    [self.waitFlowerView stopAnimating];
    [self setAccountTextField:nil];
    [self setPasswordTextField:nil];
    [self setRemberCheckbox:nil];
    [self setRemeberStateImageView:nil];
    [self setInputBgImageView:nil];
    [self setFaceBookButton:nil];
    [self setStartWallPaperView:nil];
    [self setLoginInputView:nil];
    [self setRememberPasswordLabel:nil];
    [self setTwitterLoginButton:nil];
    [self setTestPostImage:nil];
    [self setLoginButton:nil];
    [self setRegisterButton:nil];
    [self setLogoImageVIew:nil];
    [self setLogoNameImageView:nil];
    [self setWaitImageView:nil];
    [self setHelpButton:nil];
    [self setWaitFlowerView:nil];
    [super viewDidUnload];
}

-(void)remberUserInfo
{
    isRemberUserInfo=!isRemberUserInfo;
    if (isRemberUserInfo) {
        self.remeberStateImageView.hidden = NO;
    }
    else
    {
        self.remeberStateImageView.hidden = YES;
    }
}

- (IBAction)loginAction:(id)sender {
    
    if (![ToolClass checkEmail:_accountTextField.text]) {
        
        [self.startWallPaperView customHideWithAnimation:YES duration:0.2];
        [self showAutoDismissAlertView:NSLocalizedString(@"Email Format is Error", nil)];
        return;
    }

    if (isRemberUserInfo) {
        
        [[NSUserDefaults standardUserDefaults] setObject:_accountTextField.text forKey:@"account"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
        [[MYDataManager shareManager] saveAccountAndPassword:_accountTextField.text password:_passwordTextField.text];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isRember"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [MYDataManager shareManager].userInfoData.accountName = _accountTextField.text;
        
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"account"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
        [[MYDataManager shareManager] deleteAccountFromkeychain:_accountTextField.text];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isRember"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    
    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone) {

        [self.view customMoveYWithAnimation:CGPointMake(0, 20)];
        
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            CGRect frame = self.logoImageVIew.frame;
//            frame.origin.x = 122;
//            frame.origin.y = 20;
//            self.logoImageVIew.frame = frame;
//            
//            frame = self.logoNameImageView.frame;
//            frame.origin.x = 104;
//            self.logoNameImageView.frame = frame;
//            
//        } completion:^(BOOL finished) {
//            
//            
//        }];
    }
    

    
    [self setLoginType:LoginTypeNone];
    [self startLogin];

}

- (void)setLoginType:(LoginType)loginType{
    
    [MYDataManager shareManager].userInfoData.loginType = loginType;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:loginType] forKey:@"loginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)startLogin{
    
    NSString *  cmd = [BuildSocketData buildLoginString:self.accountTextField.text password:self.passwordTextField.text  logintype:LoginTypeNone logintoken:@"" devicetoken:[MYDataManager shareManager].userInfoData.device_token partner:partnerKCam];
    [[self appDelegate].mygcdSocketEngine writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)registAndLogin{
    
    if (isRemberUserInfo) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[MYDataManager shareManager].userInfoData.accountIdStr forKey:@"account"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
          [[MYDataManager shareManager] saveAccountAndPassword:[MYDataManager shareManager].userInfoData.accountIdStr  password:[MYDataManager shareManager].userInfoData.passwordStr ];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isRember"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"account"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
        [[MYDataManager shareManager] deleteAccountFromkeychain:[MYDataManager shareManager].userInfoData.accountIdStr];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isRember"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *  cmd = [BuildSocketData buildLoginString:[MYDataManager shareManager].userInfoData.accountIdStr password:[MYDataManager shareManager].userInfoData.passwordStr  logintype:LoginTypeNone logintoken:@"" devicetoken:[MYDataManager shareManager].userInfoData.device_token partner:partnerKCam];
    [[self appDelegate].mygcdSocketEngine writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (IBAction)getPasswordAction:(id)sender {
    
    self.passwordTextField.text = @"";
    
    FindPasswordViewController * vc = [[FindPasswordViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.emailTextFieldStr = self.accountTextField.text;
    [self customPresentModalViewController:vc animated:YES];
    [vc release];
    
}

- (IBAction)newAccountAction:(id)sender {
    
    registViewController *rVC=[[registViewController alloc] init];
    
    rVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    rVC.delegate = self;
    [self customPresentModalViewController:rVC animated:YES];
    [rVC release];
    
}


- (IBAction)faceBookButtonAction:(id)sender {
    
    [self loginBtnClickHandler:ShareTypeFacebook];
    
}


- (void)cancelTwitterLogin{
    
    [self.startWallPaperView customHideWithAnimation:YES duration:0.2];
}

- (IBAction)twitterLoginAction:(id)sender {
    
    if (self.twitterLoginButton.tag == LoginTypeQQ) {
        
        [self loginBtnClickHandler:ShareTypeQQSpace];
    }
    else
    {
        [self loginBtnClickHandler:ShareTypeTwitter];
    }

}

- (void)loginBtnClickHandler:(ShareType)shareType
{
    DebugLog(@"shareType1  = %d", shareType);
    
    if ([ShareSDK hasAuthorizedWithType:shareType]) {
        
        [self ShowWaitAlertView:@""];
        
    }
    
    id<ISSAuthOptions> authOption = [ShareSDK authOptionsWithAutoAuth:YES
                                                        allowCallback:NO
                                                        authViewStyle:SSAuthViewStyleModal
                                                         viewDelegate:self
                                              authManagerViewDelegate:nil];
    
    @try{
        
        [ShareSDK getUserInfoWithType:shareType
                          authOptions:authOption
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   
                                   if (result)
                                   {
                                       
                                       DebugLog(@"[userInfo uid] = %@" ,[userInfo uid]);
                                       DebugLog(@"[userInfo nickname] = %@",[userInfo nickname]);
                                       DebugLog(@"[userInfo profileImage] = %@",[userInfo profileImage]);
                                       DebugLog(@"[userInfo sourceData] = %@",[userInfo sourceData]);
                                       
                                       [self hideWaitAlertView];
                                       
                                       ShareType shareType = [userInfo type];
                                       id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:shareType];    //传入获取授权信息的类型
                                       NSLog(@"credential uid = %@", [credential uid]);
                                       DebugLog(@"credential extInfo  %@",[credential extInfo]);
                                       
                                       switch (shareType) {
                                           case ShareTypeQQSpace:
                                           {
                                               [MYDataManager shareManager].userInfoData.qqNickname = [userInfo nickname];
                                               [MYDataManager shareManager].userInfoData.qqOpenId = [credential uid];
                                               [self setLoginType:LoginTypeQQ];
                                               [self sendQQloginRequest];
                                               
                                           }
                                               break;
                                               
                                           case ShareTypeTwitter:
                                           {
                                               [MYDataManager shareManager].userInfoData.twitterid = [userInfo uid];
                                               [MYDataManager shareManager].userInfoData.twitterName = [userInfo nickname];
                                               
                                               [self twitterLoginNotification:nil];
                                           }
                                               break;
                                               
                                           case ShareTypeFacebook:
                                           {
                                               
                                               [[MYDataManager shareManager].userInfoData setFaceBookEmail:[[userInfo sourceData] objectForKey:@"email"]];
                                               [[MYDataManager shareManager].userInfoData setFaceBookName:[userInfo nickname]];
                                               [[MYDataManager shareManager].userInfoData setFaceBookid:[userInfo uid]];
                                               
                                               if (![MYDataManager shareManager].flagLoginSuccess) {
                                                   
                                                   [self setLoginType:LoginTypeFacebook];
                                                   [self sendFaceBookLoginRequest];
                                                   
                                               }
                                           }
                                               break;
                                               
                                           default:
                                               break;
                                       }
                                       
                                   }
                                   
                               }];
    }
    @catch(NSException *exception) {
        
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    

}

- (void)fbSessionError:(id)sender{
    
     [self.startWallPaperView customHideWithAnimation:YES duration:0.2];
    
}

//- (void)fbSessionOpenAction:(id)sender{
//    
//    [self populateUserDetails];
//}

//- (void)populateUserDetails
//{
//    if (FBSession.activeSession.isOpen) {
//        [[FBRequest requestForMe] startWithCompletionHandler:
//         ^(FBRequestConnection *connection,
//           NSDictionary<FBGraphUser> *user,
//           NSError *error) {
//             if (!error) {
//                 
//                 DebugLog(@"USER = %@",user.name);
//                 DebugLog(@"USER = %@",user.id);
//                 DebugLog(@"USER = %@",[user objectForKey:@"email"]);
//                 
//                 [[MYDataManager shareManager].userInfoData setFaceBookEmail:[user objectForKey:@"email"]];
//                 [[MYDataManager shareManager].userInfoData setFaceBookName:user.name];
//                 [[MYDataManager shareManager].userInfoData setFaceBookid:user.id];
//                 
//                 if (![MYDataManager shareManager].flagLoginSuccess) {
//                     
//                     [self setLoginType:LoginTypeFacebook];
//                     [self sendFaceBookLoginRequest];
//                     
//                 }
//            }
//            else
//             {
//                 DebugLog(@"Facebook err %@",error);
//                 [self.startWallPaperView customHideWithAnimation:YES duration:0.2];
//                 [self showAlertView:nil alertMsg:NSLocalizedString(@"Facebook Login Error", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//             }
//         }];
//    }
//}

- (void)twitterLoginNotification:(id)sender{

    [self setLoginType:LoginTypeTwitter];
    [self sendTwitterlogineRequest];
    
}

- (void)navigationLeftButton:(id)sender{
    
    [self.navigation.view removeFromSuperview];
}

-(void)loginFailedAlert:(NSString *)err ret:(NSInteger)ret
{
    if (ret == 2) {
        
        [[MYDataManager shareManager] deleteAccountFromkeychain:[MYDataManager shareManager].userInfoData.accountIdStr];
        self.passwordTextField.text = @"";
    }
    
    
    MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:nil
                                                      message:err
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
    alertView.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:ret] forKey:@"LoginRet"];
    [alertView show];
    [alertView release];
    
}


-(void)loginSuccess:(NSMutableDictionary *)dat
{
     dispatch_async(dispatch_get_main_queue(), ^{
         
         [self.startWallPaperView customHideWithAnimation:YES duration:0.2];
         NSString * version = [dat objectForKey:@"clientVersion"];
         NSInteger  upgradeType = [[dat objectForKey:@"upgradetype"] intValue];
         
         [MYDataManager shareManager].userInfoData.userId = [[dat objectForKey:@"userid"] intValue];
         [MYDataManager shareManager].userInfoData.clientVersion = version;
         [MYDataManager shareManager].userInfoData.upgradeType = upgradeType;
         [MYDataManager shareManager].userInfoData.accountIdStr = self.accountTextField.text;
         [MYDataManager shareManager].userInfoData.passwordStr = self.passwordTextField.text;
         [AppDelegate getAppDelegate].flagBackgroundToFront = 0;
         
         [[MYDataManager shareManager] updateImageFile];

            NSString * string = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"New", nil),NSLocalizedString(@"Version", nil),NSLocalizedString(@"Release", nil)];
            NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:upgradeType] forKey:@"updateAlert"];

            NSInteger newversion = [[dat objectForKey:@"newversion"] intValue];
         
         if (newversion > KIntVersion) {
             
             switch (upgradeType) {
                     
                 case 0:
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil];
                 }
                     
                     break;
                     
                 case 1:
                 {
                     [self showAlertView:string alertMsg:NSLocalizedString(@"Update Software", nil) userInfo:userInfo delegate:self canclButtonStr:NSLocalizedString(@"Update", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil),nil];
                     
                     break;
                 }
                     
                 case 2:
                 {
                     
                     [self showAlertView:string alertMsg:NSLocalizedString(@"Update Software", nil) userInfo:userInfo delegate:self canclButtonStr:NSLocalizedString(@"Update", nil) otherButtonTitles:nil];
                 }
                     
                     break;
                 default:
                     break;
             }
         }
         else{
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil];
         }
        
     });

}

- (void)registSuccess{
    
    [self registAndLogin];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView isKindOfClass:[MYAlertView class]]) {
        
        MYAlertView * alert = (MYAlertView *)alertView;
        NSNumber * loginRet = [alert.userInfo objectForKey:@"LoginRet"];
        if (loginRet) {
            
            [self.startWallPaperView customHideWithAnimation:YES duration:0.2];
        }
        
        
        NSNumber * number = [alert.userInfo objectForKey:@"updateAlert"];
        if (number) {
            
            if (buttonIndex == 0) {

                NSURL *url = [NSURL URLWithString:KAPPSTORE_URL];
                [[UIApplication sharedApplication] openURL:url];
                exit(0);
                
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil];
            }
        }
        
        if ([alert.userInfo objectForKey:@"KAGENT"]) {
            
            [[AppDelegate getAppDelegate].window exitApplication];
        }
    }
    
}

- (void)exitApp{
    
    exit(0);
}

#pragma mark textfielddelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    DebugLog(@"test baidu input app");
    
    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone) {
        
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            CGRect frame = self.view.frame;
//            frame.origin.x = 0;
//            frame.origin.y = 0;
//            self.view.frame = frame;
//            
//        } completion:^(BOOL finished) {
//            
//            
//        }];
        
        if ([ToolClass systemVersionFloat] >= 7.0) {
            
            [self.view customMoveYWithAnimation:CGPointMake(0, 0)];
            
        }
        else
        {
            [self.view customMoveYWithAnimation:CGPointMake(0, 20)];
            
        }
        
        
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    
    if (textField == self.accountTextField) {
        
        [self.passwordTextField becomeFirstResponder];
    }
    if (textField == self.passwordTextField) {
        
        if ([self.passwordTextField.text length] > 0 && self.accountTextField.text&&[self.accountTextField.text length] > 0) {
            
            [self loginAction:nil];
        }
        else{
            
            self.loginButton.enabled = YES;
        }
        
        if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone) {
            
            if ([ToolClass systemVersionFloat] >= 7.0) {
                
                [self.view customMoveYWithAnimation:CGPointMake(0, 0)];

            }
            else
            {
                [self.view customMoveYWithAnimation:CGPointMake(0, 20)];

            }
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                
//                CGRect frame = self.view.frame;
//                frame.origin.x = 0;
//                frame.origin.y = 0;
//                self.view.frame = frame;
//                
//            } completion:^(BOOL finished) {
//                
//                
//            }];
        }

        

        
        [textField resignFirstResponder];

    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone) {
      
        [self.view customMoveYWithAnimation:CGPointMake(0, -80)];
        
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            CGRect frame = self.logoImageVIew.frame;
//            frame.origin.x = 69;
//            frame.origin.y = 100;
//            self.logoImageVIew.frame = frame;
//            
//            frame = self.logoNameImageView.frame;
//            frame.origin.x = 140;
//            frame.origin.y = 111 + 15;
//            self.logoNameImageView.frame = frame;
//            
//        } completion:^(BOOL finished) {
//            
//            
//        }];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([self.accountTextField.text length] > 0 && [self.passwordTextField.text length] > 0) {
        
        self.loginButton.enabled = YES;
        
    }
    else{
        
        self.loginButton.enabled = YES;
    }
    
    if ([string length] == 0 && range.length == 1) {
        
        self.loginButton.enabled = YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    self.loginButton.enabled = NO;
    return YES;
}

- (void)getAgentIpError{
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.startWallPaperView customHideWithAnimation:YES duration:0.2];
        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Network Error",nil) userInfo:[NSDictionary dictionaryWithObject:@"Error" forKey:@"KAGENT"] delegate:self canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];

    });
}
- (void)sendFaceBookLoginRequest{
    
    NSString * cmd = [BuildSocketData buildLoginString:[MYDataManager shareManager].userInfoData.faceBookEmail
                                              password:KAppName
                                             logintype:LoginTypeFacebook
                                            logintoken:KAppName
                                           devicetoken:[MYDataManager shareManager].userInfoData.device_token
                                               partner:partnerKCam];
    
    [[self appDelegate].mygcdSocketEngine writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendQQloginRequest{
    
    NSString * cmd = [BuildSocketData buildLoginString:[MYDataManager shareManager].userInfoData.qqOpenId
                                              password:KAppName
                                             logintype:LoginTypeQQ
                                            logintoken:KAppName
                                           devicetoken:[MYDataManager shareManager].userInfoData.device_token
                                               partner:partnerKCam];
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine writeDataOnMainThread:cmd tag:0 waitView:YES];
}

- (void)sendTwitterlogineRequest{
    
    NSString * cmd = [BuildSocketData buildLoginString:[MYDataManager shareManager].userInfoData.twitterName
                                              password:KAppName
                                             logintype:LoginTypeTwitter
                                            logintoken:KAppName
                                           devicetoken:[MYDataManager shareManager].userInfoData.device_token
                                               partner:partnerKCam];
    
    [[self appDelegate].mygcdSocketEngine writeDataOnMainThread:cmd tag:0 waitView:YES];
}

@end
