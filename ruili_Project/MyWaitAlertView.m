//
//  MyWaitAlertView.m
//  Myanycam
//
//  Created by myanycam on 13-5-13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MyWaitAlertView.h"
#import "AppDelegate.h"

@implementation MyWaitAlertView
@synthesize timer;
@synthesize minTimeForWait;

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

- (void)prepareView:(NSString *)titleStr{
    
    self.tag = AlertViewTypeWait;
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:10];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.0015 target: self selector:@selector(handleTimer:) userInfo: nil repeats: YES];
	[UIView commitAnimations];
    
    self.waitDesLabel.text = titleStr;
//    NSLocalizedString(@"Loading...", nil)
    [self.waitActivityDicatorView startAnimating];

}

-(void)handleTimer:(NSTimer *)timer {
    
//	self.myangle += 0.01;
//    
//	if (self.myangle > 6.283) {
//        
//		self.myangle = 0;
//	}
//    
//	CGAffineTransform transform=CGAffineTransformMakeRotation(self.myangle);
//	self.smallWaitImageView.transform = transform;
    
    self.minTimeForWait = self.minTimeForWait + 1;
    if (self.minTimeForWait > 15000) {
        
        [self hide];
    }
    
}

- (void)show{
    
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self];
    self.center = appDelegate.window.center;
    
}

- (void)stopRotation{
    
//    [self.timer invalidate];
//    self.timer = nil;
    
     [self.waitActivityDicatorView stopAnimating];
    
}

- (void)hide{
    
    if (self.minTimeForWait < 300) {
        
        self.minTimeForWait = 1500 - (300 -self.minTimeForWait);
    }
    
    [self stopRotation];
    [self removeFromSuperview];
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
    [_smallWaitImageView release];
    [_waitDesLabel release];
    [_waitActivityDicatorView release];
    [super dealloc];
}
@end
