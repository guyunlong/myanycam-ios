//
//  BaseAlertView.h
//  Myanycam
//
//  Created by myanycam on 13/8/22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAlertViewDelegate.h"

@interface BaseAlertView : UIView{
    
    BOOL hasLayedOut;

}

@property (nonatomic, assign) id<BaseAlertViewDelegate> baseDelegate;
@property (nonatomic, retain) NSDictionary   * userInfo;



- (void)showAutoDismissAlertView:(NSString *)tip;
- (void)show;
- (void)hide;

@end
