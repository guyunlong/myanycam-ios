//
//  ShareCameraAlertView.m
//  Myanycam
//
//  Created by myanycam on 14/1/10.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "ShareCameraAlertView.h"
#import "MYDataManager.h"
//#import "UMSocial.h"
#import "JSONKit.h"
#import "QRCodeGenerator.h"


@implementation ShareCameraAlertView
@synthesize cameraData;
@synthesize shareDelegate;
@synthesize timeLong;
@synthesize sharePasswordStr;


- (void)dealloc {
    
    self.cameraData = nil;
    self.userInfo = nil;
    self.sharePasswordStr = nil;
    
    [_qrimage release];
    [_shareUrlLabel release];
    [_passwordTextField release];
    [_timeTextField release];
    [_sinaShareButton release];
    [_weixinShareButton release];
    [_switchControl release];
    [_shareButtonBackView release];
    [_createShareUrlButton release];
    [_cancalButton release];
    [_shareCameraAlertImageView release];
    [_backgroundView release];
    [_closeImageView release];
    [_shareTypeLabel release];
    [_showPasswordControl release];
    [_openShareLabel release];
    [_sharePasswordLabel release];
    [_shareTimeLabel release];
    [_passwordNOLabel release];
    [_showPasswordLabel release];
    [_privateShareTipLabel release];
    [_shareTimeUnitLabel release];
    [_smsButton release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareView:(CameraInfoData *)cameradata{
    
    self.passwordTextField.secureTextEntry = NO;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 6.0;
    self.cameraData = cameradata;
    self.passwordTextField.text = cameraData.sharePassword;
    self.shareCameraAlertImageView.image = [[UIImage imageNamed:@"login.gif"] resizableImage];
    self.shareUrlLabel.text = @"";
    
    UIImage * image = [[UIImage imageNamed:@"smile_bottom_transmit_nor.png"] resizableImage];
    [self.createShareUrlButton setBackgroundImage:image forState:UIControlStateNormal];
    self.tag = AlertViewTypeTop;
    [self.switchControl setOn:self.cameraData.shareswitch == 0?NO:YES];
    self.closeImageView.hidden =  self.switchControl.isOn;
    self.shareTypeLabel.text = @"";
    self.openShareLabel.text = NSLocalizedString(@"Open Share", nil);
    self.sharePasswordLabel.text = NSLocalizedString(@"Share Password", nil);
    self.shareTimeLabel.text = NSLocalizedString(@"Duration", nil);
    self.shareTimeUnitLabel.text = NSLocalizedString(@"Minute", nil);
    self.privateShareTipLabel.text = NSLocalizedString(@"Default is public share. Private share need input password. Password is 8 characters", nil);
    self.showPasswordLabel.text = NSLocalizedString(@"Show Password", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    self.timeTextField.placeholder = NSLocalizedString(@"Share Duration", nil);
//    self.sinaShareButton.tag = UMSocialSnsTypeSina;
//    self.weixinShareButton.tag = UMSocialSnsTypeWechatSession;
//    self.smsButton.tag = UMSocialSnsTypeSms;
    
    if ( [[MYDataManager shareManager] currentSystemLanguage] != DeviceLanaguage_ZH_S){
        
        UIImage * facebookimage = [UIImage imageNamed:@"sns_icon_10@2x.png"];
        UIImage * twitterImage = [UIImage imageNamed:@"sns_icon_11@2x.png"];
        [self.sinaShareButton setBackgroundImage:facebookimage forState:UIControlStateNormal];
        [self.weixinShareButton setBackgroundImage:twitterImage forState:UIControlStateNormal];
//        self.sinaShareButton.tag = UMSocialSnsTypeFacebook;
//        self.weixinShareButton.tag = UMSocialSnsTypeTwitter;
    }
    
}

- (IBAction)createShareButtonAction:(id)sender{
    
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

- (IBAction)smsButtonAction:(id)sender {
    
    if (self.shareDelegate && [self.shareDelegate respondsToSelector:@selector(shareAlertViewDelegate:userInfo:type:)]) {
        
        [self.shareDelegate shareAlertViewDelegate:self userInfo:self.userInfo type:self.smsButton.tag];
    }
    
}

- (IBAction)weixinButtonAction:(id)sender {
    
    if (self.shareDelegate && [self.shareDelegate respondsToSelector:@selector(shareAlertViewDelegate:userInfo:type:)]) {
        
        
        [self.shareDelegate shareAlertViewDelegate:self userInfo:self.userInfo type:self.weixinShareButton.tag];
    }
}

- (IBAction)weiboShareButtonAction:(id)sender {
    
    if (self.shareDelegate && [self.shareDelegate respondsToSelector:@selector(shareAlertViewDelegate:userInfo:type:)]) {
        
        [self.shareDelegate shareAlertViewDelegate:self userInfo:self.userInfo type:self.sinaShareButton.tag];
    }
    
}

- (IBAction)switchControlAction:(id)sender {
    
    UISwitch * control = (UISwitch *)sender;
    
    self.cameraData.sharePassword = self.passwordTextField.text;
    
    [[AppDelegate getAppDelegate].mygcdSocketEngine sendOpenShareSwitch:[MYDataManager shareManager].userInfoData.userId cameraid:self.cameraData.cameraId swithFlag:control.isOn?1:0 password:@""];
    self.closeImageView.hidden =  self.switchControl.isOn;
}

- (IBAction)cancelButtonAction:(id)sender {
    
    [self hide];
}

- (IBAction)showPasswordSwitch:(id)sender {
    
    self.sharePasswordStr = self.passwordTextField.text;
    
    [self.passwordTextField resignFirstResponder];
    self.passwordTextField.secureTextEntry = !self.showPasswordControl.isOn;
    [self.passwordTextField becomeFirstResponder];
    self.passwordTextField.text = self.sharePasswordStr;
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
    
    [self.shareButtonBackView customShowWithAnimation:YES duration:0.2];
    
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"Myanycam：%@  %@",self.cameraData.cameraName,shareUrl],@"content"
                               ,image,@"image"
                               ,shareUrl,@"url"
                               ,nil];
    self.userInfo = userInfo;
    self.shareUrlLabel.text = shareUrl;
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
    
    [self.passwordTextField resignFirstResponder];
    [self.timeTextField resignFirstResponder];
    
    return YES;
    
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    if (self.passwordTextField == textField) {
//        
//        if ([textField.text length] == 8 && [string length] != 0) {
//            
//            return NO;
//        }
//
//    }
//    
//    return YES;
//}

@end
