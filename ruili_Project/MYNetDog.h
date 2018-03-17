//
//  MYNetDog.h
//  Myanycam
//
//  Created by myanycam on 13/6/18.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


@interface MYNetDog : NSObject{
    
    Reachability            *_networkDetector;
}

@property (nonatomic, retain) Reachability          *networkDetector;

+ (MYNetDog *)luckDog;
- (NetworkStatus )currentInternetStatus;

@end