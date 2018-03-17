//
//  EGOPhotoController.m
//  EGOPhotoViewer
//
//  Created by Devin Doty on 1/8/10.
//  Copyright 2010 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOPhotoViewController.h"
#import "AppDelegate.h"

@interface EGOPhotoViewController (Private)
- (void)loadScrollViewWithPage:(NSInteger)page;
- (void)customloadScrollViewWithPage:(NSInteger)page;//andida
- (void)layoutScrollViewSubviews;
- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex;
- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setViewState;
- (void)setupViewForPopover;
- (void)autosizePopoverToImageSize:(CGSize)imageSize photoImageView:(EGOPhotoImageView*)photoImageView;
@end


@implementation EGOPhotoViewController

@synthesize scrollView=_scrollView;
@synthesize photoSource=_photoSource; 
@synthesize photoViews=_photoViews;
@synthesize _fromPopover;
@synthesize pageIndex = _pageIndex;
@synthesize flagIsdeleteing = _flagIsdeleteing;
@synthesize albumsType;
@synthesize currentPageDict = _currentPageDict;
@synthesize alertTypeImageView = _alertTypeImageView;
@synthesize trashAction = _trashAction;
@synthesize actionButton = _actionButton;



- (id)initWithPhoto:(id<EGOPhoto>)aPhoto {
	return [self initWithPhotoSource:[[[EGOQuickPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:aPhoto,nil]] autorelease]];
}

- (id)initWithImage:(UIImage*)anImage {
	return [self initWithPhoto:[[[EGOQuickPhoto alloc] initWithImage:anImage] autorelease]];
}

- (id)initWithImageURL:(NSURL*)anImageURL {
	return [self initWithPhoto:[[[EGOQuickPhoto alloc] initWithImageURL:anImageURL] autorelease]];
}

- (id)initWithPhotoSource:(id <EGOPhotoSource> )aSource{
	if (self = [super init]) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleBarsNotification:) name:@"EGOPhotoViewToggleBars" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewDidFinishLoading:) name:@"EGOPhotoDidFinishLoading" object:nil];
		
		self.hidesBottomBarWhenPushed = YES;
		self.wantsFullScreenLayout = YES;		
		_photoSource = [aSource retain];
		_pageIndex=0;
		
	}
	
	return self;
}

- (id)initWithPopoverController:(id)aPopoverController photoSource:(id <EGOPhotoSource>)aPhotoSource {
	if (self = [self initWithPhotoSource:aPhotoSource]) {
		_popover = aPopoverController;
	}
	
	return self;
}


#pragma mark -
#pragma mark View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.currentPageDict) {
        
        self.currentPageDict = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    
	self.view.backgroundColor = [UIColor blackColor];
	self.wantsFullScreenLayout = YES;
	
	if (!_scrollView) {
		
		_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
		_scrollView.delegate=self;
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		_scrollView.multipleTouchEnabled=YES;
		_scrollView.scrollEnabled=YES;
		_scrollView.directionalLockEnabled=YES;
		_scrollView.canCancelContentTouches=YES;
		_scrollView.delaysContentTouches=YES;
		_scrollView.clipsToBounds=YES;
		_scrollView.alwaysBounceHorizontal=YES;
		_scrollView.bounces=YES;
		_scrollView.pagingEnabled=YES;
		_scrollView.showsVerticalScrollIndicator=NO;
		_scrollView.showsHorizontalScrollIndicator=NO;
		_scrollView.backgroundColor = self.view.backgroundColor;
		[self.view addSubview:_scrollView];

	}
	
	if (!_captionView) {
		
		EGOPhotoCaptionView *view = [[EGOPhotoCaptionView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height, self.view.frame.size.width, 1.0f)];
        [view setBackgroundColor:[UIColor blackColor]];
		[self.view addSubview:view];
		_captionView=view;
		[view release];
		
	}
	
	//  load photoviews lazily
	NSMutableArray *views = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < [self.photoSource numberOfPhotos]; i++) {
		[views addObject:[NSNull null]];
	}
	self.photoViews = views;
	[views release];


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if ([self.photoSource numberOfPhotos] == 1 && UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		
		[self.navigationController setNavigationBarHidden:YES animated:NO];
		[self.navigationController setToolbarHidden:YES animated:NO];
		
		[self enqueuePhotoViewAtIndex:_pageIndex];
		[self customloadScrollViewWithPage:_pageIndex];
		[self setViewState];
		
	}
#endif

    if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
        
        UIImageView * imagev = nil;
        if ([MYDataManager shareManager].deviceTpye == DeviceTypeIpad1) {
            
            imagev  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 32, 30)];
        }
        else
        {
            if ([ToolClass systemVersionFloat] >= 7.0) {
            
                imagev  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 44, 32, 30)];
            }
            else
            {
                imagev  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64, 32, 30)];
            }
            
        }
