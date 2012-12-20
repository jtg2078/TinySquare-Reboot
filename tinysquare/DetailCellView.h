//
//  DetailCellView.h
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailCellModel;

@interface DetailCellView : UIView {
	DetailCellModel *model;
	BOOL highlighted;
}
@property (nonatomic, retain) DetailCellModel *model;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@end
