//
//  CameraNameViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "cameraDelegate.h"

@interface CameraNameViewController : BaseViewController<UITextFieldDelegate,cameraDelegate,UITextViewDelegate>

@property (retain, nonatomic) NSString * cameraName;
@property (retain, nonatomic) NSString * cameraDescription;
@property (retain, nonatomic) CameraInfoData * cameraInfo;
@property (retain, nonatomic) IBOutlet UIImageView *textFieldBackImageView;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UIImageView *descriptionBackImageView;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (retain, nonatomic) IBOutlet UILabel *cameraNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *cameraDescriptionLabel;

@end
