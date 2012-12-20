//
//  MemberLoginViewController.m
//  asoapp
//
//  Created by wyde on 12/4/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MemberLoginViewController.h"
#import "MemberIndexViewController.h"
#import "UINavigationController+Customize.h"
#import "MemberRegisterationViewController.h"
#import "EggApiManager.h"
#import "AppDelegate.h"
#import "MKInfoPanel.h"
#import "Membership.h"
#import "DataManager.h"
#import "LoginMember.h"
#import "SHKFacebook.h"


@interface MemberLoginViewController ()
{
    UITextField *accountField;
    UITextField *passwordField;
    UIImageView *tinyIcon;
    UIButton *fbButton;
    UILabel *forgetPasswordHint;
    UILabel *autoLoginText;
    UISwitch *autoLoginOrNot;
    UILabel *accountText;
    UILabel *passwordText;
    UIImageView *keyIconArea;
    UIImageView *membershipIconArea;
    UIButton *loginButton;
    
}

@end

@implementation MemberLoginViewController
@synthesize managedObjectContext;
@synthesize facebook;
@synthesize preLoginView;
@synthesize didLoginView;
@synthesize loginMemberCellOption;
@synthesize profilePhotoImageView;
@synthesize nameLabel;
@synthesize headerView;
@synthesize permissions;
@synthesize whichViewFrom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title = NSLocalizedString(@"會員登入", nil);
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark-
#pragma mark did login table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [loginMemberCellOption count];
   // NSLog(@"%@",[loginMemberCellOption count]);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Login Member Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //button.frame = CGRectMake(20, 20, (cell.contentView.frame.size.width-40), 34);
    button.frame=CGRectMake((cell.contentView.frame.size.width)/2-75, 20,150 , 35);
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [button setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]
                                stretchableImageWithLeftCapWidth:9 topCapHeight:9]
                      forState:UIControlStateNormal];
    [button setTitle:[loginMemberCellOption objectAtIndex:indexPath.row]
            forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = indexPath.row;
    [cell.contentView addSubview:button];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}



#pragma mark -
#pragma mark set the view

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen
                                                  mainScreen].applicationFrame];
    self.view = view;
    [view release];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //loginMemberCellOption=[[NSArray alloc] initWithObjects:@"我的購物車",@"購買記錄",@"會員資料",@"登出", nil];
    loginMemberCellOption=[[NSArray alloc] initWithObjects:@"登出", nil];
    permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"email",@"user_about_me",@"user_birthday", nil];
    facebook=[SHKFacebook facebook];
    facebook.sessionDelegate=self;
    [self setupNavigationBarButtons];
    [self setupPreLoginView];
    [self setupDidloginView];
}



- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    //LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //if ([lm.logincheck isEqualToNumber:[NSNumber numberWithInteger:1]] || [facebook isSessionValid] || [[defaults objectForKey:@"DidLogin   "] isEqualToNumber:[NSNumber numberWithInt:1]]) {
    if ([[defaults objectForKey:@"DidLogin"] isEqual:@"1"]) {
        // member has login
        if ([[defaults objectForKey:@"LoginMemberType"] isEqualToString:@"facebook"]) 
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"FBAccessTokenKey"] 
                && [defaults objectForKey:@"FBExpirationDateKey"]) {
                facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            }
            
            //[self showLoggedIn];
            
            if (![facebook isSessionValid]) {
                [facebook authorize:permissions];
            } else {
                [self showLoggedIn];
            }
            

        }
        else if ([[defaults objectForKey:@"LoginMemberType"] isEqualToString:@"tinysquare"]) 
        {
            [self showLoggedIn];
        }
    }
    else {
        // member has not login
        [self showLoggedOut];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



#pragma mark -
#pragma mark button selectors

-(void)addToMember
{
    MemberRegisterationViewController *loginView=[[MemberRegisterationViewController alloc] init];
    loginView.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:loginView animated:YES];
    [loginView release];
    
}

