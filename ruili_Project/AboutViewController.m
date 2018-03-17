//
//  AboutViewController.m
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "AboutViewController.h"
#import "UINavigationItem+UINavigationItemTitle.h"
#import "MoreInfoViewController.h"


@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)prepareData{

//    self.aboutArray = [NSMutableArray arrayWithCapacity:5];
//    [self.aboutArray addObject:NSLocalizedString(@"Myanycam", nil)];
//    [self.aboutArray addObject:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Version", nil),KVersionStr]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareData];
    
    [self showBackButton:nil action:nil buttonTitle:@""];
    
//    NSURL * url = [NSURL URLWithString:KMyanycamUrl];
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    [self.aboutWebView loadRequest:request];
    
    NSString * moreInfo = NSLocalizedString(@"More Info", nil);
    [self.moreInfoButton setTitle:moreInfo forState:UIControlStateNormal];
    self.moreInfoButton.hidden = YES;
    [self.versionInfoButton setTitle:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Version", nil),KVersionStr] forState:UIControlStateNormal];
    self.versionInfoButton.enabled = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellTypeStr = @"StringCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellTypeStr];
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeStr] autorelease];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    cell.textLabel.text = [self.aboutArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.aboutArray count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_aboutWebView release];
    [_logoImageView release];
    [_aboutTableView release];
    [_weiboButton release];
    [_myanycanUrlButton release];
    [_copyrightshowLable release];
    [_moreInfoButton release];
    [_versionInfoButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAboutWebView:nil];
    [self setLogoImageView:nil];
    [self setAboutTableView:nil];
    [self setWeiboButton:nil];
    [self setMyanycanUrlButton:nil];
    [self setCopyrightshowLable:nil];
    [self setMoreInfoButton:nil];
    [self setVersionInfoButton:nil];
    [super viewDidUnload];
}
- (IBAction)officalWebButtonAction:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:KMyanycamUrl]];
}

- (IBAction)weiboButtonAction:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:KTwitterUrl]];

}
- (IBAction)moreInfoButtonAction:(id)sender {
    
    MoreInfoViewController * viewController = [[MoreInfoViewController alloc] init];
    [viewController.navigationItem setCustomTitle:NSLocalizedString(@"More Info", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];

    
    
}
@end
