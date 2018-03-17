//
//  VideoQualityChangeView.m
//  Myanycam
//
//  Created by myanycam on 13/10/17.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "VideoQualityChangeView.h"

@implementation VideoQualityChangeView
@synthesize dataArray;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self prepareData];
    }
    
    return self;
}

- (void)prepareData{
    
    self.dataArray = [NSMutableArray arrayWithCapacity:3];
    [self.dataArray addObject:NSLocalizedString(@"Best", nil)];
    [self.dataArray addObject:NSLocalizedString(@"Better", nil)];
    [self.dataArray addObject:NSLocalizedString(@"Good", nil)];
//    [self.dataArray addObject:NSLocalizedString(@"Auto", nil)];
    [self.qualitySelectTableView reloadData];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString * cellStyle = @"defaultStyle";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyle] autorelease];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:11.0];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    self.qualitySelectTableView.scrollEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectVideoQualityWithIndex:)]) {
        
        [self.delegate didSelectVideoQualityWithIndex:indexPath.row];
    }
    
}

- (void)dealloc {
    
    [_qualitySelectTableView release];
    self.dataArray = nil;
    self.delegate = nil;
    
    [super dealloc];
}

@end
