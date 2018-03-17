//
//  ShareCameraViewController.h
//  Myanycam
//
//  Created by myanycam on 14/1/17.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareCameraViewController : BaseViewController<ASIHTTPRequestDelegate,UITextFieldDelegate>

@property (retain, nonatomic) CameraInfoData * cameraData;
@property (retain, nonatomic) NSDictionary * userInfo;
@property (assign, nonatomic) NSInteger  timeLong;
@property (retain, nonatomic) NSString * sharePasswordStr;

@property (retain, nonatomic) IBOutlet UILabel *openShareLabel;
@property (retain, nonatomic) IBOutlet UISwitch *openShareControl;
@property (retain, nonatomic) IBOutlet UILabel *sharePasswordLabel;
@property (retain, nonatomic) IBOutlet UIImageView *qrimage;
@property (retain, nonatomic) IBOutlet UILabel *shareUrlLabel;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField *timeTextField;
@property (retain, nonatomic) IBOutlet UIButton *sinaShareButton;
@property (retain, nonatomic) IBOutlet UIButton *weixinShareButton;

@property (retain, nonatomic) IBOutlet UIView *shareButtonBackView;
@property (retain, nonatomic) IBOutlet UILabel *shareTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *shareTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *shareTimeUnitLabel;
@property (retain, nonatomic) IBOutlet UIButton *smsButton;
@property (retain, nonatomic) IBOutlet UILabel *privateShareTipLabel;
@property (retain, nonatomic) IBOutlet UIImageView *shareCameraAlertImageView;
@property (retain, nonatomic) IBOutlet UIButton *createShareUrlButton;

@property (retain, nonatomic) IBOutlet UIImageView *closeImageView;

- (IBAction)openShareControlAction:(id)sender;
- (IBAction)createShareButtonAction:(id)sender;
//- (IBAction)smsButtonAction:(id)sender;
//- (IBAction)weixinButtonAction:(id)sender;
//- (IBAction)weiboShareButtonAction:(id)sender;
- (IBAction)copyLinkButtonAction:(id)sender;


@end
