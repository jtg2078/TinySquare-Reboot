//
//  CellPageEx.h
//  LayoutManagerEx
//
//  Created by  on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CellPageViewControllerEx;
@interface CellPageEx : NSObject

@property (nonatomic) int pageIndex;
@property (nonatomic) NSRange cellRange;
@property (nonatomic) BOOL needsAdjustCells;
@property (nonatomic) int startIndex;
@property (nonatomic) int numberOfCells;
@property (nonatomic, assign) CellPageViewControllerEx *viewController;
@property (nonatomic, retain) NSMutableArray *cells;

@end
