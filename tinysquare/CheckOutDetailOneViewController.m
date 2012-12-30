//
//  CheckOutDetailOneViewController.m
//  TinySquare
//
//  Created by jason on 12/30/12.
//
//

#import "CheckOutDetailOneViewController.h"
#import "CheckOutDetailTwoViewController.h"

#import "IIViewDeckController.h"
#import "UINavigationController+Customize.h"
#import "SVProgressHUD.h"

@interface CheckOutDetailOneViewController ()

@end

@implementation CheckOutDetailOneViewController

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
    [_nameTextField release];
    [_addressTextField release];
    [_phoneTextField release];
    [_deliverTimeTextField release];
    [_noteTextField release];
    [_emailTextField release];
    [_useReceiptButton release];
    [_receiptNameTextField release];
    [_taxIDTextField release];
    [_sameInfoButton release];
    [_nextButton release];
    [_myScrollView release];
    [_myContentView release];
    [_nextStepButton release];
    [_inputToolbar release];
    [_previousButton release];
    [_dismissKeyboardButton release];
    [_receiptPicker release];
    [_samePicker release];
    [_receiptAddressTextField release];
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
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
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
      INFO_KEY_CONTROL: self.deliverTimeTextField,
      INFO_KEY_OPTIONAL: @YES,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
      INFO_KEY_VALIDATION: [[^BOOL(){return YES;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.deliverTimeTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.noteTextField,
      INFO_KEY_OPTIONAL: @YES,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
      INFO_KEY_VALIDATION: [[^BOOL(){return YES;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.noteTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.emailTextField,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeEmailAddress),
      INFO_KEY_VALIDATION: [[^BOOL(){return [self.emailTextField.text componentsSeparatedByString:@"@"].count == 2;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.emailTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.useReceiptButton,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(INPUT_TYPE_PICKER),
      INFO_KEY_PICKER: self.receiptPicker,
      INFO_KEY_VALIDATION: [[^BOOL(){return YES;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: @"",
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.receiptNameTextField,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.receiptNameTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.receiptNameTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.taxIDTextField,
      INFO_KEY_OPTIONAL: @YES,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.taxIDTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.taxIDTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.sameInfoButton,
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
    self.samePickerChoices = @[@"同", @" 不同"];
    
    // -------------------- view related --------------------
    
    CGSize contentSize = self.myContentView.frame.size;
    self.myScrollView.contentSize = contentSize;
    [self.myScrollView addSubview:self.myContentView];
    
    self.useReceiptButton.selected = NO;
    [self.receiptPicker selectRow:1 inComponent:0 animated:NO];
    
    self.sameInfoButton.selected = NO;
    [self.samePicker selectRow:1 inComponent:0 animated:NO];
    
    // populate the fields
    NSDictionary *info = self.appManager.userInfo;
    if(info)
    {
        self.nameTextField.text = info[@"name"];
        self.addressTextField.text = info[@"address"];
        self.phoneTextField.text = info[@"phone"];
        self.emailTextField.text = info[@"email"];
        
        // config receipt controls
        BOOL useReceipt = [info[@"useReceipt"] boolValue];
        self.useReceiptButton.selected = useReceipt;
        int selectedRow = useReceipt ? 0 : 1;
        [self.receiptPicker selectRow:selectedRow inComponent:0 animated:NO];
        
        self.useReceiptButton.selected = [info[@"useReceipt"] boolValue];
        self.receiptNameTextField.text = info[@"receiptName"];
        self.taxIDTextField.text = info[@"taxID"];
        
        // config same controls
        BOOL isSameAsAddress = [info[@"sameReceiptAddress"] boolValue];
        self.sameInfoButton.selected = isSameAsAddress;
        selectedRow = isSameAsAddress ? 0 : 1;
        [self.samePicker selectRow:selectedRow inComponent:0 animated:NO];
        
        self.sameInfoButton.selected = [info[@"sameReceiptAddress"] boolValue];
        self.receiptAddressTextField.text = info[@"receiptAddress"];
    }
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setAddressTextField:nil];
    [self setPhoneTextField:nil];
    [self setDeliverTimeTextField:nil];
    [self setNoteTextField:nil];
    [self setEmailTextField:nil];
    [self setUseReceiptButton:nil];
    [self setReceiptNameTextField:nil];
    [self setTaxIDTextField:nil];
    [self setSameInfoButton:nil];
    [self setNextButton:nil];
    [self setMyScrollView:nil];
    [self setMyContentView:nil];
    [self setNextStepButton:nil];
    [self setInputToolbar:nil];
    [self setPreviousButton:nil];
    [self setDismissKeyboardButton:nil];
    [self setReceiptPicker:nil];
    [self setSamePicker:nil];
    [self setReceiptAddressTextField:nil];
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
    else if (pickerView == self.samePicker)
        return self.samePickerChoices.count;
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == self.receiptPicker)
        return [self.receiptPickerChoices objectAtIndex:row];
    else if (pickerView == self.samePicker)
        return [self.samePickerChoices objectAtIndex:row];
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if(pickerView == self.receiptPicker)
    {        
        self.useReceiptButton.selected = row == 0;
    }
    else if(pickerView == self.samePicker)
    {
        self.sameInfoButton.selected = row == 0;
        
        if(row == 0)
            self.receiptAddressTextField.text = self.addressTextField.text;
    }
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

- (IBAction)useReceiptButtonPressed:(id)sender
{
    self.useReceiptButton.selected = !self.useReceiptButton.selected;
}

- (IBAction)sameInfoButtonPressed:(id)sender
{
    self.sameInfoButton.selected = ! self.sameInfoButton.selected;
    
    self.receiptAddressTextField.text = self.sameInfoButton.selected ? self.addressTextField.text : @"";
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

- (IBAction)nextStepButtonPressed:(id)sender
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
    
    self.nextStepButton.enabled = NO;
    
    CheckOutDetailTwoViewController *codtvc = [[[CheckOutDetailTwoViewController alloc] init] autorelease];
    codtvc.recipientName = self.nameTextField.text;
    codtvc.address = self.addressTextField.text;
    codtvc.phone = self.phoneTextField.text;
    codtvc.deliverTime = self.deliverTimeTextField.text;
    codtvc.note = self.noteTextField.text;
    codtvc.receiptName = self.receiptNameTextField.text;
    codtvc.receiptAddress = self.receiptAddressTextField.text;
    codtvc.taxID = self.taxIDTextField.text;
    
    [self.navigationController pushViewController:codtvc animated:YES];
    
    self.nextStepButton.enabled = YES;
}

- (void)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
