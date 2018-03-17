//
//  twitterManager.m
//  Myanycam
//
//  Created by myanycam on 13-5-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "twitterManager.h"

@implementation twitterManager

@synthesize accountStore = _accountStore;
@synthesize accounts = _accounts;
@synthesize apiManager = _apiManager;
@synthesize flagTwitterCanLogin;
@synthesize currentTwitterAccount = _currentTwitterAccount;
@synthesize needPostToTwitterImage = _needPostToTwitterImage;
@synthesize flagNeedPostImage = _flagNeedPostImage;
@synthesize delegate = _delegate;

- (void)dealloc{
    
    self.apiManager = nil;
    self.accounts = nil;
    self.accountStore = nil;
    self.needPostToTwitterImage = nil;
    self.currentTwitterAccount = nil;
    self.delegate = nil;
    
    [super dealloc];
}


- (void)prepareTwitterData{
    
    
    _accountStore = [[ACAccountStore alloc] init];
    _apiManager = [[TWAPIManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTwitterAccounts) name:ACAccountStoreDidChangeNotification object:nil];
    
    [self refreshTwitterAccounts];
    
}

- (void)refreshTwitterAccounts
{
    TWDLog(@"Refreshing Twitter Accounts \n");
    [self obtainAccessToAccountsWithBlock:^(BOOL granted) {
        
    }];
}

- (void)obtainAccessToAccountsWithBlock:(void (^)(BOOL))block
{
    ACAccountType *twitterType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler handler = ^(BOOL granted, NSError *error) {
        if (granted) {
            self.accounts = [_accountStore accountsWithAccountType:twitterType];
        }
        
        DebugLog(@"obtainAccessToAccountsWithBlock error %@",error);
        
        if (granted) {
            
            self.flagTwitterCanLogin = 0;

            
            if ([self.accounts count] == 0) {
                
                self.flagTwitterCanLogin = 1;
            }
        }
        else {
            
            TWALog(@"You were not granted access to the Twitter accounts.");
            
            if (error)
            {
                self.flagTwitterCanLogin = 1;
            }
            else
            {
                self.flagTwitterCanLogin = 2;
            }
            
        }
        
        block(granted);
    };
    
    //  This method changed in iOS6. If the new version isn't available, fall back to the original (which means that we're running on iOS5+).
    if ([_accountStore respondsToSelector:@selector(requestAccessToAccountsWithType:options:completion:)]) {
        
        [_accountStore requestAccessToAccountsWithType:twitterType options:nil completion:handler];
    }
    else {
        
        [_accountStore requestAccessToAccountsWithType:twitterType withCompletionHandler:handler];
    }
}

- (BOOL)postImageToTwitter:(UIImage *)postImage delegate:(id<twitterManagerDelegate>)delegate{
    
    self.needPostToTwitterImage = postImage;
    self.delegate = delegate;
    _flagNeedPostImage = YES;
    
    return [self sharePhotoToWitter];
        
}

- (BOOL)sharePhotoToWitter{
    
    if (_currentTwitterAccount) {
        
        id postRequest = nil;
        
        UIImage * image = self.needPostToTwitterImage;
        
        NSURL *url = [NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"];
        if ([SLRequest class]) {
            TWDLog(@"Using request class: SLRequest\n");
            postRequest =  [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:TWRequestMethodPOST URL:url parameters:nil];
            
            SLRequest * Post = (SLRequest*)postRequest;
            [Post addMultipartData:[@"Hello,Myanycam" dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data" filename:nil];
            if (image) {
                [Post addMultipartData:UIImagePNGRepresentation(image) withName:@"media" type:@"multipart/form-data" filename:nil];
            }
            
        }
        else {
            TWDLog(@"Using request class: TWRequest\n");
            postRequest = [[TWRequest alloc] initWithURL:url parameters:nil requestMethod:TWRequestMethodPOST];
            //add text
            [postRequest addMultiPartData:[@"Hello,Myanycam" dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
            //add image
            [postRequest addMultiPartData:UIImagePNGRepresentation(image) withName:@"media" type:@"multipart/form-data"];
        }
        
        // Set the account used to post the tweet.
        
        [postRequest setAccount:_currentTwitterAccount];
        
        // Perform the request created above and create a handler block to handle the response.
        [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
#ifdef DEBUG
            NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
            
            DebugLog(@"output %@",output);
#endif
            
            _flagNeedPostImage = NO;
            if (!error) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(twitterPostImage:)]) {
                    
                    [self.delegate twitterPostImage:0];
                    
                }
            }
            
        }];
        
        return YES;
    }
    
    return NO;
}

@end
