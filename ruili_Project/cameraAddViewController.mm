//
//  cameraAddViewController.m
//  myanycam
//
//  Created by andida on 13-1-15.
//  Copyright (c) 2013年 andida. All rights reserved.
//

#import "cameraAddViewController.h"
#import "AppDelegate.h"
#import "dealWithCommend.h"
#import "MyMD5.h"
#import "navButton.h"
#import "navTitleLabel.h"
#import "QRCodeReader.h"
#import "UINavigationItem+UINavigationItemTitle.h"


#ifndef ZXQR
#define ZXQR 1
#endif

#if ZXQR
#import "QRCodeReader.h"
#endif

#ifndef ZXAZ
#define ZXAZ 0
#endif

#if ZXAZ
#import "AztecReader.h"
#endif


@interface cameraAddViewController ()

@end

@implementation cameraAddViewController

@synthesize cameraPassword=_cameraPassword;
@synthesize cameraSn=_cameraSn;
@synthesize zxingController = _zxingController;
@synthesize cameraName;
@synthesize cameraPwd;
@synthesize cameraSnStr;


-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
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
    self.isShowBottomBar = NO;
    
    if ([ToolClass systemVersionFloat] >= 7.0) {
        
        CGRect fr = self.cameraAddNavBar.frame;
        fr.size.height = 64;
        self.cameraAddNavBar.frame = fr;
        
        fr = self.backView.frame;
        fr.origin.y = 64;
        self.backView.frame = fr;
    }

    
    [_cameraAddNavBar setBackgroundImage:[[UIImage imageNamed:@"topBar.png"] resizableImage] forBarMetrics:UIBarMetricsDefault];
//    navTitleLabel *titleLabel=[[navTitleLabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44) title:NSLocalizedString(@"Add Camera",nil )];
//    _cameraAddNavItem.titleView=titleLabel;
//    [titleLabel release];
    
    [_cameraAddNavItem setCustomTitle:NSLocalizedString(@"Add Camera", nil)];

    
    NSString * imageNormalStr = @"icon_Return.png";
    NSString * imageSelectStr = @"icon_Return_hover.png";
    UIBarButtonItem *backButton = [ViewToolClass customBarButtonItem:imageNormalStr buttonSelectImage:imageSelectStr title:NSLocalizedString(@"", nil) size:CGSizeMake(32, 32) target:self action:@selector(backAction:)];
    _cameraAddNavItem.leftBarButtonItem=backButton;
    
    
    [[self appDelegate] mygcdSocketEngine].dealObject.cameraAddDegate=self;
    
    _cameraSn.delegate=self;
    _cameraPassword.delegate=self;
    
    self.cameraSn.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;

    if (self.cameraSnStr) {
        
         [self.nameTextField becomeFirstResponder];
    }
    else
    {
         [self.cameraSn becomeFirstResponder];
    }
   
//    self.addCameraBackView.layer.masksToBounds = YES;
//    self.addCameraBackView.layer.cornerRadius = 6;
//    self.addCameraBackView.backgroundColor = [UIColor colorWithRed:20/255.0 green:21/255.0 blue:23/255.0 alpha:1.0];
//    UIColor * BlueColor = [UIColor colorWithRed:91/255.0 green:169/255.0 blue:252/255.0 alpha:1.0];
//    [self.addCameraBackView addBorderToView:BlueColor borderWidth:2.0 cornerRadius:6.0];
    
    [self.sureEnterButton setTitleWithStr:NSLocalizedString(@"Add", nil) fontSize:FONT_SIZE];
    [self.qrScanButton setTitleWithStr:NSLocalizedString(@"QR Scan", nil) fontSize:FONT_SIZE];
    
    self.nameTextField.placeholder = NSLocalizedString(@"Camera Nickname", nil);
    self.cameraPassword.placeholder = NSLocalizedString(@"Password", nil);
    self.cameraSn.placeholder = NSLocalizedString(@"sn", nil);
    
    [self.cameraSn setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.cameraPassword setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTextField setValue:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];

    if (self.cameraPwd && self.cameraSnStr) {
        
        self.cameraPassword.text = self.cameraPwd;
        self.cameraSn.text = self.cameraSnStr;
        self.nameTextField.text = self.cameraName;
    }
    
    MYGestureRecognizer * gesture = [[MYGestureRecognizer alloc] initWithTarget:self action:@selector(clearInputTextField)];
    [self.backImageView addGestureRecognizer:gesture];
    [gesture release];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)clearInputTextField{
    
    [self.nameTextField resignFirstResponder];
    [self.cameraPassword resignFirstResponder];
    [self.cameraSn resignFirstResponder];
    self.backImageView.userInteractionEnabled = NO;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self hideBottomBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    
    [self customDismissModalViewControllerAnimated:YES];
}

- (IBAction)cameraAddAction:(id)sender {
    
    self.cameraSn.text = [self.cameraSn.text uppercaseString];
    
    if ([_cameraSn.text isEqualToString:@""]) {
        
        [dealWithCommend noticeAlertView:NSLocalizedString(@"Error Tip Right sn", nil)];//请输入正确的序列号！Please enter the correct serial number!
        return;
    }
    
    if ([_cameraPassword.text isEqualToString:@""]) {
        
        [dealWithCommend noticeAlertView:NSLocalizedString(@"Enter password", nil)];//请输入密码！
        return;
    }
    
    if ([self.nameTextField.text length] == 0) {
        
        [dealWithCommend noticeAlertView:NSLocalizedString(@"Enter Camera Nickname", nil)];//请输入摄像头名字！
        return;
    }
    
//    hchome
    {

        [self.cameraPassword resignFirstResponder];
        [self.cameraSn resignFirstResponder];
        
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
//        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        
        NSString * cmd = [BuildSocketData buildAddCamera:[MYDataManager shareManager].userInfoData.userId
                                                cameraSn:_cameraSn.text
                                                password:_cameraPassword.text name:self.nameTextField.text type:0 timezone:interval];
        [[[self appDelegate] mygcdSocketEngine] writeDataOnMainThread:cmd tag:0 waitView:YES];
        [[[self appDelegate] window] addActivityView];
    }
}

//- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result{
//     NSLog(@"%@",result);
//    
//    NSArray * resultArray = [result componentsSeparatedByString:@"#"];
//    
//    if ([resultArray count] >1) {
//        
//        self.cameraSn.text = [resultArray objectAtIndex:0];
//        self.cameraSn.text = [self.cameraSn.text uppercaseString];
//        self.cameraPassword.text = [resultArray objectAtIndex:1];
//        
//        [self.cameraPassword resignFirstResponder];
//        [self.cameraSn resignFirstResponder];
//        [self.nameTextField becomeFirstResponder];
//
//        self.nameTextField.text = [NSString stringWithFormat:@"Myanycam_%@",[self.cameraSn.text substringWithRange:NSMakeRange([self.cameraSn.text length]- 1,1)]];
//        
//    }
//    
//    if ([ToolClass systemVersionFloat] >= 5.0) {
//        
//        [controller dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
//    else {
//        
//        [controller dismissModalViewControllerAnimated:YES];
//    }
//}

//- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller{
//   
//    if ([ToolClass systemVersionFloat] >= 5.0) {
//        [controller dismissViewControllerAnimated:YES completion:^{
//        }];
//    }
//    else {
//        [controller dismissModalViewControllerAnimated:YES];
//    }
//}

//- (IBAction)catchByZBarSDK:(id)sender {
//    
//    
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        
//        [self showAlertView:nil alertMsg:NSLocalizedString(@"Your Device Without Camera", nil) userInfo:nil delegate:nil canclButtonStr:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//        
//        return;
//    }
//
//    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
//    
//    NSMutableSet *readers = [[NSMutableSet alloc ] init];
//    
//#if ZXQR
//    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
//    [readers addObject:qrcodeReader];
//    [qrcodeReader release];
//#endif
//    
//#if ZXAZ
//    AztecReader *aztecReader = [[AztecReader alloc] init];
//    [readers addObject:aztecReader];
//    [aztecReader release];
//#endif
//    
//    widController.readers = readers;
//    [readers release];
//    
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    widController.soundToPlay =  [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
//    [self customPresentModalViewController:widController animated:YES];
//    [widController release];
//}

- (void)dealloc {
    [_cameraSn release];
    [_cameraPassword release];
    [_cameraAddNavBar release];
    [_cameraAddNavItem release];
    self.zxingController = nil;
    [_sureEnterButton release];
    [_qrScanButton release];
    [_addCameraBackView release];
    [_nameTextField release];
    [_backView release];
    self.cameraSnStr = nil;
    self.cameraName = nil;
    self.cameraPwd = nil;
    [_backImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCameraSn:nil];
    [self setCameraPassword:nil];
    [self setCameraAddNavBar:nil];
    [self setCameraAddNavItem:nil];
    [self setSureEnterButton:nil];
    [self setQrScanButton:nil];
    [self setAddCameraBackView:nil];
    [self setNameTextField:nil];
    [self setBackImageView:nil];
    [super viewDidUnload];
}

#pragma mark cameraAddDegate

-(void)cameraAddSuccess
{

    dispatch_async(dispatch_get_main_queue(), ^{
    
        MYAlertView *alertView=[[MYAlertView alloc] initWithTitle:NSLocalizedString(@"Add Success", nil) message:NSLocalizedString(@"Add Success", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
        [alertView release];

    });
    
}

-(void)cameraAddFailed:(NSString *)res
{
    dispatch_async(dispatch_get_main_queue(),^{
    
        [dealWithCommend noticeAlertView:[NSString stringWithFormat:@"%@,%@",NSLocalizedString(@"Add Failed", nil),res]];
    });
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
//        NSString *cmd = [BuildSocketData buildDownloadCamera:[MYDataManager  shareManager].userInfoData.userId];
//        [[self appDelegate].mygcdSocketEngine writeDataOnMainThread:cmd tag:0 waitView:YES];
//         [self customDismissModalViewControllerAnimated:YES];
        
        UIViewController * controller = self.presentingViewController;
        
        [self dismissViewControllerAnimated:NO completion:^{
            
//            UIViewController * c = controller.presentingViewController;
            
            [controller dismissViewControllerAnimated:NO completion:^{
                
                
            }];
        }];
        
    }
}
#pragma mark 二维码委托

- (void)qrScanViewDelegate:(NSDictionary *)resultDict{
    
    NSLog(@"%@",resultDict);
}

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        break;
//    
//    [picker dismissModalViewControllerAnimated:YES];
//    //判断是否包含 头'ssid:'
//    NSString *ssid = @"ssid+:[^\\s]*";;
//    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
//    
//   // label.text =  symbol.data ;
//    if([ssidPre evaluateWithObject:symbol.data]){
//        
//        NSArray *arr = [symbol.data componentsSeparatedByString:@";"];
//        
//        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
//        
//        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
//        
//        
//        _cameraSn.text=[arrInfoHead objectAtIndex:1];
//        _cameraPassword.text=[arrInfoFoot objectAtIndex:1];
//        
//    }
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.cameraSn == textField) {
        
        self.cameraSn.text = [self.cameraSn.text uppercaseString];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.backImageView.userInteractionEnabled = YES;
}

#pragma mark textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    
    [textField resignFirstResponder];
    return YES;
}
@end
