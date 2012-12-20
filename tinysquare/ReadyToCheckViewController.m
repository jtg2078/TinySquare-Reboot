//
//  ReadyToCheckViewController.m
//  asoapp
//
//  Created by wyde on 12/6/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "ReadyToCheckViewController.h"
#import "UINavigationController+Customize.h"
#import "EggApiManager.h"
#import "TmpCart.h"
#import "LoginMember.h"
#import "MKInfoPanel.h"
#import "SVWebViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ReadyToCheckViewController ()

@end

@implementation ReadyToCheckViewController
@synthesize managedObjectContext;

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
	// Do any additional setup after loading the view.
    [self setupNavigationBarButtons];
    
    /*
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(60+14, 224, 172, 34);
    [loginButton setTitle:@"結帳" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(checkConfirmed:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
     LoginMember *lm=[LoginMember getMemberIfExistWithId:0 inManagedObjectContext:managedObjectContext];
    UILabel *checkmoney=[[UILabel alloc] initWithFrame:CGRectMake(60, 150, 200, 30)];
    checkmoney.backgroundColor=[UIColor clearColor];
    checkmoney.textAlignment=UITextAlignmentCenter;
    NSNumber *howmuch;
    howmuch=lm.totalMoney;
    checkmoney.text=[NSString stringWithFormat: @"總共 %@",howmuch];
    [self.view addSubview:checkmoney];
     */
    
    [self addLabelToMainView:@"您好" x:90 y:81 width:214 height:18 fontsize:17 alignment:UITextAlignmentLeft];
    [self addLabelToMainView:@"結帳總金額為" x:90 y:110 width:78 height:13 fontsize:12 alignment:UITextAlignmentLeft];
    [self addLabelToMainView:@"填寫連絡資料：" x:22 y:147 width:282 height:16 fontsize:15 alignment:UITextAlignmentLeft];
     [self addLabelToMainView:@"宅配地址：" x:22 y:187 width:66 height:14 fontsize:13 alignment:UITextAlignmentLeft];
     [self addLabelToMainView:@"連絡電話：" x:22 y:232 width:66 height:14 fontsize:13 alignment:UITextAlignmentLeft];
     [self addLabelToMainView:@"填寫資料並決定付款" x:16 y:14 width:288 height:16 fontsize:15 alignment:UITextAlignmentLeft];
    [self addImageToMainView:@"user-PicBG.png" :24 :73 :56 :56];
    [self addImageToMainView:@"buy-step2.png" :13 :37:295:21];
    
    
    UITextField *deli_address=[[UITextField alloc] initWithFrame:CGRectMake(89, 178, 200, 35)];
    deli_address.background=[UIImage imageNamed:@"textFieldBG" ];
    deli_address.keyboardType=UIKeyboardTypeDefault;
    deli_address.autocapitalizationType=NO;
    deli_address.font=[UIFont systemFontOfSize:16.0];
    deli_address.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    deli_address.returnKeyType=UIReturnKeyDone;
    [deli_address setPlaceholder:@"*請輸入您的宅配地址"];
    [deli_address addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:deli_address];
    
    UITextField *deli_phone=[[UITextField alloc] initWithFrame:CGRectMake(89, 223, 200, 35)];
    deli_phone.background=[UIImage imageNamed:@"textFieldBG" ];
    deli_phone.keyboardType=UIKeyboardTypeDefault;
    deli_phone.autocapitalizationType=NO;
    deli_phone.font=[UIFont systemFontOfSize:16.0];
    deli_phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    deli_phone.returnKeyType=UIReturnKeyDone;
    [deli_phone setPlaceholder:@"*請輸入您的連絡電話"];
    [deli_phone addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:deli_phone];

    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(29,289, 265, 35);
    [loginButton setTitle:@"使用信用卡付款" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(checkConfirmed:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    

}

-(void) addLabelToMainView:(NSString *)labelText x:(CGFloat)locationX y:(CGFloat)locationY width:(CGFloat)width height:(CGFloat)height fontsize:(CGFloat)fontsize alignment:(UITextAlignment)alignmentType
{
    UILabel *textFieldInfo=[[UILabel alloc] initWithFrame:CGRectMake(locationX, locationY, width, height)];
    textFieldInfo.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    textFieldInfo.text=labelText;
    textFieldInfo.font=[UIFont systemFontOfSize:fontsize];
    textFieldInfo.textAlignment=alignmentType;
    [self.view addSubview:textFieldInfo];
    [textFieldInfo release];
    
}

-(void) addImageToMainView:(NSString *)imageFilePath:(CGFloat) locationX:(CGFloat) locationY:(CGFloat) width:(CGFloat)height
{
    UIImageView *iconArea=[[UIImageView alloc] initWithFrame:CGRectMake(locationX, locationY, width, height)];
        iconArea.image=[UIImage imageNamed:imageFilePath];
    [self.view addSubview:iconArea];
    [iconArea release];
}
     
-(void)checkConfirmed:(id)sender
{
    [self updateCheckBill];
}

-(void) textFieldDidEndEditing:(id) sender
{
    [sender resignFirstResponder];
}

-(void)updateCheckBillCompleted:(EggApiManager *)manager
{
    LoginMember *lm=[LoginMember getMemberIfExistWithId:0 inManagedObjectContext:managedObjectContext];
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:lm.payUrl];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];

}

-(void)updateCheckBillFailed:(EggApiManager *)manager
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeError
                           title:NSLocalizedString(@"登入伺服器失敗... 請稍後再試", nil) 
                        subtitle:nil
                       hideAfter:4];
}

-(void) updateCheckBill
{
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    LoginMember *lm=[LoginMember getMemberIfExistWithId:0 inManagedObjectContext:managedObjectContext];
    NSString *cookie=lm.cookie;

    if (cookie) 
    {
        if(apiManager.isUpdatingLogin == NO)
        {
            [apiManager updateCheckBill:lm.orderId loginMember:cookie];
            apiManager.updateCheckBillDelegate=self;
            
        }
    }
    else {
        
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeProgress
                               title:NSLocalizedString(@"請先自會員系統登入", nil) 
                            subtitle:nil
                           hideAfter:2];
    }
    

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)setupNavigationBarButtons
{
    UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
