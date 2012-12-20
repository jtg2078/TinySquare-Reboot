//
//  CellPageEx.m
//  LayoutManagerEx
//
//  Created by  on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CellPageEx.h"
#import "CellPageViewControllerEx.h"

@implementation CellPageEx

@synthesize cells;
@synthesize cellRange;
@synthesize needsAdjustCells;
@synthesize pageIndex;
@synthesize startIndex;
@synthesize numberOfCells;
@synthesize viewController;

- (id)init {
    self = [super init];
    if (self) {
        self.cells = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [cells  release];
    [super dealloc];
}

@end
