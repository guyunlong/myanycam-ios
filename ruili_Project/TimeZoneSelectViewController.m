//
//  TimeZoneSelectViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "TimeZoneSelectViewController.h"
#import "TimeZoneWrapper.h"

@interface TimeZoneSelectViewController ()

@end

@implementation TimeZoneSelectViewController
@synthesize region;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DebugLog(@"");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.region.timeZoneWrappers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * timzonestr = @"cellStyle";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:timzonestr];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timzonestr] autorelease];
    }
    
    TimeZoneWrapper * timeZonewrapper = [self.region.timeZoneWrappers objectAtIndex:indexPath.row];
    
    cell.textLabel.text =  [NSString stringWithFormat:@"%@=%@",timeZonewrapper.timeZoneLocaleName,timeZonewrapper.timeZone.name];//;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_timezoneSelectTableView release];
    self.region = nil;
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTimezoneSelectTableView:nil];
    [super viewDidUnload];
}
@end