-(void)menuButtonClicked:(id)sender
{
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];
    switch ([sender tag]) {
        case 0:
            account=@"";
            password=@"";
            lm.account=@"";
            lm.logincheck=[NSNumber numberWithInt:0];
            nameLabel.text=@"";
            profilePhotoImageView.image=nil;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"" forKey:@"LoginMemberType"];
            [defaults setObject:@"0" forKey:@"DidLogin"];
            [defaults setObject:@"" forKey:@"LoginMemberAccount"];
            [defaults setObject:@"" forKey:@"LoginMemberPassword"];
            [defaults synchronize];
            [facebook logout];
            [self showLoggedOut];
            break;

        default:
            break;
    }
    
    /*
    switch ([sender tag]) {
        case 0:
            //my cart
            break;
        case 1:
            //record
            break;
        case 2:
            //member data
            break;
        case 3:
            //log out
            account=@"";
            password=@"";
            lm.account=@"";
            lm.logincheck=[NSNumber numberWithInt:0];
            nameLabel.text=@"";
            profilePhotoImageView.image=nil;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"" forKey:@"LoginMemberType"];
            [defaults setObject:@"0" forKey:@"DidLogin"];
            [defaults setObject:@"" forKey:@"LoginMemberAccount"];
            [defaults setObject:@"" forKey:@"LoginMemberPassword"];
            [defaults synchronize];
            [facebook logout];
            [self showLoggedOut];
            break;
        default:
            break;
     
    }*/
}

-(void)loginDidActivate:(id)sender
{
    if (!((accountField.text) && (passwordField.text))) {
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeError
                               title:NSLocalizedString(@"帳號或密碼不可為空白 請稍後再試", nil) 
                            subtitle:nil
                           hideAfter:3];
    }
    else {
        account=accountField.text;
        password=passwordField.text;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"tinysquare" forKey:@"LoginMemberType"];
        //modify here
        [defaults synchronize];
        [self updateLogin];
        
    }
    
}

-(void)loginWithFacebook:(id)sender
{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        //facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        //facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    //[self showLoggedIn];
    
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    } else {
        [self showLoggedIn];
    }
    
    
}



#pragma mark-
#pragma handle preloginview and didloginview



- (void)setupNavigationBarButtons
{
    UIButton* touchdownToMemberSubsys = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"註冊", nil) 
                                                                                                icon:CustomizeButtonIconMembership
                                                                                       iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                              target:self 
                                                                                              action:@selector(addToMember)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:touchdownToMemberSubsys] autorelease];
    
    UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    
}

-(void)setupDidloginView
{
    didLoginView= [[UITableView alloc] initWithFrame:self.view.bounds
                                               style:UITableViewStylePlain];
    
    didLoginView.hidden=YES;
    didLoginView.delegate=self;
    didLoginView.dataSource=self;
    didLoginView.separatorStyle = UITableViewCellSeparatorStyleNone;
    didLoginView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:didLoginView];
    
    headerView = [[UIView alloc]
                  initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    headerView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    //headerView.backgroundColor = [UIColor whiteColor];
    CGFloat xProfilePhotoOffset = self.view.center.x - 25.0;
    profilePhotoImageView = [[UIImageView alloc]
                             initWithFrame:CGRectMake(xProfilePhotoOffset, 20, 50, 50)];
    profilePhotoImageView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //[profilePhotoImageView setImage:[UIImage imageNamed:@"user-PicBG.png"]];
    [headerView addSubview:profilePhotoImageView];
    
    nameLabel = [[UILabel alloc]
                 initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, 20.0)];
    nameLabel.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    nameLabel.textAlignment = UITextAlignmentCenter;
    //nameLabel.text = @"";
    nameLabel.backgroundColor=[UIColor clearColor];
    didLoginView.tableHeaderView = headerView;
    didLoginView.backgroundColor=[UIColor clearColor];
    [headerView addSubview:nameLabel];
    
}


