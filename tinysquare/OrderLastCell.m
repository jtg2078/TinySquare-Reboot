//
//  OrderLastCell.m
//  TinySquare
//
//  Created by jason on 12/29/12.
//
//

#import "OrderLastCell.h"

@implementation OrderLastCell

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
    [_totalCountLabel release];
    [_sumPriceLabel release];
    [_shippingLabel release];
    [super dealloc];
}
@end
