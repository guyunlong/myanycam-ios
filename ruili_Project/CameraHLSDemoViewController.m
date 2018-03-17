//
//  CameraHLSDemoViewController.m
//  Myanycam
//
//  Created by myanycam on 2014/3/10.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "CameraHLSDemoViewController.h"
#import "UINavigationItem+UINavigationItemTitle.h"


@interface CameraHLSDemoViewController ()

@end

@implementation CameraHLSDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBarItem setCustomTitle:NSLocalizedString(@"Camera Demo", nil)];
    
    UIImage * bg = [[UIImage imageNamed:@"topBar.png"] resizableImage];
    [self.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    
    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"",nil) size:CGSizeMake(32, 32) target:self action:@selector(goToBack)];
    self.navigationBarItem.leftBarButtonItem = backButton;
    
    //if (self.hlsUrl)
    {
        
        NSURL * url = [NSURL URLWithString:KMyanycamHLS001];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        self.hlsWebView.backgroundColor= [UIColor blackColor];
        [self.hlsWebView loadRequest:request];
    }
    
    if ([ToolClass systemVersionFloat] >= 7.0) {
        
        CGRect fr = self.navigationBar.frame;
        fr.size.height = 64;
        self.navigationBar.frame = fr;
        
        fr = self.hlsWebView.frame;
        fr.origin.y += 20;
        self.hlsWebView.frame = fr;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_navigationBar release];
    [_navigationBarItem release];
    [_hlsWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setNavigationBarItem:nil];
    [self setHlsWebView:nil];
    [super viewDidUnload];
}
@end
