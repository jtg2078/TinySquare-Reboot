    //
//  BaseListViewcontroller.m
//  TinyStore
//
//  Created by jason on 2011/9/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseListViewcontroller.h"

#import "ItemCellModel.h"
#import "ItemCell.h"
#import "UINavigationController+Customize.h"
#import "DataManager.h"
#import "ThemeManager.h"

#import "TmpProduct.h"
#import "TmpSavedProduct.h"
#import "TmpCart.h"


@interface BaseListViewcontroller()

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureCell:(ItemCell *)theCell atIndexPath:(NSIndexPath *)theIndexPath;
- (ItemCellModel *)getCellModelWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController atIndexPath:(NSIndexPath *)theIndexPath;
- (void)beginSearch;
- (void)addPlaceHolderLabel;
- (void)removePlaceHolderLabel;

@end


@implementation BaseListViewcontroller

#pragma mark -
#pragma mark Define

#define TABLE_CELL_HEIGHT				104
#define PLACE_HOLDER_LABEL_VIEW_INDEX	1

#define BASE_VIEW_X				0
#define BASE_VIEW_Y				0
#define BASE_VIEW_WIDTH			320
#define BASE_VIEW_HEIGHT		367
#define BASE_IMAGE_VIEW_TAG     14
#define TABLE_VIEW_X			14
#define TABLE_VIEW_Y			50
#define TABLE_VIEW_WIDTH		292
#define TABLE_VIEW_HEIGHT		306

#define SEARCHBAR_X				0
#define SEARCHBAR_Y				0
#define SEARCHBAR_WIDTH			308
#define SEARCHBAR_HEIGHT		44
#define PATH_FOR_TRACKING		@"/BaseListViewcontroller"

#define SEARCH_BUTTON_X			9
#define SEARCH_BUTTON_Y			12
#define SEARCH_BUTTON_WIDTH		303
#define SEARCH_BUTTON_HEIGHT	27
//#define SEARCH_BUTTON_IMAGE		@"LCell_Searchbar.png"

#define NAME		@"name"
#define PRICE		@"price"
#define SALE_PRICE  @"salePrice"
#define IS_NEW      @"isNew"
#define ON_SALE     @"onSale"
#define CUSTOM_TAG  @"customTag"
#define SUBTITLE	@"subtitle"
#define TIME		@"time"
#define IMAGE		@"image"
#define MODE        @"mode"



#pragma mark -
#pragma mark Macro

#define RGB(r, g, b)			[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize placeHolderLabel;
@synthesize managedObjectContext;
@synthesize fetchController;
@synthesize savedSearchTerm, savedScopeButtonIndex, searchWasActive;
@synthesize searchBar;
@synthesize searchButton;
@synthesize searchFetchController;
@synthesize fetchPredicateArray;
@synthesize backedUpBackButton;
@synthesize selectedItemId;


#pragma mark -
#pragma mark initialization, view construction and dealloc

- (void)dealloc 
{
	[theTableView release];
	[placeHolderLabel release];
	[managedObjectContext release];
	[fetchPredicateArray release];
	
	[fetchController release];
	[searchFetchController release];
	
	searchController.delegate = nil; // since searchController release will call delegate and in this case
	[searchController release];      // the delegate of searchController is self, which is also being released
	[searchBar release];
    
	[super dealloc];
}

