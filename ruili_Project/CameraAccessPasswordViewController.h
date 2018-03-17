//
//  CameraAccessPasswordViewController.h
//  Myanycam
//
//  Created by myanycam on 13/6/27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "CameraInfoData.h"
#import "cameraDelegate.h"

@interface CameraAccessPasswordViewController : BaseViewController<UITextFieldDelegate,cameraDelegate>

@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) IBOutlet UILabel *currentPassword;
@property (retain, nonatomic) IBOutlet UITextField *changePasswrdTextField;
@property (retain, nonatomic) IBOutlet UIImageView *currentPasswordBackImageView;
@property (retain, nonatomic) IBOutlet UILabel *currentPasswordTipLabel;
@property (retain, nonatomic) IBOutlet UILabel *changepasswordLabel;

@end
