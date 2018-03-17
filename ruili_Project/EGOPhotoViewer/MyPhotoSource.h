//
//  MyPhotoSource.h
//  EGOPhotoViewerDemo_iPad
//
//  Created by Devin Doty on 7/3/10July3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOPhotoGlobal.h"

@interface MyPhotoSource : NSObject <EGOPhotoSource> {
	
	NSMutableArray *_photos;
	NSInteger _numberOfPhotos;

}

- (id)initWithPhotos:(NSArray*)photos;
- (void)deleteObjectAtIndex:(NSInteger)index;

- (void)addObjectWithArray:(NSArray *)photoArray;
- (void)updatePhotosWithArray:(NSArray *)photoArray;

@end
