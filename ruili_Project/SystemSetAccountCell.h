//
//  SystemSetAccountCell.h
//  Myanycam
//
//  Created by myanycam on 13/6/24.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemSetAccountCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *accountStateImageView;
@property (retain, nonatomic) IBOutlet UILabel *accountLabel;

- (void)updateView;

@end
