//
//  RepeatDaysSelectViewController.h
//  Myanycam
//
//  Created by myanycam on 13-3-4.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"
#import "RepeatDaysSelectCell.h"

@interface RepeatDaysSelectViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger                 _currentIndex;
}
@property (assign, nonatomic) NSInteger         currentIndex;
@property (retain, nonatomic) NSMutableArray  * weekDaysArray;
@property (retain, nonatomic) IBOutlet UITableView *repeatDaysSelectTableView;

@end
