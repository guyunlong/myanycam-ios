//
//  MYUIPickerView.h
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYUIPickerView : UIView
{
    
}
@property (retain, nonatomic) IBOutlet UIPickerView *customPickerView;
@property (retain, nonatomic) IBOutlet MYBaseButton *finishButton;
@property (retain, nonatomic) IBOutlet UIImageView *toolBarBgImageView;
- (IBAction)finishButtonAction:(id)sender;

- (void)reloadPickerView;
- (void)setPickerViewDelegate:(id<UIPickerViewDelegate>)delegate dataDelegate:(id<UIPickerViewDataSource>)dataDelegate;
@end
