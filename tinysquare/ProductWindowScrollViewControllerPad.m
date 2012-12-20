//
//  ProductWindowScrollViewController.m
//  tinysquare
//
//  Created by  on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//
//  HotProductScrollViewControllerPad.m
//  tinysquare
//
//  Created by  on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductWindowScrollViewControllerPad.h"
#import "UINavigationController+Customize.h"
#import "DetailViewController.h"
#import "DataManager.h"
#import "PageControl.h"
#import "MKInfoPanel.h"
#import "ThemeManager.h"

#import "Product.h"
#import "ProductItem.h"
#import "ItemImage.h"
#import "UIApplication+AppDimensions.h"
#import "MasonryLayoutManager2.h"
#import "CellPageViewControllerEx.h"
#import "ProductDetailViewControllerPad.h"


@interface ProductWindowScrollViewControllerPad ()
- (void)loadScrollViewWithPage:(int)page;
- (void)goToDetail;
- (void)setupEverything;
- (void)showWarningIfNoData;
@end

@implementation ProductWindowScrollViewControllerPad

#pragma mark -
#pragma mark define

#define TAB_IMAGE_NAME	@"HotProductTabIcon.png"
#define MODULE_NAME		NSLocalizedString(@"熱門商品", nil)
#define DUMMY_DATA_ID   50
#define PATH_FOR_TRACKING	@"/HotProductMainViewController"

#define ITEM_INFO_NAME          @"name"
#define ITEM_INFO_IMAGE         @"image"
#define ITEM_INFO_TIME          @"time"
#define ITEM_INFO_PRICE         @"price"
#define ITEM_INFO_SUMMARY       @"summary"
#define ITEM_CARD_WIDTH         320
#define MAX_ITEM_COUNT          10
#define IMAGE_TYPE_AD           200


#pragma mark -
#pragma mark synthesize

@synthesize viewControllers;
@synthesize scrollView;
@synthesize pageControl;
@synthesize layoutManager;
@synthesize productDetailViewController;


#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
	[scrollView release];
	[pageControl release];
	[viewControllers release];
    [layoutManager release];
    [productDetailViewController release];
    [super dealloc];
}

#pragma mark -
#pragma mark init and loadView

- (id)init
{
	if (self = [super init]) 
	{
		self.title = MODULE_NAME;
		
		// tab bar item and image
		UIImage* anImage = [UIImage imageNamed:TAB_IMAGE_NAME];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:MODULE_NAME image:anImage tag:0];
		self.tabBarItem = theItem;
		[theItem release];
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
    CGSize screenSize = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
	// base view plate
	UIView *baseView = [[UIView alloc] init];
	baseView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
	baseView.backgroundColor = [UIColor clearColor];
	
	// setup scroll view
	scrollView = [[UIScrollView alloc] init];
	scrollView.frame = CGRectMake(0, -20, screenSize.width, screenSize.height + 20);
	scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	[baseView addSubview:scrollView];
    
    // shadow image view at bottom
    UIImageView *bottomShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"control-shadow.png"]];
    bottomShadowImageView.frame = CGRectMake(0, 898, 768, 106);
    [baseView addSubview:bottomShadowImageView];
    [bottomShadowImageView release];
    
	// setup page controller
	pageControl = [[PageControl alloc] initWithFrame:CGRectMake(0, 968, screenSize.width, 36)];
    pageControl.delegate = self;
    pageControl.dotColorCurrentPage = themeManager.hotProductPageDotActive;
    pageControl.dotColorOtherPage = themeManager.hotProductPageDotNormal;
	//[baseView addSubview:pageControl];
    
	self.view = baseView;
	[baseView release];
}


#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// set up notification for handling user click on image to go to detail
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(goToDetail) 
												 name:@"com.fingertipcreative.tinysquare.goToDetail" object:nil];
    // key method!
    [self setupEverything];
    
    // tracking
	[self googleAnalyticsTrackPageView:PATH_FOR_TRACKING];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.viewControllers = nil;
    self.scrollView = nil;
    self.pageControl = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark -
#pragma mark theme change

- (void)updateToCurrentTheme:(NSNotification *)notif {
    [super updateToCurrentTheme:notif];
    [self applyTheme];
}

- (void)applyTheme {
    [super applyTheme];
    
    // update bg background the default loading image
    //ThemeManager *themeManager = [ThemeManager sharedInstance];
}


#pragma mark -
#pragma mark core methods

- (void)setupEverything
{
    kNumberOfPages = 4;
    
    // init the layout manager
    MasonryLayoutManager2 *mlm = [[MasonryLayoutManager2 alloc] init];
    [mlm setNumberOfPages:kNumberOfPages];
    self.layoutManager = mlm;
    self.layoutManager.productWindowViewController = self;
    [mlm release];
    
    if(kNumberOfPages == 0)
    {
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeProgress
                               title:NSLocalizedString(@"讀取中... 請稍後", nil) 
                            subtitle:nil
                           hideAfter:10];
        [self performSelector:@selector(showWarningIfNoData) withObject:nil afterDelay:10];
    }
	
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
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
	
	pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
	pageControlUsed = NO;
	
	// pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(int)page 
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    CellPageViewControllerEx *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[CellPageViewControllerEx alloc] init];
        controller.pageIndex = page;
        controller.layoutManager = self.layoutManager;
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
        [self.layoutManager setCellPageViewController:controller forPage:page];
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

#pragma mark - view transition

- (void)showDetailViewController
{
    if(!self.productDetailViewController)
    {
        productDetailViewController = [[ProductDetailViewControllerPad alloc] init];
        productDetailViewController.view.hidden = YES;
        [self.view addSubview:productDetailViewController.view];
    }
    
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.4;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	//NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	//NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
	//int rnd = random() % 4;
	transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[self.view.layer addAnimation:transition forKey:nil];
	
	self.productDetailViewController.view.hidden = NO;
}


#pragma mark -
#pragma mark data source

- (void)updateCurrentPageDetail:(int)page 
{
    
}




#pragma mark - 
#pragma mark PageControlDelegate

- (void)pageControlPageDidChange:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}



#pragma mark -
#pragma mark private interface

- (void)goToDetail
{
    
}

- (void)addToBookmark
{
	
}

- (void)showWarningIfNoData
{
    
}


#pragma mark -
#pragma mark Image loading

- (void)imageLoaded:(UIImage*)image withURL:(NSString *)url 
{
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
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end


