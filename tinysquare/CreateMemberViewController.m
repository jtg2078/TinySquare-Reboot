//
//  CreateMemberViewController.m
//  asoapp
//
//  Created by jason on 12/20/12.
//
//

#import "CreateMemberViewController.h"
#import "IIViewDeckController.h"
#import "UINavigationController+Customize.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface CreateMemberViewController ()

@end

@implementation CreateMemberViewController

#pragma mark - define

#define INPUT_TYPE_PICKER           99

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

- (void)dealloc
{
    [_myScrollView release];
    [_myContentView release];
    [_emailTextField release];
    [_pwdTextField release];
    [_pwdAgainTextField release];
    [_privacyCheckButton release];
    [_nameTextField release];
    [_addressTextField release];
    [_phoneTextField release];
    [_birthdayTextField release];
    [_genderTextField release];
    [_createAccountButton release];
    [_inputInfo release];
    [_previousButton release];
    [_nextButton release];
    [_dismissKeyboardButton release];
    [_privacyChoicePicker release];
    [_birthdayPicker release];
    [_genderPicker release];
    [_inputToolbar release];
    [_privacyPickerChoices release];
    [_genderPickerChoices release];
    [_selectedBirthday release];
    [_dateFormatter release];
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
            INFO_KEY_CONTROL: self.emailTextField,
            INFO_KEY_OPTIONAL: @NO,
            INFO_KEY_KEYBOARD: @(UIKeyboardTypeEmailAddress),
            INFO_KEY_VALIDATION: [[^BOOL(){return [self.emailTextField.text componentsSeparatedByString:@"@"].count == 2;} copy] autorelease],
            INFO_KEY_VALIDATION_MSG: self.emailTextField.placeholder,
        } mutableCopy] autorelease],
        [[@{
             INFO_KEY_CONTROL: self.pwdTextField,
             INFO_KEY_OPTIONAL: @NO,
             INFO_KEY_KEYBOARD: @(UIKeyboardTypeASCIICapable),
             INFO_KEY_VALIDATION: [[^BOOL(){return self.pwdTextField.text.length >=6 && self.pwdTextField.text.length <=13;} copy] autorelease],
             INFO_KEY_VALIDATION_MSG: self.pwdTextField.placeholder,
         } mutableCopy] autorelease],
        [[@{
             INFO_KEY_CONTROL: self.pwdAgainTextField,
             INFO_KEY_OPTIONAL: @NO,
             INFO_KEY_KEYBOARD: @(UIKeyboardTypeASCIICapable),
             INFO_KEY_VALIDATION: [[^BOOL(){return [self.pwdAgainTextField.text isEqualToString:self.pwdTextField.text];} copy] autorelease],
             INFO_KEY_VALIDATION_MSG: @"密碼並不相符",
         } mutableCopy] autorelease],
        [[@{
             INFO_KEY_CONTROL: self.privacyCheckButton,
             INFO_KEY_OPTIONAL: @NO,
             INFO_KEY_KEYBOARD: @(INPUT_TYPE_PICKER),
             INFO_KEY_PICKER: self.privacyChoicePicker,
             INFO_KEY_VALIDATION: [[^BOOL(){return self.privacyCheckButton.selected;} copy] autorelease],
             INFO_KEY_VALIDATION_MSG: @"請勾選同意保密條款",
         } mutableCopy] autorelease],
        [[@{
             INFO_KEY_CONTROL: self.nameTextField,
             INFO_KEY_OPTIONAL: @NO,
             INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
             INFO_KEY_VALIDATION: [[^BOOL(){return self.nameTextField.text.length;} copy] autorelease],
             INFO_KEY_VALIDATION_MSG: self.nameTextField.placeholder,
         } mutableCopy] autorelease],
        [[@{
             INFO_KEY_CONTROL: self.addressTextField,
             INFO_KEY_OPTIONAL: @NO,
             INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
             INFO_KEY_VALIDATION: [[^BOOL(){return self.addressTextField.text.length;} copy] autorelease],
             INFO_KEY_VALIDATION_MSG: self.addressTextField.placeholder,
         } mutableCopy] autorelease],
        [[@{
             INFO_KEY_CONTROL: self.phoneTextField,
             INFO_KEY_OPTIONAL: @NO,
             INFO_KEY_KEYBOARD: @(UIKeyboardTypeNumberPad),
             INFO_KEY_VALIDATION: [[^BOOL(){return self.phoneTextField.text.length;} copy] autorelease],
             INFO_KEY_VALIDATION_MSG: self.phoneTextField.placeholder,
         } mutableCopy] autorelease],
        [[@{
             INFO_KEY_CONTROL: self.birthdayTextField,
             INFO_KEY_OPTIONAL: @NO,
             INFO_KEY_KEYBOARD: @(INPUT_TYPE_PICKER),
             INFO_KEY_PICKER: self.birthdayPicker,
             INFO_KEY_VALIDATION: [[^BOOL(){return self.birthdayTextField.text.length;} copy] autorelease],
             INFO_KEY_VALIDATION_MSG: self.birthdayTextField.placeholder,
         } mutableCopy] autorelease],
        [[@{
             INFO_KEY_CONTROL: self.genderTextField,
             INFO_KEY_OPTIONAL: @NO,
             INFO_KEY_KEYBOARD: @(INPUT_TYPE_PICKER),
             INFO_KEY_PICKER: self.genderPicker,
             INFO_KEY_VALIDATION: [[^BOOL(){return self.genderTextField.text.length;} copy] autorelease],
             INFO_KEY_VALIDATION_MSG: self.genderTextField.placeholder,
         } mutableCopy] autorelease],
    ];
    
    for(NSMutableDictionary *info in self.inputInfo)
    {
        if([info[INFO_KEY_CONTROL] isKindOfClass:[UITextField class]])
        {
            UITextField *control = info[INFO_KEY_CONTROL];
            control.inputAccessoryView = self.inputToolbar;
            control.delegate = self;
            if([info[INFO_KEY_KEYBOARD] integerValue] == INPUT_TYPE_PICKER) {
                control.inputView = info[INFO_KEY_PICKER];
            }
            else {
                control.keyboardType = [info[INFO_KEY_KEYBOARD] integerValue];
            }
        }
        else if([info[INFO_KEY_CONTROL] isKindOfClass:[UIPickerViewButton class]])
        {
            UIPickerViewButton *control = info[INFO_KEY_CONTROL];
            control.inputAccessoryView = self.inputToolbar;
            control.inputView = info[INFO_KEY_PICKER];
        }
    }
    
    self.privacyPickerChoices = @[@"同意", @"不同意"];
    self.genderPickerChoices = @[@"男", @"女", @"保密"];
    
    // config the privacy related controls
    self.selectedPrivacy = NO;
    self.privacyCheckButton.selected = self.selectedPrivacy;
    [self.privacyChoicePicker selectRow:1 inComponent:0 animated:NO];
    
    // config birthday related controls
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"yyyy/MM/dd";
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1970];
    self.selectedBirthday = [[NSCalendar currentCalendar] dateFromComponents:comps];
    self.birthdayPicker.date = self.selectedBirthday;
    self.birthdayTextField.text = [self.dateFormatter stringFromDate:self.selectedBirthday];
    
    // config gender related controls
    self.selectedGender = 0;
    self.genderTextField.text = [self.genderPickerChoices objectAtIndex:self.selectedGender];
    [self.genderPicker selectRow:self.selectedGender inComponent:0 animated:NO];
    
    // -------------------- view related --------------------
    
    CGSize contentSize = self.myContentView.frame.size;
    self.myScrollView.contentSize = contentSize;
    [self.myScrollView addSubview:self.myContentView];
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [self setMyContentView:nil];
    [self setEmailTextField:nil];
    [self setPwdTextField:nil];
    [self setPwdAgainTextField:nil];
    [self setPrivacyCheckButton:nil];
    [self setNameTextField:nil];
    [self setAddressTextField:nil];
    [self setPhoneTextField:nil];
    [self setBirthdayTextField:nil];
    [self setGenderTextField:nil];
    [self setCreateAccountButton:nil];
    [self setInputInfo:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setDismissKeyboardButton:nil];
    [self setPrivacyChoicePicker:nil];
    [self setBirthdayPicker:nil];
    [self setGenderPicker:nil];
    [self setInputToolbar:nil];
    [self setPrivacyPickerChoices:nil];
    [self setGenderPickerChoices:nil];
    [self setSelectedBirthday:nil];
    [self setDateFormatter:nil];
    [self setActiveControl:nil];
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

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == self.privacyChoicePicker)
        return self.privacyPickerChoices.count;
    else if (pickerView == self.genderPicker)
        return self.genderPickerChoices.count;
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == self.privacyChoicePicker)
        return [self.privacyPickerChoices objectAtIndex:row];
    else if (pickerView == self.genderPicker)
        return [self.genderPickerChoices objectAtIndex:row];
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if(pickerView == self.privacyChoicePicker)
    {
        if(row == 0)
        {
            self.selectedPrivacy = YES;
            self.privacyCheckButton.selected = self.selectedPrivacy;
        }
        else
        {
            self.selectedPrivacy = NO;
            self.privacyCheckButton.selected = self.selectedPrivacy;
        }
    }
    else if(pickerView == self.genderPicker)
    {
        self.selectedGender = row;
        self.genderTextField.text = [self.genderPickerChoices objectAtIndex:self.selectedGender];
    }
}

