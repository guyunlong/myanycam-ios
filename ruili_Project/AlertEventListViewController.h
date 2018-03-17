//
//  AlertEventListViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-2.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AQGridView.h"
#import "BaseViewController.h"

@interface AlertEventListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AQGridViewDataSource,AQGridViewDelegate>

@property (retain, nonatomic) IBOutlet AQGridView *alertGridView;
@property (retain, nonatomic) NSArray  * cameraList;
@property (retain, nonatomic) IBOutlet UITableView *cameraListTableView;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *topNavigationItem;

@end
