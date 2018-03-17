//
//  AlertEventListViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-2.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AlertEventListViewController.h"
#import "AlertEventListCell.h"
#import "AlertAQGridViewCell.h"
#import "EventAlertViewController.h"
#import "MYDataManager.h"

@interface AlertEventListViewController ()

@end

@implementation AlertEventListViewController
@synthesize cameraList;


- (void)dealloc{
    self.cameraList = nil;
    [_cameraListTableView release];
    self.navigationBar = nil;
    [_alertGridView release];
    [_topNavigationItem release];
    [super dealloc];
}

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
    self.isShowBottomBar = YES;
    [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];
    self.cameraList = [[MYDataManager shareManager].cameraListDiction allValues];
    self.topNavigationItem.title = NSLocalizedString(@"Event", nil);
//    [self.cameraListTableView reloadData];
    
    // grid view sits on top of the background image
    self.alertGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.alertGridView.backgroundColor = [UIColor clearColor];
    self.alertGridView.opaque = NO;
    [self.alertGridView setRequiresSelection:YES];
    
    if ( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) )
    {
        // bring 1024 in to 1020 to make a width divisible by five
        self.alertGridView.leftContentInset = 2.0;
        self.alertGridView.rightContentInset = 2.0;
    }
    
    [self.alertGridView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCameraListTableView:nil];
    [self setNavigationBar:nil];
    [self setAlertGridView:nil];
    [self setTopNavigationItem:nil];
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.cameraList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellStyle = @"alertEventCell";
    AlertEventListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    if (!cell) {
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"AlertEventListCell" owner:nil options:nil];
        if ([views count]) {
            cell = [views lastObject];
        }
    }
    
    cell.cameraInfo = [self.cameraList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54.0;
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView{
    
    return [self.cameraList count];
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index{
    
    static NSString * CellIdentifier = @"CellIdentifier";
    
    AlertAQGridViewCell * cell = (AlertAQGridViewCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[AlertAQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 90, 90) reuseIdentifier:CellIdentifier];
//        [cell contentView].backgroundColor = [UIColor orangeColor];
    }
    
    DebugLog(@" cell.index %d",index);
    CameraInfoData * cameraData = [self.cameraList objectAtIndex:index];
    cell.cameraData = cameraData;
    return ( cell );
}

// all cells are placed in a logical 'grid cell', all of which are the same size. The default size is 96x128 (portrait).
// The width/height values returned by this function will be rounded UP to the nearest denominator of the screen width.
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView{
    
    return CGSizeMake(100, 100);
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index{
    
    
    CameraInfoData * data = [self.cameraList objectAtIndex:index];
    if (data.status != 0)//
    {
        
        EventAlertViewController * controller = [[EventAlertViewController alloc] init];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.cameraInfo = data;
        [self customPresentModalViewController:controller animated:YES];
        [controller release];
        
        AlertAQGridViewCell * cell  = (AlertAQGridViewCell *)[gridView cellForItemAtIndex:index];
        cell.eventNumberView.value = 0;
        
        CameraInfoData * cameraData = [self.cameraList objectAtIndex:index];
        [[MYDataManager shareManager].alertNumberDict removeObjectForKey:[NSNumber numberWithInt:cameraData.cameraId]];
        
        
    }
    else{
        
        [self showAlertView:@"" alertMsg:NSLocalizedString(@"Camera is offline", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    }
    

}

@end
