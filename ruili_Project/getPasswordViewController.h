//
//  getPasswordViewController.h
//  myanycam
//
//  Created by 中程 on 13-1-9.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "getPasswordDelegate.h"

@interface getPasswordViewController : BaseViewController<getPasswordDelegate,UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *accountTextField;
@property (retain, nonatomic) IBOutlet UIWebView *getPasswordWebView;
@property (retain, nonatomic) IBOutlet UINavigationBar *getPasswordNavBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *getPassowrdNavItem;

- (IBAction)getPasswordAction:(id)sender;


@end
