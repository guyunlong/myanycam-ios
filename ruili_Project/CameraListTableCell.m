//
//  CameraListTableCell.m
//  Myanycam
//
//  Created by myanycam on 13-3-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraListTableCell.h"

@implementation CameraListTableCell
@synthesize cellCameraData  = _cellCameraData;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellCameraData:(CameraInfoData *)cellCameraData{
    
    if (_cellCameraData != cellCameraData) {
        
//        [_cellCameraData removeObserver:self forKeyPath:@"status"];
        [_cellCameraData removeObserver:self forKeyPath:@"iSselect"];
        
        [_cellCameraData release];
        _cellCameraData = [cellCameraData retain];
    }
    
    if(cellCameraData){
        
        BOOL flag = cellCameraData.status == 1?YES : NO;
        self.cameraName.text = cellCameraData.cameraName;
        self.cameraStateLabel.text = flag?@"On":@"Off";
        NSString * imageStr = flag?@"摄像头在线.png":@"摄像头不在线.png";
        self.cameraStateImageView.image = [UIImage imageNamed:imageStr];
        
//        [cellCameraData addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [cellCameraData addObserver:self forKeyPath:@"iSselect" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        if (self.cellCameraData.status == 1) {
            
            self.settingButton.hidden = NO;
        }
        else
        {
            self.settingButton.hidden = YES;
        }
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        
        if (self.cellCameraData.status == 1) {
            
            self.cameraStateLabel.text = @"On";
            NSString * imageStr = @"摄像头在线.png";
            self.cameraStateImageView.image = [UIImage imageNamed:imageStr];
            self.settingButton.hidden = NO;
        }
        
        if (self.cellCameraData.status == 0) {
            
            NSString * imageStr = @"摄像头不在线.png";
            self.cameraStateLabel.text = @"Off";
            self.cameraStateImageView.image = [UIImage imageNamed:imageStr];
             self.settingButton.hidden = YES;
        }
    }
    
    if ([keyPath isEqualToString:@"iSselect"]) {
        
        if (self.cellCameraData.iSselect) {
            
            [self updateSelectState];
        }
        else{
            
            [self updateDeSelectState];
        }
    }
}

- (void)updateSelectState{
    
    [UIView transitionWithView:self
                      duration:0.05f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.cellBackImageView.image = [[UIImage imageNamed:@"选择条.png"] resizableImage];
                    } completion:NULL];
    
    self.cellBackImageView.alpha = 0.6;
    
}

- (IBAction)settingButton:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraSettingWithCameraData:)]) {
        
        [self.delegate cameraSettingWithCameraData:self.cellCameraData];
    }
}

- (void)updateDeSelectState{
        
    [UIView transitionWithView:self
                      duration:0.05f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.cellBackImageView.image = nil;//[[UIImage imageNamed:@"底条.png"] resizableImage];
                    } completion:NULL];
    
//    self.cellBackImageView.layer.masksToBounds = YES;
//    self.cellBackImageView.layer.cornerRadius = 6.0;
}

- (void)dealloc {
    
    [_cameraStateImageView release];
    [_cameraName release];
    [_cameraStateLabel release];
    [_cellBackImageView release];
    self.cellCameraData = nil;
    self.delegate = nil;

    [_settingButton release];
    [super dealloc];
}
@end
