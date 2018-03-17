//
// UIScrollView+SVPullToRefresh.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>


@class SVPullToRefreshView;

@interface UIScrollView (SVPullToRefresh)

enum {
    SVPullToRefreshPositionTop = 0,
    SVPullToRefreshPositionBottom,
};

typedef NSUInteger SVPullToRefreshPosition;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(SVPullToRefreshPosition)position;
- (void)triggerPullToRefresh;

@property (nonatomic, assign) SVPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end


enum {
    SVPullToRefreshStateStopped = 0,
    SVPullToRefreshStateTriggered,
    SVPullToRefreshStateLoading,
    SVPullToRefreshStateAll = 10
};

typedef NSUInteger SVPullToRefreshState;

@interface SVPullToRefreshView : UIView

@property (nonatomic, retain) UIColor *arrowColor;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, retain, readonly) UILabel *subtitleLabel;
@property (nonatomic, assign, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, assign,readonly) SVPullToRefreshState state;
@property (nonatomic, assign,readonly) SVPullToRefreshPosition position;

- (void)setTitle:(NSString *)title forState:(SVPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(SVPullToRefreshState)state;
- (void)setCustomView:(UIView *)view forState:(SVPullToRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;

// deprecated; use setSubtitle:forState: instead
@property (nonatomic, retain) UILabel *dateLabel DEPRECATED_ATTRIBUTE;
@property (nonatomic, retain) NSDate *lastUpdatedDate DEPRECATED_ATTRIBUTE;
@property (nonatomic, retain) NSDateFormatter *dateFormatter DEPRECATED_ATTRIBUTE;

// deprecated; use [self.scrollView triggerPullToRefresh] instead
- (void)triggerRefresh DEPRECATED_ATTRIBUTE;

@end
