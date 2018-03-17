//
//  TimeZoneViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "TimeZoneViewController.h"
#import "TimeZoneSelectViewController.h"
#import "Region.h"
#import "MYDataManager.h"

@interface TimeZoneViewController ()

@end

@implementation TimeZoneViewController
@synthesize timezoneArray;
@synthesize currentTimezone;

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
    [self showBackButton:nil action:nil buttonTitle:@"Back"] ;
    
    if (![MYDataManager shareManager].timezoneArray) {
        [MYDataManager shareManager].timezoneArray = [self displayList];
    }
    
    self.timezoneArray = [MYDataManager shareManager].timezoneArray;
    
    [self.timeZoneTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TimeZoneSelectViewController * controller = [[TimeZoneSelectViewController alloc] init];
    controller.region = [self.timezoneArray objectAtIndex:indexPath.row];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.timezoneArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * timzonestr = @"cellStyle";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:timzonestr];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timzonestr] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Region * region = [self.timezoneArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = region.name;
    
    return cell;
}

- (void)dealloc {
    [_timeZoneTableView release];
    
    self.timezoneArray = nil;
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTimeZoneTableView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Setting up the display list

- (NSArray *)displayList {
	/*
	 Return an array of Region objects.
	 Each object represents a geographical region.  Each region contains time zones.
	 Much of the information required to display a time zone is expensive to compute, so rather than using NSTimeZone objects directly use wrapper objects that calculate the required derived values on demand and cache the results.
	 */
    

	NSArray *knownTimeZoneNames = [NSTimeZone knownTimeZoneNames];
	
	NSMutableArray *regions = [NSMutableArray array];
	
	for (NSString *timeZoneName in knownTimeZoneNames) {
		
		NSArray *components = [timeZoneName componentsSeparatedByString:@"/"];
		NSString *regionName = [components objectAtIndex:0];
		
		Region *region = [Region regionNamed:regionName];
		if (region == nil) {
			region = [Region newRegionWithName:regionName];
			region.calendar = [self calendar];
			[regions addObject:region];
			[region release];
		}
		
		NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:timeZoneName];
		[region addTimeZone:timeZone nameComponents:components];
		[timeZone release];
	}
	
	NSDate *date = [NSDate date];
	// Now sort the time zones by name
	for (Region *region in regions) {
		[region sortZones];
		[region setDate:date];
	}
	// Sort the regions
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[regions sortUsingDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	return regions;
}

- (NSCalendar *)calendar {
    
	if (calendar == nil) {
		calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	}
	return calendar;
}




@end
