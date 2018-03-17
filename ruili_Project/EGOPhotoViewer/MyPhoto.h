//
//  MyPhoto.h
//  EGOPhotoViewerDemo_iPad
//
//  Created by Devin Doty on 7/3/10July3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOPhotoGlobal.h"
#import "EventAlertTableViewCellData.h"


@interface MyPhoto : NSObject <EGOPhoto>{
	
	NSURL *_URL;
	NSString *_caption;
	CGSize _size;
	UIImage *_image;
    NSString * _imagePath;
    
    NSString * _proxyName;
    
    EventAlertTableViewCellData * _cellData;
	
	BOOL _failed;
	
}
@property (retain, nonatomic) NSString * imagePath;
@property (retain, nonatomic) EventAlertTableViewCellData * cellData;
- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName image:(UIImage*)aImage;
- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName;
- (id)initWithImageURL:(NSURL*)aURL;
- (id)initWithImage:(UIImage*)aImage;

@end
