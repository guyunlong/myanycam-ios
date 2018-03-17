//
//  PhotosGridViewController.m
//  myanycam
//
//  Created by 中程 on 13-1-31.
//  Copyright (c) 2013年 中程. All rights reserved.
//

#import "PhotosGridViewController.h"
#import "navTitleLabel.h"
#import "CustomAQGridViewCell.h"
#import "EGOPhotoGlobal.h"
#import "UIImageView+Curled.h"
#import "MYDataManager.h"
#import "UINavigationItem+UINavigationItemTitle.h"


@implementation MYImageName
@synthesize imageName;
@synthesize imagePath;
@synthesize imageUrl;
@synthesize date;

- (void)dealloc{
    
    self.imagePath = nil;
    self.imageUrl = nil;
    self.imageName = nil;
    self.date = nil;
    
    [super dealloc];
}

@end

@interface PhotosGridViewController ()

@end

@implementation PhotosGridViewController
@synthesize dataArray;
@synthesize listType;

- (void)dealloc {
    
    self.dataArray = nil;
    [_fileListNavBar release];
    [_fileListNavItem release];
    [_imageListBtn release];
    [_videoListBtn release];
    [_fileGridView release];
    [_noPhotosTipLabel release];
    
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

- (void)prepareData{
    
    self.dataArray = nil;
    _currentSelectCellIndex = -1;

}

- (void)updateListData{
    
    if (self.listType == 0) {
        
        self.dataArray = [MYDataManager shareManager].imageFileArray;
    }
    
    [self.fileGridView reloadData];
}

- (void)deleteImageWithIndex:(NSInteger)imageIndex{
    
    self.dataArray = [MYDataManager shareManager].imageFileArray;
    [self.fileGridView deleteItemsAtIndices:[NSIndexSet indexSetWithIndex:imageIndex] withAnimation:AQGridViewItemAnimationNone];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if ([self.dataArray count] == 0) {
        
        self.noPhotosTipLabel.hidden = NO;
    }
    else
    {
        self.noPhotosTipLabel.hidden = YES;
    }
    
    [MobClick beginLogPageView:@"PhotosGridViewController"];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PhotosGridViewController"];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
//    self.dataArray = nil;
//    [self.fileGridView reloadData];
    
}

- (void)backAction{
    
    [[AppDelegate getAppDelegate].window jumpToRootViewControllerWithOutAnimation];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listType = 0;
    [self prepareData];
    self.isShowBottomBar = YES;
    [AsyncImageLoader sharedLoader].cache = nil;
    
    if (![AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        NSString * imageNormalStr = @"icon_Return.png";
        NSString * imageSelectStr = @"icon_Return_hover.png";
        UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"", nil) size:CGSizeMake(32, 32) target:self  action:@selector(backAction)];
        _fileListNavItem.leftBarButtonItem = backButton;
    }
    

    if ([ToolClass systemVersionFloat] >= 7.0) {
        
        CGRect fr = self.fileListNavBar.frame;
        fr.size.height = 64;
        self.fileListNavBar.frame = fr;
        
        fr = [UIScreen mainScreen].bounds;
        fr.origin.y = 64;
        fr.size.height = fr.size.height - 64 -70;
        self.fileGridView.frame = fr;
    }
    else
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.x = 0;
        frame.origin.y = 44;
        frame.size.height = frame.size.height - 44 - 70;
        self.fileGridView.frame = frame;
    }
    
    [_fileListNavBar setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.imageListBtn setTitleWithStr:NSLocalizedString(@"Photo", nil) fontSize:FONT_SIZE];
    [self.videoListBtn setTitleWithStr:NSLocalizedString(@"Video", nil) fontSize:FONT_SIZE];

    [self.fileListNavItem setCustomTitle:NSLocalizedString(@"Photo", nil)];

    // grid view sits on top of the background image
