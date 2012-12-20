    //
//  ProductWindowViewControllerEx.m
//  TinyStore
//
//  Created by jason on 2011/9/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductWindowViewController.h"
#import "MKInfoPanel.h"
#import "EggApiManager.h"
#import "CategoryListViewController.h"
#import "UIBarButtonItem+WEPopover.h"
#import "UINavigationController+Customize.h"
#import "DictionaryHelper.h"
#import "ProductDetailModelManager.h"
#import "ThemeManager.h"
#import "Membership.h"
#import "JTRevealSidebarV2Delegate.h"


@interface ProductWindowViewController() <JTRevealSidebarV2Delegate>
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)connectAndUpdate;
- (void)categoryChanged:(NSNotification *)notif;
- (void)salesProductListingButtonPressed;
- (void)setupNavigationBarButtons;
@end


@implementation ProductWindowViewController

#pragma mark -
#pragma mark Define

#define TAB_IMAGE_NAME				@"ProductWindowTabIcon.png"
#define MODULE_NAME					@"商品櫥窗"
#define PLACE_HOLDER_TEXT			@"目前沒有任何資料喔"

#define CATEGORY_PARAMS_ID          @"id"
#define CATEGORY_PARAMS_NAME        @"name"
#define CATEGORY_ID_FOR_ALL_CATEGORIES              -100


#pragma mark -
#pragma mark Macro

#define RGB(r, g, b)			[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize categoryButton;
@synthesize categoryBarButton;
@synthesize popoverController;
@synthesize predicate;


#pragma mark - 
#pragma mark dealloc

- (void)dealloc 
{
	refreshTableHeaderView = nil;
    [categoryButton release];
    [categoryBarButton release];
    [popoverController release];
    [predicate release];
    
	[super dealloc];
}


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark -
#pragma mark initialization, view construction and dealloc

- (id)init
{
	if (self = [super init]) 
	{
		self.title = NSLocalizedString(@"商品櫥窗", nil);
		
		// tab bar item and image
		UIImage* anImage = [UIImage imageNamed:TAB_IMAGE_NAME];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:self.title image:anImage tag:0];
		self.tabBarItem = theItem;
		[theItem release];
	}
	return self;
}

- (void)setupNavigationBarButtons
{
    // setup show category list button
	UIButton* button = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"全部商品", nil) 
                                                                               icon:CustomizeButtonIconAdd
                                                                      iconPlacement:CustomizeButtonIconPlacementRight 
                                                                             target:self 
                                                                             action:@selector(selectCategory:)];
	self.categoryButton = button;
	self.categoryBarButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	self.navigationItem.rightBarButtonItem = self.categoryBarButton;
    
    // setup on sale list button
    /*
    UIButton* salesListButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"特價專區", nil) 
                                                                                        icon:CustomizeButtonIconList
                                                                               iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                      target:self 
                                                                                      action:@selector(salesProductListingButtonPressed)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:salesListButton] autorelease];
     */
}

#pragma mark -
#pragma mark theme change

- (void)updateToCurrentTheme:(NSNotification *)notif {
    [super updateToCurrentTheme:notif];
    [self applyTheme];
}

- (void)applyTheme {
    [super applyTheme];
    
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
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
#pragma mark view lifecycle

- (void)viewDidLoad 
{
	[super viewDidLoad];
    
    // setup navigation bar buttons
    [self setupNavigationBarButtons];
    
    // setup popover for category selection
	popoverClass = [WEPopoverController class];
    
	// setup place holder text
	self.placeHolderLabel.text = NSLocalizedString(@"目前沒有任何資料喔", nil);
	
	// setup pull to refresh
	if (refreshTableHeaderView == nil) {
		
		EGORefreshTableHeaderView *egoView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - theTableView.bounds.size.height, theTableView.frame.size.width, theTableView.bounds.size.height)];
		egoView.delegate = self;
		[theTableView addSubview:egoView];
		refreshTableHeaderView = egoView;
		[egoView release];
	}
    
    // set up notification for changing category
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(categoryChanged:) 
												 name:@"com.fingertipcreative.tinysquare.changeCategory" object:nil];
    
    // do a refresh when product window is loaded for first time
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeProgress
                           title:NSLocalizedString(@"更新中... 請稍後", nil) 
                        subtitle:nil
                       hideAfter:3];
	
    [self reloadTableViewDataSource];
    [self loadProducts];
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
	refreshTableHeaderView = nil;
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    ProductDetailModelManager *pdmm = [[ProductDetailModelManager alloc] initWithItemId:self.selectedItemId];
    
    DetailViewController *dvc = [[DetailViewController alloc] init];
    pdmm.delegate = dvc;
    pdmm.managedObjectContext = self.managedObjectContext;
    dvc.modelManager = pdmm;
    [pdmm release];
	
    [self.navigationController pushViewController:dvc animated:YES];
	[dvc release];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

