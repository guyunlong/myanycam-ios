//
//  SystemSetAccountCell.m
//  Myanycam
//
//  Created by myanycam on 13/6/24.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "SystemSetAccountCell.h"
#import "MYDataManager.h"

@implementation SystemSetAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
                
    }
    
    return self;
}

- (void)updateView{
    
    self.accountLabel.text = [MYDataManager shareManager].userInfoData.accountName;
    NSString * imageName = nil;
    switch ([MYDataManager shareManager].userInfoData.loginType) {
        case LoginTypeNone:
            
            imageName = @"用户.png";
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
            self.accountLabel.text = [MYDataManager shareManager].userInfoData.qqNickname;

        }

            break;
        default:
            break;
    }
    
    UIImage * image = [UIImage imageNamed:imageName];
    self.accountStateImageView.image = image;
    self.accountStateImageView.layer.masksToBounds = YES;
    self.accountStateImageView.layer.cornerRadius = 6.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_accountStateImageView release];
    [_accountLabel release];
    [super dealloc];
}
@end
