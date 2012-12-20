//
//  MasonryLayoutManager2.m
//  LayoutManagerEx
//
//  Created by  on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MasonryLayoutManager2.h"
#import "CellEx.h"
#import "CellPageEx.h"
#import "CellPageViewControllerEx.h"
#import "ProductWindowScrollViewControllerPad.h"

@interface MasonryLayoutManager2()
- (void)configParameters;
- (void)getWorkingSetForCellPage:(int)pageIndex;
- (void)DivideRectVertical:(CGRect)aRect;
- (void)DivideRectHorizontal:(CGRect)aRect;
- (void)initializeCellPageEx:(int)pageIndex;
- (void)reLayoutCellPage:(int)pageIndex;
@end

@implementation MasonryLayoutManager2

#pragma mark - static

static int CELL_COUNTER = 0;

#pragma mark - define

#pragma mark - macro

#pragma mark - synthesize

@synthesize cellArray;
@synthesize workingSet;
@synthesize lastCellExpanded;
@synthesize pageCellMap;
@synthesize numberOfCellPages;
@synthesize productWindowViewController;

#pragma mark - init, dealloc

- (id)init 
{
    self = [super init];
    if (self) {
        cellArray = [[NSMutableArray array] retain];
        pageCellMap = [[NSMutableDictionary dictionary] retain];
        workingSet = [[NSMutableArray array] retain];
        [self configParameters];
    }
    return self;
}

- (void)configParameters
{
    numCellRow = 4;
    numCellCol = 3;
    viewWidth = 768;
    viewHeight = 1024;
    cellWidth = viewWidth / numCellCol;
    cellHeight = viewHeight / numCellRow;
    maxIndividualBlockCount = 12;
}

- (void)dealloc 
{
    [cellArray release];
    [workingSet release];
    [lastCellExpanded release];
    [pageCellMap release];
    [super dealloc];
}

#pragma mark - public method

- (void)setNumberOfPages:(int)pageCount
{
    //  1. pre-allocate maximum number of cells for all pages
    //  2. call the method responsible for initialize a cell page
    //  3. save number of pages
    self.numberOfCellPages = pageCount;
    int totalCells = pageCount * maxIndividualBlockCount;
    for(int i = 0; i < totalCells; i++)
    {
        CellEx *cell = [[CellEx alloc] init];
        [self.cellArray addObject:cell];
        [cell release];
    }
    
    for(int i = 0; i < pageCount; i++)
    {
        [self initializeCellPageEx:i];
    }
}

- (NSArray *)getCellsForPage:(int)pageIndex
{
    /*
    CellPageEx *cellPage = [self.pageCellMap objectForKey:[NSNumber numberWithInt:pageIndex]];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:cellPage.numberOfCells];
    for(int i = 0; i < cellPage.numberOfCells; i++)
    {
        [array addObject:[self.cellArray objectAtIndex:cellPage.startIndex + i]];
    }
    
    return array;
     */
    CellPageEx *cellPage = [self.pageCellMap objectForKey:[NSNumber numberWithInt:pageIndex]];
    return cellPage.cells;
}

- (void)cellTapped:(CellEx *)aCell inPage:(int)pageIndex
{
    // do nothing, since the cell to expand is already expanded
    if(aCell == lastCellExpanded)
    {
        [self.productWindowViewController showDetailViewController];
        return;
    }
    
    self.lastCellExpanded = aCell;
    
    aCell.isTapped = YES;
    aCell.isExpanded = YES;
    [self reLayoutCellPage:pageIndex];
}

- (BOOL)reLayoutNeeded:(int)pageIndex
{
    CellPageEx *cellPage = [self.pageCellMap objectForKey:[NSNumber numberWithInt:pageIndex]];
    if(cellPage.needsAdjustCells)
    {
        cellPage.needsAdjustCells = NO;
        return YES;
    }
    return NO;
}

