//
//  ShareCameraAlertView.h
//  Myanycam
//
//  Created by myanycam on 14/1/10.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "BaseAlertView.h"

@protocol ShareCameraAlertViewDelegate ;

@interface ShareCameraAlertView : BaseAlertView<ASIHTTPRequestDelegate,UITextFieldDelegate>

@property (retain, nonatomic) CameraInfoData * cameraData;
@property (retain, nonatomic) NSDictionary * userInfo;
@property (assign, nonatomic) NSInteger  timeLong;
@property (retain, nonatomic) NSString * sharePasswordStr;
@property (retain, nonatomic) IBOutlet UIImageView *qrimage;
@property (retain, nonatomic) IBOutlet UILabel *shareUrlLabel;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField *timeTextField;
@property (retain, nonatomic) IBOutlet UIButton *sinaShareButton;
@property (retain, nonatomic) IBOutlet UIButton *weixinShareButton;
@property (retain, nonatomic) IBOutlet UISwitch *switchControl;
@property (retain, nonatomic) IBOutlet UIView *shareButtonBackView;
@property (retain, nonatomic) IBOutlet UIButton *createShareUrlButton;
@property (retain, nonatomic) IBOutlet UIButton *cancalButton;
@property (retain, nonatomic) IBOutlet UIView *backgroundView;
@property (retain, nonatomic) IBOutlet UIImageView *closeImageView;
@property (retain, nonatomic) IBOutlet UILabel *shareTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *openShareLabel;
@property (retain, nonatomic) IBOutlet UILabel *sharePasswordLabel;
@property (retain, nonatomic) IBOutlet UILabel *shareTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *shareTimeUnitLabel;

@property (retain, nonatomic) IBOutlet UIButton *smsButton;
@property (retain, nonatomic) IBOutlet UILabel *passwordNOLabel;
@property (retain, nonatomic) IBOutlet UISwitch *showPasswordControl;
@property (retain, nonatomic) IBOutlet UILabel *showPasswordLabel;
@property (retain, nonatomic) IBOutlet UILabel *privateShareTipLabel;


@property (retain, nonatomic) IBOutlet UIImageView *shareCameraAlertImageView;
@property (assign, nonatomic) id<ShareCameraAlertViewDelegate> shareDelegate;

- (void)prepareView:(CameraInfoData *)cameradata;
- (IBAction)createShareButtonAction:(id)sender;
- (IBAction)smsButtonAction:(id)sender;
- (IBAction)weixinButtonAction:(id)sender;
- (IBAction)weiboShareButtonAction:(id)sender;
- (IBAction)switchControlAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)showPasswordSwitch:(id)sender;


@end


@protocol ShareCameraAlertViewDelegate <NSObject>

- (void)shareAlertViewDelegate:(ShareCameraAlertView *)alertView userInfo:(NSDictionary *)userInfo type:(NSInteger)type;

@end