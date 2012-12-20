    //
//  StoreListingViewController.m
//  TinyStore
//
//  Created by jason on 2011/9/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreListingViewController.h"
#import "StoreListingCell.h"
//#import "Item.h"
//#import "LocationItem.h"
//#import "Location.h"
#import "MKMapView+ZoomLevel.h"
#import "UINavigationController+Customize.h"

#import "TmpLocation.h"

@interface StoreListingViewController ()
- (void)addDetailViewToCellWithIndexPath:(NSIndexPath *)aIndexPath;
- (void)removeDetailViewInCellWithIndexPath:(NSIndexPath *)aIndexPath;
- (void)phone;
- (void)googleMap;
- (void)email;
- (void)applyTheme;
- (void)setupExpandedCellView;
@end


@implementation StoreListingViewController

#pragma mark -
#pragma mark Define

#define TABLE_CELL_HEIGHT				102
#define PLACE_HOLDER_LABEL_VIEW_INDEX	1
#define DETAIL_VIEW_TAG					11
#define TAG_GOOGLE_MAP                  20
#define TAG_PHONE                       21
#define TAG_EMAIL                       22

#pragma mark -
#pragma mark Macro

#define RGB(r, g, b)			[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize regionNames;
@synthesize indexPathForSelectedCell;
@synthesize selectedAddress;
@synthesize selectedPhone;
@synthesize selectedStoreName;
@synthesize detailViewImage;
@synthesize expandedCellView;


#pragma mark -
#pragma mark initialization, view construction and dealloc

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

