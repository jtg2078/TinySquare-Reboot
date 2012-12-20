//
//  CellPageViewControllerEx.m
//  LayoutManagerEx
//
//  Created by  on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CellPageViewControllerEx.h"
#import "CellEx.h"
#import "CellViewEx.h"
#import "MasonryLayoutManager2.h"


@implementation CellPageViewControllerEx

#pragma mark - static

#pragma mark - define

#define BACKGROUND_COLOR [UIColor whiteColor]

#pragma mark - macro

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define SHOW_LAYER_BORDER(s) s.layer.borderWidth = 2.0f; s.layer.borderColor = [[UIColor redColor] CGColor]

#pragma mark - synthesize

@synthesize cellViewArray;
@synthesize layoutManager;
@synthesize pageIndex;

#pragma mark - init, loadView, dealloc

- (id)init 
{
    self = [super init];
    if (self) {
        [self configParameters];
    }
    return self;
}

- (void)loadView
{
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    baseView.backgroundColor = BACKGROUND_COLOR;
    
    NSArray *cellArray = [self.layoutManager getCellsForPage:self.pageIndex];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:maxIndividualBlockCount];
    for(int i = 0; i < maxIndividualBlockCount; i++)
    {
        CellViewEx *cellView = [[CellViewEx alloc] init];
        cellView.indexInPage = i;
        cellView.frame = CGRectMake(viewWidth, 0, cellWidth, cellHeight);
        if(i < [cellArray count])
        {
            CellEx *cell = [cellArray objectAtIndex:i];
            cellView.cell = cell;
            cellView.frame = cell.cellFrame;
        }
        
        [cellView configCellContent];
        /*
        // debugging, add some random content first
        UILabel *cellContent = [[UILabel alloc] init];
        cellContent.frame = CGRectMake(0, 0, cellView.frame.size.width, cellView.frame.size.height);
        if(cellView.cell)
            cellContent.text = [NSString stringWithFormat:@"%d", cellView.cell.uniqueId + 1];
        else
            cellContent.text = @"e";
        cellContent.textAlignment = UITextAlignmentCenter;
        cellContent.font = [UIFont systemFontOfSize:25];
        cellContent.tag = 101;
        [cellView addSubview:cellContent];
        [cellContent release];
        SHOW_LAYER_BORDER(cellView);
        // ---- end debugging ----
         */
        
        [array addObject:cellView];
        [baseView addSubview:cellView];
        [cellView release];
    }
    self.cellViewArray = array;
    
    self.view = baseView;
    [baseView release];
}

- (void)dealloc 
{
    [cellViewArray release];
    [super dealloc];
}
 
#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
	[self.view addGestureRecognizer:tapgr];
	[tapgr release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.cellViewArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark - public method

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

- (void)reLayoutIfNeeded
{
    if([self.layoutManager reLayoutNeeded:self.pageIndex])
    {
        [self adjustCells];
    }    
}

- (void)adjustCells
{
    NSArray *cellArray = [self.layoutManager getCellsForPage:self.pageIndex];
    
    [UIView animateWithDuration:0.4 
                          delay:0
						options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction 
                     animations:^
     {
         int index = 0;
         for(CellViewEx *cellView in self.cellViewArray)
         {
             if(index < [cellArray count])
             {
                 CellEx *cell = [cellArray objectAtIndex:index];
                 cellView.frame = cell.cellFrame;
                 cellView.cell = cell;
                 //NSLog(@"adjustCells cell frame: %@", NSStringFromCGRect(cell.cellFrame));
                 
                 // debugging, add some random content first
                 UILabel *cellContent =  (UILabel *)[cellView viewWithTag:101];
                 cellContent.frame = CGRectMake(0, 0, cellView.frame.size.width, cellView.frame.size.height);
                 cellContent.text = [NSString stringWithFormat:@"%d", cell.uniqueId];
                 // end debug
             }
             else
             {
                 cellView.frame = CGRectMake(1024, 0, cellView.frame.size.width, cellView.frame.size.height);
                 
             }
             index++;
         }
     }
                     completion:^(BOOL finished) 
     {
         
     }];
    
}

#pragma mark - user interaction

- (void)tapCell:(UITapGestureRecognizer *)gesture
{
    CGPoint touchLocation = [gesture locationInView:self.view];
    
    for(CellViewEx *cellView in self.cellViewArray)
    {
        BOOL touched = CGRectContainsPoint(cellView.frame, touchLocation);
        
        if(touched)
        {
            [self.layoutManager cellTapped:cellView.cell inPage:self.pageIndex];
            //[self adjustCells];
            
            break;
        }
    }
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
