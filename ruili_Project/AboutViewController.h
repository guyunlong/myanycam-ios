//
//  AboutViewController.h
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray * aboutArray;

@property (retain, nonatomic) IBOutlet UIWebView *aboutWebView;
@property (retain, nonatomic) IBOutlet UIImageView *logoImageView;
@property (retain, nonatomic) IBOutlet UITableView *aboutTableView;
@property (retain, nonatomic) IBOutlet UIButton *weiboButton;
@property (retain, nonatomic) IBOutlet UIButton *myanycanUrlButton;
@property (retain, nonatomic) IBOutlet UILabel *copyrightshowLable;


@property (retain, nonatomic) IBOutlet UIButton *moreInfoButton;
@property (retain, nonatomic) IBOutlet UIButton *versionInfoButton;
- (IBAction)moreInfoButtonAction:(id)sender;


@end
