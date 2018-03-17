//
//  ImageBrowserViewController.m
//  Myanycam
//
//  Created by myanycam on 13-4-27.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "ImageBrowserViewController.h"
#import "VideoPlayerViewController.h"
#import "MYDataManager.h"

@interface ImageBrowserViewController ()

@end

@implementation ImageBrowserViewController
@synthesize currentIndex;
@synthesize currentCellData;
@synthesize cameraInfo;
@synthesize alaSsetsLibrary;
@synthesize deleteImageDelegate = _deleteImageDelegate;

- (void)dealloc {

    self.currentCellData = nil;
    self.cameraInfo = nil;
    self.alaSsetsLibrary = nil;
    self.deleteImageDelegate = nil;
    [MYDataManager shareManager].imageUrlEngine.delegate = nil;
    
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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isShowBottomBar = NO;
    
    ALAssetsLibrary * ala = [[ALAssetsLibrary alloc] init];
    self.alaSsetsLibrary = ala;
    [ala release];
    
    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"", nil) size:CGSizeMake(32, 32) target:self action:@selector(goBackAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UIImage * bg = [[UIImage imageNamed:@"bottomBar.png"] resizableImage];
    UIImage * topbg = [[UIImage imageNamed:@"topBar.png"] resizableImage];
    [self.navigationController.navigationBar setBackgroundImage:topbg forBarMetrics:UIBarMetricsDefault];

    [self.navigationController.toolbar setBackgroundImage:bg
                                       forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

    
    self.pageIndex = self.currentIndex;
    
    if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
        
        UIBarButtonItem * finishButton = [ViewToolClass customBarButtonItem:@"视频观看.png"
                                                          buttonSelectImage:@"视频观看1.png"
                                                                      title:nil
                                                                       size:CGSizeMake(65, 32)
                                                                     target:self
                                                                     action:@selector(goToWatchVideo)];
        
        self.navigationItem.rightBarButtonItem = finishButton;
    }
    
}

- (void)goToWatchVideo{
    
     MyPhoto * photo = [self.photoSource photoAtIndex:self.pageIndex];
    
    [self goToWatchVideoWithCameraInfo:self.cameraInfo EventCellData:[photo cellData]];
}

