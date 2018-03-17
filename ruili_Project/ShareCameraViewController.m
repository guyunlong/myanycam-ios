//
//  ShareCameraViewController.m
//  Myanycam
//
//  Created by myanycam on 14/1/17.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "ShareCameraViewController.h"
//#import "UMSocial.h"
#import "QRCodeGenerator.h"
#import "MYDataManager.h"
#import "JSONKit.h"
#import <ShareSDK/ShareSDK.h>

@interface ShareCameraViewController ()

@end

@implementation ShareCameraViewController

@synthesize cameraData;
@synthesize timeLong;
@synthesize sharePasswordStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view from its nib.
    
    [self showBackButton:nil action:nil buttonTitle:nil];
    [self prepareView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.cameraData = nil;
    self.userInfo = nil;
    self.sharePasswordStr = nil;
    
    [_openShareLabel release];
    [_openShareControl release];
    [_sharePasswordLabel release];
    [_qrimage release];
    [_shareUrlLabel release];
    [_passwordTextField release];
    [_timeTextField release];
    [_sinaShareButton release];
    [_weixinShareButton release];
    [_shareButtonBackView release];
    [_shareTypeLabel release];
    [_shareTimeLabel release];
    [_shareTimeUnitLabel release];
    [_smsButton release];
    [_privateShareTipLabel release];
    [_shareCameraAlertImageView release];
    [_createShareUrlButton release];
    [_closeImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setOpenShareLabel:nil];
    [self setOpenShareControl:nil];
    [self setSharePasswordLabel:nil];
    [self setQrimage:nil];
    [self setShareUrlLabel:nil];
    [self setPasswordTextField:nil];
    [self setTimeTextField:nil];
    [self setSinaShareButton:nil];
    [self setWeixinShareButton:nil];
    [self setShareButtonBackView:nil];
    [self setShareTypeLabel:nil];
    [self setShareTimeLabel:nil];
    [self setShareTimeUnitLabel:nil];
    [self setSmsButton:nil];
    [self setPrivateShareTipLabel:nil];
    [self setShareCameraAlertImageView:nil];
    [self setCreateShareUrlButton:nil];
    [self setCloseImageView:nil];
    [super viewDidUnload];
}

- (IBAction)openShareControlAction:(id)sender {
    
    UISwitch * control = (UISwitch *)sender;
    
    self.cameraData.sharePassword = self.passwordTextField.text;
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendOpenShareSwitch:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraData.cameraId swithFlag:control.isOn?1:0 password:@""];
    self.closeImageView.hidden =  self.openShareControl.isOn;
    self.cameraData.shareswitch = control.isOn;
}



