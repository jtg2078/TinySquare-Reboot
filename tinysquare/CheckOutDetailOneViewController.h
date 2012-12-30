//
//  CheckOutDetailOneViewController.h
//  TinySquare
//
//  Created by jason on 12/30/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIPickerViewButton.h"

@interface CheckOutDetailOneViewController : BaseViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIView *myContentView;

@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *addressTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;
@property (retain, nonatomic) IBOutlet UITextField *deliverTimeTextField;
@property (retain, nonatomic) IBOutlet UITextField *noteTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UIPickerViewButton *useReceiptButton;

- (IBAction)useReceiptButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *receiptNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *taxIDTextField;
@property (retain, nonatomic) IBOutlet UIPickerViewButton *sameInfoButton;
@property (retain, nonatomic) IBOutlet UITextField *receiptAddressTextField;

- (IBAction)sameInfoButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *nextStepButton;
@property (retain, nonatomic) IBOutlet UIPickerView *receiptPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *samePicker;

- (IBAction)nextStepButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIToolbar *inputToolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *dismissKeyboardButton;

- (IBAction)previousButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)closeKeyboardButtonPressed:(id)sender;

@property (assign, nonatomic) id activeControl;
@property (retain, nonatomic) NSArray *inputInfo;
@property (retain, nonatomic) NSArray *receiptPickerChoices;
@property (retain, nonatomic) NSArray *samePickerChoices;

@end