//        andida 20140529 屏蔽
//        imagev.image = [UIImage imageNamed:@"移动帧测.png"];
//        [self.view addSubview:imagev];
//        [self.view bringSubviewToFront:imagev];
//        self.alertTypeImageView = imagev;
//        [imagev release];
    }

}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		
		UIView *view = self.view;
		if (self.navigationController) {
			view = self.navigationController.view;
		}
		
		while (view != nil) {
			
			if ([view isKindOfClass:NSClassFromString(@"UIPopoverView")]) {
				
				_popover = view;
				break;
			
			} 
			view = view.superview;
		}
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
		if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad && _popover==nil) {
			[self.navigationController setNavigationBarHidden:NO animated:NO];
		}
#endif
		
	} else {
		
		_popover = nil;
		
	}
	
	if(!_storedOldStyles) {
		_oldStatusBarSyle = [UIApplication sharedApplication].statusBarStyle;
		
		_oldNavBarTintColor = [self.navigationController.navigationBar.tintColor retain];
		_oldNavBarStyle = self.navigationController.navigationBar.barStyle;
		_oldNavBarTranslucent = self.navigationController.navigationBar.translucent;
		
		_oldToolBarTintColor = [self.navigationController.toolbar.tintColor retain];
		_oldToolBarStyle = self.navigationController.toolbar.barStyle;
		_oldToolBarTranslucent = self.navigationController.toolbar.translucent;
		_oldToolBarHidden = [self.navigationController isToolbarHidden];
		
		_storedOldStyles = YES;
	}	
	
	if ([self.navigationController isToolbarHidden] && (!_popover || ([self.photoSource numberOfPhotos] > 1))) {
		[self.navigationController setToolbarHidden:NO animated:YES];
	}
	
	if (!_popover) {
		self.navigationController.navigationBar.tintColor = nil;
		self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
		self.navigationController.navigationBar.translucent = YES;
		
		self.navigationController.toolbar.tintColor = nil;
		self.navigationController.toolbar.barStyle = UIBarStyleBlack;
		self.navigationController.toolbar.translucent = YES;
	}

	
	[self setupToolbar];
	[self setupScrollViewContentSize];
	[self moveToPhotoAtIndex:_pageIndex animated:NO];
	
	if (_popover) {
		[self addObserver:self forKeyPath:@"contentSizeForViewInPopover" options:NSKeyValueObservingOptionNew context:NULL];
	}
	
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	self.navigationController.navigationBar.barStyle = _oldNavBarStyle;
	self.navigationController.navigationBar.tintColor = _oldNavBarTintColor;
	self.navigationController.navigationBar.translucent = _oldNavBarTranslucent;
	
	[[UIApplication sharedApplication] setStatusBarStyle:_oldStatusBarSyle animated:YES];
	
	if(!_oldToolBarHidden) {
		
		if ([self.navigationController isToolbarHidden]) {
			[self.navigationController setToolbarHidden:NO animated:YES];
		}
		
		self.navigationController.toolbar.barStyle = _oldNavBarStyle;
		self.navigationController.toolbar.tintColor = _oldNavBarTintColor;
		self.navigationController.toolbar.translucent = _oldNavBarTranslucent;
		
	} else {
		
		[self.navigationController setToolbarHidden:_oldToolBarHidden animated:YES];
		
	}
	
	if (_popover) {
		[self removeObserver:self forKeyPath:@"contentSizeForViewInPopover"];
	}
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
#endif
	
   	return (UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait);
	
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	_rotating = YES;
	
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && !_popover) {
		CGRect rect = [[UIScreen mainScreen] bounds];
		self.scrollView.contentSize = CGSizeMake(rect.size.height * [self.photoSource numberOfPhotos], rect.size.width);
	}
	
	//  set side views hidden during rotation animation
	NSInteger count = 0;
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			if (count != _pageIndex) {
				[view setHidden:YES];
			}
		}
		count++;
	}
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			[view rotateToOrientation:toInterfaceOrientation];
		}
	}
		
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	
	[self setupScrollViewContentSize];
	[self moveToPhotoAtIndex:_pageIndex animated:NO];
	[self.scrollView scrollRectToVisible:((EGOPhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).frame animated:YES];
	
	//  unhide side views
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			[view setHidden:NO];
		}
	}
	_rotating = NO;
	
}

- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)setupToolbar {
	
	[self setupViewForPopover];

	if(_popover && [self.photoSource numberOfPhotos] == 1) {
		[self.navigationController setToolbarHidden:YES animated:NO];
		return;
	}
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (!_popover && UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad && !_fromPopover) {
		if (self.modalPresentationStyle == UIModalPresentationFullScreen) {
            
//            UIBarButtonItem * finishButton = [ViewToolClass customBarButtonItem:@"buttonNormal.png"
//                                                              buttonSelectImage:@"buttonSelect.png"
//                                                                          title:NSLocalizedString(@"Done", nil)
//                                                                           size:CGSizeMake(64, 32)
//                                                                         target:self
//                                                                         action:@selector(done:)];
//            
////			UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
//			self.navigationItem.rightBarButtonItem = finishButton;
////			[doneButton release];
		}
	} else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	}
#else 
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
#endif
	

    
	UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonHit:)];
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	if ([self.photoSource numberOfPhotos] >= 1) {
		
		UIBarButtonItem *fixedCenter = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedCenter.width = 80.0f;
		UIBarButtonItem *fixedLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedLeft.width = 40.0f;
		
		if (_popover && [self.photoSource numberOfPhotos] > 1) {
			UIBarButtonItem *scaleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"egopv_fullscreen_button.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleFullScreen:)];
			self.navigationItem.rightBarButtonItem = scaleButton;
			[scaleButton release];
		}
        
        
		
        if (![AppDelegate getAppDelegate].apModelOrCloudModel) {
            
            if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
                
                UIBarButtonItem *trashAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashImageAction:)];
             
                [self setToolbarItems:[NSArray arrayWithObjects: action,fixedLeft,flex, fixedCenter,flex, trashAction,nil]];//
                
                self.trashAction = trashAction;
                [trashAction release];

            }
            else
            {
                [self setToolbarItems:[NSArray arrayWithObjects: action,fixedLeft,flex, fixedCenter, flex, nil]];//trashAction

            }
        }
        else
        {
            
            if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
                
                UIBarButtonItem *trashAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashImageAction:)];

                [self setToolbarItems:[NSArray arrayWithObjects: action,fixedLeft,flex, fixedCenter,flex, trashAction,nil]];//
                self.trashAction = trashAction;
                [trashAction release];
            }

        }
		
		[fixedCenter release];
		[fixedLeft release];
		
	} else {
        
		[self setToolbarItems:[NSArray arrayWithObjects:flex, action, nil]];
	}
	
	self.actionButton = action;
	
	[action release];
	[flex release];
	
}

- (NSInteger)currentPhotoIndex{
	
	return _pageIndex;
	
}


#pragma mark -
#pragma mark Popver ContentSize Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{	
	[self setupScrollViewContentSize];
	[self layoutScrollViewSubviews];
}


#pragma mark -
#pragma mark Bar/Caption Methods

- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated{
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) return; 
	
//    hidden = YES;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		
		[[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
		
	} else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 30200
		[[UIApplication sharedApplication] setStatusBarHidden:hidden animated:animated];
#endif
	}

}

- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated{
    
    hidden = NO;
    
	if (hidden&&_barsHidden) return;
	
	if (_popover && [self.photoSource numberOfPhotos] == 0) {
		[_captionView setCaptionHidden:hidden];
		return;
	}
		
	[self setStatusBarHidden:hidden animated:animated];
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
		if (!_popover) {
			
			if (animated) {
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.3f];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			}
			
			self.navigationController.navigationBar.alpha = hidden ? 0.0f : 1.0f;
			self.navigationController.toolbar.alpha = hidden ? 0.0f : 1.0f;
			
			if (animated) {
				[UIView commitAnimations];
			}
			
		} 
		
	} else {
		
		[self.navigationController setNavigationBarHidden:hidden animated:animated];
		[self.navigationController setToolbarHidden:hidden animated:animated];
		
	}
#else
	
	[self.navigationController setNavigationBarHidden:hidden animated:animated];
	[self.navigationController setToolbarHidden:hidden animated:animated];
	
#endif
	
	if (_captionView) {
		[_captionView setCaptionHidden:hidden];
	}
	
	_barsHidden=hidden;
	
}

- (void)toggleBarsNotification:(NSNotification*)notification{
	[self setBarsHidden:!_barsHidden animated:YES];
}


#pragma mark -
#pragma mark FullScreen Methods

