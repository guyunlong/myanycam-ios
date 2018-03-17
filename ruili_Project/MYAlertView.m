//
//  MYAlertView.m
//  Myanycam
//
//  Created by myanycam on 13-4-9.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYAlertView.h"

@implementation MYAlertView
@synthesize userInfo = _userInfo;

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationDismissDelegate
                                                  object:nil];
    self.userInfo = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkDelegate:)
                                                     name:kNotificationDismissDelegate
                                                   object:nil];
    }
    
    return self;
}

- (void)checkDelegate:(NSNotification *) notification{
    id object = [notification object];
    if (object) {
        if (object == self.delegate) {
            self.delegate = nil;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
