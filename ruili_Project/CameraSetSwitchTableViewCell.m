//
//  CameraSetSwitchTableViewCell.m
//  KCam
//
//  Created by myanycam on 2014/5/29.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "CameraSetSwitchTableViewCell.h"

@implementation CameraSetSwitchTableViewCell
@synthesize cellData = _cellData;
@synthesize delegate;


- (void)awakeFromNib
{
    // Initialization code
    
    [self.cellSwitch setDidChangeHandler:^(BOOL isOn) {
        
        NSLog(@"Biggest switch changed to %d", isOn);
        if(self.delegate && [self.delegate respondsToSelector:@selector(cameraSetSwitchChange:)])
        {
            [self.delegate cameraSetSwitchChange:self];
        }
//        [self performSelector:@selector(respondSwitch) withObject:nil afterDelay:0.2];
    }];
}

- (void)respondSwitch{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cameraSetSwitchChange:)])
    {
        [self.delegate cameraSetSwitchChange:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        
        self.cellBackImageView.backgroundColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
    }
    else
    {
        self.cellBackImageView.backgroundColor = [UIColor colorWithRed:51/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
    }
}

- (void)setCellData:(RecordVideoSetCellData *)cellData
{
    if(cellData != _cellData)
    {
        [_cellData release];
        _cellData = [cellData retain];
    }
    
    if(cellData)
    {
        self.cellTextLabel.text = cellData.cellText;
        
        if(cellData.isSelect){
            
            [self.cellSwitch setOn:YES animated:NO];
        }
        else
        {
            [self.cellSwitch setOn:NO animated:NO];
        }
    }
}

- (void)dealloc {
    
    [_cellTextLabel release];
    [_cellSwitch release];
    [_cellBackImageView release];
    self.cellData = nil;
    self.delegate = nil;
    
    [super dealloc];
}
@end
