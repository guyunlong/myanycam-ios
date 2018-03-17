//
//  ShareAlertView.h
//  Myanycam
//
//  Created by myanycam on 13-5-8.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAlertView.h"

@protocol ShareAlertViewDelegate ;

@interface ShareAlertView : BaseAlertView
@property (retain, nonatomic) IBOutlet UILabel *alertTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *facebookButton;
@property (retain, nonatomic) IBOutlet UIButton *twitterButton;
@property (retain, nonatomic) IBOutlet UILabel *facebookAction;
@property (retain, nonatomic) IBOutlet UILabel *twitterAction;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *bigBackgroundImageView;
@property (retain, nonatomic) NSArray              *buttonArray;
@property (retain, nonatomic) IBOutlet UIView *centerBackView;

@property (nonatomic, assign) id<ShareAlertViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)shareFackbookAction:(id)sender;
- (IBAction)shareTwitterAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

- (void)prepareView;



@end


@protocol ShareAlertViewDelegate <NSObject>

- (void)cancelButtonClick:(ShareAlertView *)alertView;
- (void)customalertView:(ShareAlertView *)alertView buttonAtIndex:(int)buttonAtIndex;

@end