-(void)setupPreLoginView
{
    accountField.text=@"";
    passwordField.text=@"";
    
    tinyIcon=[[UIImageView alloc] initWithFrame:CGRectMake(0+14, 25, 292, 37)];
    UIImage* tinyIconImage=[UIImage imageNamed:@"titleTSLS.png"];
    tinyIcon.image=tinyIconImage;
    [self.view addSubview:tinyIcon];
    
    fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbButton.frame = CGRectMake(45+14, 283, 202, 35);
    [fbButton setTitle:@"      使用Facebook帳號登入"  forState:UIControlStateNormal];
    fbButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [fbButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
    [fbButton setBackgroundImage:[[UIImage imageNamed:@"fbLoginButton.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [fbButton addTarget:self action:@selector(loginWithFacebook:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbButton];
    
    accountField=[[UITextField alloc] initWithFrame:CGRectMake(76+14, 77, 200, 35)];
    UIImage *textFieldBackground=[UIImage imageNamed:@"textFieldBG" ];
    accountField.background=textFieldBackground;
    accountField.font=[UIFont systemFontOfSize:18.0];
    accountField.autocapitalizationType=NO;
    [accountField setPlaceholder:@"*請輸入您的帳號"];
    [self.view addSubview:accountField];
    //when finish editting, the keyboard dissapear
    [accountField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    accountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    accountField.returnKeyType=UIReturnKeyDone;
    
    passwordField=[[UITextField alloc] initWithFrame:CGRectMake(76+14, 122, 200, 35)];
    passwordField.background=textFieldBackground;
    passwordField.font=[UIFont systemFontOfSize:18.0];
    passwordField.autocapitalizationType=NO;
    [self.view addSubview:passwordField];
    [passwordField resignFirstResponder];  
    //set up the password form
    [passwordField setSecureTextEntry:YES];
    [passwordField setPlaceholder:@"*請輸入您的密碼"];
    [passwordField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    passwordField.returnKeyType=UIReturnKeyDone;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    forgetPasswordHint=[[UILabel alloc] initWithFrame:CGRectMake(133+14, 160, 140, 15)];
    [forgetPasswordHint setTextAlignment:UITextAlignmentRight];
    forgetPasswordHint.text=@"忘記密碼";
    forgetPasswordHint.font=[UIFont systemFontOfSize:8.0];
    forgetPasswordHint.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    forgetPasswordHint.textColor=[UIColor colorWithRed:76/255.0 green:116/255.0 blue:189/255.0 alpha:1.0];
    //forgetPasswordHint.font=[UIFont systemFontSize:8];
    [self.view addSubview:forgetPasswordHint];
    
    autoLoginText=[[UILabel alloc] initWithFrame:CGRectMake(105+14, 181, 146, 18)];
    [autoLoginText setTextAlignment:UITextAlignmentLeft];
    autoLoginText.text=@"自動登入";
    autoLoginText.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    [self.view addSubview:autoLoginText];
    
    autoLoginOrNot=[[UISwitch alloc] initWithFrame:CGRectMake(22+14, 177, 94, 27)];
    //[self.view addSubview:autoLoginOrNot];
    
    membershipIconArea=[[UIImageView alloc] initWithFrame:CGRectMake(18+14, 85, 16, 16)];
    membershipIconArea.image=[UIImage imageNamed:@"icon_Membership.png"];
    [self.view addSubview:membershipIconArea];
    
    accountText=[[UILabel alloc] initWithFrame:CGRectMake(1+14, 85, 75, 16)];
    accountText.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    accountText.text=@"帳號  ";
    accountText.textAlignment=UITextAlignmentRight;
    [self.view addSubview:accountText];
    
    keyIconArea=[[UIImageView alloc] initWithFrame:CGRectMake(18+14, 130, 16, 16)];
    keyIconArea.image=[UIImage imageNamed:@"icon_Key.png"];;
    [self.view addSubview:keyIconArea];
    
    passwordText=[[UILabel alloc] initWithFrame:CGRectMake(1+14, 130, 75, 16)];
    passwordText.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    passwordText.text=@"密碼  ";
    passwordText.textAlignment=UITextAlignmentRight;
    [self.view addSubview:passwordText];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(60+14, 224, 172, 34);
    [loginButton setTitle:@"登入" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginDidActivate:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    [self hideLoginView];
    
    //accountField.text=@"ryan.test@fingertipcreative.com";
    //passwordField.text=@"1234";
}

-(void)showLoginView
{
    accountField.hidden=NO;
    passwordField.hidden=NO;
    tinyIcon.hidden=NO;
    fbButton.hidden=NO;
    forgetPasswordHint.hidden=NO;
    autoLoginText.hidden=NO;
    autoLoginOrNot.hidden=NO;
    accountText.hidden=NO;
    passwordText.hidden=NO;
    keyIconArea.hidden=NO;
    membershipIconArea.hidden=NO;
    loginButton.hidden=NO;
}

-(void)hideLoginView
{
    accountField.hidden=YES;
    passwordField.hidden=YES;
    tinyIcon.hidden=YES;
    fbButton.hidden=YES;
    forgetPasswordHint.hidden=YES;
    autoLoginText.hidden=YES;
    autoLoginOrNot.hidden=YES;
    accountText.hidden=YES;
    passwordText.hidden=YES;
    keyIconArea.hidden=YES;
    membershipIconArea.hidden=YES;
    loginButton.hidden=YES;
}


-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}


#pragma mark - 
#pragma handle member system login

-(void)updateLogin
{
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    Membership *m=[Membership getOrCreateMemberInManagedObjectContext:managedObjectContext];
    if(apiManager.isUpdatingLogin == NO)
    {
        if ([[defaults objectForKey:@"LoginMemberType"] isEqualToString:@"facebook"]) {
            account=m.email;
            password=m.password;
            [apiManager updateLogin:account:password];
            apiManager.updateLoginDelegate = self;
        }
        else {
            [apiManager updateLogin:account:password];
            apiManager.updateLoginDelegate = self;
        }        
    }
    
}


-(void)updateLoginCompleted:(EggApiManager *)manager
{
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];
    Membership *m=[Membership getOrCreateMemberInManagedObjectContext:managedObjectContext];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"LoginMemberType"] isEqualToString:@"tinysquare"]) {
        lm.account=account;
        lm.name=account; //temporarily
        lm.logincheck=[NSNumber numberWithInt:1];
        nameLabel.text=lm.name;
        [defaults setObject:@"1" forKey:@"DidLogin"];
        [defaults setObject:account forKey:@"LoginMemberAccount"];
        [defaults setObject:password forKey:@"LoginMemberPassword"];
        [defaults synchronize];
        [profilePhotoImageView setImage:[UIImage imageNamed:@"user-PicBG.png"]];
        [self showLoggedIn];
    }
    else if ([[defaults objectForKey:@"LoginMemberType"] isEqualToString:@"facebook"]) {
        [defaults setObject:m.email forKey:@"LoginMemberAccount"];
        [defaults setObject:m.password forKey:@"LoginMemberPassword"];
        [defaults synchronize];

    }


   
}

-(void)updateLoginFailed:(EggApiManager *)manager
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"LoginMemberType"] isEqualToString:@"facebook"]) {
        //
        NSMutableDictionary *registerInfo=[NSMutableDictionary dictionary];
        Membership *m=[Membership getMemberIfExistWithId:0 inManagedObjectContext:self.managedObjectContext];
        [registerInfo setObject:m.fcid forKey:@"fcid"];
        [registerInfo setObject:m.email forKey:@"email"];
        [registerInfo setObject:m.password forKey:@"password"];
        [registerInfo setObject:m.name forKey:@"name"];
        [registerInfo setObject:@"" forKey:@"address"];
        [registerInfo setObject:@"" forKey:@"phone"];
        [registerInfo setObject:m.gender forKey:@"gender"];
        [registerInfo setObject:m.age forKey:@"age"];
        //NSLog(@"registerInfo: %@",registerInfo);
        [self updateRegister:registerInfo];

    }
    else if ([[defaults objectForKey:@"LoginMemberType"] isEqualToString:@"tinysquare"]) {
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeError
                               title:NSLocalizedString(@"登入失敗... 請稍後再試", nil) 
                            subtitle:nil
                           hideAfter:4];
    } 
   
}


