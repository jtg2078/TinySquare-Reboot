//
//  OrderHeaderCell.h
//  TinySquare
//
//  Created by jason on 12/29/12.
//
//

#import <UIKit/UIKit.h>

@interface OrderHeaderCell : UITableViewCell
{
    
}

@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;
@property (retain, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *orderTotalLabel;
@property (retain, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (retain, nonatomic) IBOutlet UIImageView *lineImageView;
@property (retain, nonatomic) UITapGestureRecognizer *gestureRecognizer;

@property (assign, nonatomic) int sectionIndex;

@end