- (void)dealloc 
{
	[regionNames release];
	[indexPathForSelectedCell release];
	[selectedAddress release];
	[selectedPhone release];
	[selectedStoreName release];
    [detailViewImage release];
    [expandedCellView release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// Create a custom back button
	UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	
	self.regionNames = [NSArray arrayWithObjects: NSLocalizedString(@"基隆市", nil),
						NSLocalizedString(@"台北市", nil),
						NSLocalizedString(@"新北市", nil),
						NSLocalizedString(@"桃園縣", nil),
						NSLocalizedString(@"新竹市", nil),
						NSLocalizedString(@"新竹縣", nil),
						NSLocalizedString(@"苗栗縣", nil),
						NSLocalizedString(@"台中市", nil),
						NSLocalizedString(@"彰化縣", nil),
						NSLocalizedString(@"南投縣", nil),
						NSLocalizedString(@"雲林縣", nil),
						NSLocalizedString(@"嘉義市", nil),
						NSLocalizedString(@"嘉義縣", nil),
						NSLocalizedString(@"台南市", nil),
						NSLocalizedString(@"高雄市", nil),
						NSLocalizedString(@"屏東縣", nil),
						NSLocalizedString(@"台東縣", nil),
						NSLocalizedString(@"花蓮縣", nil),
						NSLocalizedString(@"宜蘭縣", nil),
						NSLocalizedString(@"澎湖縣", nil),
						NSLocalizedString(@"金門縣", nil),
						NSLocalizedString(@"連江縣", nil), nil];
	self.indexPathForSelectedCell = [NSIndexPath indexPathForRow:-100 inSection:-100];
	detailViewMode = StoreCellViewModeNone;
	
	[self setupExpandedCellView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(updateToCurrentTheme:) 
												 name:@"com.fingertipcreative.tinysquare.themeChange" object:nil];
	
	/*
	mapView = [[MKMapView alloc] init];
	mapView.frame = CGRectMake(10, 2, 110, 100);
	mapView.zoomEnabled = NO;
	mapView.userInteractionEnabled = NO;
	[black addSubview:mapView];
	
	UIImageView *marker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LBSMap_Icon_ItemPosition.png"]];
	marker.frame = CGRectMake(45, 36, 30, 30);
	[black addSubview:marker];
	[marker release];
	
	UILabel *phoneTitle = [[UILabel alloc] init];
	phoneTitle.frame = CGRectMake(128, 2, 35, 21);
	phoneTitle.text = NSLocalizedString(@"電話", nil);
	[black addSubview:phoneTitle];
	[phoneTitle release];
	
	phoneLabel = [[UILabel alloc] init];
	phoneLabel.frame = CGRectMake(171, 2, 154, 21);
	[black addSubview:phoneLabel];
	
	dialButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	dialButton.frame = CGRectMake(128, 56, 158, 37);
	[dialButton setTitle:NSLocalizedString(@"撥號", nil) forState:UIControlStateNormal];
	[black addSubview:dialButton];
	 */
	
	[self loadFromCoreData];
}

- (void)viewDidUnload 
{
	self.regionNames = nil;
	self.indexPathForSelectedCell = nil;
    self.expandedCellView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
#pragma mark utilities methods

- (void)updateToCurrentTheme:(NSNotification *)notif {
    [self applyTheme];
}

- (void)applyTheme {
    
    // Create a custom back button
	UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    // need to re-setup since the expanded cell view
    [self setupExpandedCellView];
    
    // for each cell update the black view
    StoreListingCell *cell = (StoreListingCell *)[self.tableView cellForRowAtIndexPath:self.indexPathForSelectedCell];
    cell.detailViewImage.image = self.detailViewImage;
}


#pragma mark -
#pragma mark Table view data source


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	// Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [self.regionNames objectAtIndex:[sectionInfo.name intValue]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(self.indexPathForSelectedCell.section == indexPath.section && self.indexPathForSelectedCell.row == indexPath.row)
	{
		if(detailViewMode == StoreCellViewModeRemoveDetail)
		{
			[self.expandedCellView removeFromSuperview];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		if(detailViewMode == StoreCellViewModeAddDetail)
		{
			[cell.contentView addSubview:self.expandedCellView];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    StoreListingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[StoreListingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
	id item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	if([item isKindOfClass:[TmpLocation class]])
	{
		TmpLocation *location = (TmpLocation *)item;
		cell.textLabel.text = location.storeName;
		cell.detailTextLabel.text = location.address;
		
		self.selectedAddress = location.address;
		self.selectedPhone = location.telephone;
		self.selectedStoreName = location.storeName;
        
        cell.detailViewImage.image = self.detailViewImage;
	}
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	if(detailViewMode == StoreCellViewModeNone)
	{
		[self performSelector:@selector(addDetailViewToCellWithIndexPath:) withObject:indexPath afterDelay:0.2];
	}
	else
	{
		[self performSelector:@selector(removeDetailViewInCellWithIndexPath:) withObject:self.indexPathForSelectedCell afterDelay:0.1];
		[self performSelector:@selector(addDetailViewToCellWithIndexPath:) withObject:indexPath afterDelay:0.2];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(self.indexPathForSelectedCell.section == indexPath.section && self.indexPathForSelectedCell.row == indexPath.row)
	{
		return 92;
	}
	return 44;
}


#pragma mark -
#pragma mark public methods

- (void)loadFromCoreData
{
	// setup fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TmpLocation" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	if([self.fetchPredicateArray count])
	{
		NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:fetchPredicateArray];
		[fetchRequest setPredicate:predicate];
	}
	
	NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"regionId" ascending:YES];
	NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"locationId" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort1, sort2, nil]];
	[sort1 release];
	[sort2 release];
	[fetchRequest setFetchBatchSize:20];
	
	// setup fetched result controller
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																				 managedObjectContext:managedObjectContext 
																				   sectionNameKeyPath:@"regionId" 
																							cacheName:@"StoreListFetchedCache"];
	controller.delegate = self;
	self.fetchedResultsController = controller;
	[fetchRequest release];
	[controller release];
	
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) 
	{
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	else
	{
		// load the table
		[self.tableView reloadData];
	}
	
	// check to see if we need to show/hide the place holder label
	if([self.fetchedResultsController.fetchedObjects count])
		[self removePlaceHolderLabel];
	else
		[self addPlaceHolderLabel];
}


#pragma mark -
#pragma mark private methods

- (void)addDetailViewToCellWithIndexPath:(NSIndexPath *)aIndexPath
{
	if(self.indexPathForSelectedCell.section == aIndexPath.section && self.indexPathForSelectedCell.row == aIndexPath.row)
	{
		detailViewMode = StoreCellViewModeNone;
		self.indexPathForSelectedCell = [NSIndexPath indexPathForRow:-100 inSection:-100];
		//[self.tableView beginUpdates];
		[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:aIndexPath] withRowAnimation:NO];
		//[self.tableView endUpdates];
		return;
	}
	
	//[self.tableView beginUpdates];
	detailViewMode = StoreCellViewModeAddDetail;
	self.indexPathForSelectedCell = aIndexPath;
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathForSelectedCell] withRowAnimation:NO];
	//[self.tableView endUpdates];
}

