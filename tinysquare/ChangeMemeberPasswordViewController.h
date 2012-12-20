//
//  ChangeMemeberPasswordViewController.h
//  asoapp
//
//  Created by jason on 12/20/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChangeMemeberPasswordViewController : BaseViewController
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIView *myContentView;

@property (retain, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (retain, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (retain, nonatomic) IBOutlet UITextField *againPwdTextField;
@property (retain, nonatomic) IBOutlet UIButton *savePwdButton;
- (IBAction)savePwdButtonPressed:(id)sender;

@end
