//
//  CellPageViewControllerEx.h
//  LayoutManagerEx
//
//  Created by  on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class MasonryLayoutManager2;
@interface CellPageViewControllerEx : UIViewController
{
    int numCellRow;
    int numCellCol;
    int viewWidth;
    int viewHeight;
    int cellWidth;
    int cellHeight;
    int maxIndividualBlockCount;
}

@property (nonatomic) int pageIndex;
@property (nonatomic, assign) MasonryLayoutManager2 *layoutManager;
@property (nonatomic, retain) NSArray *cellViewArray;

- (void)configParameters;
- (void)adjustCells;
- (void)reLayoutIfNeeded;

@end
