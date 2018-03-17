//
//  MYTapGestureRecognizer.h
//  Myanycam
//
//  Created by myanycam on 13-3-8.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYTapGestureRecognizer : UITapGestureRecognizer<UIGestureRecognizerDelegate>{
    
    id                      _target;
    SEL                     _selector;
}

@property (nonatomic, assign) id            target;
@property (nonatomic, assign) SEL           selector;

+ (MYTapGestureRecognizer *)myTapGestureRecognizer:(id)target action:(SEL)action;

@end
