    //
//  HotProductMainViewController.m
//  TinyStore
//
//  Created by jason on 2011/9/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotProductMainViewController.h"
#import "HotProductDetailViewController.h"
#import "UINavigationController+Customize.h"
#import "DetailViewController.h"
#import "PageControl.h"
#import "MKInfoPanel.h"
#import "ThemeManager.h"

#import "DataManager.h"
#import "TmpHotProduct.h"
#import "EggApiManager.h"
#import "HotProductDetailModelManager.h"
#import "QRscanningViewController.h"
#import "Membership.h"


@interface HotProductMainViewController ()
- (void)loadScrollViewWithPage:(int)page;
- (void)goToDetail;
- (void)refreshHotProduct;
- (void)setupEverything;
- (void)setTotalItemCount;
- (void)loadFromCoreData;
- (void)insertPage:(int)page;
- (void)removePage:(int)page;
- (void)updatePage:(int)page;
- (void)showWarningIfNoData;
- (void)updateHotProducts;
- (void)setupNavigationBarButtons;

- (void)beginQRscanning;
@end


@implementation HotProductMainViewController

#pragma mark -
#pragma mark define

#define TAB_IMAGE_NAME	@"HotProductTabIcon.png"
#define MODULE_NAME		@"熱門商品"
#define DUMMY_DATA_ID   50
#define PATH_FOR_TRACKING	@"/HotProductMainViewController"


//#define ITEM_INFO_NAME          @"name"
//#define ITEM_INFO_IMAGE         @"image"
//#define ITEM_INFO_TIME          @"time"
//#define ITEM_INFO_PRICE         @"price"
//#define ITEM_INFO_SALE_PRICE    @"salePrice"
//#define ITEM_INFO_SUMMARY       @"summary"
#define ITEM_CARD_WIDTH         320
#define MAX_ITEM_COUNT          10
#define IMAGE_TYPE_AD           200
#define SELF_UPDATE_INTERVAL    3600 // 1 hour


#pragma mark -
#pragma mark synthesize

@synthesize viewControllers;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize scrollView;
@synthesize pageControl;
@synthesize lastUpdateTime;


#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
	[scrollView release];
	[pageControl release];
	[viewControllers release];
	[managedObjectContext release];
    [fetchedResultsController release];
    [lastUpdateTime release];
    [super dealloc];
}


#pragma mark -
#pragma mark init and loadView

- (id)init
{
	if (self = [super init]) 
	{
		self.title = NSLocalizedString(@"熱門商品", nil);
		
		// tab bar item and image
		UIImage* anImage = [UIImage imageNamed:TAB_IMAGE_NAME];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:self.title image:anImage tag:0];
		self.tabBarItem = theItem;
		[theItem release];
        reloadAttempt = 0;
	}
	return self;
}

- (void)loadView 
{
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
	// base view plate
	UIView *baseView = [[UIView alloc] init];
	baseView.frame = CGRectMake(0, 0, 320, 367);
	baseView.backgroundColor = [UIColor clearColor];
	
	// setup scroll view
	scrollView = [[UIScrollView alloc] init];
	scrollView.frame = CGRectMake(0, 0, 320, 367);
	scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	[baseView addSubview:scrollView];
	
	// setup page controller
	pageControl = [[PageControl alloc] initWithFrame:CGRectMake(0, 338, 320, 36)];
    pageControl.delegate = self;
    pageControl.dotColorCurrentPage = themeManager.hotProductPageDotActive;
    pageControl.dotColorOtherPage = themeManager.hotProductPageDotNormal;
	[baseView addSubview:pageControl];
	
	self.view = baseView;
	[baseView release];
}

- (void)setupNavigationBarButtons
{
    // update/refresh button
	UIButton* updateButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"重新整理", nil) 
                                                                                     icon:CustomizeButtonIconReload
                                                                            iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                   target:self 
                                                                                   action:@selector(refreshHotProduct)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:updateButton] autorelease];
    
    /*UIButton* bookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"優惠掃描", nil) 
                                                                                       icon:CustomizeButtonIconQRcode
                                                                              iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                     target:self 
                                                                                     action:@selector(beginQRscanning)];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:bookmarkButton] autorelease];*/
	
	// setup bookmark button
    /*
     UIButton* bookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"收藏", nil) 
     icon:CustomizeButtonIconAdd
     iconPlacement:CustomizeButtonIconPlacementRight 
     target:self 
     action:@selector(addToBookmark)];
     self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:bookmarkButton] autorelease];
     */
}


