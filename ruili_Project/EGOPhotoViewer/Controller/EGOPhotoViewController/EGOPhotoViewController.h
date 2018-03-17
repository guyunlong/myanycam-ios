//
//  EGOPhotoController.h
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

#import <MessageUI/MessageUI.h>
#import "BaseViewController.h"
#import "EGOPhotoSource.h"
#import "EGOPhotoGlobal.h"
#import "AlertImageUrlEngine.h"

@class EGOPhotoImageView, EGOPhotoCaptionView;
@interface EGOPhotoViewController : BaseViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate,AlertImageUrlEngineDelegate> {
    
    
    id _popover;
    NSMutableDictionary * _currentPageDict;
    UIImageView * _alertTypeImageView;
    UIBarButtonItem *_leftButton;
	UIBarButtonItem *_rightButton;
	UIBarButtonItem *_actionButton;
    UIBarButtonItem *_trashAction;
    
    NSInteger _pageIndex;
    NSMutableArray *_photoViews;
	EGOPhotoCaptionView *_captionView;

    
@private
	id <EGOPhotoSource> _photoSource;
	UIScrollView *_scrollView;
	
	BOOL _rotating;
	BOOL _barsHidden;
	

	
	BOOL _storedOldStyles;
	UIStatusBarStyle _oldStatusBarSyle;
	UIBarStyle _oldNavBarStyle;
	BOOL _oldNavBarTranslucent;
	UIColor* _oldNavBarTintColor;	
	UIBarStyle _oldToolBarStyle;
	BOOL _oldToolBarTranslucent;
	UIColor* _oldToolBarTintColor;	
	BOOL _oldToolBarHidden;

//	BOOL _autoresizedPopover;

	
	BOOL _fullScreen;
	BOOL _fromPopover;
	UIView *_popoverOverlay;
	UIView *_transferView;
    
    BOOL _flagIsdeleteing;
    BOOL _requestDataing;
    
    

}

- (id)initWithPhoto:(id<EGOPhoto>)aPhoto;

- (id)initWithImage:(UIImage*)anImage;
- (id)initWithImageURL:(NSURL*)anImageURL;

- (id)initWithPhotoSource:(id <EGOPhotoSource>)aPhotoSource;
- (id)initWithPopoverController:(id)aPopoverController photoSource:(id <EGOPhotoSource>)aPhotoSource;

@property(retain, nonatomic) UIImageView * alertTypeImageView;

@property(nonatomic,retain) NSMutableDictionary * currentPageDict;
@property(nonatomic,retain) id <EGOPhotoSource> photoSource;
@property(nonatomic,retain) NSMutableArray *photoViews;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,assign) BOOL _fromPopover;
@property(nonatomic,assign) NSInteger pageIndex;

@property(nonatomic,retain) UIBarButtonItem * trashAction;
@property(nonatomic,retain) UIBarButtonItem * actionButton;

@property(nonatomic,assign) BOOL flagIsdeleteing;
#pragma mark 2013-06-26 andida
@property (assign, nonatomic) PhotoBrowseType albumsType;


- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated;

- (NSInteger)centerPhotoIndex;


- (NSInteger)currentPhotoIndex;
- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated;

//------------------------
- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setupScrollViewContentSize;


@end