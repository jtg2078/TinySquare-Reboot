//
//  CheckOutDetailTwoViewController.h
//  TinySquare
//
//  Created by jason on 12/30/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CheckOutDetailTwoViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

// data
@property (retain, nonatomic) NSString *recipientName;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *deliverTime;
@property (retain, nonatomic) NSString *note;
@property (retain, nonatomic) NSString *taxID;
@property (retain, nonatomic) NSString *receiptName;
@property (retain, nonatomic) NSString *receiptAddress;

@property (retain, nonatomic) IBOutlet UITableView *myTableView;

@property (retain, nonatomic) IBOutlet UIImageView *tableViewBgImageView;
@property (retain, nonatomic) IBOutlet UILabel *memberNameLabel;

@property (retain, nonatomic) IBOutlet UIButton *nextStepButton;

- (IBAction)nextStepButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *myTableHeaderView;

@property (retain, nonatomic) IBOutlet UILabel *recipientNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *deliverTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *noteLabel;

@property (retain, nonatomic) IBOutlet UIView *myTableFooterView;

@property (retain, nonatomic) IBOutlet UILabel *totalItemCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalProductPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *shippingLabel;
@property (retain, nonatomic) IBOutlet UILabel *receiptNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *taxIDLabel;
@property (retain, nonatomic) IBOutlet UILabel *receiptAddressLabel;



@end