- (void)prepareView{
    
    self.passwordTextField.secureTextEntry = NO;
    self.passwordTextField.text = self.cameraData.sharePassword;
    self.shareCameraAlertImageView.image = [[UIImage imageNamed:@"login.gif"] resizableImage];
    self.shareUrlLabel.text = @"";
    
    UIImage * image = [[UIImage imageNamed:@"UMSocialSDKResourcesNew.bundle/Buttons/UMS_shake__share_button@2x.png"] resizableImage];    [self.createShareUrlButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.openShareControl setOn:self.cameraData.shareswitch == 0?NO:YES];
    self.closeImageView.hidden = self.cameraData.shareswitch == 0?NO:YES;
    self.shareTypeLabel.text = @"";
    
    self.openShareLabel.text = NSLocalizedString(@"Open Share", nil);
    self.sharePasswordLabel.text = NSLocalizedString(@"Share Password", nil);
    self.shareTimeLabel.text = NSLocalizedString(@"Duration", nil);
    self.shareTimeUnitLabel.text = NSLocalizedString(@"Minute", nil);
    //请输入分享时长。如果为空，则是永久有效。
    self.privateShareTipLabel.text = NSLocalizedString(@"Please input a number. If it is empty, the share link is permanent .", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    self.timeTextField.placeholder = NSLocalizedString(@"Share Duration", nil);
//    self.sinaShareButton.tag = UMSocialSnsTypeSina;
//    self.weixinShareButton.tag = UMSocialSnsTypeWechatSession;
//    self.smsButton.tag = UMSocialSnsTypeSms;
//    
//    if ( [[MYDataManager shareManager] currentSystemLanguage] != DeviceLanaguage_ZH_S){
//        
//        UIImage * facebookimage = [UIImage imageNamed:@"sns_icon_10@2x.png"];
//        UIImage * twitterImage = [UIImage imageNamed:@"sns_icon_11@2x.png"];
//        [self.sinaShareButton setBackgroundImage:facebookimage forState:UIControlStateNormal];
//        [self.weixinShareButton setBackgroundImage:twitterImage forState:UIControlStateNormal];
//        self.sinaShareButton.tag = UMSocialSnsTypeFacebook;
//        self.weixinShareButton.tag = UMSocialSnsTypeTwitter;
//    }
    
    [self.createShareUrlButton setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];

    
}

- (IBAction)createShareButtonAction:(id)sender{
    
    [self openShareControlAction:self.openShareControl];
    
    if ([self.passwordTextField.text length] > 0 && [[self.passwordTextField text] length] < 8) {
        
        NSString * tipMsg = NSLocalizedString(@"Password is 8 characters", nil);
        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                          message:tipMsg
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        return ;
    }
    
    if ([self.passwordTextField.text length] > 8) {
        
        NSString * tipMsg = NSLocalizedString(@"Password is 8 characters", nil);
        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                          message:tipMsg
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        self.passwordTextField.text = [self.passwordTextField.text substringWithRange:NSMakeRange(0, 8)];
        
        return ;
    }
    
    
    self.cameraData.sharePassword = self.passwordTextField.text;
    self.timeLong = [self.timeTextField.text intValue];
    
    if ([self.passwordTextField.text length] == 0) {
        
        self.shareTypeLabel.text = NSLocalizedString(@"Public Share", nil);
    }
    else
    {
        self.shareTypeLabel.text = NSLocalizedString(@"Private Share", nil);
    }
    
    
    NSString * url = [BuildSocketData shareUrlToken:self.cameraData.cameraId userid:[MYDataManager shareManager].userInfoData.userId validity:self.timeLong type:[self.passwordTextField.text length] == 8?1:0 shareName:@"anycam" password:self.cameraData.sharePassword accessKey:self.cameraData.accesskey];
    
    DebugLog(@"url = %@",url);
    
    //使用post方法请求http
    NSURL * shareUrlApi = [NSURL URLWithString:[NSString stringWithFormat:KSinaShortUrl,[ToolClass encodeURL:url]]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:shareUrlApi];
    //ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://126.am/api!shorten.action"]];
    //[request setPostValue:@"548f7dbc54c74312b7d9e0c75e12317f" forKey:@"key"];
    //[request setPostValue:url forKey:@"longUrl"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    [[AppDelegate getAppDelegate].window showWaitAlertView];
}

//- (IBAction)smsButtonAction:(id)sender {
//
//    NSString * content = [self.userInfo objectForKey:@"content"];
//    
//    if (self.smsButton.tag == UMSocialSnsTypeSms) {
//        
////        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:content image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
////            
////            DebugLog(@"response %@",response);
////            
////            if (response.responseCode == UMSResponseCodeSuccess) {
////                
////                DebugLog(@"分享成功！");
////            }
////        }];
//        
//        
//        if( [MFMessageComposeViewController canSendText] ){
//            
//            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
//            
//            controller.recipients = [NSArray arrayWithObject:@"10010"];
//            controller.body = content;
//            controller.messageComposeDelegate = self;
//            
//            [self presentModalViewController:controller animated:YES];
//            
//            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
//        }else{
//            
//            [self showAutoDismissAlertView:@"设备没有短信功能"];
//        }
//    }
//
//}
//
//- (IBAction)weixinButtonAction:(id)sender {
//    
//    
//    UIImage * image = [self.userInfo objectForKey:@"image"];
//    NSString * content = [self.userInfo objectForKey:@"content"];
//    NSString * shareUrl = [self.userInfo objectForKey:@"url"];
//    
//    if (self.weixinShareButton.tag == UMSocialSnsTypeTwitter) {
//        
//        
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToTwitter] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            
//            DebugLog(@"response %@",response);
//            
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                DebugLog(@"分享成功！");
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self showAutoDismissAlertView:NSLocalizedString(@"Share Success", nil)];
//                });
//            }
//        }];
//    }
//    
//    
//    if (self.weixinShareButton.tag == UMSocialSnsTypeWechatSession) {
//        
//        
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//        [UMSocialConfig setWXAppId:@"wxaa579ca5741b8293" url:shareUrl];
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                DebugLog(@"分享成功！");
//            }
//        }];
//    }
//}

//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
//    
//    DebugLog(@"response %@",response);
//    
//    if (response.responseCode == UMSResponseCodeSuccess) {
//        
//        DebugLog(@"分享成功！");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self showAutoDismissAlertView:NSLocalizedString(@"Share Success", nil)];
//        });
//    }
//    
//}

