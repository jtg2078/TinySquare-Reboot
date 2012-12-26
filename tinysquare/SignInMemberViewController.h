//
//  SignInMemberViewController.h
//  TinySquare
//
//  Created by jason on 12/22/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SignInMemberViewController : BaseViewController <UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIView *myContentView;
@property (retain, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (retain, nonatomic) IBOutlet UITextField *userPwdTextField;
@property (retain, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
@property (retain, nonatomic) IBOutlet UIButton *forgetPwdButton;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIButton *createMemberButton;
@property (retain, nonatomic) IBOutlet UIToolbar *inputToolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *dismissKeyboardButton;

@property (retain, nonatomic) NSArray *inputInfo;
@property (assign, nonatomic) id activeControl;

- (IBAction)autoLoginSwitchValueChanged:(id)sender;
- (IBAction)forgetPwdButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)createMemberButtonPressed:(id)sender;
- (IBAction)previousButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)closeKeyboardButtonPressed:(id)sender;

@end
