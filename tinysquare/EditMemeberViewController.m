//
//  EditMemeberViewController.m
//  asoapp
//
//  Created by jason on 12/20/12.
//
//

#import "EditMemeberViewController.h"
#import "IIViewDeckController.h"
#import "UINavigationController+Customize.h"
#import "SVProgressHUD.h"

@interface EditMemeberViewController ()

@end

@implementation EditMemeberViewController

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
    [_memberNameLabel release];
    [_nameTextField release];
    [_addressTextField release];
    [_phoneTextField release];
    [_birthdayTextField release];
    [_genderTextField release];
    [_receiptButton release];
    [_buyerNameTextField release];
    [_taxIDTextField release];
    [_sameButton release];
    [_receiptAddressTextField release];
    [_saveChangeButton release];
    [_birthdayPicker release];
    [_genderPicker release];
    [_receiptPicker release];
    [_samePicker release];
    [_inputToolbar release];
    [_previousButton release];
    [_nextButton release];
    [_dismissKeyboardButton release];
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
    [[@{
      INFO_KEY_CONTROL: self.receiptButton,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(INPUT_TYPE_PICKER),
      INFO_KEY_PICKER: self.receiptPicker,
      INFO_KEY_VALIDATION: [[^BOOL(){return YES;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: @"",
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.buyerNameTextField,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.buyerNameTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.buyerNameTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.taxIDTextField,
      INFO_KEY_OPTIONAL: @YES,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.taxIDTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.taxIDTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.sameButton,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(INPUT_TYPE_PICKER),
      INFO_KEY_PICKER: self.samePicker,
      INFO_KEY_VALIDATION: [[^BOOL(){return YES;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: @"",
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.receiptAddressTextField,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.receiptAddressTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.receiptAddressTextField.placeholder,
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
    
    self.receiptPickerChoices = @[@"是", @"否"];
    self.genderPickerChoices = @[@"男", @"女", @"保密"];
    self.samePickerChoices = @[@"同", @" 不同"];
    
    // config birthday related controls
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"yyyy/MM/dd";
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1970];
    self.selectedBirthday = [[NSCalendar currentCalendar] dateFromComponents:comps];
    self.birthdayPicker.date = self.selectedBirthday;
    self.birthdayPicker.maximumDate = [NSDate date];
    self.birthdayTextField.text = [self.dateFormatter stringFromDate:self.selectedBirthday];
    
    // config gender related controls
    self.selectedGender = 0;
    self.genderTextField.text = [self.genderPickerChoices objectAtIndex:self.selectedGender];
    [self.genderPicker selectRow:self.selectedGender inComponent:0 animated:NO];
    
    // config receipt controls
    self.useReceipt = NO;
    self.receiptButton.selected = self.useReceipt;
    [self.receiptPicker selectRow:1 inComponent:0 animated:NO];
    
    // config same controls
    self.isSameAsAddress = NO;
    self.sameButton.selected = self.isSameAsAddress;
    [self.samePicker selectRow:1 inComponent:0 animated:NO];
    
    // -------------------- view related --------------------
    
    CGSize contentSize = self.myContentView.frame.size;
    self.myScrollView.contentSize = contentSize;
    [self.myScrollView addSubview:self.myContentView];
    
    // populate the fields
    NSDictionary *info = self.appManager.userInfo;
    if(info)
    {
        self.memberNameLabel.text = [NSString stringWithFormat:@"%@ 您好", info[@"name"]];
        self.nameTextField.text = info[@"name"];
        self.addressTextField.text = info[@"address"];
        self.phoneTextField.text = info[@"phone"];
        
        self.birthdayTextField.text = info[@"birthday"];
        if([info[@"gender"] intValue])
            self.genderTextField.text = [self.genderPickerChoices objectAtIndex: [info[@"gender"] intValue] - 1];
        self.birthdayPicker.date = [self.dateFormatter dateFromString:info[@"birthday"]];
        
        self.receiptButton.selected = [info[@"useReceipt"] boolValue];
        int selectedRow = self.receiptButton.selected ? 0 : 1;
        [self.receiptPicker selectRow:selectedRow inComponent:0 animated:NO];
        
        self.buyerNameTextField.text = info[@"receiptName"];
        self.taxIDTextField.text = info[@"taxID"];
        
        self.sameButton.selected = [info[@"sameReceiptAddress"] boolValue];
        selectedRow = self.sameButton.selected ? 0 : 1;
        [self.samePicker selectRow:selectedRow inComponent:0 animated:NO];
        self.receiptAddressTextField.text = info[@"receiptAddress"];
    }
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [self setMyContentView:nil];
    [self setMemberNameLabel:nil];
    [self setNameTextField:nil];
    [self setAddressTextField:nil];
    [self setPhoneTextField:nil];
    [self setBirthdayTextField:nil];
    [self setGenderTextField:nil];
    [self setReceiptButton:nil];
    [self setBuyerNameTextField:nil];
    [self setTaxIDTextField:nil];
    [self setSameButton:nil];
    [self setReceiptAddressTextField:nil];
    [self setSaveChangeButton:nil];
    [self setBirthdayPicker:nil];
    [self setGenderPicker:nil];
    [self setReceiptPicker:nil];
    [self setSamePicker:nil];
    [self setInputToolbar:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setDismissKeyboardButton:nil];
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
    if(pickerView == self.receiptPicker)
        return self.receiptPickerChoices.count;
    else if (pickerView == self.genderPicker)
        return self.genderPickerChoices.count;
    else if (pickerView == self.samePicker)
        return self.samePickerChoices.count;
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == self.receiptPicker)
        return [self.receiptPickerChoices objectAtIndex:row];
    else if (pickerView == self.genderPicker)
        return [self.genderPickerChoices objectAtIndex:row];
    else if (pickerView == self.samePicker)
        return [self.samePickerChoices objectAtIndex:row];
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if(pickerView == self.receiptPicker)
    {
        if(row == 0)
            self.useReceipt = YES;
        else
            self.useReceipt = NO;
        
        self.receiptButton.selected = self.useReceipt;
    }
    else if(pickerView == self.genderPicker)
    {
        self.selectedGender = row;
        self.genderTextField.text = [self.genderPickerChoices objectAtIndex:self.selectedGender];
    }
    else if(pickerView == self.samePicker)
    {
        if(row == 0)
        {
            self.isSameAsAddress = YES;
            self.receiptAddressTextField.text = self.addressTextField.text;
        }
        else
            self.isSameAsAddress = NO;
        
        self.sameButton.selected = self.isSameAsAddress;
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

- (IBAction)receiptButtonPressed:(id)sender
{
    self.useReceipt = !self.useReceipt;
    self.receiptButton.selected = self.useReceipt;
}

- (IBAction)sameButtonPressed:(id)sender
{
    self.isSameAsAddress = !self.isSameAsAddress;
    self.sameButton.selected = self.isSameAsAddress;
    
    if(self.sameButton.selected)
        self.receiptAddressTextField.text = self.addressTextField.text;
    else
        self.receiptAddressTextField.text = @"";
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
            
            if(index - 1 == 0)
                self.previousButton.enabled = NO;
            
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
            
            if(index + 1 == self.inputInfo.count - 1)
                self.nextButton.enabled = NO;
            
            break;
        }
        index++;
    }
}

#pragma mark - user interaction

- (void)showMemberSidebar:(id)sender
{
    if([self.viewDeckController isSideClosed:IIViewDeckRightSide])
        [self.viewDeckController openRightViewAnimated:YES];
    else
        [self.viewDeckController closeRightViewAnimated:YES];
}

- (IBAction)saveChangeButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    self.activeControl = nil;
    
    // check parameters
    for(NSMutableDictionary *info in self.inputInfo)
    {
        if([info[INFO_KEY_OPTIONAL] boolValue] == YES)
            continue;
        
        BOOL (^valdiation)() = info[INFO_KEY_VALIDATION];
        if(valdiation() == NO)
        {
            [SVProgressHUD showErrorWithStatus:info[INFO_KEY_VALIDATION_MSG]];
            return;
        }
    }
    
    self.saveChangeButton.enabled = NO;
    [SVProgressHUD showWithStatus:@"傳送中"];
    
    [self.appManager updateMemeberName:self.nameTextField.text
                               address:self.addressTextField.text
                                 phone:self.phoneTextField.text
                                gender:@(self.selectedGender + 1)
                              birthday:self.birthdayTextField.text
                            useReceipt:@(self.receiptButton.selected)
                           receiptName:self.buyerNameTextField.text
                                 taxID:self.taxIDTextField.text
                    sameReceiptAddress:@(self.sameButton.selected)
                        receiptAddress:self.receiptAddressTextField.text
                         passwordOrNil:nil success:^{
        
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        self.saveChangeButton.enabled = YES;
                             
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSString *errorMessage, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:errorMessage];
        self.saveChangeButton.enabled = YES;
        
    }];
}

@end