- (void)goToWatchVideoWithCameraInfo:(CameraInfoData *)acameraInfo EventCellData:(EventAlertTableViewCellData *)data{
    
    VideoPlayerViewController * controller = [[VideoPlayerViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.cellData = data;
    controller.cameraInfo = acameraInfo;
    [self customPresentModalViewController:controller animated:NO];
    [controller release];
}

- (void)deleteViewAtIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (index>= 0 && index < [self.photoSource numberOfPhotos]) {
        
        [self.photoSource deleteObjectAtIndex:index];

        [self.photoViews removeObjectAtIndex:index];
        
        
        
        if (self.pageIndex > [self.photoSource numberOfPhotos]) {
            
            self.pageIndex = [self.photoSource numberOfPhotos] - 1;
        }
        
        if (self.pageIndex != 0) {
            
            self.flagIsdeleteing = YES;
            
            [self setupScrollViewContentSize];
            
            [self moveToPhotoAtIndex:self.pageIndex animated:NO];
        }
        else{
            
            [self goBackAction:nil];
        }
                
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [super viewDidUnload];
}

- (void)savePhotoToFacebook{
    
	
    id photo = [self.photoSource photoAtIndex:self.currentPhotoIndex];
    if ([photo isKindOfClass:[MyPhoto class]]) {
        
        MyPhoto * photoImage = (MyPhoto *)photo;
        
        UIImage * image = [UIImage imageWithContentsOfFile:photoImage.imagePath];
        if (!image) {
            image = photoImage.image;
        }
        
        if ([photoImage.URL isFileURL]) {
            
            image = [UIImage imageWithContentsOfFile:[photoImage.URL path]];
        }

        if (image) {
            
//            [self shareIphoneWithShareSdk:KSharebyMyanycam image:image title:KAppName shareUrl:@"" viewController:self shareMediaType:SSPublishContentMediaTypeImage];
            
            if ([MYDataManager shareManager].deviceTpye == DeviceTypeIpad1) {
                
                [self shareWithShareSdk:KSharebyMyanycam image:image title:KAppName shareUrl:@"" view:self.actionButton arrowDirect:UIPopoverArrowDirectionDown shareMediaType:SSPublishContentMediaTypeImage];
            }
            else
            {
                [self shareIphoneWithShareSdk:KSharebyMyanycam image:image title:KAppName shareUrl:@"" viewController:self shareMediaType:SSPublishContentMediaTypeImage];
            }

        }
        
    }
}

- (void)saveToPhotos{
    
    [self ShowWaitAlertView:@"Saving..."];
    
    @autoreleasepool {
        
        id photo = [self.photoSource photoAtIndex:self.currentPhotoIndex];
        UIImage * image = nil;
        
        if ([photo isKindOfClass:[MyPhoto class]]) {
            
            MyPhoto * photoImage = (MyPhoto *)photo;
            image = [UIImage imageWithContentsOfFile:photoImage.imagePath];
            if (!image) {
                
                if (!image) {
                    
                    image = photoImage.image;
                }
                
                if ([photoImage.URL isFileURL]) {
                    
                    image = [UIImage imageWithContentsOfFile:[photoImage.URL path]];
                }
   
            }
            
        }
        
        if (image) {
            
            NSData * imageData = UIImagePNGRepresentation(image);
            if (!imageData) {
                imageData = UIImageJPEGRepresentation(image, 1);
            }
            if (imageData) {
                
                ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
                    
                    NSString *errorMessage = @"User denied access albums";
                    switch ([error code]) {
                        case ALAssetsLibraryAccessUserDeniedError:
                        case ALAssetsLibraryAccessGloballyDeniedError:
                            errorMessage = @"User denied access albums";
                            break;
                        default:
                            errorMessage = @"Reason unknown.";
                            break;
                    }
                    
                    DebugLog(@"errorMessage %@",errorMessage);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                         [self showAlertView:NSLocalizedString(@"", nil) alertMsg:NSLocalizedString(@"User denied access albums. Settings> Location Services. Set Myanycam App is On", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                        
                    });
                };
                
                
                NSDate *shootTime = [NSDate date];
                NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
                [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
                NSString *strDate = [dateFormatter stringFromDate:shootTime];//kCGImagePropertyTIFFDateTime
                NSDictionary *metaDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:KIMAGEMODELNAME,(NSString *)kCGImagePropertyTIFFSoftware,KIMAGEMODELNAME,(NSString *)kCGImagePropertyTIFFArtist, strDate,(NSString *)kCGImagePropertyTIFFDateTime,KIMAGEMODELNAME,kCGImagePropertyTIFFMake,nil],(NSString *)kCGImagePropertyTIFFDictionary,nil];
                
                [self.alaSsetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metaDic completionBlock:^(NSURL *assetURL, NSError *error)
                {
                    
                    NSLog(@"save image:%@",assetURL);
                    
                    [self.alaSsetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                        
                        NSString* groupname = [group valueForProperty:ALAssetsGroupPropertyName];
                        NSLog(@"groupname %@",groupname);
                        if ([groupname isEqualToString:KIMAGEMODELNAME]) {
                            
//                            stop = false;
                            
                            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                            [self.alaSsetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                
                                [group addAsset:asset];
                                int count  = [group numberOfAssets];
                                NSLog(@"count:%d",count);
                                
                                [[MYDataManager shareManager] addTakePhotoImage:[assetURL absoluteString]];

                                
                            } failureBlock:^(NSError *error) {
                                
                                [self showAlertView:NSLocalizedString(@"", nil) alertMsg:NSLocalizedString(@"User denied access albums. Settings> Location Services. Set Myanycam App is On", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                                
                            }];
                        }
                        
                        
                    } failureBlock:failureBlock];
                                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self hideWaitAlertView];
                        [self savePhotoSuccess:assetURL error:error];
                    });
                }];
            }
        }
    }    
}