- (void)loadView 
{
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
	// setup paper background and transparency
	UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(BASE_VIEW_X, BASE_VIEW_Y, BASE_VIEW_WIDTH, BASE_VIEW_HEIGHT)];
	
	// setup card view
	UIImageView *paper = [[UIImageView alloc] initWithImage:[UIImage imageNamed:themeManager.productListBgImageName]];
	paper.frame = baseView.frame;
    paper.tag = BASE_IMAGE_VIEW_TAG;
	
	// setup table view
	theTableView = [[UITableView alloc] initWithFrame:CGRectMake(TABLE_VIEW_X, TABLE_VIEW_Y, TABLE_VIEW_WIDTH, TABLE_VIEW_HEIGHT) style:UITableViewStylePlain];
	theTableView.rowHeight = TABLE_CELL_HEIGHT;
	theTableView.delegate = self;
	theTableView.dataSource = self;
	theTableView.backgroundColor = [UIColor clearColor];
	
	// add table view and background image to baseView
	[baseView addSubview:paper];
	[baseView addSubview:theTableView];
	
	self.view = baseView;
	
	[paper release];
	[baseView release];
	
	// setup searchbar
	searchBar = [[UISearchBar alloc] init];
	searchBar.frame = CGRectMake(SEARCHBAR_X, SEARCHBAR_Y, SEARCHBAR_WIDTH, SEARCHBAR_HEIGHT);
	searchBar.showsCancelButton = YES;
	searchBar.showsSearchResultsButton = NO;
	searchBar.hidden = YES;
	searchBar.delegate = self;
	[baseView addSubview:searchBar];
    
    // setup search bar mask button
	self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.searchButton.frame = CGRectMake(SEARCH_BUTTON_X, SEARCH_BUTTON_Y, SEARCH_BUTTON_WIDTH, SEARCH_BUTTON_HEIGHT);
	[self.searchButton setBackgroundImage:[UIImage imageNamed:themeManager.searchBarImageName] forState:UIControlStateNormal];
	[self.searchButton addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
	[baseView addSubview:self.searchButton];
}