- (void)setupViewForPopover{
	
	if (!_popoverOverlay && _popover && [self.photoSource numberOfPhotos] == 1) {
				
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height, self.view.frame.size.width, 40.0f)];
		view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
		_popoverOverlay = view;
		[self.view addSubview:view];
		[view release];
		
		UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _popoverOverlay.frame.size.width, 1.0f)];
		borderView.autoresizingMask = view.autoresizingMask;
		[_popoverOverlay addSubview:borderView];
		[borderView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.4f]];
		[borderView release];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:@"egopv_fullscreen_button.png"] forState:UIControlStateNormal];
		button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[button addTarget:self action:@selector(toggleFullScreen:) forControlEvents:UIControlEventTouchUpInside];
		button.frame = CGRectMake(view.frame.size.width - 40.0f, 0.0f, 40.0f, 40.0f);
		[view addSubview:button];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		view.frame = CGRectMake(0.0f, self.view.bounds.size.height - 40.0f, self.view.bounds.size.width, 40.0f);
		[UIView commitAnimations];
		
	}
	
}

- (CATransform3D)transformForCurrentOrientation{
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	switch (orientation) {
		case UIInterfaceOrientationPortraitUpsideDown:
			return CATransform3DMakeRotation((M_PI/180)*180, 0.0f, 0.0f, 1.0f);
			break;
		case UIInterfaceOrientationLandscapeRight:
			return CATransform3DMakeRotation((M_PI/180)*90, 0.0f, 0.0f, 1.0f);
			break;
		case UIInterfaceOrientationLandscapeLeft:
			return CATransform3DMakeRotation((M_PI/180)*-90, 0.0f, 0.0f, 1.0f);
			break;
		default:
			return CATransform3DIdentity;
			break;
	}
	
}

- (void)toggleFullScreen:(id)sender{
	
	_fullScreen = !_fullScreen;
	
	if (!_fullScreen) {
		
		NSInteger pageIndex = 0;
		if (self.modalViewController && [self.modalViewController isKindOfClass:[UINavigationController class]]) {
			UIViewController *controller = [((UINavigationController*)self.modalViewController) visibleViewController];
			if ([controller isKindOfClass:[self class]]) {
				pageIndex = [(EGOPhotoViewController*)controller currentPhotoIndex];
			}
		}		
		[self moveToPhotoAtIndex:pageIndex animated:NO];
		[self.navigationController dismissModalViewControllerAnimated:NO];
		
	}
	
	EGOPhotoImageView *_currentView = [self.photoViews objectAtIndex:_pageIndex];
	BOOL enabled = [UIView areAnimationsEnabled];
	[UIView setAnimationsEnabled:NO];
	[_currentView killScrollViewZoom];
	[UIView setAnimationsEnabled:enabled];
	UIImageView *_currentImage = _currentView.imageView;
	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	backgroundView.layer.transform = [self transformForCurrentOrientation];
	[keyWindow addSubview:backgroundView];
	backgroundView.frame = [[UIScreen mainScreen] applicationFrame];
	_transferView = backgroundView;
	[backgroundView release];
	
	CGRect newRect = [self.view convertRect:_currentView.scrollView.frame toView:_transferView];
	UIImageView *_imageView = [[UIImageView alloc] initWithFrame:_fullScreen ? newRect : _transferView.bounds];	
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	[_imageView setImage:_currentImage.image];
	[_transferView addSubview:_imageView];
	[_imageView release];
	
	self.scrollView.hidden = YES;
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
	animation.fromValue = _fullScreen ? (id)[UIColor clearColor].CGColor : (id)[UIColor blackColor].CGColor;
	animation.toValue = _fullScreen ? (id)[UIColor blackColor].CGColor : (id)[UIColor clearColor].CGColor;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	animation.duration = 0.4f;
	[_transferView.layer addAnimation:animation forKey:@"FadeAnimation"];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fullScreenAnimationDidStop:finished:context:)];
	_imageView.frame = _fullScreen ? _transferView.bounds : newRect;
	[UIView commitAnimations];
	
}

- (void)fullScreenAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	
	if (finished) {
		
		self.scrollView.hidden = NO;
		
		if (_transferView) {
			[_transferView removeFromSuperview];
			_transferView=nil;
		}
		
		if (_fullScreen) {
			
			BOOL enabled = [UIView areAnimationsEnabled];
			[UIView setAnimationsEnabled:NO];
			
			EGOPhotoViewController *controller = [[EGOPhotoViewController alloc] initWithPhotoSource:self.photoSource];
			controller._fromPopover = YES;
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
			
			navController.modalPresentationStyle = UIModalPresentationFullScreen;
			[self.navigationController presentModalViewController:navController animated:NO];
			[controller moveToPhotoAtIndex:_pageIndex animated:NO];
			
			[navController release];
			[controller release];
			
			[UIView setAnimationsEnabled:enabled];
			
			UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"egopv_minimize_fullscreen_button.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleFullScreen:)];
			controller.navigationItem.rightBarButtonItem = button;
			[button release];
			
		}
		
	}
	
}



#pragma mark -
#pragma mark Photo View Methods

