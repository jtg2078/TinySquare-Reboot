//
//  InvoiceDetailCell.h
//  TinySquare
//
//  Created by jason on 12/30/12.
//
//

#import <UIKit/UIKit.h>

@interface InvoiceDetailCell : UITableViewCell
{
    
}

@property (retain, nonatomic) IBOutlet UILabel *productNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *unitLabel;
@property (retain, nonatomic) IBOutlet UILabel *sumLabel;

@end
