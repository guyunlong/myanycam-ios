//
//  CameraSetTableViewCell.m
//  KCam
//
//  Created by myanycam on 2014/5/28.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "CameraSetTableViewCell.h"


@implementation CameraSetData
@synthesize cellText;
@synthesize cameraSetType;

- (void)dealloc{
    
    self.cellText = nil;
    [super dealloc];
    
}

+ (CameraSetData *)cameraSetDataWithCellText:(NSString *)cellTextStr cellSetType:(CameraSetType)setType{
    
    CameraSetData * data = [[CameraSetData alloc] init];
    data.cellText = cellTextStr;
    data.cameraSetType = setType;
    return [data autorelease];

}

@end



@implementation CameraSetTableViewCell
@synthesize cellData = _cellData;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        
        self.cellBackImageView.backgroundColor = [UIColor colorWithRed:50/255.0 green:51/255.0 blue:53/255.0 alpha:1.0];
    }
    else
    {
        self.cellBackImageView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    }
}


- (void)setCellData:(CameraSetData *)cellData
{
    if (_cellData != cellData) {
        [_cellData release];
        _cellData = [cellData retain];
    }
    
    if (cellData) {
        
        self.cellNameLabel.text = cellData.cellText;
        self.checkImageView.hidden = NO;
        if(cellData.cameraSetType == CameraSetType_Sn){
            
            self.checkImageView.hidden = YES;
        }
    }
}

- (void)dealloc {
    
    [_cellBackImageView release];
    [_cellNameLabel release];
    [_checkImageView release];
    self.cellData = nil;
    
    [super dealloc];
}
@end
