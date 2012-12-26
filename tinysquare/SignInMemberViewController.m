//
//  SignInMemberViewController.m
//  TinySquare
//
//  Created by jason on 12/22/12.
//
//

#import "SignInMemberViewController.h"
#import "CreateMemberViewController.h"
#import "IIViewDeckController.h"
#import "UINavigationController+Customize.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface SignInMemberViewController ()

@end

@implementation SignInMemberViewController

#pragma mark - define

#define INFO_KEY_CONTROL            @"control"
#define INFO_KEY_OPTIONAL           @"optional"
#define INFO_KEY_KEYBOARD           @"keyboard"
#define INFO_KEY_PICKER             @"picker"
#define INFO_KEY_VALIDATION         @"validation"
#define INFO_KEY_VALIDATION_MSG     @"validationMsg"

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myScrollView release];
    [_myContentView release];
    [_userAccountTextField release];
    [_userPwdTextField release];
    [_autoLoginSwitch release];
    [_forgetPwdButton release];
    [_loginButton release];
    [_createMemberButton release];
    [_inputToolbar release];
    [_previousButton release];
    [_nextButton release];
    [_dismissKeyboardButton release];
    [_inputInfo release];
    [super dealloc];
}

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // -------------------- navigation bar --------------------
    
	UIButton* backButton = [self.navigationController setUpCustomizeBackButtonWithText:NSLocalizedString(@"返回", nil)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    UIButton* memberShip2Button = [self.navigationController createNavigationBarButtonWithOutTextandSetIcon:CustomizeButtonIconMembership2
                                                                                              iconPlacement:CustomizeButtonIconPlacementRight
                                                                                                     target:self
                                                                                                     action:@selector(showMemberSidebar:)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:memberShip2Button] autorelease];
    
    // -------------------- input field related --------------------
    
    self.inputInfo = @[
        [[@{
          INFO_KEY_CONTROL: self.userAccountTextField,
          INFO_KEY_OPTIONAL: @NO,
          INFO_KEY_KEYBOARD: @(UIKeyboardTypeEmailAddress),
          INFO_KEY_VALIDATION: [[^BOOL(){return [self.userAccountTextField.text componentsSeparatedByString:@"@"].count == 2;} copy] autorelease],
          INFO_KEY_VALIDATION_MSG: @"帳號/密碼不正確",
          } mutableCopy] autorelease],
        [[@{
          INFO_KEY_CONTROL: self.userPwdTextField,
          INFO_KEY_OPTIONAL: @NO,
          INFO_KEY_KEYBOARD: @(UIKeyboardTypeASCIICapable),
          INFO_KEY_VALIDATION: [[^BOOL(){return self.userPwdTextField.text.length >=6 && self.userPwdTextField.text.length <=13;} copy] autorelease],
          INFO_KEY_VALIDATION_MSG: @"帳號/密碼不正確",
          } mutableCopy] autorelease]
    ];
    
    for(NSMutableDictionary *info in self.inputInfo)
    {
        UITextField *control = info[INFO_KEY_CONTROL];
        control.inputAccessoryView = self.inputToolbar;
        control.delegate = self;
        control.keyboardType = [info[INFO_KEY_KEYBOARD] integerValue];
    }
    
    // -------------------- view related --------------------
    
    CGSize contentSize = self.myContentView.frame.size;
    self.myScrollView.contentSize = contentSize;
    [self.myScrollView addSubview:self.myContentView];
    
    if(self.appManager.userInfo)
    {
        self.userAccountTextField.text = self.appManager.userInfo[@"email"];
        self.autoLoginSwitch.on = [self.appManager.userInfo[@"autoSignIn"] boolValue];
        
        if(self.autoLoginSwitch.on == YES)
            self.userPwdTextField.text = self.appManager.userInfo[@"password"];
    }
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [self setMyContentView:nil];
    [self setUserAccountTextField:nil];
    [self setUserPwdTextField:nil];
    [self setAutoLoginSwitch:nil];
    [self setForgetPwdButton:nil];
    [self setLoginButton:nil];
    [self setCreateMemberButton:nil];
    [self setInputToolbar:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setDismissKeyboardButton:nil];
    [self setActiveControl:nil];
    [self setInputInfo:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self subscribeForKeyboardEvents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unsubscribeFromKeyboardEvents];
    [self.view endEditing:YES];
    
    [super viewWillDisappear:animated];
}

