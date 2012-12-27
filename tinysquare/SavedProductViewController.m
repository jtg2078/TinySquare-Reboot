    //
//  SavedProductViewController.m
//  TinyStore
//
//  Created by jason on 2011/9/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavedProductViewController.h"
#import "UINavigationController+Customize.h"
#import "DictionaryHelper.h"
#import "TmpSavedProduct.h"
#import "SavedProductDetailModelManager.h"
#import "TmpCart.h"
#import "AddToCartViewController.h"

#import "NewViewController.h"

#import "BaseMemberAreaViewController.h"

#import "IIViewDeckController.h"



@interface SavedProductViewController()
- (void)beginEditBookmarks;
- (void)endEditBookmarks;
- (void)setupNavigationBarButtons;
@end

@implementation SavedProductViewController

#pragma mark - define

#define TAB_IMAGE_NAME      @"SavedProductTabIcon.png"
#define MODULE_NAME         @"我的收藏"
#define PLACE_HOLDER_TEXT   @"您目前沒有任何收藏喔"

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
	[placeHolderLabel release];
    [super dealloc];
}

#pragma mark - init

- (id)init
{
	if (self = [super init]) 
	{
		self.title = NSLocalizedString(@"我的收藏", nil);
		
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
    UIButton* memberShip2Button = [self.navigationController createNavigationBarButtonWithOutTextandSetIcon:CustomizeButtonIconMembership2
                                                                                              iconPlacement:CustomizeButtonIconPlacementRight
                                                                                                     target:self
                                                                                                     action:@selector(showMemberSidebar:)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:memberShip2Button] autorelease];
    
    

    // setup add bookmark button
    
	UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"編輯", @"ItemListViewController") 
                                                                                           icon:CustomizeButtonIconEdit 
                                                                                  iconPlacement:CustomizeButtonIconPlacementLeft 
                                                                                         target:self 
                                                                                         action:@selector(beginEditBookmarks)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
 
}

#pragma mark - theme change related

- (void)updateToCurrentTheme:(NSNotification *)notif
{
    [super updateToCurrentTheme:notif];
    [self applyTheme];
}

- (void)applyTheme
{
    [super applyTheme];
    
    // refresh navigation bar buttons
    [self setupNavigationBarButtons];
}

#pragma mark - view lifecycle

- (void)viewDidLoad 
{
	[super viewDidLoad];
    
    // setup navigation bar buttons
    [self setupNavigationBarButtons];
	
	// setup place holder text
	self.placeHolderLabel.text = NSLocalizedString(@"您目前沒有任何收藏喔", nil);
    
    
	[self loadSavedProducts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[placeHolderLabel release];
}

#pragma mark - public methods

- (void)loadSavedProducts
{
	[self loadFromCoreData];
}

- (void)loadFromCoreData
{    
	// setup fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TmpSavedProduct" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// setup sorting
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"savedDate" ascending:NO];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort, nil]];
	[sort release];
	[fetchRequest setFetchBatchSize:20];
	
	// setup fetched result controller
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																				 managedObjectContext:managedObjectContext 
																				   sectionNameKeyPath:nil 
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


#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		TmpSavedProduct *p = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
		[TmpSavedProduct deleteProductIfExistWithProductId:p.productId inManagedObjectContext:self.managedObjectContext];
		
		NSError *error = nil;
		if (![managedObjectContext save:&error]) {
			NSLog(@"bookmark remove failed, error occured while saving to core data: %@", [error description]);
		}
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    SavedProductDetailModelManager *spdmm = [[SavedProductDetailModelManager alloc] initWithItemId:self.selectedItemId];
	DetailViewController *dvc = [[DetailViewController alloc] init];
    spdmm.delegate = dvc;
    spdmm.managedObjectContext = self.managedObjectContext;
    dvc.modelManager = spdmm;
    [spdmm release];
	
    [self.navigationController pushViewController:dvc animated:YES];
	[dvc release];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	[super controllerDidChangeContent:controller];
    
	// check to see if there are no more bookmark, end edit mode if user is still in it
	if(theTableView.editing == YES && ![[controller fetchedObjects] count])
		[self endEditBookmarks];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:YES];
	
	// show the tab bar
	NSNumber *showBar = [NSNumber numberWithInt:1];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
}


#pragma mark -
#pragma mark private interface

- (void)beginEditBookmarks
{
	[theTableView setEditing:YES animated:YES];
}

- (void)endEditBookmarks
{
	[theTableView setEditing:NO animated:YES];
}

- (void)shareBookmarks
{
	// get all the items that has been bookmarked in background thread
	NSPersistentStoreCoordinator *coordinator = [self.managedObjectContext persistentStoreCoordinator];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
	{
		NSManagedObjectContext *moc = [[[NSManagedObjectContext alloc] init] autorelease];
		[moc setPersistentStoreCoordinator:coordinator];
		
		// setup fetch request
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"TmpSavedProduct" inManagedObjectContext:moc];
		[fetchRequest setEntity:entity];
		
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"savedDate" ascending:NO];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort,nil]];
		[sort release];
		
		NSError *error = nil;
		
		NSArray* savedProducts = [moc executeFetchRequest:fetchRequest error:&error];
		[fetchRequest release];
		
		if(error == nil && [savedProducts count])
		{
			int count = 1;
			NSMutableString *emailBody = [NSMutableString stringWithCapacity:300];
			for(TmpSavedProduct *p in savedProducts)
			{
				[emailBody appendFormat:@"%d.%@\n%@\n\n",count, p.productName, p.webUrl];
				count++;
			}
			
			dispatch_async(dispatch_get_main_queue(), ^
			{
				// hide the tab bar
				NSNumber *showBar = [NSNumber numberWithInt:0];
				NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
				[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
				
				MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init];
				NSString *emailSubject = @"我的收藏～";
				
				[emailComposer setMailComposeDelegate: self]; 
				[emailComposer setSubject:emailSubject];
				[emailComposer setMessageBody:emailBody isHTML:NO];
				
				emailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
				
				[self presentModalViewController:emailComposer animated:YES];
				[emailComposer release];
			});
		}
		
	});
}

#pragma mark - user interaction

- (void)showMemberSidebar:(id)sender
{
    if([self.viewDeckController isSideClosed:IIViewDeckRightSide])
        [self.viewDeckController openRightViewAnimated:YES];
    else
        [self.viewDeckController closeRightViewAnimated:YES];
}

@end
