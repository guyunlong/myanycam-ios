//
//  OpenPlatformManager.m
//  Myanycam
//
//  Created by myanycam on 13-4-1.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "OpenPlatformManager.h"
#import "AppDelegate.h"

@implementation OpenPlatformManager
@synthesize delegate = _delegate;
@synthesize currentNeedPostImage;
@synthesize needPostImageController;

@synthesize accountStore = _accountStore;
@synthesize facebookAccount = _facebookAccount;


- (void)dealloc{
    self.delegate = nil;
    self.currentNeedPostImage = nil;
    self.needPostImageController = nil;
    
    self.accountStore = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationFBSessionStateOpen object:nil];

    [super dealloc];
}

- (void)postPhotoToFaceBook:(UIImage *)image viewController:(UIViewController *)controller delegate:(id<OpenPlatformManagerDelegate>)delegate{
    
    self.delegate = delegate;
    self.currentNeedPostImage = image;
    self.needPostImageController = controller;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNeedPostImage) name:KNotificationFBSessionStateOpen object:nil];
    
    [self checkNeedPostImage];
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    NSArray * array = FBSession.activeSession.permissions;
    if ([array indexOfObject:@"publish_actions"] == NSNotFound ||[ array indexOfObject:@"publish_stream"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions",@"publish_stream"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                    
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}

- (BOOL) checkFackbookSeccsion{
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (FBSession.activeSession.isOpen) {
        
        return YES;
    }
    else{
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            // Yes, so just open the session (this won't display any UX).
            [appDelegate openSession:NO];
        } else {
            // No, display the login page.
            [appDelegate openSession:YES];
        }
        
        return NO;
        
    }
    
    return NO;
}

- (void)checkNeedPostImage{
    
    if (self.flagNeedPostImage) {
        
        if ([self checkFackbookSeccsion]) {
            
            // if it is available to us, we will post using the native dialog
            BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self.needPostImageController
                                                                            initialText:nil
                                                                                  image:self.currentNeedPostImage
                                                                                    url:nil
                                                                                handler:nil];
            if (!displayedNativeDialog) {
                [self performPublishAction:^{
                    
                    NSData * imageData = UIImagePNGRepresentation(self.currentNeedPostImage);
                    if (!imageData) {
                        imageData = UIImageJPEGRepresentation(self.currentNeedPostImage, 1);
                    }
                    if (imageData) {
                        
                    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          imageData,@"picture",
                                          @"Hello,Myanycam ",@"measage",
                                          @"www.myanycam.com",@"link",
                                          @"Hello,Myanycam", @"caption",
                                          @"Hello,Myanycam", @"description",
                                              nil];
                        
                        [FBRequestConnection startWithGraphPath:@"me/Photos" parameters:dic HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                            
                            DebugLog(@"checkNeedPostImage error %@",error);
                            if (!error) {
                                if (error == NULL) {
                                    //
                                    self.flagNeedPostImage = NO;
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(postPhotoToFaceBookSuccess)]) {
                                        [self.delegate postPhotoToFaceBookSuccess];
                                    }
                                }
                            }
                            
                        }];
                        
                    }

                    
                }];
            }
        }

    }
}




@end