- (void)cancelTwitterLogin{
    
    [self hideWaitAlertView];
}

//- (void)savePhotoToTwitter{
//    
//    if ([ToolClass systemVersionFloat] < 6.0) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"iOS version is at least  6.0", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//        });
//        
//        return;
//    }
//    
//    [self ShowWaitAlertView:NSLocalizedString(@"Sharing...", nil)];
//    id photo = [self.photoSource photoAtIndex:self.currentPhotoIndex];
//    
//    if ([photo isKindOfClass:[MyPhoto class]]) {
//        
//        MyPhoto * photoImage = (MyPhoto *)photo;
//        UIImage * image = [UIImage imageWithContentsOfFile:photoImage.imagePath];
//        if (!image) {
//            image = photoImage.image;
//        }
//        
//        if ([photoImage.URL isFileURL]) {
//            
//            image = [UIImage imageWithContentsOfFile:[photoImage.URL path]];
//        }
//
//        
//        AppDelegate * delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        CustomWindow * window = delegate.window;
//        
//        if (![window.myTwitterManager postImageToTwitter:image delegate:self]) {
//            
//            if ([TWAPIManager isLocalTwitterAccountAvailable]) {
//                
//                if (window.myTwitterManager.flagTwitterCanLogin == 0) {
//                    
//                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTwitterLogin) name:kNotificationChooseTwitterAccountCancel object:nil];
//                    [window  twitterPerformReverseAuth:nil];
//                }
//                else{
//                    
//                    if (window.myTwitterManager.flagTwitterCanLogin == 1) {
//                        
//                        [self hideWaitAlertView];
//                        [self  showTwitterSettings];
//                    }
//                    
//                    if (window.myTwitterManager.flagTwitterCanLogin == 2) {
//                        
//                        [self hideWaitAlertView];
//                        
//                        UIAlertView *alertViewTwitter = [[[UIAlertView alloc]
//                                                          initWithTitle:NSLocalizedString(@"Twitter account is Disabled", nil)
//                                                          message:@"Please enable it for Myanycam: Settings > Twitter , and Switch Myanycam is On"
//                                                          delegate:nil
//                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                                                          otherButtonTitles:nil, nil]
//                                                         autorelease];
//                        
//                        [alertViewTwitter show];
//                    }
//                    
//                }
//                
//            }
//            else
//            {
//                [self hideWaitAlertView];
//                [self showTwitterSettings];
//            }
//            
//        }
//        
//    }
//}

- (void)postPhotoToFaceBookSuccess{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self hideWaitAlertView];
        
        [self showAlertView:NSLocalizedString(@"Share Success", nil) alertMsg:nil userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    });
}

- (void)deletePhoto{
    
    id photo = [self.photoSource photoAtIndex:self.currentPhotoIndex];
    
    if ([photo isKindOfClass:[MyPhoto class]]) {
        
        MyPhoto * photo1 = (MyPhoto *)photo;
        
        switch (self.albumsType) {
            case PhotoBrowseTypeAlertPhoto:
            {
                [[AppDelegate getAppDelegate].mygcdSocketEngine sendDeletePictureFromCamera:self.cameraInfo fileName:photo1.caption];
            }
                break;
            case PhotoBrowseTypeTakePhoto:
            {
                [[MYDataManager shareManager] deleteImageFromFileWithIndex:self.currentPhotoIndex];
                
                if (self.deleteImageDelegate) {
                    [self.deleteImageDelegate deleteImageWithIndex:self.currentPhotoIndex];
                }
            }
            default:
                break;
        }
        
        
        [self deleteViewAtIndex:self.currentPhotoIndex animated:NO];
        

    }
}

- (void)twitterPostImage:(NSInteger)error{
    
    if (error == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideWaitAlertView];
            
            [self showAlertView:NSLocalizedString(@"Share Success", nil) alertMsg:nil userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        });
    }
}