#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
    /*
	// setup table header view
	UIView *headerView = [[UIView alloc] init];
	headerView.frame = CGRectMake(0, 0, 308, 44);
	[headerView addSubview:itemFilterController.view];
	theTableView.tableHeaderView = headerView;
	[headerView release];
	*/
     
	// setup search display controller
	searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchController.delegate = self;
	searchController.searchResultsDataSource = self;
	searchController.searchResultsDelegate = self;
	searchController.searchResultsTableView.rowHeight = TABLE_CELL_HEIGHT;
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm) {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        self.savedSearchTerm = nil;
    }
	
	// setup place holder
	UILabel *label = [[UILabel alloc] init];
	label.textColor = [UIColor blackColor];
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	label.frame = CGRectMake(0, 60, 320, 30);
	label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
	label.hidden = YES;
	self.placeHolderLabel = label;
	[label release];
	[self.view insertSubview:self.placeHolderLabel atIndex:PLACE_HOLDER_LABEL_VIEW_INDEX];
	
	self.fetchPredicateArray = [NSMutableArray array];
	
	// tracking
	[self googleAnalyticsTrackPageView:PATH_FOR_TRACKING];
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
	
	searchController.delegate = nil;
	[searchController release];
	
	self.searchButton = nil;
	self.fetchPredicateArray = nil;
	self.placeHolderLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//	The scrollbars won't flash unless the tableview is long enough.
	[theTableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
	
	// save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}


#pragma mark - 
#pragma mark utilities methods

- (void)updateToCurrentTheme:(NSNotification *)notif {
    [super updateToCurrentTheme:notif];
    [self applyTheme];
}

- (void)applyTheme {
    [super applyTheme];
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    UIImageView *baseImageView = (UIImageView *)[self.view viewWithTag:BASE_IMAGE_VIEW_TAG];
    baseImageView.image = [UIImage imageNamed:themeManager.productListBgImageName];
    [self.searchButton setBackgroundImage:[UIImage imageNamed:themeManager.searchBarImageName] forState:UIControlStateNormal];
    [theTableView reloadData];
    
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
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    int count = [[[self fetchedResultsControllerForTableView:tableView] sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section];
	int count  = [sectionInfo numberOfObjects];
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	static NSString *CellIdentifier = @"mySuperCell";
    
    ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
	[self fetchedResultsController:[self fetchedResultsControllerForTableView:tableView] 
					 configureCell:cell 
					   atIndexPath:indexPath];
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	ItemCellModel *selectCellModel = [self getCellModelWithFetchedResultsController:[self fetchedResultsControllerForTableView:tableView] atIndexPath:indexPath];
    
    self.selectedItemId = selectCellModel.itemId;
}

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Detemine if it's in editing mode
    if (tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        
		Item *item = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
		[DataManager removeBookmarkItemWithId:[item.itemId intValue] managedObjectContext:self.managedObjectContext showIndicatorInView:self.view];
         
    }
}
*/


#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [theTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath 
{
    UITableView *tableView = theTableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
		case NSFetchedResultsChangeUpdate:
			[self fetchedResultsController:controller
							 configureCell:(ItemCell *)[tableView cellForRowAtIndexPath:indexPath] 
							   atIndexPath:indexPath];
			break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
	
	// check to see if we need to show/hide the place holder label
	if([controller.fetchedObjects count])
		[self removePlaceHolderLabel];
	else
		[self addPlaceHolderLabel];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type 
{
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [theTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [theTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [theTableView endUpdates];
}


#pragma mark -
#pragma mark UISearchBarDelegate

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    //theSearchBar.hidden = YES;
    [theSearchBar resignFirstResponder];
	// Do something with the mySearchBar.text
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
    theSearchBar.hidden = YES; 
    [theSearchBar resignFirstResponder];
    searchButton.hidden = NO;
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    // update the filter, in this case just blow away the FRC and let lazy evaluation create another with the relevant search info
    self.searchFetchController.delegate = nil;
    self.searchFetchController = nil;
}


#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
{
    // search is done so get rid of the search FRC and reclaim memory
    self.searchFetchController.delegate = nil;
    self.searchFetchController = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString 
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
	
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] 
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
	
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
	// customized the search result table view
	tableView.rowHeight = TABLE_CELL_HEIGHT;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    if(searchBar)
    {
        searchBar.hidden = YES;
        [searchBar resignFirstResponder];
    }
}


#pragma mark -
#pragma mark public methods

- (void)loadFromCoreData
{	
	// check to see if we need to show/hide the place holder label
	if([self.fetchController.fetchedObjects count])
		[self removePlaceHolderLabel];
	else
		[self addPlaceHolderLabel];
}


#pragma mark -
#pragma mark async image loading

- (void) imageLoaded:(UIImage *)image withURL:(NSURL *)url {
    [self refreshCellsWithImage:image fromURL:url inTable:theTableView];
}

/*
#pragma mark -
#pragma mark bookmarks management

- (void)beginEditBookmarks
{
	[theTableView setEditing:YES animated:YES];
	
	UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"完成", nil) 
																					  icon:CustomizeButtonIconEdit  
																			 iconPlacement:CustomizeButtonIconPlacementLeft 
																					target:self 
																					action:@selector(endEditBookmarks)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
}

- (void)endEditBookmarks
{
	[theTableView setEditing:NO animated:YES];
    
    UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"編輯", nil) 
                                                                                       icon:CustomizeButtonIconEdit 
																			 iconPlacement:CustomizeButtonIconPlacementLeft 
																					target:self 
																					action:@selector(beginEditBookmarks)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
}
*/

#pragma mark -
#pragma mark private methods

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView {
	return tableView == theTableView ? self.fetchController : self.searchFetchController;
}


- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureCell:(ItemCell *)theCell atIndexPath:(NSIndexPath *)theIndexPath 
{
	//ItemCellModel *model = [self getCellModelWithFetchedResultsController:fetchedResultsController atIndexPath:theIndexPath];
    
    id item = [fetchedResultsController objectAtIndexPath:theIndexPath];
    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
    
    if([item isKindOfClass:[TmpProduct class]])
	{
        TmpProduct *p = (TmpProduct *)item;
        
        NSString *customTag = [TmpProduct getLastTagFromTagString:p.customTags];
        NSString *image = [TmpProduct getFirstProductImageWithSize:TmpProductImageSize100 imageJson:p.imagesJson];
        NSNumber *mode = [NSNumber numberWithBool:[p.salePrice intValue] == -1];
        NSString *price = @"";
        NSString *salePrice = [NSString stringWithFormat:@"%d %@", [p.salePrice intValue], NSLocalizedString(@"元", nil)];
        
        if([p.price intValue])
            price = [NSString stringWithFormat:@"%d %@", [p.price intValue], NSLocalizedString(@"元", nil)];
        
        [tmp setObject:p.productName    forKey:NAME];
        [tmp setObject:price            forKey:PRICE];
        [tmp setObject:salePrice        forKey:SALE_PRICE];
        [tmp setObject:p.isNew          forKey:IS_NEW];
        [tmp setObject:p.isOnSale       forKey:ON_SALE];
        [tmp setObject:customTag        forKey:CUSTOM_TAG];
        [tmp setObject:image            forKey:IMAGE];
        [tmp setObject:mode             forKey:MODE];
	}
    
    if([item isKindOfClass:[TmpSavedProduct class]])
    {
        TmpSavedProduct *p = (TmpSavedProduct *)item;
        
        NSString *customTag = [TmpSavedProduct getLastTagFromTagString:p.customTags];
        NSString *image = [TmpSavedProduct getFirstProductImageWithSize:TmpSavedProductImageSize100 imageJson:p.imagesJson];
        NSNumber *mode = [NSNumber numberWithBool:[p.salePrice intValue] == -1];
        NSString *price = @"";
        NSString *salePrice = [NSString stringWithFormat:@"%d %@", [p.salePrice intValue], NSLocalizedString(@"元", nil)];
        
        if([p.price intValue])
            price = [NSString stringWithFormat:@"%d %@", [p.price intValue], NSLocalizedString(@"元", nil)];
        
        [tmp setObject:p.productName    forKey:NAME];
        [tmp setObject:price            forKey:PRICE];
        [tmp setObject:salePrice        forKey:SALE_PRICE];
        [tmp setObject:p.isNew          forKey:IS_NEW];
        [tmp setObject:p.isOnSale       forKey:ON_SALE];
        [tmp setObject:customTag        forKey:CUSTOM_TAG];
        [tmp setObject:image            forKey:IMAGE];
        [tmp setObject:mode             forKey:MODE];
    }
    
    if([item isKindOfClass:[TmpCart class]])
    {
        TmpCart *p = (TmpCart *)item;
        
        NSString *customTag = [TmpCart getLastTagFromTagString:p.customTags];
        NSString *image = [TmpCart getFirstProductImageWithSize:TmpCartImageSize100 imageJson:p.imagesJson];
        NSNumber *mode = [NSNumber numberWithBool:[p.salePrice intValue] == -1];
        NSString *price = @"";
        NSString *salePrice = [NSString stringWithFormat:@"%d %@", [p.salePrice intValue], NSLocalizedString(@"元", nil)];
        
        if([p.price intValue])
            price = [NSString stringWithFormat:@"%d %@", [p.price intValue], NSLocalizedString(@"元", nil)];
        
        [tmp setObject:p.productName    forKey:NAME];
        [tmp setObject:price            forKey:PRICE];
        [tmp setObject:salePrice        forKey:SALE_PRICE];
        [tmp setObject:p.isNew          forKey:IS_NEW];
        [tmp setObject:p.isOnSale       forKey:ON_SALE];
        [tmp setObject:customTag        forKey:CUSTOM_TAG];
        [tmp setObject:image            forKey:IMAGE];
        [tmp setObject:mode             forKey:MODE];
        
        //
        [tmp setObject:p.buyItemCount   forKey:@"buyItemCount"];
    }

    
	[theCell updateCellInfo:tmp];
}

- (ItemCellModel *)getCellModelWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController atIndexPath:(NSIndexPath *)theIndexPath
{
	id item = [fetchedResultsController objectAtIndexPath:theIndexPath];
	
	ItemCellModel *model =[[ItemCellModel alloc] init];
	model.cellStyle = fetchedResultsController == self.fetchController ? ProductCellStyleCustomized : ProductCellStylePlain;
	
	if([item isKindOfClass:[TmpProduct class]])
	{
        TmpProduct *p = (TmpProduct *)item;
        model.imageUrl = [TmpProduct getFirstProductImageWithSize:TmpProductImageSize100 imageJson:p.imagesJson];
		model.itemId = [p.productId intValue];
		model.title = p.productName;
		model.productType = ProductCellTypeProduce;
		model.content1 = [p.price stringValue];
		model.content2 = p.durationString;
        model.content3 = @"";
	}
    
    if([item isKindOfClass:[TmpSavedProduct class]])
	{
        TmpSavedProduct *p = (TmpSavedProduct *)item;
        model.imageUrl = [TmpSavedProduct getFirstProductImageWithSize:TmpSavedProductImageSize100 imageJson:p.imagesJson];
		model.itemId = [p.productId intValue];
		model.title = p.productName;
		model.productType = ProductCellTypeProduce;
		model.content1 = [p.price stringValue];
		model.content2 = p.durationString;
        model.content3 = @"";
	}
    
    if([item isKindOfClass:[TmpCart class]])
	{
        TmpCart *p = (TmpCart *)item;
        model.imageUrl = [TmpCart getFirstProductImageWithSize:TmpCartImageSize100 imageJson:p.imagesJson];
		model.itemId = [p.productId intValue];
		model.title = p.productName;
		model.productType = ProductCellTypeProduce;
		model.content1 = [p.price stringValue];
		model.content2 = p.durationString;
        //
        model.content3=@"";
        //model.content3 =[NSString stringWithFormat:@"%@",p.buyItemCount];
	}
	
	return [model autorelease];
}

- (NSFetchedResultsController *)newFetchedResultsControllerWithSearch:(NSString *)searchString 
{	
	// setup fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setFetchBatchSize:20];
	
	// entity
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TmpProduct" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// predicate
	if(searchString.length)
	{
		NSMutableArray *predicates = [NSMutableArray array];
		
		if([self.fetchPredicateArray count])
			[predicates addObjectsFromArray:self.fetchPredicateArray];
		
		[predicates addObject:[NSPredicate predicateWithFormat:@"productName CONTAINS[cd] %@", searchString]];

		[fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
	}
	
	// sort
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"productId" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort,nil]];
	[sort release];
	
	// create FetchedResultsController
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                                managedObjectContext:self.managedObjectContext 
                                                                                                  sectionNameKeyPath:nil 
                                                                                                           cacheName:nil];
    aFetchedResultsController.delegate = self;
    [fetchRequest release];
	
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) 
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
	
    return aFetchedResultsController;
}

- (NSFetchedResultsController *)searchFetchController 
{
    if (searchFetchController != nil) 
    {
        return searchFetchController;
    }
    searchFetchController = [self newFetchedResultsControllerWithSearch:self.searchDisplayController.searchBar.text];
    return [[searchFetchController retain] autorelease];
}

- (void)beginSearch
{
	[searchController setActive:YES animated:YES];
	searchController.searchBar.hidden = NO;
	self.searchButton.hidden = YES;
	[searchController.searchBar becomeFirstResponder];
	
	// for google analytics tracking
	[self googleAnalyticsTrackEvent:NSLocalizedString(@"點擊搜尋", nil) 
				   atViewController:PATH_FOR_TRACKING 
					 withStringData:nil 
						   intValue:0];
}

- (void)addPlaceHolderLabel {
	self.placeHolderLabel.hidden = NO;
}

- (void)removePlaceHolderLabel {
	self.placeHolderLabel.hidden = YES;
}

- (void)itemFilterChanged:(NSNotification *)notif
{
	//ItemFilterMainViewController *ifmvc = [notif object];
	//[self populateTableViewWithFilter:ifmvc.filter];
	[self.fetchPredicateArray removeAllObjects];
	[self loadFromCoreData];
}


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
