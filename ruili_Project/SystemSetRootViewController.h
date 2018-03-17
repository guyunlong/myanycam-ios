//
//  SystemSetRootViewController.h
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"


@interface SystemSetRootViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray      *_functionSetDataArray;
    NSMutableArray      *_infomationSetDataArray;
}

@property (retain, nonatomic) IBOutlet UITableView *systemSetTableView;
@property (retain, nonatomic) NSMutableArray * functionSetDataArray;
@property (retain, nonatomic) NSMutableArray * infomationSetDataArray;
@property (retain, nonatomic) IBOutlet UIWebView *aboutWebView;
@property (retain, nonatomic) IBOutlet UIImageView *aboutLogoImageView;
@property (retain, nonatomic) IBOutlet UIImageView *aboutNameImageView;
@property (retain, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logoutButtonAction:(id)sender;


@end


