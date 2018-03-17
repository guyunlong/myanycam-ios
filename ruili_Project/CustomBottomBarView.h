//
//  CustomBottomBarView.h
//  Myanycam
//
//  Created by myanycam on 13-3-14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNumberBadgeView.h"

@protocol CustomBottomBarViewDelegate ;


@interface CustomBottomBarView : UIView{
    
    id<CustomBottomBarViewDelegate> _delegate;
    NSInteger _currentIndex;
}

@property (assign, nonatomic) id<CustomBottomBarViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *bottomButton1;
@property (retain, nonatomic) IBOutlet UIButton *bottomButton2;
@property (retain, nonatomic) IBOutlet UIButton *bottomButton3;
@property (retain, nonatomic) IBOutlet UIButton *bottomButton4;

@property (retain, nonatomic) IBOutlet UILabel *cameraLabel;
@property (retain, nonatomic) IBOutlet UILabel *fileLabel;
@property (retain, nonatomic) IBOutlet UILabel *eventLabel;
@property (retain, nonatomic) IBOutlet UILabel *aboutLabel;
@property (retain, nonatomic) IBOutlet UIImageView *stateImageView1;
@property (retain, nonatomic) IBOutlet UIImageView *stateImageView2;
@property (retain, nonatomic) IBOutlet UIImageView *stateImageView3;
@property (retain, nonatomic) IBOutlet UIImageView *stateImageView4;
@property (retain, nonatomic) CameraInfoData * cameraData;

//@property (retain, nonatomic) IBOutlet UIImageView *eventStateImage;
@property (retain, nonatomic) IBOutlet MKNumberBadgeView *eventNumberView;


- (IBAction)bottomButton1Action:(id)sender;
- (IBAction)bottomButton2Action:(id)sender;
- (IBAction)bottomButton3Action:(id)sender;
- (IBAction)bottomButton4Action:(id)sender;

- (void)updateCustomView;

- (void)showEventStateImage;
- (void)hideEventStateImage;

- (void)setButtonHighlightWithIndex:(NSInteger)index;

@end

@protocol CustomBottomBarViewDelegate <NSObject>

- (void)customBottomBarViewDelegate:(CustomBottomBarView *)bottomBarView button:(UIButton *)button userInfo:(NSDictionary*)userInfo;

@end