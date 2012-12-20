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
#import "JTRevealSidebarV2Delegate.h"
#import "SidebarViewController.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"

#import "BaseMemberAreaViewController.h"




@interface SavedProductViewController() <JTRevealSidebarV2Delegate,UITableViewDataSource, UITableViewDelegate, SidebarViewControllerDelegate>
- (void)beginEditBookmarks;
- (void)endEditBookmarks;
- (void)setupNavigationBarButtons;
@end

@implementation SavedProductViewController

#pragma mark -
#pragma mark define

#define TAB_IMAGE_NAME      @"SavedProductTabIcon.png"
#define MODULE_NAME         @"我的收藏"
#define PLACE_HOLDER_TEXT   @"您目前沒有任何收藏喔"


#pragma mark -
#pragma mark synthesize


#pragma mark - 
#pragma mark dealloc

- (void)dealloc {
	[placeHolderLabel release];
    [super dealloc];
}


#pragma mark -
#pragma mark initialization and view construction

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
    /*
    UIButton* memberShip2Button = [self.navigationController createNavigationBarButtonWithOutTextandSetIcon:CustomizeButtonIconMembership2
                                                                                   iconPlacement:CustomizeButtonIconPlacementRight
                                                                                          target:self
                                                                                          action:@selector(revealRightSidebar:)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:memberShip2Button] autorelease];
    */
    
    

    // setup add bookmark button
    
	UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"編輯", @"ItemListViewController") 
                                                                                           icon:CustomizeButtonIconEdit 
                                                                                  iconPlacement:CustomizeButtonIconPlacementLeft 
                                                                                         target:self 
                                                                                         action:@selector(beginEditBookmarks)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
     
	/*
    UIButton* shareBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"購物車", nil) 
                                                                                            icon:CustomizeButtonIconAdd 
                                                                                   iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                          target:self 
                                                                                          action:@selector(editMyCart)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:shareBookmarkButton] autorelease];
     */

	// setup share bookmark button
	
    
    /*
    UIButton* shareBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"郵寄", nil) 
                                                                                            icon:CustomizeButtonIconEmail 
                                                                                   iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                          target:self 
                                                                                          action:@selector(shareBookmarks)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:shareBookmarkButton] autorelease];
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
    // refresh navigation bar buttons
    if(theTableView.isEditing)
    {
        UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"完成", @"ItemListViewController") 
                                                                                               icon:CustomizeButtonIconEdit  
                                                                                      iconPlacement:CustomizeButtonIconPlacementLeft 
                                                                                             target:self 
                                                                                             action:@selector(endEditBookmarks)];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
    }
    else
    {
        // setup add bookmark button
        UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"編輯", @"ItemListViewController") 
                                                                                               icon:CustomizeButtonIconEdit 
                                                                                      iconPlacement:CustomizeButtonIconPlacementLeft 
                                                                                             target:self 
                                                                                             action:@selector(beginEditBookmarks)];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
    }
    
	
    
    	// setup share bookmark button
    /*
    UIButton* shareBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"我的購物車", nil) 
                                                                                            icon:CustomizeButtonIconAdd 
                                                                                   iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                          target:self 
                                                                                          action:@selector(editMyCart)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:
                                               shareBookmarkButton] autorelease];
     */

	
    /*
    UIButton* shareBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"郵寄", nil) 
                                                                                            icon:CustomizeButtonIconEmail 
                                                                                   iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                          target:self 
                                                                                          action:@selector(shareBookmarks)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:
     shareBookmarkButton] autorelease];
     */
}


