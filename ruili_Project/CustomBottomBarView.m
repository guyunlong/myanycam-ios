//
//  CustomBottomBarView.m
//  Myanycam
//
//  Created by myanycam on 13-3-14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CustomBottomBarView.h"
#import "MYDataManager.h"

@implementation CustomBottomBarView
@synthesize delegate = _delegate;
@synthesize cameraData;

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
        // Initialization code
        
    }
    return self;
}

- (void)updateCustomView{
    
    self.cameraLabel.text =  NSLocalizedString(@"Camera", nil);
    self.eventLabel.text = NSLocalizedString(@"Event", nil);
    self.fileLabel.text = NSLocalizedString(@"Photo", nil);
    self.aboutLabel.text = NSLocalizedString(@"Setting", nil);

    self.bottomButton1.exclusiveTouch = YES;
    self.bottomButton2.exclusiveTouch = YES;
    self.bottomButton3.exclusiveTouch = YES;
    self.bottomButton4.exclusiveTouch = YES;
    self.eventNumberView.hideWhenZero = YES;
    self.eventNumberView.value = 0;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat w = width/4;
    
    CGPoint center;
    CGRect frame = self.bottomButton1.frame;
    frame.size.width = w;
    
    frame.origin.x = 0;
    self.bottomButton1.frame = frame;
    center = self.bottomButton1.center;
    center.y = self.cameraLabel.center.y;
    self.cameraLabel.center = center;
    center.y = self.stateImageView1.center.y;
    self.stateImageView1.center = center;
    
    frame.origin.x = w;
    self.bottomButton2.frame = frame;
    center = self.bottomButton2.center;
    center.y = self.eventLabel.center.y;
    self.eventLabel.center = center;
    center.y = self.stateImageView2.center.y;
    self.stateImageView2.center = center;
    
    frame.origin.x = 2*w;
    self.bottomButton3.frame = frame;
        center = self.bottomButton3.center;
    center.y = self.fileLabel.center.y;
    self.fileLabel.center = center;
    center.y = self.stateImageView3.center.y;
    self.stateImageView3.center = center;
    
    frame.origin.x = 3*w;
    self.bottomButton4.frame = frame;
    center = self.bottomButton4.center;
    center.y = self.aboutLabel.center.y;
    self.aboutLabel.center = center;
    center.y = self.stateImageView4.center.y;
    self.stateImageView4.center = center;
    
    CGRect eventFrame = self.eventNumberView.frame;
    
    self.eventNumberView.frame = CGRectMake((width/2 - eventFrame.size.width), eventFrame.origin.y, eventFrame.size.width, eventFrame.size.height);
    
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
    self.delegate = nil;
    self.cameraData = nil;
    [_bottomButton1 release];
    [_bottomButton2 release];
    [_bottomButton4 release];
    [_bottomButton3 release];
    [_cameraLabel release];
    [_fileLabel release];
    [_eventLabel release];
    [_aboutLabel release];
    [_stateImageView1 release];
    [_stateImageView2 release];
    [_stateImageView3 release];
    [_stateImageView4 release];
    [_eventNumberView release];
    [super dealloc];
}

- (void)showEventStateImage{
    
    if (self.cameraData) {
        
        NSNumber * cameraID = [NSNumber numberWithInt:self.cameraData.cameraId];
        self.eventNumberView.value = [[[MYDataManager shareManager].alertNumberDict objectForKey:cameraID] intValue];
    }
}

- (void)hideEventStateImage{
    
    self.eventNumberView.value = 0;
}

- (void)setButtonHighlightWithIndex:(NSInteger)index{
    
    DebugLog(@"setButtonHighlightWithIndex %d",index);
    
    
    if (index == _currentIndex) {
        
        return;
    }
    
    _currentIndex = index;
    
    
    switch (index) {
        case 1:
        {
            [self keepOnlyButtonHighlight:self.bottomButton1];
            self.stateImageView1.image = [UIImage imageNamed:@"icon4_hover.png"];
            self.cameraLabel.textColor = [UIColor whiteColor];
        }
            break;
        case 2:
        {
            [self keepOnlyButtonHighlight:self.bottomButton2];
            self.stateImageView2.image = [UIImage imageNamed:@"icon5_hover.png"];
            self.eventLabel.textColor = [UIColor whiteColor];
        }
            break;
        case 3:
        {
            [self keepOnlyButtonHighlight:self.bottomButton3];
            self.stateImageView3.image = [UIImage imageNamed:@"icon6_hover.png"];
             self.fileLabel.textColor = [UIColor whiteColor];

        }
            break;
        case 4:
        {
            [self keepOnlyButtonHighlight:self.bottomButton4];
            self.stateImageView4.image = [UIImage imageNamed:@"icon7_hover.png"];
             self.aboutLabel.textColor = [UIColor whiteColor];

        }
            break;
        default:
            break;
    }
}


- (void)doNormalButton{
    
    self.bottomButton1.highlighted = NO;
    self.bottomButton2.highlighted = NO;
    self.bottomButton3.highlighted = NO;
    self.bottomButton4.highlighted = NO;
    
    self.stateImageView1.image = [UIImage imageNamed:@"icon4.png"];
    self.stateImageView2.image = [UIImage imageNamed:@"icon5.png"];
    self.stateImageView3.image = [UIImage imageNamed:@"icon6.png"];
    self.stateImageView4.image = [UIImage imageNamed:@"icon7.png"];
    
    self.cameraLabel.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
    self.eventLabel.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
    self.fileLabel.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
    self.aboutLabel.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
    
    
}

- (void)doHighlight:(UIButton*)b {
    
    [b setHighlighted:YES];
}

- (void)keepOnlyButtonHighlight:(id)sender{
    
    [self doNormalButton];
    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
    
}

- (IBAction)bottomButton1Action:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customBottomBarViewDelegate:button:userInfo:)]) {
        [self.delegate customBottomBarViewDelegate:self button:sender userInfo:nil];
    }
    [self keepOnlyButtonHighlight:sender];
    
    self.stateImageView1.image = [UIImage imageNamed:@"icon4_hover.png"];
    self.cameraLabel.textColor = [UIColor whiteColor];

}

- (IBAction)bottomButton2Action:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customBottomBarViewDelegate:button:userInfo:)]) {
        [self.delegate customBottomBarViewDelegate:self button:sender userInfo:nil];
    }
    [self keepOnlyButtonHighlight:sender];
    
    self.stateImageView2.image = [UIImage imageNamed:@"icon5_hover.png"];
    self.eventLabel.textColor = [UIColor whiteColor];

    [self hideEventStateImage];

}

- (IBAction)bottomButton3Action:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customBottomBarViewDelegate:button:userInfo:)]) {
        [self.delegate customBottomBarViewDelegate:self button:sender userInfo:nil];
    }
    [self keepOnlyButtonHighlight:sender];
    
    self.fileLabel.textColor = [UIColor whiteColor];
    self.stateImageView3.image = [UIImage imageNamed:@"icon6_hover.png"];

}


- (IBAction)bottomButton4Action:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customBottomBarViewDelegate:button:userInfo:)]) {
        [self.delegate customBottomBarViewDelegate:self button:sender userInfo:nil];
    }
    [self keepOnlyButtonHighlight:sender];
    
    self.aboutLabel.textColor = [UIColor whiteColor];
    self.stateImageView4.image = [UIImage imageNamed:@"icon7_hover.png"];

}
@end
