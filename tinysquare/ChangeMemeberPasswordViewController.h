//
//  ChangeMemeberPasswordViewController.h
//  asoapp
//
//  Created by jason on 12/20/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChangeMemeberPasswordViewController : BaseViewController <UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIView *myContentView;

@property (retain, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (retain, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (retain, nonatomic) IBOutlet UITextField *againPwdTextField;
@property (retain, nonatomic) IBOutlet UIButton *savePwdButton;

- (IBAction)savePwdButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIToolbar *inputToolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *dismissKeyboardButton;

- (IBAction)previousButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)closeKeyboardButtonPressed:(id)sender;

@property (retain, nonatomic) NSArray *inputInfo;
@property (assign, nonatomic) id activeControl;

@end
