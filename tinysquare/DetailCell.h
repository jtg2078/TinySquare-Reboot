//
//  DetailCell.h
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCellView.h"
#import "DetailCellModel.h"
#import "DetailCellDelegate.h"


@interface DetailCell : UITableViewCell {
	DetailCellView *cellView;
    NSObject<DetailCellDelegate> *delegate;
}
@property (nonatomic, assign) id<DetailCellDelegate> delegate;
- (id)initWithData:(DetailCellModel *)cellData style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)redrawWithModel:(DetailCellModel *)anModel;
- (void)redrawCellView;
@end
