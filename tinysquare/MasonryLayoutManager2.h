//
//  MasonryLayoutManager2.h
//  LayoutManagerEx
//
//  Created by  on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CellEx;
@class CellPageViewControllerEx;
@class ProductWindowScrollViewControllerPad;
@interface MasonryLayoutManager2 : NSObject
{
    int numCellRow;
    int numCellCol;
    int viewWidth;
    int viewHeight;
    int cellWidth;
    int cellHeight;
    int maxIndividualBlockCount;
}

@property (nonatomic) int numberOfCellPages;
@property (nonatomic, retain) NSMutableArray *workingSet;
@property (nonatomic, retain) NSMutableArray *cellArray;
@property (nonatomic, retain) CellEx *lastCellExpanded;
@property (nonatomic, retain) NSMutableDictionary *pageCellMap;
@property (nonatomic, assign) ProductWindowScrollViewControllerPad *productWindowViewController;

- (void)setNumberOfPages:(int)pageCount;
- (NSArray *)getCellsForPage:(int)pageIndex;

- (void)cellTapped:(CellEx *)aCell inPage:(int)pageIndex;
- (BOOL)reLayoutNeeded:(int)pageIndex;
- (void)setCellPageViewController:(CellPageViewControllerEx *)viewController forPage:(int)pageIndex;

@end
