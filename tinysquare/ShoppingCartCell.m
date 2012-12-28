//
//  ShoppingCartCell.m
//  TinySquare
//
//  Created by jason on 12/28/12.
//
//

#import "ShoppingCartCell.h"

@implementation ShoppingCartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_productImageView release];
    [_discountPriceLabel release];
    [_originalPriceLabel release];
    [_productNameLabel release];
    [_countTextField release];
    [_stockCountLabel release];
    [_lastUpdatedTimeLabel release];
    [super dealloc];
}
@end
