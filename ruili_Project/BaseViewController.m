//
//  BaseViewController.m
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "MYAlertView.h"
#import "AutoDismissAlertView.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize isShowBottomBar = _isShowBottomBar;
@synthesize activityIndicatorView;
@synthesize waitAlertView;

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDismissDelegate object:self];
    
    self.waitAlertView = nil;
    self.activityIndicatorView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        if([ToolClass systemVersionFloat]>=7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.isShowBottomBar) {
        
        [self showBottomBar];
    }
    else{
        
        [self hideBottomBar];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];

    });
    
}

- (void)goToBack{
    
    [self customDismissModalViewControllerAnimated:YES];
}

-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (AppDelegate *)getDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (UIAlertView *)showAlertView:(NSString *)titleStr alertMsg:(NSString *)alertMsg userInfo:(NSDictionary *)userInfo delegate:(id<UIAlertViewDelegate>)delegate canclButtonStr:(NSString *)canclButtonStr otherButtonTitles:(NSString *)otherButtonTitles, ...{


    MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:titleStr
                                                      message:alertMsg
                                                     delegate:delegate
                                            cancelButtonTitle:canclButtonStr
                                            otherButtonTitles:otherButtonTitles,nil];
    [alertView show];
    [alertView release];
    alertView.userInfo = userInfo;
    return alertView;
    
}


- (void)showCustomAutoDismssAlertView:(NSString *)tip{
    
    AutoDismissAlertView * view = nil;
    
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"AutoDismissAlertView" owner:nil options:nil];
    if ([views count]) {
        
        view = [views lastObject];
        view.alertViewTipLabel.text = tip;
    }
    
    [view show];
    
    [self performSelector:@selector(autocustomAlertViewDimissAlert:) withObject:view afterDelay:1.8];
    
}

- (void)autocustomAlertViewDimissAlert:(BaseAlertView *)alertView{
    
    if(alertView)
    {
        [alertView hide];
        alertView = nil;
    }
}


- (void)showAutoDismissAlertView:(NSString *)tip{
    
    MYAlertView * alertView = [[MYAlertView alloc] initWithTitle:tip message:nil
                                                        delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    
    CGFloat y = alertView.frame.origin.y;
    CGFloat h = alertView.frame.size.height;
    CGFloat offsetH = h - 80;
    y += offsetH/2;
    
    alertView.frame = CGRectMake(alertView.frame.origin.x, y, alertView.frame.size.width, 80);

    
    [self performSelector:@selector(autoDimissAlert:) withObject:alertView afterDelay:1.8];
}

- (void)autoDimissAlert:(MYAlertView *)alertView{
    
    if(alertView)
    {
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:NO];
        [alertView release];
    }
}

- (void)showBackButton:(id)target action:(SEL)action buttonTitle:(NSString *)title{
    
    if (target == nil) {
        target = self;
    }
    if (action == nil) {
        action = @selector(goBack);
    }
    
    if (title == nil) {
        
        title = NSLocalizedString(@"Back", nil);
    }

    
    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:title size:CGSizeMake(32, 32) target:target  action:action];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)hideBottomBar{
    
    [[self appDelegate].window hideCustomBottomBar];
}

- (void)showBottomBar{
    
    [[self appDelegate].window showCustomBottomBar];
}

- (void)addActivityView{
    
    UIActivityIndicatorView * waitView = [[UIActivityIndicatorView alloc] init];
    self.activityIndicatorView = waitView;
    [waitView release];
    
    [self.view addSubview:waitView];
    [waitView startAnimating];
    
}


- (void)customPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    
    if (modalViewController ) {
        
        if ([ToolClass systemVersionFloat] >= 5.0) {
            
            [self presentViewController:modalViewController animated:animated completion:^{
                
            }];
        }
        else {
            [self presentModalViewController:modalViewController animated:animated];
        }
    }

}

- (void)customDismissModalViewControllerAnimated:(BOOL)animated{

    if ([ToolClass systemVersionFloat] >= 5.0) {
        
            [self dismissViewControllerAnimated:animated completion:^{
        }];
    }
    else {
        
        [self dismissModalViewControllerAnimated:animated];
    }
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;  // 可以修改为任何方向
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if (UIInterfaceOrientationPortrait == toInterfaceOrientation) {
        return YES;
    }
    return NO;
}

- (void)ShowWaitAlertView:(NSString *)titleStr{
    
    MyWaitAlertView * alertView = nil;
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"MyWaitAlertView" owner:nil options:nil];
    if ([views count]) {
        alertView = [views lastObject];
        alertView.frame = [UIScreen mainScreen].bounds;

    }
    self.waitAlertView = alertView;
    [alertView prepareView:titleStr];
    [alertView show];
}