#pragma mark - keyboard

- (void)subscribeForKeyboardEvents
{
    /* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeFromKeyboardEvents
{
    /* No longer listen for keyboard */
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // Note: rects are in screen coordinates, need to convert it
    endFrame = [self.view convertRect:endFrame fromView:nil];
    
    CGSize contentSize = self.myContentView.frame.size;
    contentSize.height += endFrame.size.height;
    
    self.myScrollView.contentSize = contentSize;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGSize contentSize = self.myContentView.frame.size;
    self.myScrollView.contentSize = contentSize;
}

#pragma mark  - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeControl = textField;
    [self bringActiveControlIntoView];
    
    self.previousButton.enabled = YES;
    self.nextButton.enabled = YES;
    int index = 0;
    for(NSMutableDictionary *info in self.inputInfo)
    {
        if(info[INFO_KEY_CONTROL] == self.activeControl)
        {
            if(index == 0)
            {
                self.previousButton.enabled = NO;
            }
            
            if(index == self.inputInfo.count - 1)
            {
                self.nextButton.enabled = NO;
            }
            
            break;
        }
        index++;
    }
}

#pragma mark - input related

- (void)bringActiveControlIntoView
{
    CGRect frame = [self.activeControl convertRect:[self.activeControl frame] toView:self.myScrollView];
    CGPoint offset = CGPointMake(0, MAX(0, frame.origin.y - 100));
    [self.myScrollView setContentOffset:offset animated:YES];
}

- (IBAction)closeKeyboardButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    self.activeControl = nil;
    self.previousButton.enabled = YES;
    self.nextButton.enabled = YES;
}

- (IBAction)previousButtonPressed:(id)sender
{
    self.nextButton.enabled = YES;
    int index = 0;
    for(NSMutableDictionary *info in self.inputInfo)
    {
        if(info[INFO_KEY_CONTROL] == self.activeControl)
        {
            self.activeControl = self.inputInfo[index-1][INFO_KEY_CONTROL];
            [self.activeControl becomeFirstResponder];
            
            [self bringActiveControlIntoView];
            
            break;
        }
        index++;
    }
}

- (IBAction)nextButtonPressed:(id)sender
{
    self.previousButton.enabled = YES;
    int index = 0;
    for(NSMutableDictionary *info in self.inputInfo)
    {
        if(info[INFO_KEY_CONTROL] == self.activeControl)
        {
            self.activeControl = self.inputInfo[index+1][INFO_KEY_CONTROL];
            [self.activeControl becomeFirstResponder];
            
            [self bringActiveControlIntoView];
            
            break;
        }
        index++;
    }
}

#pragma mark - user interaction

- (IBAction)autoLoginSwitchValueChanged:(id)sender
{
}

- (IBAction)forgetPwdButtonPressed:(id)sender
{
}

- (IBAction)loginButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    self.activeControl = nil;
    
    // check parameters
    for(NSMutableDictionary *info in self.inputInfo)
    {
        BOOL (^valdiation)() = info[INFO_KEY_VALIDATION];
        if(valdiation() == NO)
        {
            [SVProgressHUD showErrorWithStatus:info[INFO_KEY_VALIDATION_MSG]];
            return;
        }
    }
    
    // parameters checking passed, prepare for submit
    self.loginButton.enabled = NO;
    
    [self.appManager memberSignIn:self.userAccountTextField.text password:self.userPwdTextField.text remember:self.autoLoginSwitch.on success:^{
        
        [SVProgressHUD showSuccessWithStatus:@"登入成功"];
        
        self.loginButton.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSString *errorMessage, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:errorMessage];
        
        self.loginButton.enabled = YES;
        
    }];
}

- (IBAction)createMemberButtonPressed:(id)sender
{
    CreateMemberViewController *cmvc = [[[CreateMemberViewController alloc] init] autorelease];
    [self.navigationController pushViewController:cmvc animated:YES];
}

- (void)showMemberSidebar:(id)sender
{
    if([self.viewDeckController isSideClosed:IIViewDeckRightSide])
        [self.viewDeckController openRightViewAnimated:YES];
    else
        [self.viewDeckController closeRightViewAnimated:YES];
}

@end
