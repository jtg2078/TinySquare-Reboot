//
//  MemberRegisterationViewController.m
//  asoapp
//
//  Created by wyde on 12/4/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define TEXTFIELD_X_COR                  90
#define TEXTFIELD_ACCOUNT_Y_COR          77
#define TEXTFIELD_PASSWORD_Y_COR        122
#define TEXTFIELD_PASSCONFIRM_Y_COR     167
#define TEXTFIELD_NAME_Y_COR            296
#define TEXTFIELD_LIVEADDRESS_Y_COR     341
#define TEXTFIELD_PHONE_Y_COR           386
#define TEXTFIELD_GENDER_Y_COR             431
#define TEXTFIELD_BIRTH_Y_COR              476



#import "MemberRegisterationViewController.h"
#import "UINavigationController+Customize.h"
#import "EggApiManager.h"
#import "MKInfoPanel.h"
#import "Membership.h"
#import "JSONKit.h"
#import "DictionaryHelper.h"
#import "LoginMember.h"
#import "MemberIndexViewController.h"


@interface MemberRegisterationViewController()
{
    
    UITextField *account;
    UITextField *password;
    UITextField *passconfirm;
    UITextField *membername;
    UITextField *liveaddress;
    UITextField *phonenumber;
    UITextField *birthday;
    UITextField *gender;
    UIButton    *checkbutton;
    BOOL        checkcontrol;
    BOOL        readyToRegister;
    

}
@end

@implementation MemberRegisterationViewController
@synthesize modelManager=_modelManager;
@synthesize managedObjectContext;
@synthesize lastUpdateTime=_lastUpdateTime;

/*
@synthesize phonenumber;
@synthesize account;
@synthesize password;
@synthesize membername;
@synthesize passconfirm;
@synthesize liveaddress;
*/
 
#pragma mark - 
#pragma mark init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title= NSLocalizedString(@"註冊", nil);
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
 
    
    scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0,320, 480-115)]; 
    scrollView.delegate = self;
    //[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setContentSize:CGSizeMake(292, 575)];
    
    scrollView.showsVerticalScrollIndicator = NO;  
    scrollView.showsHorizontalScrollIndicator = NO; 
    [self.view addSubview: scrollView];
    
    [self setupNavigationBarButtons];
    //[self updateFcid];
    [self templateSculption];
    
    
    /*
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
     */
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)setupNavigationBarButtons
{
    UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    
}

