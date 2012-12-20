    //
//  DetailViewController.m
//  TinyStore
//
//  Created by jason on 2011/9/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "UINavigationController+Customize.h"
#import "DataManager.h"
#import "ThemeManager.h"

//#import "DetailCell.h"
#import "DetailCellModel.h"

@interface DetailViewController ()
- (void)shareContent:(NSNotification *)notif;
- (void)addToBookmark;
@end


@implementation DetailViewController

#pragma mark -
#pragma mark Macros 

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark define

#define FACEBOOK_BUTTON 120
#define TWITTER_BUTTON	121
#define EMAIL_BUTTON	122
#define PATH_FOR_TRACKING @"/DetailViewController"


#pragma mark -
#pragma mark synthesize


#pragma mark -
#pragma mark initialization, view construction and dealloc

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{	
	[super loadView];
}

- (void)dealloc 
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self];
    
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

	// setup add bookmark button
	UIButton* bookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"收藏", nil) 
																				  icon:CustomizeButtonIconAdd
																		 iconPlacement:CustomizeButtonIconPlacementRight 
																				target:self 
																				action:@selector(addToBookmark)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:bookmarkButton] autorelease];
	
	// set up notification
	//NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	//[center addObserver:self 
			   //selector:@selector(shareContent:) 
				   //name:@"com.fingertipcreative.tinysquare.shareContent" object:nil];

	// load content
	[self loadContentAsync];
	
	// tracking
	[self googleAnalyticsTrackPageView:PATH_FOR_TRACKING];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self];
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
#pragma mark utilities methods

- (void)updateToCurrentTheme:(NSNotification *)notif {
    [super updateToCurrentTheme:notif];
    [self applyTheme];
}

- (void)applyTheme {
    [super applyTheme];
    // setup add bookmark button
	UIButton* bookmarkButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"收藏", nil) 
                                                                                       icon:CustomizeButtonIconAdd
                                                                              iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                     target:self 
                                                                                     action:@selector(addToBookmark)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:bookmarkButton] autorelease];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark public method

- (void)loadContentAsync {
    //expire when touch down the figure in the list
	[self.modelManager createDetailCellList];
}


#pragma mark -
#pragma mark private interface

- (void)shareContent:(NSNotification *)notif
{
    /*NSNumber *shareMode = [notif object];
    
    
    if([shareMode intValue] == FACEBOOK_BUTTON)
	{
        
        
        NSLog(@"facebook share has been selected");
        
		NSString *appId = @" 332501660150860";
		Facebook* facebook = [[Facebook alloc] initWithAppId:appId andDelegate:self];
		//[facebook dialog:@"feed" andDelegate:self];
		
		NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   appId,		@"app_id",
									   url,			@"link",
									   @"http://i2.lativ.com.tw/i/03513/0351301_01_0.jpg", @"picture",
									   itemTitle,	@"name",
									   price,		@"caption",
									   summary,		@"description",
									   nil];
		
		[facebook dialog:@"feed" andParams:params andDelegate:self];
		
		//[facebook dialog:@"feed" andParams:nil andDelegate:self];
	}*/
	
    /*
	if([shareMode intValue] == TWITTER_BUTTON)
	{
	}
	
	if([shareMode intValue] == EMAIL_BUTTON)
	{
		NSNumber *showBar = [NSNumber numberWithInt:0];
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
		
		MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init]; 
		
		[emailComposer setMailComposeDelegate: self]; 
		[emailComposer setSubject:itemTitle];
  		[emailComposer setMessageBody:[NSString stringWithFormat:@"%@\n\n%@", summary, url] isHTML:NO];
        
		emailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		[self presentModalViewController:emailComposer animated:YES];
		[emailComposer release];
	}
     */
}

- (void)addToBookmark
{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
	
    [self.modelManager addToBookmarkAndShowIndicatorInView:self.view];
	
	[self.navigationItem.rightBarButtonItem setEnabled:YES];
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:YES];
	NSNumber *showBar = [NSNumber numberWithInt:1];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

@end