- (void)photoViewDidFinishLoading:(NSNotification*)notification{
	if (notification == nil) return;
	
	if ([[[notification object] objectForKey:@"photo"] isEqual:[self.photoSource photoAtIndex:[self centerPhotoIndex]]]) {
		if ([[[notification object] objectForKey:@"failed"] boolValue]) {
			if (_barsHidden) {
				//  image failed loading
				[self setBarsHidden:NO animated:YES];
			}
		} 
		[self setViewState];
	}
}

- (NSInteger)centerPhotoIndex{
	
	CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat x = self.scrollView.contentOffset.x;
	return floor((x - pageWidth / 2) / pageWidth) + 1;
	
}

- (void)moveForward:(id)sender{
	[self moveToPhotoAtIndex:[self centerPhotoIndex]+1 animated:NO];	
}

- (void)moveBack:(id)sender{
	[self moveToPhotoAtIndex:[self centerPhotoIndex]-1 animated:NO];
}

- (void)setViewState {	
	
	if (_leftButton) {
		_leftButton.enabled = !(_pageIndex-1 < 0);
	}
	
	if (_rightButton) {
		_rightButton.enabled = !(_pageIndex+1 >= [self.photoSource numberOfPhotos]);
	}
	
	if (_actionButton) {
		EGOPhotoImageView *imageView = [_photoViews objectAtIndex:[self centerPhotoIndex]];
		if ((NSNull*)imageView != [NSNull null]) {
			
			_actionButton.enabled = self.trashAction.enabled = ![imageView isLoading];
             ;
			
		} else {
			
			_actionButton.enabled = self.trashAction.enabled =NO;

		}
	}
	
	if ([self.photoSource numberOfPhotos] > 1) {
		self.title = [NSString stringWithFormat:@"%li of %li", _pageIndex+1, (long)[self.photoSource numberOfPhotos]];
	} else {
		self.title = @"";
	}
	
	if (_captionView) {
		[_captionView setCaptionText:[[self.photoSource photoAtIndex:_pageIndex] caption] hidden:YES];
	}
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
			
	if([self respondsToSelector:@selector(setContentSizeForViewInPopover:)] && [self.photoSource numberOfPhotos] == 1) {
		
		EGOPhotoImageView *imageView = [_photoViews objectAtIndex:[self centerPhotoIndex]];
		if ((NSNull*)imageView != [NSNull null]) {
			self.contentSizeForViewInPopover = [imageView sizeForPopover];
		}
		
	}
	
#endif
	
}

- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated {
	
    NSAssert(index < [self.photoSource numberOfPhotos] && index >= 0, @"Photo index passed out of bounds");
	if(index > [self.photoSource numberOfPhotos] || index < 0)
    {
        return;
    }
    
	_pageIndex = index;
	[self setViewState];

	[self enqueuePhotoViewAtIndex:index];
	
    
//    [self customloadScrollViewWithPage:index-1];
	[self customloadScrollViewWithPage:index];
//	[self customloadScrollViewWithPage:index+1];
	
	
	[self.scrollView scrollRectToVisible:((EGOPhotoImageView*)[self.photoViews objectAtIndex:index]).frame animated:animated];
	
	if ([[self.photoSource photoAtIndex:_pageIndex] didFail]) {
		[self setBarsHidden:NO animated:YES];
	}
	
	//  reset any zoomed side views
    
    if (index + 1 < [self.photoViews count]) {
     
        if (index + 1 < [self.photoSource numberOfPhotos] && (NSNull*)[self.photoViews objectAtIndex:index+1] != [NSNull null])
        {
            [((EGOPhotoImageView*)[self.photoViews objectAtIndex:index+1]) killScrollViewZoom];
        }
    }
    

    
	if (index - 1 >= 0 && (NSNull*)[self.photoViews objectAtIndex:index-1] != [NSNull null]) {
		[((EGOPhotoImageView*)[self.photoViews objectAtIndex:index-1]) killScrollViewZoom];
	} 	
	
}

