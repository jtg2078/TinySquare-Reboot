//
//  TermsOfServiceViewController.h
//  TinySquare
//
//  Created by jason on 12/26/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TermsOfServiceViewController : BaseViewController
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIView *myContentView;
@property (retain, nonatomic) IBOutlet UIButton *agreeButton;
@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
@property (assign, nonatomic) BOOL callFromCreateMemeberVC;

- (IBAction)agreeButtonPressed:(id)sender;

@end
