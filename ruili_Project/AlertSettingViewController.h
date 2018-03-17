//
//  AlertSettingViewController.h
//  Myanycam
//
//  Created by myanycam on 13-3-11.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "BaseViewController.h"


#import "AlertSettingViewCell.h"
@interface AlertSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AlertSettingViewCellDelegate,AlertSettingDelegate,AHAlertViewDelegate>{
    
    NSMutableArray      *_dataArray;
    NSInteger            _sectionCount;
}
@property (retain, nonatomic) CameraInfoData * cameraData;
@property (retain, nonatomic) IBOutlet UIImageView *skipForAlertSetImageView;
@property (retain, nonatomic) IBOutlet UILabel *setTimeTipLabel;
@property (retain, nonatomic) IBOutlet UIButton *setAlertTimeButton;
@property (retain, nonatomic) IBOutlet UITableView *alertSettingTableView;
@property (retain, nonatomic) NSMutableArray    *dataArray;
@property (retain, nonatomic) NSMutableArray    *firstSectionDataArray;
@property (retain, nonatomic) NSMutableArray    *alertTypeDataArray;
- (IBAction)setAlertTimeButtonAction:(id)sender;

@end
