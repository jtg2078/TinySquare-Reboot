//
//  CheckOutPaymentViewController.h
//  TinySquare
//
//  Created by jason on 12/30/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIPickerViewButton.h"

@interface CheckOutPaymentViewController : BaseViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIView *myContentView;

@property (retain, nonatomic) IBOutlet UITextField *cardHolderNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (retain, nonatomic) IBOutlet UITextField *expireMonthTextField;
@property (retain, nonatomic) IBOutlet UITextField *expireYearTextField;
@property (retain, nonatomic) IBOutlet UITextField *securityCodeTextField;
@property (retain, nonatomic) IBOutlet UIPickerViewButton *storeCardInfoButton;
@property (retain, nonatomic) IBOutlet UIPickerView *storeCardPicker;

- (IBAction)storeCardButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *submitPaymentButton;

- (IBAction)submitPaymentButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIToolbar *inputToolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *dismissKeyboardButton;

- (IBAction)previousButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)closeKeyboardButtonPressed:(id)sender;

@property (assign, nonatomic) id activeControl;
@property (retain, nonatomic) NSArray *inputInfo;
@property (retain, nonatomic) NSArray *storeCardPickerChoices;

@end
