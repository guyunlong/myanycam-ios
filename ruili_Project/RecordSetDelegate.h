//
//  RecordSetDelegate.h
//  Myanycam
//
//  Created by myanycam on 13-5-14.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RecordSetDelegate <NSObject>

- (void)getRecordInfoRespond:(NSDictionary *)info;

- (void)setRecordInfoRespond:(NSDictionary *)info;

@end
