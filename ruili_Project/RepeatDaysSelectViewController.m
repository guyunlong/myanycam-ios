//
//  RepeatDaysSelectViewController.m
//  Myanycam
//
//  Created by myanycam on 13-3-4.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "RepeatDaysSelectViewController.h"
#import "RepeatDaysSelectCell.h"


@interface RepeatDaysSelectViewController ()

@end

@implementation RepeatDaysSelectViewController
@synthesize weekDaysArray = _weekDaysArray;
@synthesize currentIndex = _currentIndex;

- (void)dealloc {
    [_repeatDaysSelectTableView release];
    self.weekDaysArray = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self prepareData];
    }
    return self;
}

- (void)prepareData{
    
    self.weekDaysArray = [NSMutableArray arrayWithCapacity:7];
    [self.weekDaysArray addObject:[WeekDayData weekDayData:1 dayName:@"星期一" seletState:0]];
    [self.weekDaysArray addObject:[WeekDayData weekDayData:2 dayName:@"星期二" seletState:0]];
    [self.weekDaysArray addObject:[WeekDayData weekDayData:3 dayName:@"星期三" seletState:0]];
    [self.weekDaysArray addObject:[WeekDayData weekDayData:4 dayName:@"星期四" seletState:0]];
    [self.weekDaysArray addObject:[WeekDayData weekDayData:5 dayName:@"星期五" seletState:0]];
    [self.weekDaysArray addObject:[WeekDayData weekDayData:6 dayName:@"星期六" seletState:0]];
    [self.weekDaysArray addObject:[WeekDayData weekDayData:7 dayName:@"星期日" seletState:0]];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"Record Plan", nil) size:CGSizeMake(32, 32) target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WeekDayData * dayData = [self.weekDaysArray objectAtIndex:indexPath.row];
    dayData.selectState = !(dayData.selectState);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.weekDaysArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellStyle = @"cellStyle";
    RepeatDaysSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    if (!cell) {
        NSArray * viewCells = [[NSBundle mainBundle] loadNibNamed:@"RepeatDaysSelectCell" owner:nil options:nil];
        if ([viewCells count]) {
            cell = [viewCells lastObject];
        }
    }
    
    cell.cellData = [self.weekDaysArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setRepeatDaysSelectTableView:nil];
    [super viewDidUnload];
}
@end
