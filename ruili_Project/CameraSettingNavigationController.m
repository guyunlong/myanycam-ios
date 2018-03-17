//
//  CameraSettingNavigationController.m
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraSettingNavigationController.h"

@interface CameraSettingNavigationController ()

@end

@implementation CameraSettingNavigationController
@synthesize cameraInfo;
@synthesize cameraDelegate;

- (void)dealloc{
    
    self.cameraInfo = nil;
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
	// Do any additional setup after loading the view.
    CameraSettingViewController * controller = [[CameraSettingViewController alloc] init];
//    controller.title =  NSLocalizedString(@"Camera Settings", nil); //@"Camera Settings";
    controller.cameraInfo = self.cameraInfo;
    controller.delegate = self.cameraDelegate;
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
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

    if (orientation == UIInterfaceOrientationPortrait) {
        
        return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        
        return YES;
    }
    return NO;
}

@end
