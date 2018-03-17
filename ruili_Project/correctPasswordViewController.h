//
//  correctPasswordViewController.h
//  myanycam
//
//  Created by myanycam on 13-1-9.
//  Copyright (c) 2013年 myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "correctPasswordDelegate.h"

@interface correctPasswordViewController : BaseViewController<correctPasswordDelegate,UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (retain, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (retain, nonatomic) IBOutlet UITextField *comfirmPassword;
@property (retain, nonatomic) IBOutlet UIImageView *oldPasswordImageView;
@property (retain, nonatomic) IBOutlet UIImageView *passwordImageVIew;
@property (retain, nonatomic) IBOutlet UILabel *setNewPasswordLabel;

@property (retain, nonatomic) IBOutlet UILabel *oldpasswordLabel;
@property (retain, nonatomic) IBOutlet UILabel *confirmPasswordLabel;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;
@property (retain, nonatomic) IBOutlet UIView *inputBackImageView;

@property (retain, nonatomic) IBOutlet UIImageView *backImageView;
- (void)correctAction:(id)sender;
- (void)cancleAction:(id)sender;

- (IBAction)submitButtonAction:(id)sender;

@end