#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// setup navigation bar buttons
    [self setupNavigationBarButtons];
	
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
    self.fetchedResultsController = nil;
    self.scrollView = nil;
    self.pageControl = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if(self.lastUpdateTime == nil)
    {
        [self updateHotProducts];
        self.lastUpdateTime = [NSDate date];
    }
    else
    {
        NSTimeInterval sinceLastUpdate = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
		
		if(sinceLastUpdate >= SELF_UPDATE_INTERVAL)
        {
            [self updateHotProducts];
            self.lastUpdateTime = [NSDate date];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    pageControl.dotColorCurrentPage = themeManager.hotProductPageDotActive;
    pageControl.dotColorOtherPage = themeManager.hotProductPageDotNormal;
    [pageControl setNeedsDisplay];
    
    // update navigation bar buttons
    [self setupNavigationBarButtons];
    
    // needs to customize title display
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.text = self.title;
	titleLabel.textColor = themeManager.navigationBarTitleTextColor;
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.frame = CGRectMake(0, 0, [titleLabel.text sizeWithFont:font].width, 44);
	titleLabel.font = font;
	self.navigationItem.titleView = titleLabel;
	[titleLabel release];
}


#pragma mark -
#pragma mark core methods

- (void)setupEverything
{
    // set total item count first
	[self setTotalItemCount];
    [self loadFromCoreData];
    
    kNumberOfPages = [[self.fetchedResultsController fetchedObjects] count];
    
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
    HotProductDetailViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        //get the image url
        TmpHotProduct *p = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
        
		controller = [[HotProductDetailViewController alloc] initWithProductIdentifier:[p.id intValue]];
		controller.managedObjectContext = self.managedObjectContext;
        
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


#pragma mark -
#pragma mark data source

- (void)setTotalItemCount
{
	NSError *error = nil;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpHotProduct" inManagedObjectContext:self.managedObjectContext];
	NSUInteger entityCount = [self.managedObjectContext countForFetchRequest:request error:&error];
	totalItemCount = entityCount;
	[request release];
}

- (void)loadFromCoreData
{    
    
    // setup fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpHotProduct" inManagedObjectContext:self.managedObjectContext];
	[request setFetchLimit:10];
    
    // setup sorting
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObjects:sort, nil]];
	[sort release];
	
	// setup fetched result controller
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
																				 managedObjectContext:managedObjectContext 
																				   sectionNameKeyPath:nil 
																							cacheName:nil];
	controller.delegate = self;
	self.fetchedResultsController = controller;
	[request release];
	[controller release];
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) 
	{
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

- (void)updateCurrentPageDetail:(int)page 
{
    TmpHotProduct *p = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
    
    HotProductDetailViewController *controller = [viewControllers objectAtIndex:page];
    if((NSNull *)controller != [NSNull null])
    {
        [controller displayProductWithId:[p.id intValue]];
    }
}

- (void)insertPage:(int)page
{
    totalItemCount++;
    kNumberOfPages++;
    pageControl.numberOfPages = kNumberOfPages;
    
    // a page is the width of the scroll view
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    
    if([viewControllers count] <= page)
    {
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 0; i <= page; i++)
        {
            [array addObject:[NSNull null]];
            
            if(i < [viewControllers count])
            {
                [array replaceObjectAtIndex:i withObject:[viewControllers objectAtIndex:i]];
            }
        }
        self.viewControllers = array;
    }
    else
    {
        [self.viewControllers insertObject:[NSNull null] atIndex:page];
    }
    
    // replace the placeholder if necessary
    HotProductDetailViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        //get the image url
        TmpHotProduct *p = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
        
		controller = [[HotProductDetailViewController alloc] initWithProductIdentifier:[p.id intValue]];
		controller.managedObjectContext = self.managedObjectContext;
        
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.alpha = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
    
    // animating the add page action
    [UIView animateWithDuration:0.4 animations:^{
        int i = 0;
        for(UIViewController *controller in self.viewControllers)
        {
            if ((NSNull *)controller == [NSNull null])
                continue;
            
            CGRect frame = scrollView.frame;
            frame.origin.x = frame.size.width * i;
            frame.origin.y = 0;
            controller.view.frame = frame;
            i++;
        }
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            controller.view.alpha = 1;
        }];
    }];
}