- (void)layoutScrollViewSubviews{
	
	NSInteger _index = [self currentPhotoIndex];
	
	for (NSInteger page = _index -1; page < _index+2; page++) {
		
		if (page >= 0 && page < [self.photoSource numberOfPhotos]){
			
			CGFloat originX = self.scrollView.bounds.size.width * page;
			
			if (page < _index) {
				originX -= EGOPV_IMAGE_GAP;
			} 
			if (page > _index) {
				originX += EGOPV_IMAGE_GAP;
			}
			
            if ([self.photoViews count] < [self.photoSource numberOfPhotos] ) {
                
                for (unsigned i = 0; i < [self.photoSource numberOfPhotos] - [self.photoViews count]; i++) {
                    [self.photoViews addObject:[NSNull null]];
                }
                
                [self setupScrollViewContentSize];
            }
            
			if ([self.photoViews objectAtIndex:page] == [NSNull null] || !((UIView*)[self.photoViews objectAtIndex:page]).superview){
                
				[self customloadScrollViewWithPage:page];
			}
			
			EGOPhotoImageView *_photoView = (EGOPhotoImageView*)[self.photoViews objectAtIndex:page];
			CGRect newframe = CGRectMake(originX, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
			
			if (!CGRectEqualToRect(_photoView.frame, newframe)) {	
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.1];
				_photoView.frame = newframe;
				[UIView commitAnimations];
			
			}
			
		}
	}
	
}

- (void)setupScrollViewContentSize{
	
	CGFloat toolbarSize = _popover ? 0.0f : self.navigationController.toolbar.frame.size.height;	
	
	CGSize contentSize = self.view.bounds.size;
	contentSize.width = (contentSize.width * [self.photoSource numberOfPhotos]);
	
	if (!CGSizeEqualToSize(contentSize, self.scrollView.contentSize)) {
		self.scrollView.contentSize = contentSize;
	}
	
	_captionView.frame = CGRectMake(0.0f, self.view.bounds.size.height - (toolbarSize + 40.0f), self.view.bounds.size.width, 40.0f);

}

- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex{
	
	NSInteger count = 0;
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			if (count > theIndex+1 || count < theIndex-1) {
				[view prepareForReusue];
				[view removeFromSuperview];
			} else {
				view.tag = 0;
			}
			
		} 
		count++;
	}	
	
}

- (EGOPhotoImageView*)dequeuePhotoView{
	
	NSInteger count = 0;
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			if (view.superview == nil) {
				view.tag = count;
				return view;
			}
		}
		count ++;
	}	
	return nil;
	
}

