//
//  BaseAlertView.m
//  Myanycam
//
//  Created by myanycam on 13/8/22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseAlertView.h"
#import "AppDelegate.h"

@implementation BaseAlertView
@synthesize baseDelegate;
@synthesize userInfo;

- (void)dealloc{
    
    self.baseDelegate = nil;
    self.userInfo = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationDismissDelegate
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIDeviceOrientationDidChangeNotification
												  object:nil];
    
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [super dealloc];
    
}

- (void)prepareData{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkDelegate:)
                                                 name:kNotificationDismissDelegate
                                               object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self prepareData];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self prepareData];    
    }
    
    return self;
}


- (void)checkDelegate:(NSNotification *) notification{
    id object = [notification object];
    if (object) {
        if (object == self.baseDelegate) {
            self.baseDelegate = nil;
        }
    }
}

- (void)deviceOrientationChanged:(NSNotification *)notification
{
	[self setNeedsLayout];
}

- (CGAffineTransform)transformForCurrentOrientation
{
	CGAffineTransform transform = CGAffineTransformIdentity;
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if(orientation == UIInterfaceOrientationPortraitUpsideDown)
		transform = CGAffineTransformMakeRotation(M_PI);
	else if(orientation == UIInterfaceOrientationLandscapeLeft)
		transform = CGAffineTransformMakeRotation(-M_PI_2);
	else if(orientation == UIInterfaceOrientationLandscapeRight)
		transform = CGAffineTransformMakeRotation(M_PI_2);
	
	return transform;
}

CGFloat CGAffineTransformGetAbsoluteRotationAngleDifference1(CGAffineTransform t1, CGAffineTransform t2)
{
	CGFloat dot = t1.a * t2.a + t1.c * t2.c;
	CGFloat n1 = sqrtf(t1.a * t1.a + t1.c * t1.c);
	CGFloat n2 = sqrtf(t2.a * t2.a + t2.c * t2.c);
	return acosf(dot / (n1 * n2));
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGAffineTransform baseTransform = [self transformForCurrentOrientation];
	
	CGFloat delta = CGAffineTransformGetAbsoluteRotationAngleDifference1(self.transform, baseTransform);
	BOOL isDoubleRotation = (delta > M_PI);
	
	if(hasLayedOut)
	{
		CGFloat duration = [[UIApplication sharedApplication] statusBarOrientationAnimationDuration];
		if(isDoubleRotation)
			duration *= 2;
		
		[UIView animateWithDuration:duration animations:^{
			self.transform = baseTransform;
		}];
	}
	else
		self.transform = baseTransform;
    
    hasLayedOut = YES;

	
}

- (void)show{
    
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self];
    self.center = appDelegate.window.center;
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^ {
        
        self.transform = CGAffineTransformMakeScale(ANIMATION_MAX_SCALE, ANIMATION_MAX_SCALE);
        
    }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.1 animations:^ {
                             
                             self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             CGAffineTransform baseTransform = [self transformForCurrentOrientation];
                             self.transform = baseTransform;
                             
                         }];
                     }];
    
}

- (void)hide{
    
    [self removeFromSuperview];
}

- (void)showAutoDismissAlertView:(NSString *)tip{
    
    MYAlertView * alertView = [[MYAlertView alloc] initWithTitle:tip
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:nil];
    [alertView show];
    
    CGFloat y = alertView.frame.origin.y;
    CGFloat h = alertView.frame.size.height;
    CGFloat offsetH = h - 85;
    y += offsetH/2;
    
    alertView.frame = CGRectMake(alertView.frame.origin.x, y, alertView.frame.size.width, 85);
    
    [self performSelector:@selector(autoDimissAlert:) withObject:alertView afterDelay:1.5];
}

- (void)autoDimissAlert:(MYAlertView *)alertView{
    
    if(alertView)
    {
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
        [alertView release];
    }
}





@end
