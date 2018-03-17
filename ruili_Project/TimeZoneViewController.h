//
//  TimeZoneViewController.h
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"

@interface TimeZoneViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>{
    
    NSCalendar *calendar;
    NSInteger  _currentTimeZone;
    
}

@property (assign, nonatomic) NSInteger currentTimezone;
@property (retain, nonatomic) NSArray * timezoneArray;
@property (retain, nonatomic) IBOutlet UITableView *timeZoneTableView;

@end
