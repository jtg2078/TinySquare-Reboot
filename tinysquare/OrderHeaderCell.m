//
//  OrderHeaderCell.m
//  TinySquare
//
//  Created by jason on 12/29/12.
//
//

#import "OrderHeaderCell.h"

@implementation OrderHeaderCell

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

- (void)dealloc
{
    [_iconImageView release];
    [_orderNumberLabel release];
    [_orderDateLabel release];
    [_orderTotalLabel release];
    [_arrowImageView release];
    [_lineImageView release];
    [super dealloc];
}
@end
