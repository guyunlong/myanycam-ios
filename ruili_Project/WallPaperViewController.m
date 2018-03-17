//
//  WallPaperViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "WallPaperViewController.h"
#import "AppDelegate.h"

@interface WallPaperViewController ()

@end

@implementation WallPaperViewController
@synthesize startWallViewTimer;
@synthesize delegate;

- (void)dealloc{
    
    [self.startWallViewTimer invalidate];
    self.startWallViewTimer = nil;
    self.delegate = nil;
    [_startWallPaperView release];
    [_waitImageView release];
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
    
//    self.startWallViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                               target:self
//                                                             selector:@selector(waitTimeAdd)
//                                                             userInfo:nil
//                                                              repeats:YES];
    
    
    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone) {
        
        self.waitImageView.image = [UIImage imageNamed:@"BG_960.png"];
    }
    
    if ([MYDataManager shareManager].deviceTpye == DeviceTypeIphone5) {
        
        self.waitImageView.image = [UIImage imageNamed:@"BG.png"];
    }
    
}

- (void)waitTimeAdd{
    
    _startWallTime ++ ;
}

- (void)stopTimer{
    
    _startWallTime = 0;
    [self.startWallViewTimer invalidate];
    self.startWallViewTimer = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissModalViewController{
    
    [self stopTimer];
    [self customDismissModalViewControllerAnimated:NO];
}

- (void)viewDidUnload {
    
    [self setStartWallPaperView:nil];
    [self setWaitImageView:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}
@end
