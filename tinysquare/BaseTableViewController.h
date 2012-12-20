//
//  BaseTableViewController.h
//  TinyStore
//
//  Created by jason on 2011/9/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface BaseTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	// UI
	UILabel *placeHolderLabel;
	// core data
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	NSMutableArray *fetchPredicateArray;
	
	// BaseViewController
	NSMutableArray* requests;
}

// UI
@property (nonatomic, retain) UILabel *placeHolderLabel;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableArray *fetchPredicateArray;

// BaseViewController
- (ASIHTTPRequest*) requestWithURL:(NSString*) s;
- (ASIFormDataRequest*) formRequestWithURL:(NSString*) s;
- (void) addRequest:(ASIHTTPRequest*)request;
- (void) clearFinishedRequests;
- (void) cancelRequests;

- (void) refreshCellsWithImage:(UIImage*)image fromURL:(NSURL*)url inTable:(UITableView*)tableView;

- (void)hideTabBar;
- (void)showTabBar;

- (void)addPlaceHolderLabel;
- (void)removePlaceHolderLabel;

@end