//
//  CheckOutPaymentViewController.m
//  TinySquare
//
//  Created by jason on 12/30/12.
//
//

#import "CheckOutPaymentViewController.h"

#import "IIViewDeckController.h"
#import "UINavigationController+Customize.h"
#import "SVProgressHUD.h"

@interface CheckOutPaymentViewController ()

@end

@implementation CheckOutPaymentViewController

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
    [_cardHolderNameTextField release];
    [_cardNumberTextField release];
    [_expireMonthTextField release];
    [_expireYearTextField release];
    [_securityCodeTextField release];
    [_storeCardInfoButton release];
    [_submitPaymentButton release];
    [_inputToolbar release];
    [_previousButton release];
    [_nextButton release];
    [_dismissKeyboardButton release];
    [_storeCardPicker release];
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
    
    // -------------------- input field related --------------------
    
    self.inputInfo = @[
    [[@{
      INFO_KEY_CONTROL: self.cardHolderNameTextField,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeDefault),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.cardHolderNameTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.cardHolderNameTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.cardNumberTextField,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeNumberPad),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.cardNumberTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.cardNumberTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.expireMonthTextField,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeNumberPad),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.expireMonthTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.expireMonthTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.expireYearTextField,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeNumberPad),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.expireYearTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.expireYearTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.securityCodeTextField,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(UIKeyboardTypeNumberPad),
      INFO_KEY_VALIDATION: [[^BOOL(){return self.securityCodeTextField.text.length;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: self.securityCodeTextField.placeholder,
      } mutableCopy] autorelease],
    [[@{
      INFO_KEY_CONTROL: self.storeCardInfoButton,
      INFO_KEY_OPTIONAL: @NO,
      INFO_KEY_KEYBOARD: @(INPUT_TYPE_PICKER),
      INFO_KEY_PICKER: self.storeCardPicker,
      INFO_KEY_VALIDATION: [[^BOOL(){return YES;} copy] autorelease],
      INFO_KEY_VALIDATION_MSG: @"",
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
    
    self.storeCardPickerChoices = @[@"是", @"否"];
    
    // -------------------- view related --------------------
    
    CGSize contentSize = self.myContentView.frame.size;
    self.myScrollView.contentSize = contentSize;
    [self.myScrollView addSubview:self.myContentView];
    
    self.storeCardInfoButton.selected = NO;
    [self.storeCardPicker selectRow:1 inComponent:0 animated:NO];
    
    // populate the fields
    NSDictionary *info = self.appManager.userInfo;
    if(info)
    {
        BOOL saveCardInfo = [info[@"saveCardInfo"] boolValue];
        
        if(saveCardInfo)
        {
            self.cardHolderNameTextField.text = info[@"cardName"];
            self.cardNumberTextField.text = info[@"cardNumber"];
            self.expireMonthTextField.text = info[@"cardExpireMonth"];
            self.expireYearTextField.text = info[@"cardExpireYear"];
            self.securityCodeTextField.text = info[@"cardSecurityCode"];
        }
        
        self.storeCardInfoButton.selected = saveCardInfo;
        int selectedRow = saveCardInfo ? 0 : 1;
        [self.storeCardPicker selectRow:selectedRow inComponent:0 animated:NO];
    }
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [self setMyContentView:nil];
    [self setCardHolderNameTextField:nil];
    [self setCardNumberTextField:nil];
    [self setExpireMonthTextField:nil];
    [self setExpireYearTextField:nil];
    [self setSecurityCodeTextField:nil];
    [self setStoreCardInfoButton:nil];
    [self setSubmitPaymentButton:nil];
    [self setInputToolbar:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setDismissKeyboardButton:nil];
    [self setStoreCardPicker:nil];
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
    if(pickerView == self.storeCardPicker)
        return self.storeCardPickerChoices.count;
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == self.storeCardPicker)
        return [self.storeCardPickerChoices objectAtIndex:row];
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if(pickerView == self.storeCardPicker)
    {
        self.storeCardInfoButton.selected = row == 0;
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

- (IBAction)storeCardButtonPressed:(id)sender
{
    self.storeCardInfoButton.selected = !self.storeCardInfoButton.selected;
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

- (IBAction)submitPaymentButtonPressed:(id)sender
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
    
    [SVProgressHUD showWithStatus:@"處理中"];
    self.submitPaymentButton.enabled = NO;
    
    [self.appManager submitPaymentForOrder:self.appManager.cartReal[CART_KEY_orderid]
                                     total:self.appManager.cartReal[CART_KEY_total]
                                      name:self.cardHolderNameTextField.text
                                   address:self.address
                                     phone:self.phone
                                  shiptime:self.deliverTime
                                      note:self.note
                                     email:self.appManager.userInfo[@"email"]
                                    rtitle:self.receiptName
                                   rnumber:self.taxID
                                  raddress:self.receiptAddress
                              saveCardInfo:self.storeCardInfoButton.selected
                                    cardno:self.cardNumberTextField.text
                                     cardm:self.expireMonthTextField.text
                                     cardy:self.expireYearTextField.text
                                      cvv2:self.securityCodeTextField.text
                                   success:^(int code, NSString *msg) {
                                       
                                       [SVProgressHUD showSuccessWithStatus:msg];
                                       self.submitPaymentButton.enabled = YES;
                                       
                                       [self dismissModalViewControllerAnimated:YES];
                                       
                                   } failure:^(NSString *errorMessage, NSError *error) {
                                       
                                       [SVProgressHUD showErrorWithStatus:errorMessage];
                                       self.submitPaymentButton.enabled = YES;
                                       
                                       [self dismissModalViewControllerAnimated:YES];
                                       
                                   }];
}

@end