#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad 
{
	[super viewDidLoad];
    self.navigationItem.revealSidebarDelegate=self;
    
    // setup navigation bar buttons
    [self setupNavigationBarButtons];
	
	// setup place holder text
	self.placeHolderLabel.text = NSLocalizedString(@"您目前沒有任何收藏喔", nil);
    
    
	[self loadSavedProducts];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[placeHolderLabel release];
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
#pragma mark public methods

- (void)loadSavedProducts {
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


#pragma mark -
#pragma mark Table view delegate

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


#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	[super controllerDidChangeContent:controller];
    
	// check to see if there are no more bookmark, end edit mode if user is still in it
	if(theTableView.editing == YES && ![[controller fetchedObjects] count])
		[self endEditBookmarks];
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

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
	
	UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"完成", @"ItemListViewController") 
																					  icon:CustomizeButtonIconEdit  
																			 iconPlacement:CustomizeButtonIconPlacementLeft 
																					target:self 
																					action:@selector(endEditBookmarks)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
}

- (void)endEditBookmarks
{
	[theTableView setEditing:NO animated:YES];
	
	UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"編輯", @"ItemListViewController") 
																					  icon:CustomizeButtonIconEdit  
																			 iconPlacement:CustomizeButtonIconPlacementLeft 
																					target:self 
																					action:@selector(beginEditBookmarks)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
}



-(void)editMyCart
{
    AddToCartViewController *loginView=[[AddToCartViewController alloc] init];
    loginView.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:loginView animated:YES];
    [loginView release];
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

#pragma mark -
#pragma mark sidebar related
- (void)revealLeftSidebar:(id)sender {
    [self.navigationController toggleRevealState:JTRevealedStateLeft];
}

- (void)revealRightSidebar:(id)sender {
    [self.navigationController toggleRevealState:JTRevealedStateRight];
}

// This is an examle to configure your sidebar view through a custom UIViewController
- (UIView *)viewForLeftSidebar {
    // Use applicationViewFrame to get the correctly calculated view's frame
    // for use as a reference to our sidebar's view
    
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    
    UITableViewController *controller = self.leftSidebarViewController;
    if ( ! controller) {
        self.leftSidebarViewController = [[SidebarViewController alloc] init];
        self.leftSidebarViewController.sidebarDelegate = self;
        controller = self.leftSidebarViewController;
        //controller.title = @"LeftSidebarViewController";
    }
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    
    
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    return controller.view;
     

}


- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath {
    
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    
    //modify over here
    
    BaseMemberAreaViewController *controller = [[BaseMemberAreaViewController alloc] init];
    //controller.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    controller.title = (NSString *)object;
    controller.leftSidebarViewController  = sidebarViewController;
    controller.leftSelectedIndexPath      = indexPath;
    //controller.label.text = [NSString stringWithFormat:@"Selected %@ from LeftSidebarViewController", (NSString *)object];
    sidebarViewController.sidebarDelegate = controller;
    [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];

    
        /*
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hpmvc];
    nav.delegate = self;
    [nav setUpCustomizeAppearence];
    [hpmvc release];
    */
}

// This is an examle to configure your sidebar view without a UIViewController
- (UIView *)viewForRightSidebar {
    
    
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    
    UITableViewController *controller = self.leftSidebarViewController;
    if ( ! controller) {
        self.leftSidebarViewController = [[SidebarViewController alloc] init];
        self.leftSidebarViewController.sidebarDelegate = self;
        controller = self.leftSidebarViewController;
        //controller.title = @"LeftSidebarViewController";
    }
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    
    
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    return controller.view;
    
    // Use applicationViewFrame to get the correctly calculated view's frame
    // for use as a reference to our sidebar's view
    /*
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    UITableView *view = self.rightSidebarView;
    if ( ! view) {
        view = self.rightSidebarView = [[UITableView alloc] initWithFrame:CGRectZero];
        view.dataSource = self;
        view.delegate   = self;
    }
    view.frame = CGRectMake(self.navigationController.view.frame.size.width - 270, viewFrame.origin.y, 270, viewFrame.size.height);
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    return view;
     */
}

- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController {
    return self.leftSelectedIndexPath;
}

- (void)didChangeRevealedStateForViewController:(UIViewController *)viewController {
    // Example to disable userInteraction on content view while sidebar is revealing
    if (viewController.revealedState == JTRevealedStateNo) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}



#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