- (void)loadContentAsync {
	//this function is userless here
}

#pragma mark -
#pragma handle facebook member register


- (void)updateRegister:(NSMutableDictionary *)registerInfo
{
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    
    if(apiManager.isUpdatingRegister == NO)
    {
        [apiManager updateRegister:registerInfo];
        apiManager.updateRegisterDelegate = self;
    }
}


- (void)updateRegisterCompleted:(EggApiManager *)manager
{
    Membership *m=[Membership getMemberIfExistWithId:0 inManagedObjectContext:self.managedObjectContext];
    //NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([m.status isEqualToNumber:[NSNumber numberWithInt:1]]) {
        //NSLog(@"regist sucessful");
        [self updateLogin];
    }
    else{
        NSLog(@"reason of regist failure: %@",m.message);
        /*
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"註冊失敗" message:[NSString stringWithFormat:@"原因: %@",m.message] delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];  
        [alertView show];  
        [alertView release];
         */
        
    }
    
    
}

- (void)updateRegisterFailed:(EggApiManager *)manager
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeError
                           title:NSLocalizedString(@"連接系統失敗，您尚未成為tinysquare會員，請稍後再重新登入", nil) 
                        subtitle:nil
                       hideAfter:4];
    
    // still try to load it anyways
    //
}


#pragma mark -
#pragma handle facebook login


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}


