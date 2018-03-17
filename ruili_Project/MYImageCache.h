//
//  MYImageCache.h
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYImageCache : NSCache
{
    NSString                *_cacheDirectoryPath;
	NSMutableDictionary     *_diskKeys;
	dispatch_queue_t        cache_queue;
    ASIHTTPRequest          *_request;
    
    NSFileHandle            *_fileHandler;
    UIImage                 *_currentImage;
}
@property (nonatomic, retain) UIImage                   *currentImage;
@property (nonatomic, retain) ASIHTTPRequest            *request;
@property (nonatomic, retain) NSMutableDictionary       *diskKeys;
@property (copy,nonatomic)    NSString                  *cacheDirectoryName;
@property (copy,nonatomic)    NSString                  *notificationName;
@property (assign,nonatomic)  NSTimeInterval            timeTillRefreshCache;
@property (nonatomic,strong)  NSFileHandle              *fileHandler;

- (id) initWithCacheDirectoryName:(NSString*)dirName;
- (void)loadImageWithUrl:(NSString *)url imageKey:(NSString *)imageKey;
-(UIImage*)readCacheImageWithKey:(NSString *)key;
-(void)saveCacheImageWithKey:(NSString *)key iamgeData:(NSData*)data;
+ (MYImageCache*)sharedImageCache;
+(id) imageCacheWithDirectoryName:(NSString*)dirName;

@end
