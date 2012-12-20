//
//  BaseListViewcontroller.h
//  TinyStore
//
//  Created by jason on 2011/9/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "DetailViewController.h"



@interface BaseListViewcontroller: BaseViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
	// UI
	UITableView *theTableView;
	UILabel *placeHolderLabel;
	UIBarButtonItem *backedUpBackButton;
	// core data
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchController;
	NSMutableArray *fetchPredicateArray;
	// for searching function
	NSFetchedResultsController *searchFetchController;
	UISearchDisplayController *searchController;
	UISearchBar *searchBar;
    UIButton *searchButton;
	BOOL searchBarOn;
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
}

// UI
@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) UIBarButtonItem *backedUpBackButton;

@property (nonatomic) int selectedItemId;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchController;
@property (nonatomic, retain) NSMutableArray *fetchPredicateArray;

// for searching function
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSFetchedResultsController *searchFetchController;
@property (nonatomic, retain) UIButton *searchButton;

// The saved state of the search UI if a memory warning removed the view.
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (void)loadFromCoreData;
- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView;

@end
