//
//  EventAlertViewDelegate.h
//  Myanycam
//
//  Created by myanycam on 13-5-22.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventAlertViewDelegate <NSObject>

- (void)getEventAlertPictureRsp:(NSDictionary *)info;

- (void)getRecordFileNameRsp:(NSDictionary *)info;


@end
