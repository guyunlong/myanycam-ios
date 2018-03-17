//
//  APSetingViewController.m
//  myanycam
//
//  Created by myanycam on 13-2-22.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "AppDelegate.h"
#import "APSetingViewController.h"
#import "SettingRootViewController.h"


@interface APSetingViewController ()

@end


@implementation APSetingViewController
@synthesize finishButton = _finishButton;



- (void)dealloc{
    
    self.finishButton = nil;
    [super dealloc];
}

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
    // add as a subview
    SettingRootViewController * settingController = [[SettingRootViewController alloc] init];
    settingController.title = NSLocalizedString(@"Myanycam M", nil);
    [self pushViewController:settingController animated:NO];
    [settingController release];
    
    [[MYDataManager shareManager] updateImageFile];
}

-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return NO;
}


@end