- (void)hideWaitAlertView{
    
    [self.waitAlertView hide];
    self.waitAlertView = nil;
}

- (void)showAskAlertView:(NSString *)title msg:(NSString *)msg userInfo:(NSDictionary *)userInfo{
    
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:title message:msg];
    alert.userInfo = userInfo;
    alert.alertDelegate = self;
    [alert setCancelButtonTitle:NSLocalizedString(@"Cancel", nil) block:nil];
    [alert addButtonWithTitle:NSLocalizedString(@"OK", nil) block:nil];
    [alert show];
    [alert release];
    
}

- (void)showAskAlertViewWithButton:(NSString *)title msg:(NSString *)msg userInfo:(NSDictionary *)userInfo okBtn:(NSString *)btnStr{
    
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:title message:msg];
    alert.userInfo = userInfo;
    alert.alertDelegate = self;
    [alert setCancelButtonTitle:NSLocalizedString(@"Cancel", nil) block:nil];
    [alert addButtonWithTitle:btnStr block:nil];
    [alert show];
    [alert release];
    
}

- (void)alertView:(AHAlertView *)alertView otherButtonIndex:(NSInteger)buttonIndex{
    
}

- (void)cancelButtonAction:(NSDictionary *)info{
    
}

- (void)shareIphoneWithShareSdk:(NSString * )content image:(UIImage *)image title:(NSString *)title shareUrl:(NSString *)shareUrl viewController:(UIViewController *)viewController  shareMediaType:(SSPublishContentMediaType)mediaType{
    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:title
                                                  url:shareUrl
                                          description:content
                                            mediaType:mediaType];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    [container setIPhoneContainerWithViewController:viewController];
        
    [ShareSDK showShareActionSheet:container
                         shareList:[[MYDataManager shareManager] getShareTypeArray]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:[[MYDataManager shareManager] getShareOptionsArray]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSString * shareStr = NSLocalizedString(@"Share Success", nil);
                                    
                                    if (type == ShareTypeCopy) {
                                        
                                        shareStr = NSLocalizedString(@"Copy Success", nil);
                                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                        pasteboard.string = shareUrl;

                                    }
                                    
                                    if (type == ShareTypeSinaWeibo || type == ShareTypeTwitter || type == ShareTypeFacebook) {
                                        
                                        shareStr = NSLocalizedString(@"Share Success", nil);
                                    }
                                    
                                    DebugLog(@"分享成功！");
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self showAutoDismissAlertView:shareStr];
                                    });
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSString * string = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Share Failed", nil), [error errorDescription]];
                                    
                                    DebugLog(@"Share Failed%@",string);
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self showAutoDismissAlertView:string];
                                        
                                    });
                                }
                            }];
    
}

- (void)shareWithShareSdk:(NSString * )content image:(UIImage *)image title:(NSString *)title shareUrl:(NSString *)shareUrl view:(id)view arrowDirect:(UIPopoverArrowDirection)arrowDirect shareMediaType:(SSPublishContentMediaType)mediaType {
    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:title
                                                  url:shareUrl
                                          description:content
                                            mediaType:mediaType];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    if ([view isKindOfClass:[UIBarButtonItem class]]) {
        
        [container setIPadContainerWithBarButtonItem:view arrowDirect:arrowDirect];
        
    }
    else
    {
        
        [container setIPadContainerWithView:view arrowDirect:arrowDirect];
        
    }
    
    
    [ShareSDK showShareActionSheet:container
                         shareList:[[MYDataManager shareManager] getShareTypeArray]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:[[MYDataManager shareManager] getShareOptionsArray]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                DebugLog(@"%@",[statusInfo urls]);
                                
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                    NSString * shareStr = NSLocalizedString(@"Share Success", nil);
                                    
                                    if (type == ShareTypeCopy) {
                                        
                                        shareStr = NSLocalizedString(@"Copy Success", nil);
                                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                        pasteboard.string = shareUrl;
                                        
                                    }
                                    
                                    if (type == ShareTypeSinaWeibo || type == ShareTypeTwitter || type == ShareTypeFacebook) {
                                        
                                        shareStr = NSLocalizedString(@"Share Success", nil);
                                    }
                                    
                                    DebugLog(@"分享成功！");
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self showAutoDismissAlertView:shareStr];
                                    });
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSString * string = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Share Failed", nil), [error errorDescription]];
                                    
                                    DebugLog(@"Share Failed%@",string);
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self showAutoDismissAlertView:string];
                                        
                                    });
                                }
                            }];
    
    
}

@end
