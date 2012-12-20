//
//  BookmarkViewControllerPad.m
//  tinysquare
//
//  Created by  on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookmarkViewControllerPad.h"
#import "UIApplication+AppDimensions.h"
#import "BookmarkCellPad.h"


@implementation BookmarkViewControllerPad

#pragma mark - define

#define BOOKMARKCELL_WIDTH  768
#define BOOKMARKCELL_HEIGHT 249

#pragma mark - macro

#pragma mark - synthesize

@synthesize gridView;

#pragma mark - dealloc

- (void)dealloc {
    [gridView release];
    [super dealloc];
}

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - loadView

- (void)loadView
{
    CGSize screenSize = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    gridView = [[AQGridView alloc] init];
    gridView.frame = baseView.frame;
    gridView.dataSource = self;
    gridView.separatorStyle = AQGridViewCellSeparatorStyleNone;
    [baseView addSubview:gridView];
    
    self.view = baseView;
    [baseView release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = NO;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
     */
    [self.gridView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.gridView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return 4;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * BookmarkCellIdentifier = @"BookmarkCellIdentifier";
    
    AQGridViewCell *cell = nil;
    BookmarkCellPad *bookmarkCell = (BookmarkCellPad *)[aGridView dequeueReusableCellWithIdentifier: BookmarkCellIdentifier];
    if(bookmarkCell == nil)
    {
        bookmarkCell = [[[BookmarkCellPad alloc] initWithFrame:CGRectMake(0, 0, BOOKMARKCELL_WIDTH, BOOKMARKCELL_HEIGHT) reuseIdentifier:BookmarkCellIdentifier] autorelease];
        bookmarkCell.selectionStyle = AQGridViewCellSelectionStyleNone;
    }
    bookmarkCell.productImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Favorite_Photo0%d.png",index + 1]];
    bookmarkCell.prodctContentImageView.image = [UIImage imageNamed:@"Favorite_Words.png"];
    cell = bookmarkCell;
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(BOOKMARKCELL_WIDTH, BOOKMARKCELL_HEIGHT);
}

#pragma mark -
#pragma mark Grid View Delegate

// nothing here yet

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
