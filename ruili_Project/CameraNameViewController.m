//
//  CameraNameViewController.m
//  Myanycam
//
//  Created by myanycam on 13-5-3.
//  Copyright (c) 2013年 Myanycam. All rights reserved.
//

#import "CameraNameViewController.h"
#import "AppDelegate.h"

@interface CameraNameViewController ()

@end

@implementation CameraNameViewController
@synthesize cameraName;
@synthesize cameraDescription ;
@synthesize cameraInfo = _cameraInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self showBackButton:self action:@selector(saveCameraChange) buttonTitle:@""];
    
    [self.nameTextField becomeFirstResponder];
    self.nameTextField.text = self.cameraInfo.cameraName;
    self.cameraDescription = self.cameraInfo.memo;
    
    self.cameraNameLabel.text = NSLocalizedString(@"Camera Nickname", nil);
    self.cameraDescriptionLabel.text =  NSLocalizedString(@"Camera Description", nil);
    
    
    if ([self.cameraInfo.memo isEqualToString:@""]) {
        
        self.descriptionTextView.text = NSLocalizedString(@"Camera Description",nil);
    }
    else{
        
        self.descriptionTextView.text = self.cameraInfo.memo;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.nameTextField resignFirstResponder];
    return YES;
    
}

#pragma UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    UIToolbar * keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = NO;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];

    UIBarButtonItem * doneButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    textView.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = -50;
        self.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
}

#pragma UITextViewDelegate

- (void)pickerDoneClicked:(id)sender{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.descriptionTextView resignFirstResponder];
}

- (void)saveCameraChange{
    
    if ([self.nameTextField.text length] == 0) {
        
        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Camera Name can not be blank", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        return;
    }
    
    if ([self.nameTextField.text length] > CAMERA_NAME_LENGTH) {
        
        [self showAlertView:NSLocalizedString(@"Error", nil) alertMsg:NSLocalizedString(@"Camera Name is too long", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        return;
    }
    
    [self.nameTextField resignFirstResponder];
    self.cameraDescription = self.descriptionTextView.text;
    
    if ([[AppDelegate getAppDelegate].mygcdSocketEngine isConnect]
        && (![self.cameraInfo.cameraName isEqualToString:self.nameTextField.text]
        || ![self.cameraInfo.memo isEqualToString:self.descriptionTextView.text])
        && self.cameraInfo.status != 0)
    {
        
        [AppDelegate getAppDelegate].mygcdSocketEngine.dealObject.cameraDelegate = self;
        [[AppDelegate getAppDelegate].mygcdSocketEngine sendInfoModifyCamera:self.cameraInfo cameraName:self.nameTextField.text cameraMemo:self.cameraDescription password:self.cameraInfo.password];
    }
    else{
        
        [self goBack];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_textFieldBackImageView release];
    [_nameTextField release];
    self.cameraName = nil;
    self.cameraDescription = nil;
    self.cameraInfo = nil;
    [_descriptionBackImageView release];
    [_descriptionTextView release];
    [_cameraNameLabel release];
    [_cameraDescriptionLabel release];
    [super dealloc];
}

- (void)modifySuccess{
    
    self.cameraInfo.cameraName = self.nameTextField.text;
    self.cameraInfo.memo = self.descriptionTextView.text;
    
     [self goBack];
}

- (void)modifyFailed{
    
     [self goBack];
}

- (void)viewDidUnload {
    [self setTextFieldBackImageView:nil];
    [self setNameTextField:nil];
    [self setDescriptionBackImageView:nil];
    [self setDescriptionTextView:nil];
    [self setCameraNameLabel:nil];
    [self setCameraDescriptionLabel:nil];
    [super viewDidUnload];
}
@end
