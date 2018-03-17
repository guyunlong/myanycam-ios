//
//  MyPhotoSource.m
//  EGOPhotoViewerDemo_iPad
//
//  Created by Devin Doty on 7/3/10July3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyPhotoSource.h"


@implementation MyPhotoSource

@synthesize photos=_photos;
@synthesize numberOfPhotos=_numberOfPhotos;


- (id)initWithPhotos:(NSArray*)photos{
	
	if (self = [super init]) {
		
		self.photos = [NSMutableArray arrayWithArray:photos];
		_numberOfPhotos = [_photos count];
		
	}
	
	return self;

}

- (id <EGOPhoto>)photoAtIndex:(NSInteger)index{
	
    if (index <0 || index > [_photos count]) {
        
        return nil;
    }
	return [_photos objectAtIndex:index];
	
}


- (void)deleteObjectAtIndex:(NSInteger)index{
    
    [self.photos removeObjectAtIndex:index];
    _numberOfPhotos --;
    
}

- (void)addObjectWithArray:(NSArray *)photoArray{
    
    [self.photos addObjectsFromArray:photoArray];
    _numberOfPhotos = [_photos count];
    DebugLog(@"photoArray :%d _numberOfPhotos :%d",[photoArray count],_numberOfPhotos);
}


- (void)updatePhotosWithArray:(NSArray *)photoArray{
    
    [self.photos removeAllObjects];
    [self.photos addObjectsFromArray:photoArray];
    _numberOfPhotos = [_photos count];
    DebugLog(@"photoArray :%d _numberOfPhotos :%d",[photoArray count],_numberOfPhotos);
}

- (void)dealloc{
	
	[_photos release], _photos=nil;
	[super dealloc];
}

@end