- (void)setCellPageViewController:(CellPageViewControllerEx *)viewController forPage:(int)pageIndex
{
    CellPageEx *cellPage = [self.pageCellMap objectForKey:[NSNumber numberWithInt:pageIndex]];
    cellPage.viewController = viewController;
}

#pragma mark - page view creation and initialization

- (void)initializeCellPageEx:(int)pageIndex
{
    // get the working set
    [self getWorkingSetForCellPage:pageIndex];
    
    // find out the starting location
    int startIndex = 0;
    int cellCounter = 0;
    
    if(pageIndex  > 0)
    {
        CellPageEx *cellPage = [self.pageCellMap objectForKey:[NSNumber numberWithInt:pageIndex - 1]];
        startIndex = cellPage.startIndex + cellPage.numberOfCells;
    }
    
    for(int r = 1, cellY = 0; r <= numCellRow; r++, cellY+=cellHeight)
    {
        for(int c = 1, cellX = 0; c <= numCellCol; c++, cellX+=cellWidth)
        {
            for(int i = 0; i < [self.workingSet count]; i++)
            {
                CGRect potentialFrame = [[self.workingSet objectAtIndex:i] CGRectValue];
                
                if(potentialFrame.origin.x == cellX && potentialFrame.origin.y == cellY)
                {
                    //CellEx *cell = [[CellEx alloc] init];
                    CellEx *cell = [self.cellArray objectAtIndex:startIndex + cellCounter];
                    cell.uniqueId = CELL_COUNTER++;
                    cell.ownerId = pageIndex;
                    cell.cellIndex = cellCounter++;
                    cell.horizontalSpan = 1;
                    cell.verticalSpan = 1;
                    
                    if(potentialFrame.size.width == cellWidth * 2 && potentialFrame.size.height == cellHeight)
                        cell.horizontalSpan = 2;
                    
                    if(potentialFrame.size.height == cellHeight * 2 && potentialFrame.size.width == cellWidth)
                        cell.verticalSpan = 2;
                    
                    cell.isExpanded = NO;
                    cell.isTapped = NO;
                    
                    if(potentialFrame.size.width == cellWidth * 2 && potentialFrame.size.height == cellHeight * 2)
                    {
                        cell.isExpanded = YES;
                        cell.isTapped = YES;
                    }
                    
                    cell.cellFrame = potentialFrame;
                    
                    [self.workingSet removeObjectAtIndex:i];
                    break;
                }
            }
        }
    }
    
    CellPageEx *cellPage = [[CellPageEx alloc] init];
    cellPage.pageIndex = pageIndex;
    cellPage.startIndex = startIndex;
    cellPage.numberOfCells = cellCounter;
    cellPage.needsAdjustCells = NO;
    
    for(int i = 0; i < cellCounter; i++)
    {
        CellEx *cell = [self.cellArray objectAtIndex:startIndex + i];
        [cellPage.cells addObject:cell];
    }
    
    [self.pageCellMap setObject:cellPage forKey:[NSNumber numberWithInt:pageIndex]];
    [cellPage release];
}

- (void)getWorkingSetForCellPage:(int)pageIndex
{
    // make sure we start clean
    [self.workingSet removeAllObjects];
    
    if(pageIndex == 0)
    {
        // 1
        [self.workingSet addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, cellWidth, cellHeight)]];
        // 2
        [self.workingSet addObject:[NSValue valueWithCGRect:CGRectMake(cellWidth, 0, cellWidth * 2, cellHeight * 2)]];
        // 3
        [self.workingSet addObject:[NSValue valueWithCGRect:CGRectMake(0, cellHeight, cellWidth, cellHeight)]];
        // 4
        [self.workingSet addObject:[NSValue valueWithCGRect:CGRectMake(0, cellHeight * 2, cellWidth * 2, cellHeight)]];
        // 5
        [self.workingSet addObject:[NSValue valueWithCGRect:CGRectMake(cellWidth * 2, cellHeight * 2, cellWidth, cellHeight)]];
        // 6
        [self.workingSet addObject:[NSValue valueWithCGRect:CGRectMake(0, cellHeight * 3, cellWidth, cellHeight)]];
        // 7
        [self.workingSet addObject:[NSValue valueWithCGRect:CGRectMake(cellWidth, cellHeight * 3, cellWidth, cellHeight)]];
        // 8
        [self.workingSet addObject:[NSValue valueWithCGRect:CGRectMake(cellWidth * 2, cellHeight * 3, cellWidth, cellHeight)]];
    }
    
    if(pageIndex == self.numberOfCellPages - 1)
    {
        // 1
        [self.workingSet addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, cellWidth, cellHeight)]];
    }
    
    // if working set remains empty, that means it needs to be generated
    if([self.workingSet count] == 0)
    {
        CGRect entireZone = CGRectMake(0, 0, viewWidth, viewHeight);
        //[self DivideRectVertical:entireZone];
        [self DivideRectHorizontal:entireZone];
    }
}