// UITableViewDelegate conforms to UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return isReloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - 
#pragma mark UITableViewDelegate

/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
    [headerView setBackgroundColor:[UIColor blackColor]];
    return headerView;
}
 */


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource 
{
	isReloading = YES;
	[self connectAndUpdate];
}

- (void)doneLoadingTableViewData 
{
	//  model should call this when its done loading
	isReloading = NO;
	[refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:theTableView];
}

- (void)connectAndUpdate
{
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    
    if(apiManager.isUpdatingProductWindow == NO)
    {
        [apiManager updateProductWindow];
        apiManager.updateProductWindowDelegate = self;
    }
    
    if(apiManager.isUpdatingCategories == NO)
    {
        [apiManager updateCategories];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchController sections] objectAtIndex:section];
    
    // preprocessed section name
    NSString *name = sectionInfo.name;
    if([name length])
        name = [name substringFromIndex:1];
    
	return name;
}

- (void)loadFromCoreData
{    
	// setup fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TmpProduct" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
    //[fetchRequest setFetchLimit:100];
    
    if(self.predicate)
        [fetchRequest setPredicate:self.predicate];
	
	// setup sorting
	NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"categoryName" ascending:YES];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort1, sort2, nil]];
	[sort1 release];
    [sort2 release];
	[fetchRequest setFetchBatchSize:20];//originally 20

	
	// setup fetched result controller
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																				 managedObjectContext:managedObjectContext 
																				   sectionNameKeyPath:@"categoryName" 
																							cacheName:nil];
	controller.delegate = self;
	self.fetchController = controller;
	[fetchRequest release];
	[controller release];
	
	NSError *error;
	if (![self.fetchController performFetch:&error]) 
	{
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	else
	{
		// load the table
        [theTableView reloadData];
	}
    
    [super loadFromCoreData];
}


#pragma mark -
#pragma mark EggApiManagerDelegate

- (void)updateProductWindowCompleted:(EggApiManager *)manager
{
    //[self loadContentAsync];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
}

- (void)updateProductWindowFailed:(EggApiManager *)manager
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeError
                           title:NSLocalizedString(@"更新失敗... 請稍後再試", nil) 
                        subtitle:nil
                       hideAfter:4];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
}


#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}


#pragma mark -
#pragma mark public methods

- (void)loadProducts {
	[self loadFromCoreData];
}


#pragma mark - 
#pragma mark category related 

- (void)selectCategory:(id)sender
{	
	if (!self.popoverController) 
	{
		CategoryListViewController *contentViewController = [[CategoryListViewController alloc] initWithStyle:UITableViewStylePlain];
        contentViewController.managedObjectContext = self.managedObjectContext;
		self.popoverController = [[[popoverClass alloc] initWithContentViewController:contentViewController] autorelease];
		self.popoverController.delegate = self;
		self.popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
		
		[self.popoverController presentPopoverFromBarButtonItem:categoryBarButton
									   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) 
													   animated:YES];
		
		[contentViewController release];
	} 
	else 
	{
		[self.popoverController dismissPopoverAnimated:YES];
		self.popoverController = nil;
	}
}

- (void)categoryChanged:(NSNotification *)notif
{
    NSDictionary *categoryParameters = (NSDictionary *)[notif object];
	NSNumber *categoryId = [categoryParameters numberForKey:CATEGORY_PARAMS_ID];
    NSString *categoryName = [categoryParameters stringForKey:CATEGORY_PARAMS_NAME];
	[self changeCategoryWithId:categoryId categoryName:categoryName];
}

- (void)changeCategoryWithId:(NSNumber *)categoryId categoryName:(NSString *)categoryName
{
	[self.categoryButton setTitle:categoryName forState:UIControlStateNormal];
	[self.popoverController dismissPopoverAnimated:YES];
	self.popoverController = nil;
    
    // code for respond to category changes
    if([categoryId intValue] == CATEGORY_ID_FOR_ALL_CATEGORIES) // this is for showing all categories
        self.predicate = nil;
    else
        self.predicate = [NSPredicate predicateWithFormat:@"categoryId = %d", [categoryId intValue]];
    
    [self loadFromCoreData];
}

- (void)salesProductListingButtonPressed
{
    self.predicate = [NSPredicate predicateWithFormat:@"salePrice != %d", -1];
    [self loadFromCoreData];
}

@end
