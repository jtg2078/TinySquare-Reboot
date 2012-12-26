//
//  EditMemeberViewController.h
//  asoapp
//
//  Created by jason on 12/20/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIPickerViewButton.h"

@interface EditMemeberViewController : BaseViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIView *myContentView;
@property (retain, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *addressTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;
@property (retain, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (retain, nonatomic) IBOutlet UITextField *genderTextField;
@property (retain, nonatomic) IBOutlet UIPickerViewButton *receiptButton;
@property (retain, nonatomic) IBOutlet UITextField *buyerNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *taxIDTextField;
@property (retain, nonatomic) IBOutlet UIPickerViewButton *sameButton;
@property (retain, nonatomic) IBOutlet UITextField *receiptAddressTextField;
@property (retain, nonatomic) IBOutlet UIButton *saveChangeButton;

- (IBAction)receiptButtonPressed:(id)sender;
- (IBAction)sameButtonPressed:(id)sender;
- (IBAction)saveChangeButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *receiptPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *samePicker;

@property (retain, nonatomic) IBOutlet UIToolbar *inputToolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *dismissKeyboardButton;

- (IBAction)previousButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)closeKeyboardButtonPressed:(id)sender;
- (IBAction)birthdayPickerChanged:(id)sender;

@property (assign, nonatomic) id activeControl;
@property (retain, nonatomic) NSDateFormatter *dateFormatter;
@property (retain, nonatomic) NSArray *inputInfo;
@property (retain, nonatomic) NSArray *genderPickerChoices;
@property (retain, nonatomic) NSArray *receiptPickerChoices;
@property (retain, nonatomic) NSArray *samePickerChoices;
@property (retain, nonatomic) NSDate *selectedBirthday;
@property (assign, nonatomic) int selectedGender;
@property (assign, nonatomic) BOOL isSameAsAddress;
@property (assign, nonatomic) BOOL useReceipt;

@end
