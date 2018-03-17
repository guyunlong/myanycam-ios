//
//  RecordVideoSetCellData.m
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "RecordVideoSetCellData.h"

@implementation RecordVideoSetCellData
@synthesize cellText;
@synthesize cellType;
@synthesize isSwitch;
@synthesize isSelect;

- (void)dealloc{
    self.cellText = nil;
    [super dealloc];
}

+ (RecordVideoSetCellData *)recordVideoSetCellData:(NSString *)cellText cellType:(CellDataType)cellType isSwitch:(BOOL)isSwitch isSelect:(BOOL)isSelect{
    
    RecordVideoSetCellData * cellData = [[[RecordVideoSetCellData alloc] init] autorelease];
    cellData.cellText = cellText;
    cellData.cellType = cellType;
    cellData.isSwitch = isSwitch;
    
    cellData.isSelect = isSelect;
    return cellData;
}

@end
