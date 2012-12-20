//
//  BaseTableViewController.m
//  TinyStore
//
//  Created by jason on 2011/9/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTableViewController.h"


@implementation BaseTableViewController

#pragma mark -
#pragma mark Define

#define TABLE_CELL_HEIGHT				102
#define PLACE_HOLDER_LABEL_VIEW_INDEX	1

#pragma mark -
#pragma mark Macro

#define RGB(r, g, b)			[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize placeHolderLabel;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize fetchPredicateArray;


#pragma mark -
#pragma mark initialization, view construction and dealloc

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)dealloc 
{
	[placeHolderLabel release];
	[managedObjectContext release];
	[fetchPredicateArray release];
	[fetchedResultsController release];
	[super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    int count = [[self.fetchedResultsController sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	int count  = [sectionInfo numberOfObjects];
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath 
{	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
		case NSFetchedResultsChangeUpdate:
			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
			break;
			
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


#pragma mark -
#pragma mark public methods


- (void)hideTabBar
{
	NSNumber *showBar = [NSNumber numberWithInt:0];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
}

- (void)showTabBar
{
	NSNumber *showBar = [NSNumber numberWithInt:1];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
}


#pragma mark -
#pragma mark private methods

- (void)addPlaceHolderLabel {
	self.placeHolderLabel.hidden = NO;
}

- (void)removePlaceHolderLabel {
	self.placeHolderLabel.hidden = YES;
}


#pragma mark -
#pragma mark HTTP requests

- (ASIHTTPRequest*) requestWithURL:(NSString*) s {
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s]];
	[self addRequest:request];
	return request;
}

- (ASIFormDataRequest*) formRequestWithURL:(NSString*) s {
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:s]];
	[self addRequest:request];
	return request;
}

- (void) addRequest:(ASIHTTPRequest*)request {
	[request setDelegate:self];
	if (!requests) {
		requests = [[NSMutableArray alloc] initWithCapacity:3];
	} else {
		[self clearFinishedRequests];
	}
	[requests addObject:request];
}

- (void) clearFinishedRequests {
	NSMutableArray* toremove = [[NSMutableArray alloc] initWithCapacity:[requests count]];
	for (ASIHTTPRequest* r in requests) {
		if ([r isFinished]) {
			[toremove addObject:r];
		}
	}
	
	for (ASIHTTPRequest* r in toremove) {
		[requests removeObject:r];
	}
	[toremove release];
}

- (void) cancelRequests {
	for (ASIHTTPRequest* r in requests) {
		r.delegate = nil;
		[r cancel];
	}	
	[requests removeAllObjects];
}

- (void) refreshCellsWithImage:(UIImage*)image fromURL:(NSURL*)url inTable:(UITableView*)tableView {
    NSArray *cells = [tableView visibleCells];
    [cells retain];
    SEL selector = @selector(imageLoaded:withURL:);
    for (int i = 0; i < [cells count]; i++) {
		UITableViewCell* c = [[cells objectAtIndex: i] retain];
        if ([c respondsToSelector:selector]) {
            [c performSelector:selector withObject:image withObject:url];
        }
        [c release];
		c = nil;
    }
    [cells release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}


@end

