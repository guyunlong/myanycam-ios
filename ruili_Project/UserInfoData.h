//
//  UserInfoData.h
//  Myanycam
//
//  Created by myanycam on 13/6/24.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoData : NSObject
{
    NSString * _accountIdStr;
    NSString * _twitterName;
    NSString * _faceBookName;
}

#pragma mark loginType 0:myanycam acount 1:facebook 2:twitter
@property (assign, nonatomic) LoginType   loginType;
@property (retain, nonatomic) NSString  * accountName;
@property (retain, nonatomic) NSString  * accountIdStr;
@property (retain, nonatomic) NSString  * passwordStr;
@property (retain, nonatomic) NSString  * faceBookEmail;
@property (retain, nonatomic) NSString  * faceBookName;
@property (retain, nonatomic) NSString  * faceBookToken;
@property (retain, nonatomic) NSString  * faceBookid;
@property (retain, nonatomic) NSString  * device_token;
@property (nonatomic,assign) NSInteger userId;

#pragma mark twitter data
@property (retain, nonatomic) NSString  * twitterEmail;
@property (retain, nonatomic) NSString  * twitterName;
@property (retain, nonatomic) NSString  * twitterOauthToken;
@property (retain, nonatomic) NSString  * twitterOauthTokenSecret;
@property (retain, nonatomic) NSString  * twitterid;

#pragma mark qq

@property (retain, nonatomic) NSString * qqOpenId;
@property (retain, nonatomic) NSString * qqAccessToken;
@property (retain, nonatomic) NSString * qqNickname;
@property (retain, nonatomic) NSString * gender;

#pragma mark client version
@property (retain, nonatomic) NSString  * clientVersion;//1.0.1
@property (assign, nonatomic) int upgradeType;//0:不更新 1:可选更新 2:强制更新
@property (assign, nonatomic) int appType;//和硬件相关

+ (UserInfoData *) userInfoData;

@end
