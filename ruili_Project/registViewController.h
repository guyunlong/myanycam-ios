//
//  registViewController.h
//  myanycam
//
//  Created by myanycam on 13-1-9.
//  Copyright (c) 2013年 myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "registDelegate.h"

@protocol RegistViewControllerDelegate;

@interface registViewController : BaseViewController<registDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) NSString * passwardStr;
@property (retain, nonatomic) NSString * accountStr;
@property (assign, nonatomic) id<RegistViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextField *accountTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField *confirmPassword;
@property (retain, nonatomic) IBOutlet UINavigationBar *registNavBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *registNavItem;
@property (retain, nonatomic) IBOutlet UIImageView *inputBigImageView;
@property (retain, nonatomic) IBOutlet UIButton *registerButton;
@property (retain, nonatomic) IBOutlet UIView *inputBigView;
@property (retain, nonatomic) IBOutlet UIImageView *topBackImageView;

- (IBAction)registAction:(id)sender;
- (IBAction)resetAction:(id)sender;

@end

@protocol RegistViewControllerDelegate <NSObject>

- (void)registSuccess;

@end