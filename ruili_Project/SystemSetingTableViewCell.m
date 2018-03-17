//
//  SystemSetingTableViewCell.m
//  KCam
//
//  Created by myanycam on 2014/5/27.
//  Copyright (c) 2014年 Myanycam. All rights reserved.
//

#import "SystemSetingTableViewCell.h"
#import "MYDataManager.h"



@implementation SystemSetData
@synthesize cellText;
@synthesize systemType;

- (void)dealloc{
    
    self.cellText = nil;
    [super dealloc];
}

+ (SystemSetData *)SystemDataWith:(NSString *)cellTextStr setType:(SystemSetType)setType{
    
    SystemSetData * data = [[SystemSetData alloc] init];
    data.cellText = cellTextStr;
    data.systemType = setType;
    return [data autorelease];
}

@end


@implementation SystemSetingTableViewCell
@synthesize cellData = _cellData;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {

        self.cellBackImageView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    }
    else
    {
        self.cellBackImageView.backgroundColor = [UIColor whiteColor];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}

- (void)setCellData:(SystemSetData *)cellData{
    
    if (_cellData != cellData) {
        
        [_cellData release];
        _cellData = [cellData retain];
    }
    
    if (cellData) {
        
        self.cellNameLabel.text = cellData.cellText;
        
        if (cellData.systemType == SystemSetType_Account) {
            
            self.cellChevronImageView.hidden = YES;
            self.cellNameLabel.text = [MYDataManager shareManager].userInfoData.accountName;
            NSString * imageName = nil;
            switch ([MYDataManager shareManager].userInfoData.loginType) {
                    
                case LoginTypeNone:
                    
                    imageName = @"icon13.png";
                    break;
                case LoginTypeFacebook:
                    imageName = @"sns_icon_10@2x.png";
                    break;
                case LoginTypeTwitter:
                    imageName = @"sns_icon_11@2x.png";
                    break;
                case LoginTypeQQ:
                {
                    imageName = @"sns_qq_icon@2x.png";
                    self.cellNameLabel.text = [MYDataManager shareManager].userInfoData.qqNickname;
                }
                    
                    break;
                default:
                    break;
            }
            
            UIImage * image = [[UIImage imageNamed:imageName] resizableImage];
            self.cellImage.image = image;
//            self.cellImage.layer.masksToBounds = YES;
//            self.cellImage.layer.cornerRadius = 6.0;
        }
        else{
            self.cellChevronImageView.hidden = NO;
            
            if (cellData.systemType == SystemSetType_ChangePassword ) {
                
                UIImage * image = [[UIImage imageNamed:@"icon14.png"] resizableImage];
                self.cellImage.image = image;
            }
            if (cellData.systemType == SystemSetType_About) {
                
                UIImage * image = [[UIImage imageNamed:@"icon15.png"] resizableImage];
                self.cellImage.image = image;
            }
        }
        
        
    }
}

- (void)dealloc {
    
    self.cellData = nil;
    
    [_cellImage release];
    [_cellBackImageView release];
    [_cellChevronImageView release];
    [_cellNameLabel release];
    [super dealloc];
}
@end







