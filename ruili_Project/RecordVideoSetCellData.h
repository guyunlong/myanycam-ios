//
//  RecordVideoSetCellData.h
//  Myanycam
//
//  Created by myanycam on 13-2-28.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordVideoSetCellData : NSObject
@property (retain, nonatomic)     NSString    * cellText;
@property (assign, nonatomic)     CellDataType cellType;
@property (assign, nonatomic)     BOOL          isSwitch;
@property (assign, nonatomic)     BOOL          isSelect;


+ (RecordVideoSetCellData *)recordVideoSetCellData:(NSString *)cellText cellType:(CellDataType)cellType isSwitch:(BOOL)isSwitch isSelect:(BOOL)isSelect;

@end
