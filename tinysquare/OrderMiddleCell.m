//
//  OrderMiddleCell.m
//  TinySquare
//
//  Created by jason on 12/29/12.
//
//

#import "OrderMiddleCell.h"

@implementation OrderMiddleCell

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
    [_productNameLabel release];
    [_unitPriceLabel release];
    [_unitLabel release];
    [_sumLabel release];
    [super dealloc];
}
@end
