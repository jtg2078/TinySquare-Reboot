//
//  CellViewEx.h
//  LayoutManagerEx
//
//  Created by  on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CellEx;
@class ProductCellViewControllerPad;
@interface CellViewEx : UIView

@property (nonatomic) int indexInPage;
@property (nonatomic, retain) CellEx *cell;
@property (nonatomic, retain) ProductCellViewControllerPad* pcvc;

- (void)configCellContent;

@end