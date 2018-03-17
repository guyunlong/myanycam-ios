//
//  ImageBrowserNavigationController.m
//  Myanycam
//
//  Created by myanycam on 13-4-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "ImageBrowserNavigationController.h"


@interface ImageBrowserNavigationController ()

@end

@implementation ImageBrowserNavigationController

@synthesize photoSource = _photoSource;
@synthesize deleteImageDelegate = _deleteImageDelegate;
@synthesize imageBrowserType;
@synthesize currentCellData;
@synthesize cameraInfo;

- (void)dealloc{
    
    [_photoSource release];
    _photoSource = nil;
    self.deleteImageDelegate = nil;
    self.cameraInfo = nil;
    self.currentCellData = nil;
    [super dealloc];
    
}

- (id)initWithPhotoSource:(id <EGOPhotoSource> )aPhotoSource currentIndex:(int)index imageBrowserType:(PhotoBrowseType)aImageBrowserType{
    
    self = [super init];
    if (self) {
        // Custom initialization
        _photoSource = [aPhotoSource retain];
        _currentIndex = index;
        self.imageBrowserType = aImageBrowserType;
        
    }
    return self;
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
    
    UIImage * topbg = [[UIImage imageNamed:@"topBar.png"] resizableImage];
    [self.navigationBar setBackgroundImage:topbg forBarMetrics:UIBarMetricsDefault];
    
    self.interactivePopGestureRecognizer.enabled = NO;
    
    ImageBrowserViewController *photoController = [[ImageBrowserViewController alloc] initWithPhotoSource:self.photoSource];
    photoController.currentIndex = _currentIndex;
    photoController.albumsType = self.imageBrowserType;
    photoController.cameraInfo = self.cameraInfo;
    photoController.currentCellData = self.currentCellData;
    photoController.deleteImageDelegate = self.deleteImageDelegate;
    photoController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self pushViewController:photoController animated:NO];
    [photoController release];
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
