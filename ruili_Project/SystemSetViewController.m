//
//  SystemSetViewController.m
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "SystemSetViewController.h"
#import "SystemSetRootViewController.h"
#import "UINavigationItem+UINavigationItemTitle.h"


@interface SystemSetViewController ()

@end

@implementation SystemSetViewController

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
    SystemSetRootViewController * controller = [[SystemSetRootViewController alloc] init];
//    controller.title = NSLocalizedString(@"Setting", nil);
    [controller.navigationItem setCustomTitle:NSLocalizedString(@"System Setting", nil)];
    [self pushViewController:controller animated:YES];
    self.tabBarItem.title = nil;
    [controller release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate{
    
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if (UIInterfaceOrientationPortrait == toInterfaceOrientation) {
        return YES;
    }
    return NO;
}



@end
