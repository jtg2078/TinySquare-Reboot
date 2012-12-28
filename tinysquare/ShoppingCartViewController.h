//
//  ShoppingCartViewController.h
//  TinySquare
//
//  Created by jason on 12/28/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ShoppingCartViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    int tableViewWidth;
    int tableViewHeight;
    
}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UIView *myHeaderView;
@property (retain, nonatomic) IBOutlet UILabel *totalItemCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *shippingCostLabel;
@property (retain, nonatomic) IBOutlet UILabel *freeShippingCostLabel;
@property (retain, nonatomic) IBOutlet UILabel *checkoutCostLabel;
@property (retain, nonatomic) IBOutlet UIButton *buyButton;

- (IBAction)buyButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIToolbar *inputToolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *dismissKeyboardButton;

- (IBAction)closeKeyboardButtonPressed:(id)sender;

@property (retain, nonatomic) NSArray *productArray;
@property (retain, nonatomic) NSMutableDictionary *countDict;

@end