- (void)customloadScrollViewWithPage:(NSInteger)page{
    
    if (page == [self.photoSource numberOfPhotos] - 1 && self.albumsType == PhotoBrowseTypeAlertPhoto ) {
        
        if (!_requestDataing) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationDownAlertImage object:nil];
            DebugLog(@"KNotificationDownAlertImage page = %d",page);
            _requestDataing = YES;
        }
    }
    else
    {
        _requestDataing = NO;
    }
    
    
    if (page < 0) return;
    if (page >= [self.photoSource numberOfPhotos]) return;
    
	EGOPhotoImageView * photoView = [self.photoViews objectAtIndex:page];
    
    BOOL flag = NO;
    id <EGOPhoto> aPhoto = [self.photoSource photoAtIndex:page];

    
    if ((NSNull*)photoView != [NSNull null] && [aPhoto image]) {
        
        [photoView setPhoto:[self.photoSource photoAtIndex:page]];

        flag = YES;
    }

    
	if ((NSNull*)photoView == [NSNull null]) {
		
		photoView = [self dequeuePhotoView];
		if (photoView != nil) {
			[self.photoViews exchangeObjectAtIndex:photoView.tag withObjectAtIndex:page];
			photoView = [self.photoViews objectAtIndex:page];
		}
	}
	
	if (photoView == nil || (NSNull*)photoView == [NSNull null]) {
		
		photoView = [[EGOPhotoImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
		[self.photoViews replaceObjectAtIndex:page withObject:photoView];
		[photoView release];
		
	}
    
    MyPhoto * photoData = (MyPhoto *)aPhoto;
    
    if (photoData.proxyName) {
        
        NSString * imagePath = [[MYDataManager shareManager].haveDownloadImageFile objectForKey:photoData.proxyName];
        if (imagePath) {
            
            photoData.URL = [NSURL fileURLWithPath:imagePath];
        }
    }
    
    if(aPhoto.proxyName && [aPhoto.proxyName length] > 0 && !flag && ![photoData.URL isFileURL])
    {
        [[MYDataManager shareManager].imageUrlEngine sendAlertPictureRequest:[MYDataManager shareManager].currentCameraData fileName:[aPhoto proxyName] delegate:self];
        [self.currentPageDict setObject:[NSNumber numberWithInt:page] forKey:[aPhoto proxyName]];
        DebugLog(@"aPhoto.proxyName %@",aPhoto.proxyName);
    }
    else
    {
        [photoView setPhoto:[self.photoSource photoAtIndex:page]];
    }
		
    if (photoView.superview == nil) {
        
		[self.scrollView addSubview:photoView];
	}
	
	CGRect frame = self.scrollView.frame;
	NSInteger centerPageIndex = _pageIndex;
	CGFloat xOrigin = (frame.size.width * page);
	if (page > centerPageIndex) {
		xOrigin = (frame.size.width * page) + EGOPV_IMAGE_GAP;
	} else if (page < centerPageIndex) {
		xOrigin = (frame.size.width * page) - EGOPV_IMAGE_GAP;
	}
	
	frame.origin.x = xOrigin;
	frame.origin.y = 0;
	photoView.frame = frame;
    
    
    if (photoData.cellData.flagRecord == 0) {
        
        [self.navigationItem setRightBarButtonItem:nil];
    }
    else
    {
        UIBarButtonItem * finishButton = [ViewToolClass customBarButtonItem:@"视频观看.png"
                                                          buttonSelectImage:@"视频观看1.png"
                                                                      title:nil
                                                                       size:CGSizeMake(65, 32)
                                                                     target:self
                                                                     action:@selector(goToWatchVideo)];
        
        self.navigationItem.rightBarButtonItem = finishButton;
    }
    
    
    if (self.albumsType == PhotoBrowseTypeAlertPhoto && page == self.currentPhotoIndex ) {
        
        if (photoData.cellData.alertType == AlertTypeMotion) {
            
            self.alertTypeImageView.image = [UIImage imageNamed:@"移动帧测.png"];
            DebugLog(@"移动帧测");
        }
        
        if (photoData.cellData.alertType == AlertTypeNoise) {
            
            self.alertTypeImageView.image = [UIImage imageNamed:@"躁声报警.png"];
            DebugLog(@"躁声报警");
        }
        
        
        if (photoData.cellData.alertType == AlertTypeManual) {
            
            self.alertTypeImageView.image = [UIImage imageNamed:@"手动拍照.png"];
            DebugLog(@"手动拍照");
        }
        
        if (photoData.cellData.alertType == AlertTypeThermalInfrared) {
            
            self.alertTypeImageView.image = [UIImage imageNamed:@"红外报警.png"];
            DebugLog(@"红外报警");
        }
    }

}


- (void)alertImageOrRecordUrl:(NSString *)url type:(NSInteger)type{
    
    
    NSInteger page = [[self.currentPageDict objectForKey:[[url pathComponents] lastObject]] intValue];
    id <EGOPhoto> aPhoto = [self.photoSource photoAtIndex:page];
    aPhoto.URL = [NSURL URLWithString:url];
    
//    [self loadScrollViewWithPage:page];
    
    EGOPhotoImageView * photoView = [self.photoViews objectAtIndex:page];
    if ((NSNull*)photoView != [NSNull null]) {
        
            [photoView setPhoto:aPhoto];
    }
    
}

- (void)loadScrollViewWithPage:(NSInteger)page {
	
    if (page < 0) return;
    if (page >= [self.photoSource numberOfPhotos]) return;
	
	EGOPhotoImageView * photoView = [self.photoViews objectAtIndex:page];
	if ((NSNull*)photoView == [NSNull null]) {
		
		photoView = [self dequeuePhotoView];
		if (photoView != nil) {
			[self.photoViews exchangeObjectAtIndex:photoView.tag withObjectAtIndex:page];
			photoView = [self.photoViews objectAtIndex:page];
		}
		
	}
	
	if (photoView == nil || (NSNull*)photoView == [NSNull null]) {
		
		photoView = [[EGOPhotoImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
		[self.photoViews replaceObjectAtIndex:page withObject:photoView];
		[photoView release];
		
	} 
	
	[photoView setPhoto:[self.photoSource photoAtIndex:page]];
	
    if (photoView.superview == nil) {
		[self.scrollView addSubview:photoView];
	}
	
	CGRect frame = self.scrollView.frame;
	NSInteger centerPageIndex = _pageIndex;
	CGFloat xOrigin = (frame.size.width * page);
	if (page > centerPageIndex) {
		xOrigin = (frame.size.width * page) + EGOPV_IMAGE_GAP;
	} else if (page < centerPageIndex) {
		xOrigin = (frame.size.width * page) - EGOPV_IMAGE_GAP;
	}
	
	frame.origin.x = xOrigin;
	frame.origin.y = 0;
	photoView.frame = frame;
}


#pragma mark -
#pragma mark UIScrollView Delegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	NSInteger _index = [self centerPhotoIndex];
	if (_index >= [self.photoSource numberOfPhotos] || _index < 0) {
		return;
	}
	
	if (_pageIndex != _index && !_rotating) {

        if (!self.flagIsdeleteing) {
            [self setBarsHidden:YES animated:YES];
        }
        
        self.flagIsdeleteing = NO;
        
		_pageIndex = _index;
		[self setViewState];
		
		if (![scrollView isTracking]) {
			[self layoutScrollViewSubviews];
		}
		
	}
    
    if (_pageIndex == _index && !_rotating) {
        
        _actionButton.enabled = _trashAction.enabled =YES;
    }
		
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
	NSInteger _index = [self centerPhotoIndex];
	if (_index >= [self.photoSource numberOfPhotos] || _index < 0) {
		return;
	}
	
	[self moveToPhotoAtIndex:_index animated:YES];

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	[self layoutScrollViewSubviews];
}


#pragma mark -
#pragma mark Actions

- (void)doneSavingImage{
	DebugLog(@"done saving image");
}

- (void)savePhotoToFacebook{
	
//	UIImageWriteToSavedPhotosAlbum(((EGOPhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image, nil, nil, nil);

}

- (void)savePhotoToTwitter{
    
    
    
}

- (void)deletePhoto
{

    //	[[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation(((EGOPhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image) forPasteboardType:@"public.png"];
	
}

- (void)emailPhoto{
	
	MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
	[mailViewController setSubject:@"Shared Photo"];
	[mailViewController addAttachmentData:[NSData dataWithData:UIImagePNGRepresentation(((EGOPhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image)] mimeType:@"image/png" fileName:@"Photo.png"];
	mailViewController.mailComposeDelegate = self;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		mailViewController.modalPresentationStyle = UIModalPresentationPageSheet;
	}
#endif
	
	[self presentModalViewController:mailViewController animated:YES];
	[mailViewController release];
	
}

- (void)saveToPhotos{
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
	[self dismissModalViewControllerAnimated:YES];
	
	NSString *mailError = nil;
	
	switch (result) {
		case MFMailComposeResultSent: ; break;
		case MFMailComposeResultFailed: mailError = @"Failed sending media, please try again...";
			break;
		default:
			break;
	}
	
	if (mailError != nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:mailError delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}


#pragma mark -
#pragma mark UIActionSheet Methods

- (void)trashImageAction:(id)sender{
    
    [self deletePhoto];
    
}

- (void)actionButtonHit:(id)sender{
	
	UIActionSheet *actionSheet;
	
    if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
        
        
        if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !_popover) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Save to Photos", nil),nil];
            } else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Save to Photos", nil), nil];
            }
#else
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Save to Photos", nil), nil];
#endif
        }
        else
        {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !_popover) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Share by Facebook", @"Share by Twitter", nil];
            } else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Share by Facebook", @"Share by Twitter", nil];//NSLocalizedString(@"Save to Photos", nil),
            }
