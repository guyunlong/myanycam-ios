//
//  MYImageCache.m
//  Myanycam
//
//  Created by myanycam on 13-5-30.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYImageCache.h"


@interface MYImageCache (private)

- (NSString *) _filePathWithKey:(NSString *)key;
- (BOOL) _imageExistsOnDiskWithKey:(NSString *)key;
- (UIImage*) _imageFromDiskWithKey:(NSString*)key;
- (void) _readImageFromDiskWithKey:(NSString*)key tag:(NSUInteger)tag;
- (void) _sendRequestForURL:(NSURL*)url key:(NSString*)key tag:(NSUInteger)tag;

@end

@implementation MYImageCache
@synthesize cacheDirectoryName=_cacheDirectoryName,notificationName=_notificationName;
@synthesize timeTillRefreshCache=_timeTillRefreshCache;
@synthesize request=_request;
@synthesize diskKeys=_diskKeys;
@synthesize fileHandler=_fileHandler;
@synthesize currentImage=_currentImage;

static MYImageCache* imageCache = nil;

-(void)dealloc{
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    self.cacheDirectoryName = nil;
    self.notificationName = nil;
    self.diskKeys = nil;
    self.currentImage = nil;
    dispatch_release(cache_queue);
    [super dealloc];
}
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+ (MYImageCache*)sharedImageCache
{
    if (imageCache == nil) {
        imageCache = [[super allocWithZone:NULL] init];
    }
    return imageCache;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedImageCache] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;
}
+(id)imageCacheWithDirectoryName:(NSString*)dirName{
    if (imageCache == nil) {
        imageCache = [[super allocWithZone:NULL] initWithCacheDirectoryName:dirName];
    }
    return imageCache;
}
- (id) initWithCacheDirectoryName:(NSString*)dirName{
	if(!(self=[super init])) return nil;
	
	//[self setCountLimit:20];
	self.cacheDirectoryName = dirName;
	
	cache_queue = dispatch_queue_create("com.vk51",NULL);
	
	return self;
}
-(UIImage*)readCacheImageWithKey:(NSString *)key{
    
    
    if (![self imageExistsWithKey:key]) {
        return nil;
    }
    return [self _readImageFromDiskWithKey:key];
}
-(void)saveCacheImageWithKey:(NSString *)key iamgeData:(NSData*)data{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self _filePathWithKey:key]]){
		
		dispatch_async(cache_queue,^{
			UIImage *cacheImage = [UIImage imageWithData:data];
			
            NSString *filePath = [self _filePathWithKey:key];
            
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
			self.fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePath];
            if (self.fileHandler) {
                [self.fileHandler writeData:data];
            }
            
            
			
			if(cacheImage){
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[self setObject:cacheImage forKey:key];
					
					
				});
			}
		});
		
		
	}
}
- (void)loadImageWithUrl:(NSString *)url imageKey:(NSString *)imageKey{
    
    NSArray *splitArray = [url componentsSeparatedByString:@"/"];
    
    splitArray = [[splitArray lastObject] componentsSeparatedByString:@"."];
    NSString *key = [splitArray objectAtIndex:0];
    
    if([self _imageExistsOnDiskWithKey:key]){
		
		[self _readImageFromDiskWithKey:key];
        return ;
		
	}
    
    if (self.request) {
        [self.request clearDelegatesAndCancel];
    }
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    self.request.delegate = self;
    self.request.userInfo = [NSDictionary dictionaryWithObject:key forKey:@"key"];
    
    [self.request setTimeOutSeconds:60];
    [self.request startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request {
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSString *key = [request.userInfo objectForKey:@"key"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self _filePathWithKey:key]]){
		
		dispatch_async(cache_queue,^{
			UIImage *cacheImage = [UIImage imageWithData:request.responseData];
			
            NSString *filePath = [self _filePathWithKey:key];
            
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
			self.fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePath];
            if (self.fileHandler) {
                [self.fileHandler writeData:request.responseData];
            }
            
            
			
			if(cacheImage){
				
				
				NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:cacheImage,@"image",[NSNumber numberWithUnsignedInt:1],@"imageDownFinshed",nil];
                
				
				dispatch_async(dispatch_get_main_queue(), ^{
					
                    //	if(_diskKeys) [_diskKeys setObject:[NSNull null] forKey:request.key];
					
					
					[self setObject:cacheImage forKey:key];
					//[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:dict];
					
					[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:self userInfo:dict];
					
					
				});
			}
		});
		
		
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
}
// for subclassing if you need to process the image
- (UIImage*) adjustImageRecieved:(UIImage*)image{
	return image;
}