#pragma mark - 
#pragma mark sculption
-(void) templateSculption
{
    

    //----------textfield:account 
    account=[[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X_COR, TEXTFIELD_ACCOUNT_Y_COR, 200, 35)];
    account.background=[UIImage imageNamed:@"textFieldBG" ];
    account.keyboardType=UIKeyboardTypeDefault;
    account.autocapitalizationType=NO;
    account.font=[UIFont systemFontOfSize:16.0];
    account.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    account.returnKeyType=UIReturnKeyDone;
    [self addLabelToMainView:@"帳號" x:TEXTFIELD_X_COR-83  y:TEXTFIELD_ACCOUNT_Y_COR+9 width:75 height:18 fontsize:16.0 alignment:UITextAlignmentRight];
    [account setPlaceholder:@"*請輸入您的帳號"];
    [self addImageToMainView:@"icon_Membership.png" :TEXTFIELD_X_COR-58 :TEXTFIELD_ACCOUNT_Y_COR+10 :16 :16];
    [account addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [scrollView addSubview:account];
 
   
    //----------textfield:password 
    password=[[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X_COR, TEXTFIELD_PASSWORD_Y_COR, 200, 35)];
    password.background=[UIImage imageNamed:@"textFieldBG" ];
    password.keyboardType=UIKeyboardTypeDefault;
    password.autocapitalizationType=NO;
    password.font=[UIFont systemFontOfSize:16.0];
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.returnKeyType=UIReturnKeyDone;
    [self addLabelToMainView:@"密碼" x:TEXTFIELD_X_COR-83  y:TEXTFIELD_PASSWORD_Y_COR+9 width:75 height:18 fontsize:16.0 alignment:UITextAlignmentRight];
    [password setPlaceholder:@"*請輸入您的密碼"];
    [password setSecureTextEntry:YES];
    [self addImageToMainView:@"icon_Key.png" :TEXTFIELD_X_COR-58 :TEXTFIELD_PASSWORD_Y_COR+10 :16 :16];
    [password addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [scrollView addSubview:password];
    
    
    //----------textfield:password confirm
    passconfirm=[[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X_COR, TEXTFIELD_PASSCONFIRM_Y_COR, 200, 35)];
    passconfirm.background=[UIImage imageNamed:@"textFieldBG" ];
    passconfirm.keyboardType=UIKeyboardTypeDefault;
    passconfirm.autocapitalizationType=NO;
    passconfirm.font=[UIFont systemFontOfSize:16.0];
    passconfirm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passconfirm.returnKeyType=UIReturnKeyDone;
    [self addLabelToMainView:@"密碼確認" x:TEXTFIELD_X_COR-83  y:TEXTFIELD_PASSCONFIRM_Y_COR+9 width:75 height:18 fontsize:16.0 alignment:UITextAlignmentRight];
    [passconfirm setPlaceholder:@"*請再次輸入您的密碼"];
    [passconfirm setSecureTextEntry:YES];
    [passconfirm addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [scrollView addSubview:passconfirm];
    
    //----------textfield:living membername
    membername=[[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X_COR, TEXTFIELD_NAME_Y_COR, 200, 35)];
    membername.background=[UIImage imageNamed:@"textFieldBG" ];
    membername.keyboardType=UIKeyboardTypeDefault;
    membername.autocapitalizationType=NO;
    membername.font=[UIFont systemFontOfSize:16.0];
    membername.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    membername.returnKeyType=UIReturnKeyDone;
    [self addLabelToMainView:@"姓名" x:TEXTFIELD_X_COR-83  y:TEXTFIELD_NAME_Y_COR+9 width:75 height:18 fontsize:16.0 alignment:UITextAlignmentRight];
    [membername setPlaceholder:@"*請輸入您的真實姓名"];
    [membername addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [scrollView addSubview:membername];
    
    //----------textfield:living address
    liveaddress=[[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X_COR, TEXTFIELD_LIVEADDRESS_Y_COR, 200, 35)];
    liveaddress.background=[UIImage imageNamed:@"textFieldBG" ];
    liveaddress.keyboardType=UIKeyboardTypeDefault;
    liveaddress.autocapitalizationType=NO;
    liveaddress.font=[UIFont systemFontOfSize:16.0];
    liveaddress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    liveaddress.returnKeyType=UIReturnKeyDone;
    [self addLabelToMainView:@"住址" x:TEXTFIELD_X_COR-83  y:TEXTFIELD_LIVEADDRESS_Y_COR+9 width:75 height:18 fontsize:16.0 alignment:UITextAlignmentRight];
    [liveaddress setPlaceholder:@"*請輸入您的聯絡住址"];
    [liveaddress addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [scrollView addSubview:liveaddress];
    
    //----------textfield:phonenumber
    phonenumber=[[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X_COR, TEXTFIELD_PHONE_Y_COR, 200, 35)];
    phonenumber.background=[UIImage imageNamed:@"textFieldBG" ];
    phonenumber.keyboardType=UIKeyboardTypePhonePad;
    phonenumber.font=[UIFont systemFontOfSize:16.0];
    phonenumber.inputAccessoryView=[self accessoryView];
    phonenumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addLabelToMainView:@"電話" x:TEXTFIELD_X_COR-83  y:TEXTFIELD_PHONE_Y_COR+9 width:75 height:18 fontsize:16.0 alignment:UITextAlignmentRight];
    [phonenumber setPlaceholder:@"*請輸入您的聯絡電話"];
    [scrollView addSubview:phonenumber];
    
    //----------textfield:gender
    [self addLabelToMainView:@"性別" x:TEXTFIELD_X_COR-83  y:TEXTFIELD_GENDER_Y_COR+9 width:75 height:18 fontsize:16.0 alignment:UITextAlignmentRight];
    gender=[[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X_COR, TEXTFIELD_GENDER_Y_COR, 200, 35)];
    gender.background=[UIImage imageNamed:@"textFieldBG" ];
    gender.keyboardType=UIKeyboardTypeDefault;
    gender.returnKeyType=UIReturnKeyDone;
    [gender addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    gender.font=[UIFont systemFontOfSize:16.0];
    gender.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [gender setPlaceholder:@"*請輸入您的性別，男性或女性"];
    [scrollView addSubview:gender];
    //[self addCustomizeButtonToMainView:@"datepicker" :@"" :TEXTFIELD_X_COR :431];
    
    
    //----------textfield:birthday
    [self addLabelToMainView:@"生日" x:TEXTFIELD_X_COR-83  y:TEXTFIELD_BIRTH_Y_COR+9 width:75 height:18 fontsize:16.0 alignment:UITextAlignmentRight];
    birthday=[[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X_COR, TEXTFIELD_BIRTH_Y_COR, 200, 35)];
    birthday.background=[UIImage imageNamed:@"textFieldBG" ];
    birthday.keyboardType=UIKeyboardTypeDefault;
    birthday.returnKeyType=UIReturnKeyDone;
    [birthday addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    birthday.font=[UIFont systemFontOfSize:16.0];
    birthday.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [birthday setPlaceholder:@"*範例 1911/01/01"];
    [scrollView addSubview:birthday];
    
    
    //[self addCustomizeButtonToMainView:@"datepicker" :@"" :TEXTFIELD_X_COR :476];
      
    //----------button:register
    [self addCustomizeButtonToMainView:@"register":@"加入會員":60+14:525];
    
    //----------labels:info elaborate
    [self addLabelToMainView:@"使用者帳號及密碼" x:16  y:23 width:260 height:19 fontsize:17.0 alignment:UITextAlignmentLeft];
    [self addLabelToMainView:@"此帳號適用於所有本會員系統的應用軟體" x:16  y:48 width:260 height:12 fontsize:10.0 alignment:UITextAlignmentLeft];
    [self addLabelToMainView:@"基本資料" x:16  y:226 width:260 height:19 fontsize:17.0 alignment:UITextAlignmentLeft];
    [self addLabelToMainView:@"請仔細填寫您的個人資料，以供日後購買商品使用" x:42  y:251 width:240 height:12 fontsize:10.0 alignment:UITextAlignmentLeft];
    [self addLabelToMainView:@"本會員系統負責資料保密，按此瀏覽" x:42  y:267 width:178 height:12 fontsize:10.0 alignment:UITextAlignmentLeft];
    [self addLabelToMainView:@"保密條款" x:220  y:266 width:62 height:15 fontsize:12.0 alignment:UITextAlignmentLeft];
    checkbutton=[[UIButton alloc] initWithFrame:CGRectMake(11, 252, 28, 28)];
    [[checkbutton layer] setCornerRadius:5.0f];
    [[checkbutton layer] setMasksToBounds:YES];
    
    [[checkbutton layer] setBackgroundColor:[[UIColor colorWithWhite:0.5 alpha:0.5] CGColor]];
    checkcontrol=NO;
    [checkbutton addTarget:self action:@selector(keepSecretConfirm) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:checkbutton];
    
   
       
}


-(void)keepSecretConfirm
{
    if (checkcontrol==NO) {
       [[checkbutton layer] setBackgroundColor:[[UIColor colorWithWhite:0.2 alpha:0.9] CGColor]];
        checkcontrol=YES;
    }
    else {
        [[checkbutton layer] setBackgroundColor:[[UIColor colorWithWhite:0.5 alpha:0.5] CGColor]];
        checkcontrol=NO;
    }
}


// using this method to add image in the scroll view

-(void) addImageToMainView:(NSString *)imageFilePath:(CGFloat) locationX:(CGFloat) locationY:(CGFloat) width:(CGFloat)height
{
    UIImageView *iconArea=[[UIImageView alloc] initWithFrame:CGRectMake(locationX, locationY, width, height)];
    iconArea.image=[UIImage imageNamed:imageFilePath];
    [scrollView addSubview:iconArea];
    [iconArea release];
}

-(void) addDatePickerToMainView
{
    NSLog(@"test");
}

-(void) setTestingInfo
{
    //testing info
    account.text=@"ryan@fingertipcreative.com.tw02";
    password.text=@"fingertip";
    membername.text=@"ryan";
    liveaddress.text=@"台北市某處";
    phonenumber.text=@"0912345678";
}

-(void) beginRegister
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.register" object:nil];
    
    //[self setTestingInfo];
    
    
    NSMutableDictionary *registerInfo=[NSMutableDictionary dictionary];
    Membership *m=[Membership getMemberIfExistWithId:0 inManagedObjectContext:self.managedObjectContext];
    
    
    //stupid proof
        
    if (!(account.text && password.text && passconfirm.text && membername.text && phonenumber.text && birthday.text && gender.text && liveaddress.text) )
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeError
                               title:NSLocalizedString(@"任何一項不可為空白", nil) 
                            subtitle:nil
                           hideAfter:3];
    else if (![password.text isEqualToString:passconfirm.text]) {
        NSLog(@"password:%@  passconfirm:%@ ",password.text,passconfirm);
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeError
                               title:NSLocalizedString(@"請再次確認您的密碼", nil) 
                            subtitle:nil
                           hideAfter:3];
    }
    else if (!checkcontrol)
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeError
                               title:NSLocalizedString(@"請同意保密條款", nil) 
                            subtitle:nil
                           hideAfter:3];
    else {
        
        [registerInfo setObject:m.fcid forKey:@"fcid"];
        [registerInfo setObject:account.text forKey:@"email"];
        [registerInfo setObject:password.text forKey:@"password"];
        [registerInfo setObject:membername.text forKey:@"name"];
        [registerInfo setObject:liveaddress.text forKey:@"address"];
        [registerInfo setObject:phonenumber.text forKey:@"phone"];
        [registerInfo setObject:birthday.text forKey:@"age"];
        
        if ([gender.text isEqualToString:@"男性"])
            [registerInfo setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
        else if ([gender.text isEqualToString:@"女性"]) 
            [registerInfo setObject:[NSNumber numberWithInt:2] forKey:@"gender"];
        else
            [registerInfo setObject:[NSNumber numberWithInt:3] forKey:@"gender"];
        [self updateRegister:registerInfo];
    }
    


    
       /*
    NSLog(@"account %@",account.text);
    NSLog(@"password %@",password.text);
    NSLog(@"password confirm %@",passconfirm.text);
    NSLog(@"%@",phonenumber.text);
    NSLog(@"%@",liveaddress.text);
    */
    
    //NSManagedObjectContext *managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
    //NSPersistentStoreCoordinator *persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator;
    //[managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    //NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //[request setEntity:[NSEntityDescription entityForName:@"Membership" inManagedObjectContext:managedObjectContext]];
    
    //request.entity = [NSEntityDescription entityForName:@"Membership" inManagedObjectContext:managedObjectContext];
    //request.predicate = [NSPredicate predicateWithFormat:@"id = %d", 0];

    /*
    NSError *err = nil;
    id obj = [[managedObjectContext executeFetchRequest:request error:&err] lastObject];
    [request release];
    */
    /*
    if (!err && !obj)
    {
        self.error = err;
        [self performSelectorOnMainThread:@selector(reportCreateFailed) withObject:nil 
                            waitUntilDone:[NSThread isMainThread]];
        return;
    }
    */
    
    //Membership *m = (Membership *)obj;
    //NSLog(@"%@",m.fcid);
    
    

}

/* reference code
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    ProductDetailModelManager *pdmm = [[ProductDetailModelManager alloc] initWithItemId:self.selectedItemId];
	DetailViewController *dvc = [[DetailViewController alloc] init];
    pdmm.delegate = dvc;
    pdmm.managedObjectContext = self.managedObjectContext;
    dvc.modelManager = pdmm;
    [pdmm release];
	
    [self.navigationController pushViewController:dvc animated:YES];
	[dvc release];
}

*/

-(void) addCustomizeButtonToMainView:(NSString *) buttonType :(NSString *)hintOnButton:(CGFloat)locationX:(CGFloat)locationY
{
    UIButton *customizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [customizeButton setTitle:hintOnButton forState:UIControlStateNormal];
    
    
    if ([buttonType isEqualToString:@"datepicker"]) {
        [customizeButton setBackgroundImage:[[UIImage imageNamed:@"textFieldBG2.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
        customizeButton.frame = CGRectMake(locationX, locationY, 200, 35);
        [customizeButton addTarget:self action:@selector(addDatePickerToMainView)forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if ([buttonType isEqualToString:@"register"]) {
        [customizeButton setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
        customizeButton.frame = CGRectMake(locationX, locationY, 172, 34);
        [customizeButton addTarget:self action:@selector(beginRegister)forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
    [customizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[customizeButton addTarget:self action:@selector(StartScan:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:customizeButton];
}

/*
-(void) addTextFieldWithHintLabel:(UITextField *)textFieldModel:(NSString *)keyinType:(NSString *)infoHint:(NSString *) keyinHint:(CGFloat)cgMakeX:(CGFloat)cgMakeY:(BOOL) setIfHaveIcon16x16:(NSString *) iconFileName
{
    textFieldModel=[[UITextField alloc] initWithFrame:CGRectMake(cgMakeX, cgMakeY, 200, 35)];
    if ([keyinType isEqualToString:@"email"])
        textFieldModel.keyboardType=UIKeyboardTypeEmailAddress;
    else if ([keyinType isEqualToString:@"phone"]) 
    {
        textFieldModel.keyboardType=UIKeyboardTypePhonePad;
    }
    else if ([keyinType isEqualToString:@"password"])
        [textFieldModel setSecureTextEntry:YES];
    else 
        textFieldModel.keyboardType=UIKeyboardTypeDefault;
    
    
    textFieldModel.autocapitalizationType=NO;
    textFieldModel.background=[UIImage imageNamed:@"textFieldBG" ];    
    textFieldModel.font=[UIFont systemFontOfSize:18.0];
    [textFieldModel setPlaceholder:keyinHint];
    textFieldModel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [textFieldModel addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    textFieldModel.returnKeyType=UIReturnKeyDone;
    [scrollView addSubview:textFieldModel];
    [textFieldModel release];
    
    [self addLabelToMainView:infoHint :cgMakeX-83 :cgMakeY+9 :75 :16];
    if (setIfHaveIcon16x16)
        [self addImageToMainView:iconFileName :cgMakeX-58 :cgMakeY+9 :16 :16];
    
}
 */

-(UIToolbar *)accessoryView
{
    UIToolbar *assiToKeyboard=[[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 26.0f)];
    assiToKeyboard.tintColor=[UIColor darkGrayColor];
    NSMutableArray *textbarItems=[NSMutableArray array];
    [textbarItems addObject:[[[UIBarButtonItem alloc]  
                              initWithTitle:@"done" style:UIBarButtonSystemItemCancel                                 target:self
                              action:@selector(textFieldDidEndEditing:)] autorelease]]; 
    
    assiToKeyboard.items=textbarItems;
    return assiToKeyboard;
}


-(void) addLabelToMainView:(NSString *)labelText x:(CGFloat)locationX y:(CGFloat)locationY width:(CGFloat)width height:(CGFloat)height fontsize:(CGFloat)fontsize alignment:(UITextAlignment)alignmentType
{
    UILabel *textFieldInfo=[[UILabel alloc] initWithFrame:CGRectMake(locationX, locationY, width, height)];
    textFieldInfo.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    textFieldInfo.text=labelText;
    textFieldInfo.font=[UIFont systemFontOfSize:fontsize];
    textFieldInfo.textAlignment=alignmentType;
    [scrollView addSubview:textFieldInfo];
    [textFieldInfo release];
    
}



-(void) textFieldDidEndEditing:(id) sender
{
    [phonenumber resignFirstResponder];
}



#pragma mark - 
#pragma mark EggApiManagerDelegate

- (void)updateRegisterCompleted:(EggApiManager *)manager
{
     Membership *m=[Membership getMemberIfExistWithId:0 inManagedObjectContext:self.managedObjectContext];
    if ([m.status isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeInfo
                               title:NSLocalizedString(@"註冊成功", nil) 
                            subtitle:nil
                           hideAfter:4];
        
        [self updateLogin];

        //insert log in code right here
    }
    else {
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"註冊失敗" message:[NSString stringWithFormat:@"原因: %@",m.message] delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];  
        [alertView show];  
        [alertView release]; 

    }
    
    
}

- (void)updateRegisterFailed:(EggApiManager *)manager
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeError
                           title:NSLocalizedString(@"註冊失敗... 請稍後再試", nil) 
                        subtitle:nil
                       hideAfter:4];
    
    // still try to load it anyways
    //
}


-(void)updateLoginCompleted:(EggApiManager *)manager
{
    /*
     secondViewController=[[MemberIndexViewController alloc] init];
     [window addSubview:secondViewController.view];
     */
    
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];
    lm.account=account.text;
    NSLog(@"%@",lm.account);
    MemberIndexViewController *loginView=[[MemberIndexViewController alloc] init];
    loginView.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:loginView animated:YES];
    [loginView release];
    
    
}

-(void)updateLoginFailed:(EggApiManager *)manager
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeError
                           title:NSLocalizedString(@"登入失敗... 請稍後再試", nil) 
                        subtitle:nil
                       hideAfter:4];
}


#pragma mark -
#pragma mark private interface

- (void)updateRegister:(NSMutableDictionary *)registerInfo
{
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    
    if(apiManager.isUpdatingRegister == NO)
    {
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeProgress
                               title:NSLocalizedString(@"註冊中... 請稍後", nil) 
                            subtitle:nil
                           hideAfter:2];
        
        [apiManager updateRegister:registerInfo];
        apiManager.updateRegisterDelegate = self;
    }
}

-(void)updateLogin
{
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    
    if(apiManager.isUpdatingLogin == NO)
    {
        /*
         [MKInfoPanel showPanelInView:self.view
         type:MKInfoPanelTypeProgress
         title:NSLocalizedString(@"更新中... 請稍後", nil) 
         subtitle:nil
         hideAfter:2];
         */
        //[self clearTable];
        [apiManager updateLogin:account.text:password.text];
        apiManager.updateLoginDelegate = self;
    }
    
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

#pragma mark - 
#pragma mark dealloc
-(void)dealloc
{
    [scrollView release];
    //[_managedObjectContext release];
    [_lastUpdateTime release];
    [account release];
    [password release];
    [passconfirm release];
    [membername release];
    [liveaddress release];
    [phonenumber release];
    //[window release];
    
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
