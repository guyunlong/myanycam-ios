//
//  TimeZoneSelectViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "Region.h"

@interface TimeZoneSelectViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (retain, nonatomic) Region * region;
@property (retain, nonatomic) IBOutlet UITableView *timezoneSelectTableView;

@end