#else
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Share by Facebook",@"Share by Twitter", nil];
#endif
        }
        

    }
    else
    {
        if ([MFMailComposeViewController canSendMail]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !_popover) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Share by Facebook", @"Share by Twitter", @"Email", nil];//@"Email",
            } else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Share by Facebook", @"Share by Twitter",  @"Email",nil];//@"Email",
            }
#else
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Share by Facebook", @"Share by Twitter", @"Email", nil];//@"Email",
#endif
            
        } else {
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !_popover) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Share by Facebook", @"Share by Twitter",nil];
            } else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Share by Facebook", @"Share by Twitter", nil];
            }
#else
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Share by Facebook",@"Share by Twitter", nil];
#endif
            
        }
    }
    
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.delegate = self;
	
	[actionSheet showInView:self.view];
	[self setBarsHidden:YES animated:YES];
	
	[actionSheet release];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	[self setBarsHidden:NO animated:YES];
	

    
    if ([AppDelegate getAppDelegate].apModelOrCloudModel) {
        
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
                
                [self saveToPhotos];
            }
            else
            {
                [self saveToPhotos];
            }
        } 
    }
    else
    {
        
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            [self savePhotoToFacebook];//save to facebook
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
            [self savePhotoToTwitter];// delete
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 2) {
            
            if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
                
                [self saveToPhotos];
            }
            else
            {
                [self saveToPhotos];
            }
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 3) {
            //      [self emailPhoto];// email
        }
    }
}


#pragma mark -
#pragma mark Memory

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
	
	self.photoViews=nil;
	self.scrollView=nil;
	_captionView=nil;
    [MYDataManager shareManager].imageUrlEngine.delegate = nil;
	
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    self.currentPageDict = nil;
    self.alertTypeImageView = nil;

	_captionView=nil;
	[_photoViews release], _photoViews=nil;
	[_photoSource release], _photoSource=nil;
	[_scrollView release], _scrollView=nil;
	[_oldToolBarTintColor release], _oldToolBarTintColor = nil;
	[_oldNavBarTintColor release], _oldNavBarTintColor = nil;
    
    self.trashAction = nil;
    self.actionButton = nil;
	
    [super dealloc];
}


@end
