//
//  CustomWindow.m
//  Myanycam
//
//  Created by myanycam on 13-3-14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CustomWindow.h"
#import "MYDataManager.h"
#import "MYAlertView.h"
#import "UIViewController+Helper.h"


@implementation CustomWindow

@synthesize myRootViewController = _myRootViewController;
@synthesize bottomBarView = _bottomBarView;
@synthesize currentButtonTag = _currentButtonTag;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize activityIndicatorBackImageView;

@synthesize waitAlertView;
@synthesize topViewController = _topViewController;


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationKICK_OFF object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCameraInfoAlertEvent object:nil];

    self.myRootViewController = nil;
    self.activityIndicatorView = nil;
    self.topViewController = nil;
    self.bottomBarView = nil;
    self.waitAlertView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kickOffNotification:) name:KNotificationKICK_OFF object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertEventUpdataView:) name:kNotificationCameraInfoAlertEvent object:nil];
      
    }
    return self;
}

- (void)initCustomBottomBar{
    
    if (!self.bottomBarView) {
        
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"CustomBottomBarView" owner:nil options:nil];
        if ([views count] > 0){
            
            CustomBottomBarView * bottomBar = [views lastObject];
            self.bottomBarView = bottomBar;
            self.bottomBarView.delegate = self;
            CGRect rect = self.bottomBarView.frame;
            rect.size.width = self.frame.size.width;
            rect.origin.y = self.frame.size.height - rect.size.height;
            self.bottomBarView.frame = rect;
            [self addSubview:self.bottomBarView];
            [self.bottomBarView updateCustomView];
            
            
            self.currentButtonTag = 1;
            

        }
    }

    


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if ([alertView isKindOfClass:[MYAlertView class]]) {
        
        MYAlertView * alert = (MYAlertView *)alertView;
        if ([[alert.userInfo objectForKey:KALERTTYPE] isEqualToString:@"KICK_OFF"]) {
            
            if (buttonIndex == 0) {
                
                [[MYDataManager shareManager] deleteAccountFromkeychain:[MYDataManager shareManager].userInfoData.accountIdStr];
                
                [self exitApplication];
            }
        }
    }

}

- (void)bringBottomToFront{

    [self.bottomBarView setButtonHighlightWithIndex:self.currentButtonTag];
    [self bringSubviewToFront:self.bottomBarView];
}

- (void)hideCustomBottomBar{
    [self.bottomBarView customHideWithAnimation:YES duration:0.3];
}

- (void)showCustomBottomBar{
    
    [self bringSubviewToFront:self.bottomBarView];
    [self.bottomBarView customShowWithAnimation:YES duration:0.3];
}

- (void)customBottomBarViewDelegate:(CustomBottomBarView *)bottomBarView button:(UIButton *)button userInfo:(NSDictionary *)userInfo{
    
    if (button.tag == self.currentButtonTag) {
        return;
    }
    
     self.currentButtonTag = button.tag;
    
    [self.myRootViewController dismisscurrentViewController];
    
    switch (button.tag) {
        case 1:
        {
            [self.myRootViewController showCameraViewController];
            
        }
            break;
        case 2:
        {
            [self.myRootViewController showUserViewController];
        }
            break;
        case 3:
        {
            [self.myRootViewController showFileViewController];
        }
            break;
        case 4:
        {
            [self.myRootViewController showSettingViewController];
        }
            break;
            
        default:
            break;
    }
    
   
}

- (void)addActivityView{
    
    [self removeActivityView];

    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = [UIScreen mainScreen].bounds;
    imageView.alpha = 0.6;
    imageView.backgroundColor = [UIColor blackColor];
    [self addSubview:imageView];
    [self bringSubviewToFront:imageView];
    self.activityIndicatorBackImageView = imageView;
    self.activityIndicatorBackImageView.userInteractionEnabled = YES;
    [imageView release];
    
    UIActivityIndicatorView * waitView = [[UIActivityIndicatorView alloc] init];
    self.activityIndicatorView = waitView;
    CGRect frame = CGRectMake(0, 0, 32, 32);
    self.activityIndicatorView.frame = frame;
    [self addSubview:waitView];
    waitView.center = self.center;
    [waitView startAnimating];
    [self bringSubviewToFront:waitView];
    [waitView release];
    
}

- (void)removeActivityView{
    
    if (self.activityIndicatorView&&self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorBackImageView removeFromSuperview];
        [self.activityIndicatorView removeFromSuperview];
    }
    
}

- (void)removeActivityViewInMainThread{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeActivityView];
    });
}

