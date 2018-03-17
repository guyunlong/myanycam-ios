//
//  WallPaperViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-13.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "WallPaperDelegate.h"
#import "BaseViewController.h"


@interface WallPaperViewController : BaseViewController
{
    NSInteger                  _startWallTime;
    
}

@property (retain, nonatomic) NSTimer  *startWallViewTimer;
@property (retain, nonatomic) IBOutlet UIView *startWallPaperView;
@property (retain, nonatomic) id<WallPaperDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIImageView *waitImageView;

- (void)dismissModalViewController;

@end
