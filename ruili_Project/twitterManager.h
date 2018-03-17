//
//  twitterManager.h
//  Myanycam
//
//  Created by myanycam on 13-5-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWAPIManager.h"


@protocol twitterManagerDelegate;

@interface twitterManager : NSObject
{
    
    ACAccountStore *_accountStore;
    TWAPIManager *_apiManager;
    NSArray *_accounts;
    ACAccount * _currentTwitterAccount;
    BOOL        _flagNeedPostImage;
    UIImage   * _needPostToTwitterImage;
    id<twitterManagerDelegate>  _delegate;
    
}


@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) TWAPIManager *apiManager;
@property (nonatomic, retain) NSArray *accounts;
@property (nonatomic, assign) NSInteger   flagTwitterCanLogin;
@property (nonatomic, assign) ACAccount * currentTwitterAccount;
@property (nonatomic, retain) UIImage   * needPostToTwitterImage;

@property (nonatomic, assign) id<twitterManagerDelegate>    delegate;

@property (assign, nonatomic) BOOL  flagNeedPostImage;

- (BOOL)postImageToTwitter:(UIImage *)postImage delegate:(id<twitterManagerDelegate>)delegate;
- (BOOL)sharePhotoToWitter;
- (void)prepareTwitterData;

@end


@protocol twitterManagerDelegate <NSObject>

- (void)twitterPostImage:(NSInteger)error;

@end
