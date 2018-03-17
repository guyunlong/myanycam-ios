//
//  MYUIPickerView.m
//  myanycam
//
//  Created by myanycam on 13-2-25.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "MYUIPickerView.h"

@implementation MYUIPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setPickerViewDelegate:(id<UIPickerViewDelegate>)delegate dataDelegate:(id<UIPickerViewDataSource>)dataDelegate{
    
    [self.customPickerView setDataSource:dataDelegate];
    [self.customPickerView setDelegate:delegate];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)finishButtonAction:(id)sender {
    [self customHideWithAnimation:YES duration:0.3];
}

- (void)reloadPickerView{
    [self.customPickerView reloadAllComponents];
}
- (void)dealloc {
    [_customPickerView release];
    [_finishButton release];
    [_toolBarBgImageView release];
    [super dealloc];
}
@end