- (void)DivideRectVertical:(CGRect)aRect
{
    int width = aRect.size.width;
    
    if(width == 768)
    {
        CGRect leftRect, rightRect;
        int portion = 0;
        
        if(arc4random() % 2 == 0)
        {
            // divide at 256
            portion = 256;
        }
        else
        {
            // divide at 512
            portion = 512;
        }
        
        CGRectDivide(aRect, &leftRect, &rightRect, portion, CGRectMinXEdge);
        
        //NSLog(@"leftRect: %@", NSStringFromCGRect(leftRect));
        //NSLog(@"rightRect: %@", NSStringFromCGRect(rightRect));
        
        [self DivideRectHorizontal:leftRect];
        [self DivideRectHorizontal:rightRect];
    }
    else if(width == 512)
    {
        if(arc4random() % 2 == 0)
        {
            int portion = 256;
            CGRect leftRect, rightRect;
            
            CGRectDivide(aRect, &leftRect, &rightRect, portion, CGRectMinXEdge);
            
            //NSLog(@"leftRect: %@", NSStringFromCGRect(leftRect));
            //NSLog(@"rightRect: %@", NSStringFromCGRect(rightRect));
            
            [self DivideRectHorizontal:leftRect];
            [self DivideRectHorizontal:rightRect];
        }
        else
        {
            // do nothing
            //NSLog(@"rect: %@", NSStringFromCGRect(aRect));
            [self DivideRectHorizontal:aRect];
            //[self.workingSet addObject:[NSValue valueWithCGRect:aRect]];
        }
    }
    else if(width == 256)
    {
        if(aRect.size.height > 512)
        {
            [self DivideRectHorizontal:aRect];
        }
        else if(aRect.size.height >= 512)
        {
            if(arc4random() % 10 >= 2)
                [self DivideRectHorizontal:aRect];
            else
            {
                // do nothing
                NSLog(@"rect: %@", NSStringFromCGRect(aRect));
                [self.workingSet addObject:[NSValue valueWithCGRect:aRect]];
            }
        }
        else
        {
            // do nothing
            NSLog(@"rect: %@", NSStringFromCGRect(aRect));
            [self.workingSet addObject:[NSValue valueWithCGRect:aRect]];
        }
        
        
    }
}

