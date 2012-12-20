//
//  AddToCartViewController.m
//  asoapp
//
//  Created by wyde on 12/5/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddToCartViewController.h"
#import "UINavigationController+Customize.h"
#import "DictionaryHelper.h"
#import "TmpSavedProduct.h"
//#import "SavedProductDetailModelManager.h"
#import "AddToCartModelManager.h"
#import "TmpCart.h"
#import "BuyDetailViewController.h"
#import "EggApiManager.h"
#import "MKInfoPanel.h"
#import "ReadyToCheckViewController.h"

@interface AddToCartViewController ()
- (void)beginEditBookmarks;
- (void)endEditBookmarks;
- (void)setupNavigationBarButtons;
@end

@implementation AddToCartViewController

#pragma mark -
#pragma mark define

#define TAB_IMAGE_NAME      @"SavedProductTabIcon.png"
#define MODULE_NAME         @"我的購物車"
#define PLACE_HOLDER_TEXT   @"您的購物車目前沒有東西喔"


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
		self.title = NSLocalizedString(@"我的購物車", nil);
		
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
    // setup add bookmark button
    /*
	UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"編輯", @"ItemListViewController") 
                                                                                           icon:CustomizeButtonIconEdit 
                                                                                  iconPlacement:CustomizeButtonIconPlacementLeft 
                                                                                         target:self 
                                                                                         action:@selector(beginEditBookmarks)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
    */
    UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	
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
}


#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad 
{
	[super viewDidLoad];
    
    // setup navigation bar buttons
    [self setupNavigationBarButtons];
	
	// setup place holder text
	//self.placeHolderLabel.text = NSLocalizedString(@"您的購物車目前沒有東西喔", nil);
	
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


-(void)updateBuyListCompleted:(EggApiManager *)manager
{
    
    
    ReadyToCheckViewController *bdvc=[[ReadyToCheckViewController alloc] init];
    bdvc.managedObjectContext=self.managedObjectContext;
    [self.navigationController pushViewController:bdvc animated:YES];

    
}

-(void)updateBuyListFailed:(EggApiManager *)manager
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeError
                           title:NSLocalizedString(@"登入伺服器失敗... 請稍後再試", nil) 
                        subtitle:nil
                       hideAfter:4];
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TmpCart" inManagedObjectContext:managedObjectContext];
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
		TmpCart *p = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
		[TmpCart deleteProductIfExistWithProductId:p.productId inManagedObjectContext:self.managedObjectContext];
		
		NSError *error = nil;
		if (![managedObjectContext save:&error]) {
			NSLog(@"bookmark remove failed, error occured while saving to core data: %@", [error description]);
		}
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    
        /*
    AddToCartModelManager *spdmm = [[AddToCartModelManager alloc] initWithItemId:self.selectedItemId];
	BuyDetailViewController *dvc = [[BuyDetailViewController alloc] init];
    spdmm.delegate = dvc;
    spdmm.managedObjectContext = self.managedObjectContext;
    dvc.modelManager = spdmm;
    [spdmm release];
	
    [self.navigationController pushViewController:dvc animated:YES];
	[dvc release];
     */
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
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
}

- (void)endEditBookmarks
{
	[theTableView setEditing:NO animated:YES];
	
	UIButton* editBookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"編輯", @"ItemListViewController") 
                                                                                           icon:CustomizeButtonIconEdit  
                                                                                  iconPlacement:CustomizeButtonIconPlacementLeft 
                                                                                         target:self 
                                                                                         action:@selector(beginEditBookmarks)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBookmarkButton] autorelease];
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
                       NSEntityDescription *entity = [NSEntityDescription entityForName:@"TmpCart" inManagedObjectContext:moc];
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
                           for(TmpCart *p in savedProducts)
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
                                              NSString *emailSubject = @"我的購物車～";
                                              
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
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
