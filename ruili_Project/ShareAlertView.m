//
//  ShareAlertView.m
//  Myanycam
//
//  Created by myanycam on 13-5-8.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "ShareAlertView.h"
#import "AppDelegate.h"

@implementation ShareAlertView
@synthesize delegate;
@synthesize buttonArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
                
    }
    
    return self;
    
}

- (void)prepareView{
    
    self.backgroundImageView.backgroundColor = [UIColor orangeColor];
    self.backgroundImageView.layer.masksToBounds = YES;
    self.backgroundImageView.layer.cornerRadius = 6.0;
    
    self.bigBackgroundImageView.layer.masksToBounds = YES;
    self.bigBackgroundImageView.layer.cornerRadius = 6.0;
    
    self.alertTitleLabel.text = NSLocalizedString(@"Take Photo Success!", nil);
    [self.shareButton setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    
}

- (void)checkDelegate:(NSNotification *) notification{
    id object = [notification object];
    if (object) {
        if (object == self.delegate) {
            self.delegate = nil;
        }
        
        if (object == self.baseDelegate) {
            
            self.baseDelegate = nil;
        }
    }
}


- (void)dealloc {
    
    [_alertTitleLabel release];
    [_facebookButton release];
    [_twitterButton release];
    [_facebookAction release];
    [_twitterAction release];
    [_cancelButton release];
    [_backgroundImageView release];
    [_bigBackgroundImageView release];
    self.delegate = nil;
    self.buttonArray = nil;

    [_centerBackView release];
    [_shareButton release];
    [super dealloc];
}

- (IBAction)shareFackbookAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customalertView:buttonAtIndex:)]) {
        
        [self.delegate customalertView:self buttonAtIndex:0];
    }
    
    [self removeFromSuperview];
    
}

- (IBAction)shareTwitterAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customalertView:buttonAtIndex:)]) {
        
        [self.delegate customalertView:self buttonAtIndex:1];
    }

    [self removeFromSuperview];
}

- (IBAction)cancelButtonAction:(id)sender {
    
    [self removeFromSuperview];
}



@end
