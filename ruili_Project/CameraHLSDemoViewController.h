//
//  CameraHLSDemoViewController.h
//  Myanycam
//
//  Created by myanycam on 2014/3/10.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"

@interface CameraHLSDemoViewController : BaseViewController

@property (retain, nonatomic) NSString * hlsUrl;

@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *navigationBarItem;
@property (retain, nonatomic) IBOutlet UIWebView *hlsWebView;


@end
