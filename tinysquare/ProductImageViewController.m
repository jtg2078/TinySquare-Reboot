    //
//  ProductImageViewControllerEx.m
//  TinyStore
//
//  Created by jason on 2011/9/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductImageViewController.h"

#import "ProductImageController.h"
#import "UINavigationController+Customize.h"
#import "ImageManager.h"
#import "ProductImagePageControl.h"


@interface ProductImageViewController ()
- (void)loadScrollViewWithPage:(int)page;
- (void)setupPageControl;
@end

@implementation ProductImageViewController

#pragma mark -
#pragma mark define

#define NUM_OF_IMAGES		5
#define PATH_FOR_TRACKING	@"/ProductImageViewController"


#pragma mark -
#pragma mark synthesize

@synthesize viewControllers;
@synthesize contentList;


#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
	[scrollView release];
	[pageControl release];
	[titleLabel release];
	[viewControllers release];
	[contentList release];
    [super dealloc];
}


#pragma mark -
#pragma mark initialization and view construction

- (void)loadView 
{
	// base view plate
	UIView *baseView = [[UIView alloc] init];
	baseView.frame = CGRectMake(0, 0, 320, 367);
	baseView.backgroundColor = [UIColor clearColor];
	
	// setup scroll view
	scrollView = [[UIScrollView alloc] init];
	scrollView.frame = CGRectMake(0, 0, 320, 367);
	scrollView.backgroundColor = [UIColor clearColor];
	[baseView addSubview:scrollView];
	
	// setup page controller
	pageControl = [[ProductImagePageControl alloc] initWithFrame:CGRectMake(0, 321, 320, 40)];
	[baseView addSubview:pageControl];
	
	self.view = baseView;
	[baseView release];
}


#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Create a custom back button
	UIButton* backButton = [self.navigationController setUpCustomizeBackButtonWithText:NSLocalizedString(@"返回", nil)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	
	// setup title view
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
	titleLabel = [[UILabel alloc] init];
	titleLabel.text = [NSString stringWithFormat:@"1 / %d", kNumberOfPages];
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.frame = CGRectMake(0, 0, [titleLabel.text sizeWithFont:font].width, 44);
	titleLabel.font = font;
	self.navigationItem.titleView = titleLabel;
	
	kNumberOfPages = self.contentList.count;
	titleLabel.text = [NSString stringWithFormat:@"%d / %d", 1, kNumberOfPages];
	
	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
	
	// a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
	// setup page control
	[self setupPageControl];
	
	// pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
	
	// tracking
	[self googleAnalyticsTrackPageView:PATH_FOR_TRACKING];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.viewControllers = nil;
	self.contentList = nil;
	[titleLabel release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark private interface

- (void)setupPageControl
{
	[pageControl setupPageControl:kNumberOfPages];
	pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
	pageControl.delegate = self;
	pageControlUsed = NO;
	
	int i = 0;
	for(NSString *imageName in self.contentList)
	{
		UIImage* image = [ImageManager loadImage:[NSURL URLWithString:imageName]];
		if (image) 
			[pageControl setPageIcon:image forPage:i];
		
		i++;
	}
}

- (void)loadScrollViewWithPage:(int)page 
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    ProductImageController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
		//NSNumber *itemId = (NSNumber *)[self.contentList objectAtIndex:page];
		//controller = [[ProductImageController alloc] initWithImageName:[NSString stringWithFormat:@"%d-%d.png", eggId, [itemId intValue]]];
		controller = [[ProductImageController alloc] initWithImageName:[self.contentList objectAtIndex:page]];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)imageLoaded:(UIImage*)image withURL:(NSString *)url 
{
	int i = 0;
	for(NSString *imageName in self.contentList)
	{
		if([imageName isEqualToString:url])
			[pageControl setPageIcon:image forPage:i];
		i++;
	}
	
	SEL selector = @selector(imageLoaded:withURL:);
	for (UIViewController* vc in self.viewControllers) 
	{
		if ([vc respondsToSelector:selector])
			[vc performSelector:selector withObject:image withObject:url];
	}
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	titleLabel.text = [NSString stringWithFormat:@"%d / %d", pageControl.currentPage + 1, kNumberOfPages];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}


#pragma mark -
#pragma mark ProductImagePageControlDelegate

- (void)pageControlPageDidChange:(ProductImagePageControl *)thePageControl
{
    int page = thePageControl.currentPage;
	titleLabel.text = [NSString stringWithFormat:@"%d / %d", pageControl.currentPage + 1, kNumberOfPages];
	// load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
	
	pageControlUsed = YES;
}


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


@end
