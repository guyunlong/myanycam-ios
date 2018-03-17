//
//  QRWifiSettingViewController.h
//  Myanycam
//
//  Created by myanycam on 13/11/21.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"

@interface QRWifiSettingViewController : BaseViewController<UITextFieldDelegate>
@property (retain, nonatomic) UIImageView *qrshowImageView;
@property (retain, nonatomic) IBOutlet UITextField *wifiNameTextfiled;
@property (retain, nonatomic) IBOutlet UIButton *generateQRbutton;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UIView *inputView;
@property (retain, nonatomic) IBOutlet UILabel *showPasswordLabel;

@property (retain, nonatomic) IBOutlet UIView *backview;
@property (retain, nonatomic) IBOutlet UILabel *qrscanLabel;

- (IBAction)generateQRbuttonAction:(id)sender;
@property (retain, nonatomic) IBOutlet UISwitch *showPassword;

- (IBAction)showPasswordAction:(id)sender;


@end