- (void)goBackAction:(id)sender {
    
    [self customDismissModalViewControllerAnimated:YES];
}

- (void)watchVideo:(id)sender{
    
}

- (void)savePhotoSuccess:(NSURL *)assetURL error:(NSError *)error{
    
    if(!error){
        
        DebugLog(@"Photo saved to library!");
        
            [self showAlertView:NSLocalizedString(@"Save Success", nil) alertMsg:nil userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    } else{
        
        DebugLog(@"Saving failed :(");
        
        [self showAlertView:NSLocalizedString(@"Save failed", nil) alertMsg:[error.userInfo objectForKey:@"NSLocalizedFailureReason"] userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    }
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
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Save to Photos", nil), nil];
#endif
            
        }
        else
        {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !_popover) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share", nil), NSLocalizedString(@"Save to Photos", nil),nil];
            } else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share", nil), NSLocalizedString(@"Save to Photos", nil), nil];
            }
#else
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share", nil), NSLocalizedString(@"Save to Photos", nil), nil];
#endif
        }
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        actionSheet.delegate = self;
        
        [actionSheet showFromToolbar:self.navigationController.toolbar];
        //	[actionSheet showInView:self.view];
        
        [self setBarsHidden:YES animated:YES];
        
        [actionSheet release];
        
    }
    else
    {

            
        id photo = [self.photoSource photoAtIndex:self.currentPhotoIndex];
        if ([photo isKindOfClass:[MyPhoto class]]) {
            
            MyPhoto * photoImage = (MyPhoto *)photo;
            
            UIImage * image = [UIImage imageWithContentsOfFile:photoImage.imagePath];
            if (!image) {
                image = photoImage.image;
            }
            
            if ([photoImage.URL isFileURL]) {
                
                image = [UIImage imageWithContentsOfFile:[photoImage.URL path]];
            }
            
            if (image) {
//                
//            [self shareIphoneWithShareSdk:KSharebyMyanycam image:image title:KAppName shareUrl:@"" viewController:self shareMediaType:SSPublishContentMediaTypeImage];
                if ([MYDataManager shareManager].deviceTpye == DeviceTypeIpad1) {
                    
                    [self shareWithShareSdk:KSharebyMyanycam image:image title:KAppName shareUrl:@"" view:self.actionButton arrowDirect:UIPopoverArrowDirectionDown shareMediaType:SSPublishContentMediaTypeImage];
                }
                else
                {
                    [self shareIphoneWithShareSdk:KSharebyMyanycam image:image title:KAppName shareUrl:@"" viewController:self shareMediaType:SSPublishContentMediaTypeImage];
                }
                
            }
            
        }
    }
	

	
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
//                [self saveToPhotos];
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
            
            if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
                
                [self saveToPhotos];
            }
            else
            {
                // [self saveToPhotos];
            }
            
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 2) {
            
            if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
                
                [self saveToPhotos];
            }
            else
            {
//                [self saveToPhotos];
            }
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 3) {
            //      [self emailPhoto];// email
        }
    }
}


#pragma mark 重写父类函数
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
			
			_actionButton.enabled = _trashAction.enabled = ![imageView isLoading];
            
			
		} else {
			
			_actionButton.enabled = _trashAction.enabled =NO;
            
		}
	}
	
	if ([self.photoSource numberOfPhotos] > 1) {
        
        if (self.albumsType == PhotoBrowseTypeAlertPhoto) {
            
            AlertPictureListData * data = [[MYDataManager shareManager] getAlertEventListDataWithCameraID:self.cameraInfo.cameraId];
            self.title = [NSString stringWithFormat:@"%li of %li", _pageIndex+1, (long)data.total];//[self.photoSource numberOfPhotos]

        }
        else
        {
            self.title = [NSString stringWithFormat:@"%li of %li", _pageIndex+1, (long)[self.photoSource numberOfPhotos]];//

        }
        
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


@end
