//
//  UserInfoData.m
//  Myanycam
//
//  Created by myanycam on 13/6/24.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "UserInfoData.h"

@implementation UserInfoData
@synthesize accountIdStr = _accountIdStr;
@synthesize passwordStr = _passwordStr;
@synthesize faceBookEmail = _faceBookEmail;
@synthesize faceBookName = _faceBookName;
@synthesize faceBookToken = _faceBookToken;
@synthesize faceBookid = _faceBookid;
@synthesize device_token;
@synthesize userId;
@synthesize loginType;
@synthesize accountName;

@synthesize twitterEmail;
@synthesize twitterName = _twitterName;
@synthesize twitterOauthToken;
@synthesize twitterOauthTokenSecret;
@synthesize twitterid;

@synthesize clientVersion;//1.0.1
@synthesize upgradeType;//0:不更新 1:可选更新 2:强制更新 
@synthesize appType;

@synthesize qqOpenId;
@synthesize qqAccessToken;
@synthesize qqNickname;
@synthesize gender;


- (void)dealloc{
    
    self.qqNickname = nil;
    self.gender = nil;
    self.qqAccessToken = nil;
    self.qqOpenId = nil;
    self.accountIdStr = nil;
    self.accountName = nil;
    self.passwordStr = nil;
    self.faceBookEmail = nil;
    self.faceBookName = nil;
    self.faceBookToken = nil;
    self.faceBookid = nil;
    self.device_token = nil;
    
    self.twitterEmail = nil;
    self.twitterid = nil;
    self.twitterName = nil;
    self.twitterOauthToken = nil;
    self.twitterOauthTokenSecret = nil;
    
    [super dealloc];
}

- (void)setAccountIdStr:(NSString *)accountIdStr{
    
    if (_accountIdStr != accountIdStr) {
        
        [_accountIdStr release];
        _accountIdStr = [accountIdStr retain];
    }
    
    if (accountIdStr) {
        
        if (self.loginType == LoginTypeNone) {
            
            self.accountName = accountIdStr;
        }

    }
}

- (void)setTwitterName:(NSString *)twitterName{
    
    if (_twitterName != twitterName) {
        
        [_twitterName release];
        _twitterName = [twitterName retain];
    }
    
    if (twitterName) {
        
        if (self.loginType == LoginTypeTwitter ) {
            
            self.accountName = twitterName;
        }

    }
}

- (void)setFaceBookName:(NSString *)faceBookName
{
    if (_faceBookName != faceBookName) {
        
        [_faceBookName release];
        _faceBookName = [faceBookName retain];
    }
    
    if (faceBookName) {
        
        if (self.loginType == LoginTypeFacebook) {
            
            self.accountName = faceBookName;
        }

    }
}

+ (UserInfoData *) userInfoData{
    
    UserInfoData * data = [[[UserInfoData alloc] init] autorelease];
    return data;
}

@end
