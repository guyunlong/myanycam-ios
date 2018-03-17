//
//  MYNetDog.m
//  Myanycam
//
//  Created by myanycam on 13/6/18.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYNetDog.h"


static MYNetDog *_instance = nil;

@implementation MYNetDog

@synthesize networkDetector         = _networkDetector;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
    self.networkDetector = nil;
    [super dealloc];
}


- (NetworkStatus )currentInternetStatus{
    NetworkStatus netStatus = [self.networkDetector currentReachabilityStatus];
    return netStatus;
}

- (void)refreshNetstatWith:(Reachability*)curReach {
	if ([curReach isKindOfClass:[Reachability class]]) {
		NetworkStatus netStatus = [curReach currentReachabilityStatus];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetworkStateChange
                                                            object:[NSNumber numberWithInteger:netStatus]];
		switch (netStatus) {
			case NotReachable:
			{
                
			}
                break;
			case ReachableViaWiFi:
			{
				
			}
                break;
			case ReachableViaWWAN:
			{
				
			}
                break;
            default:
                break;
		}
	}
}

- (void)initializeNetDetector{
	self.networkDetector = [Reachability reachabilityForInternetConnection];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(reachabilityChanged:)
												 name:kReachabilityChangedNotification
											   object:nil];
	[self.networkDetector startNotifier];
	[self refreshNetstatWith:self.networkDetector];
}


- (void)reachabilityChanged:(NSNotification*)notification{
	Reachability *curReach = [notification object];
	[self refreshNetstatWith:curReach];
}

- (id)init{
	self = [super init];
	if (self) {
		[self initializeNetDetector];
	}
	return self;
}


+ (MYNetDog *)luckDog {
	@synchronized(self){
		if (nil == _instance) {
			_instance = [[MYNetDog alloc] init];
		}
	}
	return _instance;
}



@end