//    self.fileGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.fileGridView.backgroundColor = [UIColor clearColor];
    self.fileGridView.opaque = NO;
    [self.fileGridView setRequiresSelection:YES];
    

    
    if ( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) )
    {
        // bring 1024 in to 1020 to make a width divisible by five
        self.fileGridView.leftContentInset = 2.0;
        self.fileGridView.rightContentInset = 2.0;
    }

    [self updateListData];
    
    self.noPhotosTipLabel.text = NSLocalizedString(@"No Photos", nil);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFileListNavBar:nil];
    [self setFileListNavItem:nil];
    [self setImageListBtn:nil];
    [self setVideoListBtn:nil];
    [self setFileGridView:nil];
    [self setFileGridView:nil];
    [self setNoPhotosTipLabel:nil];
    [super viewDidUnload];
}

- (IBAction)imagesButton:(id)sender {
    
    [_imageListBtn setBackgroundImage:[UIImage imageNamed:@"11.png"] forState:UIControlStateNormal];
    [_imageListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_videoListBtn setBackgroundImage:[UIImage imageNamed:@"10.png"] forState:UIControlStateNormal];
    [_videoListBtn setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forState:UIControlStateNormal];
    self.listType = 0;
    [self updateListData];
}

- (IBAction)videoButton:(id)sender {
    
    [_imageListBtn setBackgroundImage:[UIImage imageNamed:@"10.png"] forState:UIControlStateNormal];
    [_imageListBtn setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forState:UIControlStateNormal];
    [_videoListBtn setBackgroundImage:[UIImage imageNamed:@"11.png"] forState:UIControlStateNormal];
    [_videoListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.listType = 1;
    [self updateListData];
}

//-------------------------------------------------------


- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView{
    
    return [self.dataArray count];
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index{
    
    static NSString * CellIdentifier = @"CellIdentifier";
    
    
    CustomAQGridViewCell * cell = (CustomAQGridViewCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        CGSize size = CGSizeMake(152, 85);
        
        cell = [[[CustomAQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, size.width, size.height) reuseIdentifier: CellIdentifier] autorelease];
        [cell contentView].backgroundColor = [UIColor clearColor];
       
    }
    else
    {
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imageView];
    }
    
    cell.currentIndex = index;
    
    MYImageName * imageName = [self.dataArray objectAtIndex:index];
    cell.imageView.image = [UIImage imageNamed:@"照片缓冲.png"];
    [cell updateImage:imageName.imageUrl];
//    cell.imageView.imageURL = [NSURL fileURLWithPath:imageName.imagePath];
//    [cell.imageView setImage:image borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0];
    
    return ( cell );
}


// all cells are placed in a logical 'grid cell', all of which are the same size. The default size is 96x128 (portrait).
// The width/height values returned by this function will be rounded UP to the nearest denominator of the screen width.
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView{
    
    return CGSizeMake(152, 85 + 4);
}

//-------------------------------------------------------

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index{
    
    DebugLog(@" index %lu",(unsigned long)index);
    
    if (self.listType == 0) {
        
        MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[MYDataManager shareManager].imageSourceArray];
        ImageBrowserNavigationController * controller = [[ImageBrowserNavigationController alloc] initWithPhotoSource:source currentIndex:index imageBrowserType:PhotoBrowseTypeTakePhoto];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.deleteImageDelegate = self;
        [self hideBottomBar];
        [self customPresentModalViewController:controller animated:NO];
        [controller release];
        [source release];
        
        if (_currentSelectCellIndex != -1 && [self.dataArray count] >= _currentSelectCellIndex +1 &&  _currentSelectCellIndex != index) {
            
            CustomAQGridViewCell * currentCell = (CustomAQGridViewCell*)[gridView cellForItemAtIndex:_currentSelectCellIndex];
            [currentCell setHighlighted:NO animated:NO];
        }
        _currentSelectCellIndex = index;
        
        
    }
    
    if (self.listType == 1) {
        
        
    }
        
}


@end
