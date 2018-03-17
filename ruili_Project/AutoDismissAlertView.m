//
//  AutoDismissAlertView.m
//  Myanycam
//
//  Created by myanycam on 13/11/19.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AutoDismissAlertView.h"

@implementation AutoDismissAlertView

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
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
    }
    
    return self;
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
    
    [_alertViewTipLabel release];
    [super dealloc];
}
@end