- (void)removePage:(int)page
{
    // decrement the item count
    totalItemCount--;
    kNumberOfPages--;
    
    int i = 0;
    for(UIViewController *controller in self.viewControllers)
    {
        if ((NSNull *)controller != [NSNull null])
        {
            if(i == page)
            {
                [controller.view removeFromSuperview];
                break;
            }
        }
        i++;
    }
    //[self.viewControllers removeObjectAtIndex:pageIndex];
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width - scrollView.frame.size.width, scrollView.contentSize.height);
    
    // adjust the page controller
    // if the page currently at is the one being remove, roll back by one
    // roll forward if it is the first item being removed
    pageControl.numberOfPages = kNumberOfPages;
    if(page == pageControl.currentPage)
    {
        if (page == 0) {
            pageControl.currentPage = 1;
        }
        else {
            pageControl.currentPage--;
        }
        
        [self pageControlPageDidChange:nil];
    }
}

- (void)updatePage:(int)page
{
    [self updateCurrentPageDetail:page];
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
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    //[theTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath 
{
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self insertPage:newIndexPath.row];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self removePage:indexPath.row];
            break;
			
		case NSFetchedResultsChangeUpdate:
            [self updatePage:newIndexPath.row];
			break;
			
        case NSFetchedResultsChangeMove:
            [self updatePage:indexPath.row];
            [self updatePage:newIndexPath.row];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    //[theTableView endUpdates];
}


#pragma mark -
#pragma mark private interface

- (void)refreshHotProduct
{
    [self updateHotProducts];
}

- (void)goToDetail
{
    TmpHotProduct *p = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:self.pageControl.currentPage inSection:0]];
    
    HotProductDetailModelManager *hpdmm = [[HotProductDetailModelManager alloc] initWithItemId:[p.productId intValue]];
	DetailViewController *dvc = [[DetailViewController alloc] init];
    hpdmm.delegate = dvc;
    hpdmm.managedObjectContext = self.managedObjectContext;
    dvc.modelManager = hpdmm;
    [hpdmm release];
	
    [self.navigationController pushViewController:dvc animated:YES];
	[dvc release];
}

- (void)beginQRscanning
{
    QRscanningViewController *qrview=[[QRscanningViewController alloc] init];
    [self.navigationController pushViewController:qrview animated:YES];
    [qrview release];
    
    
 
}

- (void)addToBookmark
{
	[self.navigationItem.rightBarButtonItem setEnabled:NO];
	
    TmpHotProduct *p = (TmpHotProduct *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:self.pageControl.currentPage inSection:0]];
    
    [DataManager saveHotProductWithProductId:p.productId 
                        managedObjectContext:self.managedObjectContext 
                         showIndicatorInView:self.view];
	
	[self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)showWarningIfNoData
{
    if(![[self.fetchedResultsController fetchedObjects] count])
    {
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeError
                               title:NSLocalizedString(@"目前沒有資料喔", nil) 
                            subtitle:nil
                           hideAfter:2];
    }
}

- (void)updateHotProducts
{    
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    
    if(apiManager.isUpdatingHotProduct == NO)
    {
        panel = [MKInfoPanel showPanelInView:self.view 
                                        type:MKInfoPanelTypeProgress 
                                       title:NSLocalizedString(@"更新中... 請稍後", nil) 
                                    subtitle:nil];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [apiManager updateHotProduct];
        apiManager.updateHotProductDelegate = self;
    }
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
#pragma mark EggApiManagerDelegate

- (void)updateHotProductCompleted:(EggApiManager *)manager
{
    [panel hidePanel];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)updateHotProductFailed:(EggApiManager *)manager
{
    [panel hidePanel];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