- (void)request:(FBRequest *)request didLoad:(id)result 
{
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];
    //NSLog(@"facebook result: %@",result);
    
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    // use uid as the password, and email as the account for tinysquare member
    if ([result objectForKey:@"name"]) {
        // If basic information callback, set the UI objects to
        // display this.
        lm.name=[result objectForKey:@"name"];
        nameLabel.text=lm.name;
        
        // Get the profile image
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"pic"]]]];
        
        // Resize, crop the image to make sure it is square and renders
        // well on Retina display
        float ratio;
        float delta;
        float px = 100; // Double the pixels of the UIImageView (to render on Retina)
        CGPoint offset;
        CGSize size = image.size;
        if (size.width > size.height) {
            ratio = px / size.width;
            delta = (ratio*size.width - ratio*size.height);
            offset = CGPointMake(delta/2, 0);
        } else {
            ratio = px / size.height;
            delta = (ratio*size.height - ratio*size.width);
            offset = CGPointMake(0, delta/2);
        }
        CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                     (ratio * size.width) + delta,
                                     (ratio * size.height) + delta);
        UIGraphicsBeginImageContext(CGSizeMake(px, px));
        UIRectClip(clipRect);
        [image drawInRect:clipRect];
        UIImage *imgThumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [profilePhotoImageView setImage:imgThumb];
        
        //[facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
        
        Membership *m=[Membership getMemberIfExistWithId:0 inManagedObjectContext:self.managedObjectContext];
        //NSString *facebookMemberEmail=[NSString stringWithFormat:@"%@@facebook.com",[result objectForKey:@"username"]];
        //m.email=[NSString stringWithFormat:@"%@",[result objectForKey:@"uid"]];
        m.email=[NSString stringWithFormat:@"%@@facebook.com",[result objectForKey:@"uid"]];
        //m.email=[result objectForKey:@"email"];
        m.age=[result objectForKey:@"birthday"];
        m.name=[result objectForKey:@"name"];
        m.password=[NSString stringWithFormat:@"fin%@ger",[result objectForKey:@"uid"]];
        if ([[result objectForKey:@"sex"] isEqualToString:@"male"]) {
            m.gender=[NSNumber numberWithInt:1];
        }
        else if ([[result objectForKey:@"sex"] isEqualToString:@"female"]) {
            m.gender=[NSNumber numberWithInt:2];
        }
        else {
            m.gender=[NSNumber numberWithInt:3];
        }
        account=m.email;
        password=m.password;
        //NSLog(@"load from facebook account:%@ password:%@",account,password);
        //automatically login with tinysqaure member system
 
        [self updateLogin];
      } 
    /*
     else {
     // Processing permissions information
     HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
     [delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
     }
     */
}

#pragma mark-
#pragma mark fbRequestDelegate method

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}


- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}


#pragma mark-
#pragma mark fbSessionDelegate method

- (void)fbDidLogin 
{
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];
    lm.logincheck=[NSNumber numberWithInteger:1];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults setObject:@"facebook" forKey:@"LoginMemberType"];
    [defaults setObject:@"1" forKey:@"DidLogin"];
    [defaults setObject:@"" forKey:@"LoginMemberAccount"];
    [defaults setObject:@"" forKey:@"LoginMemberPassword"];
    
    [defaults synchronize];
    //[self getFacebookLoginInfo];
    [self showLoggedIn];
    
}

- (void)fbDidLogout {    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    [self showLoggedOut];
}

-(void)getFacebookLoginInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT username , email, uid, birthday, name, pic, sex FROM user WHERE uid=me()", @"query",
                                   nil];
    [facebook requestWithMethodName:@"fql.query"
                          andParams:params
                      andHttpMethod:@"POST"
                        andDelegate:self];
}

#pragma mark-
#pragma mark UI control
//showLoggedIn ui control
-(void)showLoggedIn
{
        LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];
            [self hideLoginView];
        didLoginView.hidden=NO;
        nameLabel.text=lm.name;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"LoginMemberType"]) {
            if ([[defaults objectForKey:@"LoginMemberType"] isEqualToString:@"tinysquare"]) {
                [profilePhotoImageView setImage:[UIImage imageNamed:@"user-PicBG.png"]];
            }
            else if ([[defaults objectForKey:@"LoginMemberType"] isEqualToString:@"facebook"]){
                [self getFacebookLoginInfo];
            }
        }
    if ([self.whichViewFrom isEqualToString:@"BaseDetailViewController"]) {
        [self dismissModalViewControllerAnimated:NO];
    }
}


-(void) showLoggedOut
{
    [self showLoginView];
    didLoginView.hidden=YES;
    
}


/*
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}
*/

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}


#pragma mark-
#pragma mark dealloc
- (void)dealloc 
{
    [managedObjectContext release];
	[super dealloc];
}


@end