#pragma mark  - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.birthdayTextField || textField == self.genderTextField)
        return  NO;
    
    return YES;
}

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

- (IBAction)privacyCheckButtonPressed:(id)sender
{
    [self.privacyCheckButton becomeFirstResponder];
    self.activeControl = self.privacyCheckButton;
    [self bringActiveControlIntoView];
}

- (IBAction)birthdayPickerChanged:(id)sender
{
    self.selectedBirthday = self.birthdayPicker.date;
    self.birthdayTextField.text = [self.dateFormatter stringFromDate:self.selectedBirthday];
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

- (IBAction)createAccountButtonPressed:(id)sender
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
    
    self.createAccountButton.enabled = NO;
    
    // parameters checking passed, prepare for submit
    NSURL *baseURL = [NSURL URLWithString:@"http://api.ideaegg.com.tw"];
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:baseURL] autorelease];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSDictionary *params = @{
        @"fcid": @(1),
        @"appid": @(1),
        @"email": self.emailTextField.text,
        @"password":self.pwdTextField.text,
        @"name":self.nameTextField.text,
        @"adress": self.addressTextField.text,
        @"phone": self.phoneTextField.text,
        @"gender": @(self.selectedGender + 1),
        @"birth": self.birthdayTextField.text,
    };
    
    [httpClient postPath:@"Member.svc/Register" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Member.svc/Register: %@", JSON);
        
        if([JSON[@"status"] boolValue] == YES)
        {
            [SVProgressHUD showSuccessWithStatus:JSON[@"message"]];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:JSON[@"message"]];
        }
        
        self.createAccountButton.enabled = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
        self.createAccountButton.enabled = YES;
    }];
}

- (void)showMemberSidebar:(id)sender
{
    if([self.viewDeckController isSideClosed:IIViewDeckRightSide])
        [self.viewDeckController openRightViewAnimated:YES];
    else
        [self.viewDeckController closeRightViewAnimated:YES];
}


@end