- (void)alertEventUpdataView:(NSNotification *)notify{
    
    
    if ([[notify.userInfo objectForKey:@"type"] intValue] == AlertTypeLow_Power) {
        
//        [self showAlertViewWithTitle:@"Low battery"];
    }
    else
    {
        if (self.myRootViewController) {
            
            if (![self.myRootViewController.currentController isKindOfClass:[EventAlertViewController class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.bottomBarView showEventStateImage];
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.bottomBarView showEventStateImage];
            });
        }
    }

}

- (void)addSubview:(UIView *)view{
    
    [super addSubview:view];
    
    UIView * alertView = [self viewWithTag:AlertViewTypeTop];
    if (alertView) {
        
        [self bringSubviewToFront:alertView];
    }
    
    alertView = [self viewWithTag:AlertViewTypeQuestion];
    if (alertView) {
        
        [self bringSubviewToFront:alertView];
    }
    alertView = [self viewWithTag:AlertViewTypeWait];
    
    if (alertView) {
        
        [self bringSubviewToFront:alertView];
    }

}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex != actionSheet.cancelButtonIndex) {
//        
//        
//        TWAPIManager * apiManger = self.myTwitterManager.apiManager;//
//        self.myTwitterManager.currentTwitterAccount = [self.myTwitterManager.accounts objectAtIndex:buttonIndex];
//        [apiManger performReverseAuthForAccount:self.myTwitterManager.currentTwitterAccount withHandler:^(NSData *responseData, NSError *error) {
//            if (responseData) {
//                NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//                
//                TWDLog(@"Reverse Auth process returned: %@", responseStr);
//                
//                NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
//                //NSString *lined = [parts componentsJoinedByString:@"\n"];
//                if ([parts count] > 3) {
//                    
//                    [MYDataManager shareManager].userInfoData.twitterOauthToken = [ToolClass getEqualString:[parts objectAtIndex:0]];
//                    [MYDataManager shareManager].userInfoData.twitterOauthTokenSecret = [ToolClass getEqualString:[parts objectAtIndex:1]];
//                    [MYDataManager shareManager].userInfoData.twitterid = [ToolClass getEqualString:[parts objectAtIndex:2]];
//                    [MYDataManager shareManager].userInfoData.twitterName = [ToolClass getEqualString:[parts objectAtIndex:3]];
//                }
//                
//                [responseStr release];
//                
//                if (self.myTwitterManager.flagNeedPostImage) {
//                    
//                    [self.myTwitterManager sharePhotoToWitter];
//                }
//                else{
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTwitterSessionStateOpen object:nil];
//                }
//            }
//            else {
//                
//                TWALog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
//           
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        
//                        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:nil
//                                                                          message:[error localizedDescription]
//                                                                         delegate:nil
//                                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                                                                otherButtonTitles:nil];
//                        [alertView show];
//                        [alertView release];
//                    });
//            }
//        }];
//    }
//    else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChooseTwitterAccountCancel object:nil userInfo:nil];
//    }
//}

- (void)showWaitAlertView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
    MyWaitAlertView * alertView = nil;
    
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"MyWaitAlertView" owner:nil options:nil];
        
    if ([views count]) {
        
        alertView = [views lastObject];
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.height);
        alertView.frame = frame;
        
    }
        
    self.waitAlertView = alertView;
    [alertView prepareView:nil];
    [alertView show];
        
    });
}

- (void)hideWaitAlertView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.waitAlertView hide];
        self.waitAlertView = nil;
        
    });

}

- (void)jumpToRootViewControllerWithOutAnimation {
    
    self.myRootViewController.needDissmiss = YES;
    
    UIViewController *controller = self.rootViewController;
    UIViewController *lastController = nil;
    UIViewController *topViewController = [UIViewController topViewController];
    while (topViewController != controller) {
        UIViewController *parentViewController = [topViewController getParentViewController];
        
        [topViewController  customDismissModalViewControllerAnimated:NO];
        topViewController = parentViewController;

        if (topViewController == lastController) {
            [topViewController customDismissModalViewControllerAnimated:NO];
            return ;
        }
        lastController = topViewController;
    }
    
    self.currentButtonTag = 1;
    self.myRootViewController.needDissmiss = YES;
    [self.bottomBarView setButtonHighlightWithIndex:self.currentButtonTag];
    
}

- (void)kickOffNotification:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString * tipMsg = NSLocalizedString(@"Login Elsewhere", nil);
        NSDictionary * userInfo = [NSDictionary dictionaryWithObject:@"KICK_OFF" forKey:KALERTTYPE];
        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                          message:tipMsg
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        alertView.userInfo = userInfo;
        [alertView show];
        [alertView release];
    });
}

- (void)showAlertViewWithTitle:(NSString *)title{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString * tipMsg = NSLocalizedString(title, nil);
        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                          message:tipMsg
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}

- (void)exitApplication {
    
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [AppDelegate getAppDelegate].window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}


@end
