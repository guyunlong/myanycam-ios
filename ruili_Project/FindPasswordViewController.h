//
//  FindPasswordViewController.h
//  KCam
//
//  Created by myanycam on 2014/6/3.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "FindPasswordDelegate.h"

@interface FindPasswordViewController : BaseViewController<UITextFieldDelegate,FindPasswordDelegate>

@property (retain, nonatomic) NSString * emailTextFieldStr;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UIButton *sumitButton;
@property (retain, nonatomic) IBOutlet UINavigationBar *findPasswordnavigationBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *findPasswordnavigationItem;
- (IBAction)sumbitButtonAction:(id)sender;

@end