- (void)removeDetailViewInCellWithIndexPath:(NSIndexPath *)aIndexPath
{
	//[self.tableView beginUpdates];
	detailViewMode = StoreCellViewModeRemoveDetail;
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathForSelectedCell] withRowAnimation:NO];
	//[self.tableView endUpdates];
}

- (void)phone
{
	NSString *alertMsg = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"撥打", nil), self.selectedPhone];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertMsg 
													message:nil
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"取消", nil) 
										  otherButtonTitles:NSLocalizedString(@"撥打", nil),nil];
	[alert show];
	[alert release];
}

- (void)googleMap
{
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", self.selectedAddress];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)email
{
	// hide the tab bar
	NSNumber *showBar = [NSNumber numberWithInt:0];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
	
	NSString *emailSubject = [NSString stringWithFormat:@"分享店家資訊: %@", self.selectedStoreName];
	NSString *emailBody = [NSString stringWithFormat:@"%@\n%@\n%@",self.selectedStoreName, self.selectedAddress, self.selectedPhone];
	
	MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init];
	emailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[emailComposer setMailComposeDelegate: self]; 
	[emailComposer setSubject:emailSubject];
	[emailComposer setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:emailComposer animated:YES];
	[emailComposer release];
}

- (void)setupExpandedCellView
{
    
    if(self.expandedCellView == nil)
    {
        expandedCellView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 49)];
        expandedCellView.tag = DETAIL_VIEW_TAG;
        expandedCellView.backgroundColor = [UIColor whiteColor];
        expandedCellView.opaque = YES;
    }
    else
    {
        // refresh buttons in expanded view in cell
        // remove old one
        UIButton *mapOld = (UIButton *)[self.expandedCellView viewWithTag:TAG_GOOGLE_MAP];
        UIButton *phoneOld = (UIButton *)[self.expandedCellView viewWithTag:TAG_PHONE];
        UIButton *emailOld = (UIButton *)[self.expandedCellView viewWithTag:TAG_EMAIL];
        [mapOld removeFromSuperview];
        [phoneOld removeFromSuperview];
        [emailOld removeFromSuperview];
    }
    
	UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DDBox_Cell_BG.png"]];
	bg.frame = CGRectMake(0, 0, 320, 49);
	[self.expandedCellView addSubview:bg];
	[bg release];
	
	// setup map/phone/email button
	int x = 7;
	UIButton* map = [self.navigationController setUpCustomizeButtonWithText:NSLocalizedString(@"Google Map", nil) 
                                                                       icon:[UIImage imageNamed:@"DDBox_KeyFIcon_GoogleMap.png"]
                                                              iconPlacement:CustomizeButtonIconPlacementRight 
                                                                     target:self 
                                                                     action:@selector(googleMap)];
	map.frame = CGRectMake(x, 10, map.frame.size.width, map.frame.size.height);
    map.tag = TAG_GOOGLE_MAP;
	[self.expandedCellView addSubview:map];
	x += (map.frame.size.width + 5);
	
	UIButton* phone = [self.navigationController setUpCustomizeButtonWithText:NSLocalizedString(@"聯絡電話", nil) 
																		 icon:[UIImage imageNamed:@"DDBox_KeyFIcon_Call.png"]
																iconPlacement:CustomizeButtonIconPlacementRight 
																	   target:self 
																	   action:@selector(phone)];
	phone.frame = CGRectMake(x, 10, phone.frame.size.width, phone.frame.size.height);
    phone.tag = TAG_PHONE;
	[self.expandedCellView addSubview:phone];
	x += (phone.frame.size.width + 5);
	
	UIButton* email = [self.navigationController setUpCustomizeButtonWithText:NSLocalizedString(@"E-mail 分享", nil) 
																		 icon:[UIImage imageNamed:@"DDBox_KeyFIcon_EmailShare.png"]
																iconPlacement:CustomizeButtonIconPlacementRight 
																	   target:self 
																	   action:@selector(email)];
	email.frame = CGRectMake(x, 10, email.frame.size.width, email.frame.size.height);
    email.tag = TAG_EMAIL;
	[self.expandedCellView addSubview:email];
    
    // take a snape shot of the black view
    UIGraphicsBeginImageContextWithOptions(self.expandedCellView.frame.size, YES, 0.0);
    [self.expandedCellView.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.detailViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// 0 = cancel
	// 1 = dial
	if(buttonIndex == 1)
	{
		NSString *phoneString = [NSString stringWithFormat:@"tel://%@", self.selectedPhone];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: phoneString]];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}


@end
