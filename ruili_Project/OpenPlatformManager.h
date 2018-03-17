//
//  OpenPlatformManager.h
//  Myanycam
//
//  Created by myanycam on 13-4-1.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "OAuth+Additions.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"

@protocol OpenPlatformManagerDelegate;

@interface OpenPlatformManager : NSObject{
    

    ACAccountStore *_accountStore;
    ACAccount * _facebookAccount;
    
}

@property (retain, nonatomic)     ACAccountStore * accountStore;
@property (retain, nonatomic)     ACAccount * facebookAccount;

@property (assign, nonatomic) BOOL flagNeedPostImage;
@property (assign, nonatomic) id<OpenPlatformManagerDelegate> delegate;
@property (retain, nonatomic) UIImage * currentNeedPostImage;
@property (retain, nonatomic) UIViewController * needPostImageController;

////////////////////////////////////////////
#pragma mark twitter


- (void)postPhotoToFaceBook:(UIImage *)image viewController:(UIViewController *)controller delegate:(id<OpenPlatformManagerDelegate>)delegate;

- (void)performPublishAction:(void (^)(void)) action;

#pragma mark twitter function


@end


@protocol OpenPlatformManagerDelegate <NSObject>

- (void)postPhotoToFaceBookSuccess;

@end