- (void)DivideRectHorizontal:(CGRect)aRect
{
    int height = aRect.size.height;
    
    if(height == 1024)
    {
        CGRect topRect, botRect;
        
        int portion = (arc4random() % 3 + 1) * 256; // divide at 256, 512, 768
        
        CGRectDivide(aRect, &topRect, &botRect, portion, CGRectMinYEdge);
        
        //NSLog(@"topRect: %@", NSStringFromCGRect(topRect));
        //NSLog(@"botRect: %@", NSStringFromCGRect(botRect));
        
        [self DivideRectVertical:topRect];
        [self DivideRectVertical:botRect];
    }
    else if(height == 768)
    {
        CGRect topRect, botRect;
        
        int portion = (arc4random() % 2 + 1) * 256; // divide at 256, 512
        
        CGRectDivide(aRect, &topRect, &botRect, portion, CGRectMinYEdge);
        
        //NSLog(@"topRect: %@", NSStringFromCGRect(topRect));
        //NSLog(@"botRect: %@", NSStringFromCGRect(botRect));
        
        [self DivideRectVertical:topRect];
        [self DivideRectVertical:botRect];
    }
    else if(height == 512)
    {
        if(arc4random() % 2 == 0)
        {
            int portion = 256;
            CGRect topRect, botRect;
            
            CGRectDivide(aRect, &topRect, &botRect, portion, CGRectMinYEdge);
            
            //NSLog(@"topRect: %@", NSStringFromCGRect(topRect));
            //NSLog(@"botRect: %@", NSStringFromCGRect(botRect));
            
            [self DivideRectVertical:topRect];
            [self DivideRectVertical:botRect];
        }
        else
        {
            // do nothing
            //NSLog(@"rect: %@", NSStringFromCGRect(aRect));
            [self DivideRectVertical:aRect];
            //[self.workingSet addObject:[NSValue valueWithCGRect:aRect]];
        }
    }
    else if(height == 256)
    {
        if(aRect.size.width >= 512)
        {
            if(arc4random() % 10 >= 6)
                [self DivideRectVertical:aRect];
            else
            {
                NSLog(@"rect: %@", NSStringFromCGRect(aRect));
                [self.workingSet addObject:[NSValue valueWithCGRect:aRect]];
            }
            
        }
        else
        {
            // do nothing
            NSLog(@"rect: %@", NSStringFromCGRect(aRect));
            [self.workingSet addObject:[NSValue valueWithCGRect:aRect]];
        }
    }
}

#pragma mark - layout update

