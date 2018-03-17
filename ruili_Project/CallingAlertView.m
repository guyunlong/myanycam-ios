//
//  CallingAlertView.m
//  Myanycam
//
//  Created by myanycam on 13/10/8.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CallingAlertView.h"
#import "MusicPlayEngine.h"

@implementation CallingAlertView
@synthesize cameraInfo;




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareData:(CameraInfoData *)acameraInfo{
    
    [[MusicPlayEngine sharedMusicPlayerEngine] playSoundEffect:SoundEffectCall repeat:YES];
    
    self.cameraInfo = acameraInfo;
    NSString * camera = NSLocalizedString(@"Camera", nil);
    NSString * calling = NSLocalizedString(@"Calling", nil);
    NSString * messageString = [[NSString alloc] initWithFormat:@"%@:%@ is %@",camera,acameraInfo.cameraName,calling];
    self.callingNameLabel.text = messageString;
    [messageString release];
    
    
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    
    [_acceptButton release];
    [_cancelButton release];
    [_callingNameLabel release];
    self.cameraInfo = nil;
    
    [super dealloc];
}
- (IBAction)cancelButtonAction:(id)sender {
    
    if (self.baseDelegate) {
        
        [self.baseDelegate alertView:self clickButtonAtIndex:BaseAlertViewButtonTypeCancel];
    }
    
    [[MusicPlayEngine sharedMusicPlayerEngine] stopRepeatPlay];
    
    [self hide];
}

- (IBAction)acceptButtonAction:(id)sender {
    
    if (self.baseDelegate) {
        
        [self.baseDelegate alertView:self clickButtonAtIndex:BaseAlertViewButtonTypeOK];
    }
    
    [[MusicPlayEngine sharedMusicPlayerEngine] stopRepeatPlay];
    
    [self hide];
    
}
@end