//- (IBAction)weiboShareButtonAction:(id)sender {
//    
//    
//    UIImage * image = [self.userInfo objectForKey:@"image"];
//    NSString * content = [self.userInfo objectForKey:@"content"];
////    NSString * shareUrl = [self.userInfo objectForKey:@"url"];
//    
//    if (self.sinaShareButton.tag == UMSocialSnsTypeSina) {
//        
//        [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:image socialUIDelegate:self];     //设置分享内容和回调对象
//        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//    }
//    
//    
//    if (self.sinaShareButton.tag == UMSocialSnsTypeFacebook) {
//        
//        [self shareImageToFacebook:image msg:content];
//    }
//}

- (IBAction)copyLinkButtonAction:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareUrlLabel.text;
    
    [self showAutoDismissAlertView:NSLocalizedString(@"Copy share link to pasteboard success!", nil)];
}


- (void)requestStarted:(ASIHTTPRequest *)request{
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
    DebugLog(@"responseHeaders %@",responseHeaders);
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    
    DebugLog(@"request %@",request.responseData);
    NSString * str = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    DebugLog(@"str %@",str);
    
    //    NSDictionary *result = [str objectFromJSONString];
    //    NSString * shareUrl = [result objectForKey:@"url_short"];
    
    NSString * shareUrl = nil;
    NSArray * array  = [str objectFromJSONString];
    for (NSDictionary * dict  in array) {
        
        shareUrl= [dict objectForKey:@"url_short"];
    }
    
    UIImage * image = [QRCodeGenerator qrImageForString:shareUrl imageSize:200];
    self.qrimage.image = image;
    [self.qrimage setNeedsDisplay];
    
    
//    [self.shareButtonBackView customShowWithAnimation:YES duration:0.2];
    
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%@：%@ %@",KAppName,self.cameraData.cameraName,shareUrl],@"content"
                               ,image,@"image"
                               ,shareUrl,@"url"
                               ,nil];
    self.userInfo = userInfo;
    self.shareUrlLabel.text = shareUrl;
    
    
    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIpad1) {
        
        [self shareWithShareSdk:[userInfo objectForKey:@"content"] image:image title:KAppName shareUrl:shareUrl view:self.createShareUrlButton arrowDirect:UIPopoverArrowDirectionUp shareMediaType:SSPublishContentMediaTypeNews];
    }
    else
    {
        [self shareIphoneWithShareSdk:[userInfo objectForKey:@"content"] image:image title:KAppName shareUrl:shareUrl viewController:self shareMediaType:SSPublishContentMediaTypeNews];
    }
    

    [str release];
    
    [[AppDelegate getAppDelegate].window hideWaitAlertView];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == self.passwordTextField) {
        
        [self checkPasswordTextFieldState];
    }
    
    return YES;
}

- (BOOL)checkPasswordTextFieldState{
    
    
    if ([self.passwordTextField.text length] > 0 && [[self.passwordTextField text] length] < 8) {
        
        NSString * tipMsg = NSLocalizedString(@"Password is 8 characters", nil);
        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                          message:tipMsg
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        return NO;
    }
    
    if ([self.passwordTextField.text length] > 8) {
        
        NSString * tipMsg = NSLocalizedString(@"Password is 8 characters", nil);
        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                          message:tipMsg
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        self.passwordTextField.text = [self.passwordTextField.text substringWithRange:NSMakeRange(0, 8)];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.passwordTextField) {
        
        if ([textField.text length] > 0 && [[textField text] length] < 8) {
            
            NSString * tipMsg = NSLocalizedString(@"Password is 8 characters", nil);
            MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                              message:tipMsg
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                    otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
            return NO;
        }
        
        if ([textField.text length] > 8) {
            
            NSString * tipMsg = NSLocalizedString(@"Password is 8 characters", nil);
            MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                              message:tipMsg
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                    otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 8)];
            
            return YES;
        }
    }
    
    if (textField == self.timeTextField) {
        
        self.timeLong = [self.timeTextField.text intValue];
    }
    
    if (textField == self.passwordTextField) {
        
        if (![self.sharePasswordStr isEqualToString:self.passwordTextField.text]) {
            
            [self.shareButtonBackView customHideWithAnimation:YES duration:0.2];
            self.shareTypeLabel.text = @"";
            self.shareUrlLabel.text = @"";
        }
        
        self.sharePasswordStr = self.passwordTextField.text;
    }
    
    [self.passwordTextField resignFirstResponder];
    [self.timeTextField resignFirstResponder];
    
    return YES;
    
}
@end
