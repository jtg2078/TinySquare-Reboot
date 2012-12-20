//
//  CategoryListViewController.m
//  tinysquare
//
//  Created by ling tsu hsuan on 3/23/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "CategoryListViewController.h"
#import "TmpCategory.h"

@interface CategoryListViewController()
- (void)loadFromCoreData;
@end

@implementation CategoryListViewController

#pragma mark - 
#pragma mark define

#define CATEGORY_PARAMS_ID          @"id"
#define CATEGORY_PARAMS_NAME        @"name"
#define VIEW_WIDTH                  150


#pragma mark -
#pragma mark synthesize

@synthesize managedObjectContext;
@synthesize fetchedResultsController;


#pragma mark - 
#pragma mark dealloc

- (void)dealloc {
	[managedObjectContext release];
    [fetchedResultsController release];
    [super dealloc];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		//self.contentSizeForViewInPopover = CGSizeMake(100, 5 * 44 - 1);
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	//self.tableView.rowHeight = 44.0;
	self.view.backgroundColor = [UIColor clearColor];
	self.tableView.showsVerticalScrollIndicator = NO;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadFromCoreData];
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
 // Return YES for supported orientations
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
    self.contentSizeForViewInPopover = CGSizeMake(VIEW_WIDTH, count * self.tableView.rowHeight - 1);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CategoryListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.minimumFontSize = 10.0f;
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    // Configure the cell...
    TmpCategory *c = (TmpCategory *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = c.categoryName;

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    TmpCategory *c = (TmpCategory *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:c.categoryId forKey:CATEGORY_PARAMS_ID];
    [params setValue:c.categoryName forKey:CATEGORY_PARAMS_NAME];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.changeCategory" object:params];
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
            /*
			[self fetchedResultsController:controller
							 configureCell:(ItemCell *)[tableView cellForRowAtIndexPath:indexPath] 
							   atIndexPath:indexPath];
             */
			break;
			
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
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
#pragma mark private interface

- (void)loadFromCoreData
{
	// setup fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TmpCategory" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
    
	// setup sorting
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort,nil]];
	[sort release];
	
    // the line below has been modify from 20 to 100
    [fetchRequest setFetchBatchSize:100];
	
	// setup fetched result controller
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																				 managedObjectContext:managedObjectContext 
																				   sectionNameKeyPath:nil 
																							cacheName:nil];
	controller.delegate = self;
	self.fetchedResultsController = controller;
	[fetchRequest release];
	[controller release];
	
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	else {
		// load the table
		[self.tableView reloadData];
	}
}

@end