- (void)reLayoutCellPage:(int)pageIndex
{
    if(pageIndex >= self.numberOfCellPages)
        return;
    
    // 1. calculate and update cell frame for each cell in this page
    // 2. update the visible cell counter for each page as well
    // 3. is aCell is not null, then the cell to expand is reside on this page
    
    NSMutableArray *blockedZones = [NSMutableArray array];
    CGRect entireZone = CGRectMake(0, 0, viewWidth, viewHeight);
    int cellCounter = 0;
    
    CellEx *aCell = nil;
    
    // make sure working set is clean
    [self.workingSet removeAllObjects];
    
    // find out the starting location for working set
    CellPageEx *cellPage = [self.pageCellMap objectForKey:[NSNumber numberWithInt:pageIndex]];
    CellPageEx *nextPage = [self.pageCellMap objectForKey:[NSNumber numberWithInt:pageIndex + 1]];
    
    for(int i = 0; i < [cellPage.cells count]; i++)
    {
        CellEx *cell = [cellPage.cells objectAtIndex:i];
        
        if(cell != self.lastCellExpanded)
            [self.workingSet addObject:cell];
        else
            aCell = self.lastCellExpanded;
    }
    
    if(aCell)
    {
        // figure out how to expand
        //
        // 1.figure out if to the right is feasible
        //      yes: expand to the right
        //      no: expand to left
        // 2.figure out if to the bottom is feasible
        //      yes: expand to bottom
        //      no: expand up
        
        CGRect newFrame = aCell.cellFrame;
        
        // 1. expand horziontally
        newFrame.size.width = (cellWidth + cellWidth);
        if((aCell.cellFrame.origin.x + cellWidth + cellWidth) > viewWidth)
        {
            newFrame.origin.x -= cellWidth;
        }
        
        // 2. expand vertically
        newFrame.size.height = (cellHeight + cellHeight);
        if((aCell.cellFrame.origin.y + cellHeight + cellHeight) > viewHeight)
        {
            newFrame.origin.y -= cellHeight;
        }
        
        aCell.cellFrame = newFrame;
        [blockedZones addObject:[NSValue valueWithCGRect:newFrame]];
        
        cellCounter++;
    }
    
    for(int r = 1, cellY = 0; r <= numCellRow; r++, cellY+=cellHeight)
    {
        for(int c = 1, cellX = 0; c <= numCellCol; c++, cellX+=cellWidth)
        {
            if([self.workingSet count])
            {
                for(int i = 0; i < [self.workingSet count]; i++)
                {
                    CellEx *cell = (CellEx *)[self.workingSet objectAtIndex:i];
                    CGRect potentialFrame = CGRectMake(cellX, cellY, cell.horizontalSpan * cellWidth, cell.verticalSpan * cellHeight);
                    BOOL isInside = NO;
                    
                    for(NSValue *val in blockedZones)
                    {
                        CGRect blockedZone = [val CGRectValue];
                        if(CGRectIntersectsRect(blockedZone, potentialFrame))
                        {
                            isInside = YES;
                            break;
                        }
                    }
                    
                    if(!isInside)
                    {
                        BOOL isFit = CGRectContainsRect(entireZone, potentialFrame);
                        
                        if(isFit)
                        {
                            [self.workingSet removeObject:cell];
                            cell.cellFrame = potentialFrame;
                            cellCounter++;
                            [blockedZones addObject:[NSValue valueWithCGRect:potentialFrame]];
                            
                            break;
                        }
                    }
                }
            }
            else
            {
                // this means theres still space left to fill, get some cells from next page
                if(!nextPage)
                    break;
                
                for(int i = 0; i < [nextPage.cells count]; i++)
                {
                    CellEx *cell = (CellEx *)[nextPage.cells objectAtIndex:i];
                    CGRect potentialFrame = CGRectMake(cellX, cellY, cell.horizontalSpan * cellWidth, cell.verticalSpan * cellHeight);
                    BOOL isInside = NO;
                    
                    for(NSValue *val in blockedZones)
                    {
                        CGRect blockedZone = [val CGRectValue];
                        if(CGRectIntersectsRect(blockedZone, potentialFrame))
                        {
                            isInside = YES;
                            break;
                        }
                    }
                    
                    if(!isInside)
                    {
                        BOOL isFit = CGRectContainsRect(entireZone, potentialFrame);
                        
                        if(isFit)
                        {
                            [cellPage.cells addObject:cell];
                            [nextPage.cells removeObject:cell];
                            cell.cellFrame = potentialFrame;
                            cellCounter++;
                            [blockedZones addObject:[NSValue valueWithCGRect:potentialFrame]];
                            
                            break;
                        }
                    }
                }
            }
        }
    }
    
    for(int i = 0; i < [self.workingSet count]; i++)
    {
        CellEx *cell = (CellEx *)[self.workingSet objectAtIndex:i];
        [nextPage.cells addObject:cell];
        [cellPage.cells removeObject:cell];
    }
    
    for(int i = 0; i < [cellPage.cells count]; i++)
    {
        CellEx *cell = [cellPage.cells objectAtIndex:i];
        NSLog(@"cell in page(%d) frame:%@ id:%d", pageIndex, NSStringFromCGRect(cell.cellFrame), cell.uniqueId);
    }
    
    
    /*
    //      1. if cellCounter == cellPage.numberOfCells:    this means no cell gain and no spillover cells
    //      2. if cellCounter > cellPage.numberOfCells:     gain cells from next page
    //      3. if cellCounter < cellPage.numberOfCells:     spillover cells to next page
    NSLog(@"number of cells fitted, was: %d     now: %d", cellPage.numberOfCells, cellCounter);
    
    if(cellCounter != cellPage.numberOfCells)
    {
        // update next page's cell range
        CellPageEx *nextPage = [self.pageCellMap objectForKey:[NSNumber numberWithInt:pageIndex + 1]];
        nextPage.startIndex += (cellCounter - cellPage.numberOfCells);
        
        // update this page's cell range
        cellPage.numberOfCells = cellCounter;
    }
     */
    
    // do actual layout change
    [cellPage.viewController adjustCells];
    
    // call the next page to layout
    [self reLayoutCellPage:pageIndex + 1];
}

@end
