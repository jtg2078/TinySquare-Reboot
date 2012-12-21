//
//  CreateMemberViewController.h
//  asoapp
//
//  Created by jason on 12/20/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIPickerViewButton.h"

@interface CreateMemberViewController : BaseViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIView *myContentView;

@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UITextField *pwdTextField;
@property (retain, nonatomic) IBOutlet UITextField *pwdAgainTextField;
@property (retain, nonatomic) IBOutlet UIPickerViewButton *privacyCheckButton;
- (IBAction)privacyCheckButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *addressTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;
@property (retain, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (retain, nonatomic) IBOutlet UITextField *genderTextField;
@property (retain, nonatomic) IBOutlet UIButton *createAccountButton;
- (IBAction)createAccountButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIToolbar *inputToolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *dismissKeyboardButton;

- (IBAction)previousButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)closeKeyboardButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIPickerView *privacyChoicePicker;
@property (retain, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *genderPicker;

- (IBAction)birthdayPickerChanged:(id)sender;

@property (retain, nonatomic) NSArray *inputInfo;
@property (retain, nonatomic) NSArray *privacyPickerChoices;
@property (retain, nonatomic) NSArray *genderPickerChoices;

@property (assign, nonatomic) id activeControl;

@property (assign, nonatomic) BOOL selectedPrivacy;
@property (assign, nonatomic) int selectedGender;
@property (assign, nonatomic) NSDate *selectedBirthday;

@property (retain, nonatomic) NSDateFormatter *dateFormatter;

@end
