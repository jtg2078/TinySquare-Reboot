//
//  ShoppingCartCell.h
//  TinySquare
//
//  Created by jason on 12/28/12.
//
//

#import <UIKit/UIKit.h>

@interface ShoppingCartCell : UITableViewCell
{
    
}

@property (retain, nonatomic) IBOutlet UIImageView *productImageView;
@property (retain, nonatomic) IBOutlet UILabel *discountPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *productNameLabel;
@property (retain, nonatomic) IBOutlet UITextField *countTextField;
@property (retain, nonatomic) IBOutlet UILabel *stockCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *lastUpdatedTimeLabel;


@end
