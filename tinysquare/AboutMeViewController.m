    //
//  AboutMeViewControllerEx.m
//  TinyStore
//
//  Created by jason on 2011/9/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutMeViewController.h"
#import "AppDelegate.h"
#import "UINavigationController+Customize.h"
#import "DetailCell.h"
#import "DetailCellModel.h"
#import "BaseDetailModelManager.h"
#import "SettingsViewController.h"
#import "EggApiManager.h"
#import "MKInfoPanel.h"
#import "MemberLoginViewController.h"
#import "Membership.h"
#import "LoginMember.h"
#import "MemberIndexViewController.h"

@interface AboutMeViewController ()
- (void)updateAboutMe;
@end

@implementation AboutMeViewController

#pragma mark -
#pragma mark define

#define TAB_IMAGE_NAME	@"AboutMeTabIcon.png"
#define MODULE_NAME		@"關於我"

#define SELF_UPDATE_INTERVAL 3600 // 1 hour


#pragma mark -
#pragma mark Macros 

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize managedObjectContext;
@synthesize lastUpdateTime;

#pragma mark-
#pragma mark dealloc

- (void)dealloc 
{
    [managedObjectContext release];
    [lastUpdateTime release];
	[super dealloc];
}


#pragma mark -
#pragma mark initialization and view construction

- (id)init
{
	if (self = [super init]) 
	{
		self.title = NSLocalizedString(@"關於我", nil);
		// tab bar item and image
		UIImage* anImage = [UIImage imageNamed:TAB_IMAGE_NAME];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:self.title image:anImage tag:0];
		self.tabBarItem = theItem;
		[theItem release];
	}
	return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{	
	[super loadView];
}

- (void)setupNavigationBarButtons
{
    // setup the app settings button
    
	/*UIButton* appSettings = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"Settings", nil) 
                                                                                    icon:CustomizeButtonIconSetting
                                                                           iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                  target:self 
                                                                                  action:@selector(showSettingsViewController)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:appSettings] autorelease];*/
    
    
    // update/refresh button
	UIButton* updateButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"重新整理", nil) 
                                                                                     icon:CustomizeButtonIconReload
                                                                            iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                   target:self 
                                                                                   action:@selector(refreshAboutMe)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:updateButton] autorelease];
    
    
    /*
    UIButton* touchdownToMemberSubsys = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"會員登入", nil) 
                                                                                    icon:CustomizeButtonIconMembership
                                                                           iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                  target:self 
                                                                                  action:@selector(memberLogin)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:touchdownToMemberSubsys] autorelease];
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
	[self setupNavigationBarButtons];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	[super viewDidLoad];
    
    // setup navigation bar buttons
	[self setupNavigationBarButtons];
    
    [self updateAboutMe];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    /*
    if(self.lastUpdateTime == nil)
    {
        [self updateAboutMe];
        self.lastUpdateTime = [NSDate date];
    }
    else
    {
        NSTimeInterval sinceLastUpdate = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
		
		if(sinceLastUpdate >= SELF_UPDATE_INTERVAL)
        {
            [self clearTable];
            [self updateAboutMe];
            self.lastUpdateTime = [NSDate date];
        }
    }
     */
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark user interaction

- (void)showSettingsViewController {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	SettingsViewController *svc = [[SettingsViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
	[nav setUpCustomizeAppearence];
	[svc release];
	nav.modalPresentationStyle = UIModalPresentationPageSheet;
	[appDelegate presentModalViewController:nav animated:YES];
	[nav release];
}

- (void)refreshAboutMe
{
    [self updateAboutMe];
}


-(void)memberLogin
{
    /*
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];
    if ([lm.logincheck isEqualToNumber:[NSNumber numberWithInt:1]]) {
        MemberIndexViewController *indexView=[[MemberIndexViewController alloc] init];
        indexView.managedObjectContext = self.managedObjectContext;
        [self.navigationController pushViewController:indexView animated:YES];
        [indexView release];
    }
    else {
        MemberLoginViewController *loginView=[[MemberLoginViewController alloc] init];
        loginView.managedObjectContext = self.managedObjectContext;
        [self.navigationController pushViewController:loginView animated:YES];
        [loginView release];
    }
     */
    
    MemberLoginViewController *loginView=[[MemberLoginViewController alloc] init];
    loginView.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:loginView animated:YES];
    loginView.whichViewFrom=@"";
    [loginView release];

}

#pragma mark -
#pragma mark public method

- (void)loadContentAsync {
	[self.modelManager createDetailCellList];
}

#pragma mark - 
#pragma mark EggApiManagerDelegate

- (void)updateAboutMeCompleted:(EggApiManager *)manager
{
    [self loadContentAsync];
}

- (void)updateAboutMeFailed:(EggApiManager *)manager
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeError
                           title:NSLocalizedString(@"更新失敗... 請稍後再試", nil) 
                        subtitle:nil
                       hideAfter:4];
    
    // still try to load it anyways
    [self loadContentAsync];
}


#pragma mark -
#pragma mark private interface

- (void)updateAboutMe
{
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    
    if(apiManager.isUpdatingAboutMe == NO)
    {
        [MKInfoPanel showPanelInView:self.view
                                type:MKInfoPanelTypeProgress
                               title:NSLocalizedString(@"更新中... 請稍後", nil) 
                            subtitle:nil
                           hideAfter:3];
        
        [self clearTable];
        [apiManager updateAboutMe];
        apiManager.updateAboutMeDelegate = self;
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
