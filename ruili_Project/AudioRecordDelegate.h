//
//  AudioRecordDelegate.h
//  Myanycam
//
//  Created by myanycam on 13/6/17.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioRecordDelegate <NSObject>

- (void)audioRecordCompleteWithData:(NSData *)data;

@end
