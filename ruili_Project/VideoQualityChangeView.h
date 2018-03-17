//
//  VideoQualityChangeView.h
//  Myanycam
//
//  Created by myanycam on 13/10/17.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoQualityChangeDelegate;

@interface VideoQualityChangeView : UIView <UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *qualitySelectTableView;
@property (assign, nonatomic) id<VideoQualityChangeDelegate> delegate;
@property (retain, nonatomic) NSMutableArray * dataArray;
@end


@protocol VideoQualityChangeDelegate <NSObject>

- (void)didSelectVideoQualityWithIndex:(NSInteger)index;

@end