- (void) clearCachedImages{
	
	[self removeAllObjects];
	[_diskKeys removeAllObjects];
	dispatch_async(cache_queue,^{
		
		NSError* error = nil;
		NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectoryPath] error:&error];
		
		
		for( NSString *file in files ) {
			if( ![file isEqual: @"."] && ![file isEqual: @".."] ) {
				NSString *path = [[self cacheDirectoryPath] stringByAppendingPathComponent:file];
				[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
				
			}
		}
		
		
	});
    
	
}
- (void) removeCachedImagesFromDiskOlderThanTime:(NSTimeInterval)time{
	
	
	UIBackgroundTaskIdentifier bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
	
	NSError* error = nil;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectoryPath] error:&error];
	
	for( NSString *file in files ) {
		if( ![file isEqual: @"."] && ![file isEqual: @".."] ) {
			
			NSString *path = [[self cacheDirectoryPath] stringByAppendingPathComponent:file];
			NSDate *created = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL] fileCreationDate];
			NSTimeInterval timeSince = fabs([created timeIntervalSinceNow]);
			
			
			
			
			if(timeSince > time){
				
				if(_diskKeys) [_diskKeys removeObjectForKey:file];
                
				[[NSFileManager defaultManager] removeItemAtPath:[[self cacheDirectoryPath] stringByAppendingPathComponent:file] error:&error];
			}
			
		}
	}
	
	
	[[UIApplication sharedApplication] endBackgroundTask:bgTask];
    
	
}

#pragma mark Disk Cache Methods
- (NSString *) _filePathWithKey:(NSString *)key{
    return [[self cacheDirectoryPath] stringByAppendingPathComponent:key];
}
- (BOOL) _imageExistsOnDiskWithKey:(NSString *)key{
	
	if(_diskKeys) return [_diskKeys objectForKey:key]==nil ? NO : YES;
	
    return [[NSFileManager defaultManager] fileExistsAtPath:[self _filePathWithKey:key]];
}
- (UIImage*) _imageFromDiskWithKey:(NSString*)key{
	NSData *data = [NSData dataWithContentsOfFile:[self _filePathWithKey:key]];
    UIImage *temp = [UIImage imageWithData:data];
	return temp;
}
- (UIImage*) _readImageFromDiskWithKey:(NSString*)key{
	self.currentImage = nil;
    
    if ([self objectForKey:key]) {
        
        //DLog(@"read from nsCache");
        
        return [self objectForKey:key];
    }
    
    UIImage *tempImage = [self adjustImageRecieved:[self _imageFromDiskWithKey:key]];
    
    if (tempImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setObject:tempImage forKey:key];
        });
    }
    
    return tempImage;
}
- (UIImage*) cachedImageForKey:(NSString*)key{
	return [self _imageFromDiskWithKey:key];
}
- (BOOL) imageExistsWithKey:(NSString *)key{
	
	if([self objectForKey:key]) return YES;
	
	
	return [self _imageExistsOnDiskWithKey:key];
	
}

#pragma mark Path Methods
- (void) _setupFolderDirectory{
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [self cacheDirectoryPath];
	
	BOOL isDirectory = NO;
	BOOL folderExists = [fileManager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
	
	if (!folderExists){
		NSError *error = nil;
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
	}
	
	
	
}
- (void) setCacheDirectoryName:(NSString *)str{
	
	_cacheDirectoryPath=nil;
	_cacheDirectoryName = [str copy];
	
	[self _setupFolderDirectory];
	
    //
    //	NSError* error = nil;
    //	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectoryPath] error:&error];
    //
    //
    //	if(error) return;
    //
    //	NSMutableArray *ar = [NSMutableArray arrayWithCapacity:files.count];
    //	for(NSObject *obj in files)
    //		[ar addObject:[NSNull null]];
    //
    //	_diskKeys = [[NSMutableDictionary alloc] initWithObjects:ar forKeys:files];
	
	
}
- (NSString *) cacheDirectoryPath{
	
	if(_cacheDirectoryPath==nil){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *str = [documentsDirectory stringByAppendingPathComponent:_cacheDirectoryName];
		_cacheDirectoryPath = [str copy];
	}
	return _cacheDirectoryPath;
}

@end
