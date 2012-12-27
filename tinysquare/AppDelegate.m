//
//  AppDelegate.m
//  tinysquare
//
//  Created by  on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ImageManager.h"
#import "UINavigationController+Customize.h"
#import "TATabBarController.h"
#import "SVWebViewController.h"
#import "ProductImageViewController.h"
#import "ThemeManager.h"

#import "HotProductMainViewController.h"
#import "ProductWindowViewController.h"
#import "StoreMapViewController.h"
#import "SavedProductViewController.h"
#import "AboutMeViewController.h"

#import "GANTracker.h"
#import "EggApiManager.h"
#import "EggAppManager.h"
#import "TestFlight.h"

#import "TATabBarControllerPad.h"
#import "UIApplication+AppDimensions.h"
#import "HotProductScrollViewControllerPad.h"
#import "ProductWindowScrollViewControllerPad.h"
#import "StoreMapViewControllerPad.h"
#import "ProductDetailViewControllerPad.h"
#import "BookmarkViewControllerPad.h"
#import "AboutMeViewControllerPad.h"
#import "AboutMeDetailModelManager.h"

#import "SHKConfiguration.h"
#import "SHKFacebook.h"
#import "MKInfoPanel.h"
#import "AddToCartViewController.h"

#import "EggConnectionManager.h"

//temp modify
#import "ViewController.h"

#import "IIViewDeckController.h"
#import "MemberMainViewController.h"

#import "AFHTTPRequestOperationLogger.h"


@interface AppDelegate()
- (void)setupTabBarControllers;
- (id)setupTab1;
- (id)setupTab2;
- (id)setupTab3;
- (id)setupTab4;
- (id)setupTab5;
- (id)setupTab6;
- (void)setupGoogleAnalytics;
- (void)checkForFirstTimeRunning;
@end

@implementation AppDelegate

#pragma mark -
#pragma mark define

#define TESTFLIGHT_TOKEN				@"5385d4b57ae2dc0845edc120dcb7a7ee_MzU0MTEyMDExLTEwLTE5IDAxOjU0OjUwLjE3MDY1OA"
#define GOOGLE_ANALYTICS_ID				@"UA-30429044-1"
#define ANALYTICS_DISPATCH_PERIOD_SEC	10
#define FIRST_RUN_FLAG					@"applicationRanBefore"
#define FIRST_TIME_FOR_NEW_BACKEND      @"connectToNewAPIBefore"
#define UPDATE_MIN_INTERVAL_IN_SEC		7200


#pragma mark -
#pragma mark define

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#pragma mark -
#pragma mark synthesize

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize tabBarController = _tabBarController;
@synthesize tabBarControllerPad = _tabBarControllerPad;
@synthesize bgImageView = _bgImageView;
@synthesize splashView=_splashView;
@synthesize viewDeckController = _viewDeckController;


#pragma mark -
#pragma mark My addition

+ (AppDelegate *) sharedAppDelegate {
	return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
	[self.tabBarController presentModalViewController:modalViewController animated:animated];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
	[self.tabBarController dismissModalViewControllerAnimated:animated];
}

- (void)setupGoogleAnalytics
{
	// setup google analytic tracker
	[[GANTracker sharedTracker] startTrackerWithAccountID:GOOGLE_ANALYTICS_ID
										   dispatchPeriod:ANALYTICS_DISPATCH_PERIOD_SEC
												 delegate:nil];
	NSError *error;
	
	if (![[GANTracker sharedTracker] trackEvent:NSLocalizedString(@"搶鮮機 iPhone App" , nil)
										 action:@"Launch iPhone"
										  label:@"NTIFO"
										  value:99
									  withError:&error]) {
		NSLog(@"error in trackEvent");
	}
	
	if (![[GANTracker sharedTracker] trackPageview:@"/app_entry_point"
										 withError:&error]) {
		NSLog(@"error in trackPageview");
	}
}

- (void)checkForFirstTimeRunning
{
	if (![[NSUserDefaults standardUserDefaults] boolForKey:FIRST_RUN_FLAG]) 
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_RUN_FLAG];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:FIRST_TIME_FOR_NEW_BACKEND]) 
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_TIME_FOR_NEW_BACKEND];
		
        // delete everything from the database
        /*
        NSError *error;
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"tinysquare.sqlite"];
        [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
        
        if(error)
            NSLog(@"error while deleting the sqlite db file: %@", [error description]);
         */
	}
    
    
    [[EggAppManager sharedInstance] setupInstalledDate];
    [[EggAppManager sharedInstance] setupAppVersionNumber];
	
	// always perform update when app starts up
	//EggApiManager *apiManager = [EggApiManager sharedInstance];
	//[apiManager updateData];
	
	NSError *error;
	if (![[GANTracker sharedTracker] trackEvent:NSLocalizedString(@"搶鮮機 iPhone App" , nil)
										 action:NSLocalizedString(@"APP開啟所進行的自動更新" , nil)
										  label:@"NTIFO"
										  value:0
									  withError:&error]) {
		NSLog(@"error in APP開啟所進行的自動更新");
	}
}

- (void)setupTabBarControllers
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _tabBarControllerPad = [[TATabBarControllerPad alloc] init];
        [_tabBarControllerPad setSelectedImageMask:[UIImage imageNamed:@"grad_white.png"]];
        [_tabBarControllerPad setUnselectedImageMask:[UIImage imageNamed:@"grad_white.png"]];
        CGSize screenSize = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
        _tabBarControllerPad.view.frame = CGRectMake(0, 20, screenSize.width, screenSize.height);
        
        _tabBarControllerPad.viewControllers = [NSArray arrayWithObjects:[self setupTab1],
                                                [self setupTab2],
                                                [self setupTab3],
                                                [self setupTab4],
                                                [self setupTab5], 
                                                [self setupTab6], nil];
    }
    else
    {
        _tabBarController = [[TATabBarController alloc] init];
        [_tabBarController setSelectedImageMask:[UIImage imageNamed:@"grad_white.png"]];
        [_tabBarController setUnselectedImageMask:[UIImage imageNamed:@"grad_white.png"]];
        
        _tabBarController.view.backgroundColor = [UIColor clearColor];
        _tabBarController.view.frame = CGRectMake(0, 20, 320, 460);
        
        _tabBarController.viewControllers = [NSArray arrayWithObjects:[self setupTab1],
                                             [self setupTab2],
                                             [self setupTab3],
                                             [self setupTab4],
                                             [self setupTab5], nil];
        //_window.rootViewController=_tabBarController;

    }
}


- (id)setupTab1
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        HotProductScrollViewControllerPad *vc = [[HotProductScrollViewControllerPad alloc] init];
        CGRect rect;
        rect.origin = CGPointMake(0, 0);
        rect.size = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
        vc.view.frame = rect;
        vc.view.backgroundColor = [UIColor whiteColor];
        
        UIImage* anImage = [UIImage imageNamed:@"nav_sidebar_icon01.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"none" image:anImage tag:0];
		vc.tabBarItem = theItem;
		[theItem release];
        
        return [vc autorelease];
    }
    else
    {
        HotProductMainViewController *hpmvc = [[HotProductMainViewController alloc] init];
        hpmvc.managedObjectContext = self.managedObjectContext;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hpmvc];
        nav.delegate = self;
        [nav setUpCustomizeAppearence];
        [hpmvc release];
        return [nav autorelease];
    }
}

- (id)setupTab2
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ProductWindowScrollViewControllerPad *vc = [[ProductWindowScrollViewControllerPad alloc] init];
        CGRect rect;
        rect.origin = CGPointMake(0, 0);
        rect.size = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
        vc.view.frame = rect;
        vc.view.backgroundColor = [UIColor whiteColor];
        
        UIImage* anImage = [UIImage imageNamed:@"nav_sidebar_icon02.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"none" image:anImage tag:0];
		vc.tabBarItem = theItem;
		[theItem release];
        
        return [vc autorelease];
    }
    else
    {
        ProductWindowViewController *pwvc = [[ProductWindowViewController alloc] init];
        pwvc.managedObjectContext = self.managedObjectContext;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pwvc];
        nav.delegate = self;
        [nav setUpCustomizeAppearence];
        [pwvc release];
        return [nav autorelease];
    }
}

- (id)setupTab3
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        StoreMapViewControllerPad *vc = [[StoreMapViewControllerPad alloc] init];
        CGRect rect;
        rect.origin = CGPointMake(0, 0);
        rect.size = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
        vc.view.frame = rect;
        vc.view.backgroundColor = [UIColor whiteColor];
        
        UIImage* anImage = [UIImage imageNamed:@"nav_sidebar_icon03.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"none" image:anImage tag:0];
		vc.tabBarItem = theItem;
		[theItem release];
        
        return [vc autorelease];
    }
    else
    {
        StoreMapViewController *smvc = [[StoreMapViewController alloc] init];
        smvc.managedObjectContext = self.managedObjectContext;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:smvc];
        nav.delegate = self;
        [nav setUpCustomizeAppearence];
        [smvc release];
        return [nav autorelease];
    }
}

- (id)setupTab4
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        BookmarkViewControllerPad *vc = [[BookmarkViewControllerPad alloc] init];
        CGRect rect;
        rect.origin = CGPointMake(0, 0);
        rect.size = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
        vc.view.frame = rect;
        vc.view.backgroundColor = [UIColor whiteColor];
        
        UIImage* anImage = [UIImage imageNamed:@"nav_sidebar_icon04.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"none" image:anImage tag:0];
		vc.tabBarItem = theItem;
		[theItem release];
        
        return [vc autorelease];
    }
    else
    {
//        AddToCartViewController *spvc=[[AddToCartViewController alloc] init];
        //spvc.managedObjectContext=self.managedObjectContext;
        
        SavedProductViewController *spvc = [[SavedProductViewController alloc] init];
        //ViewController *spvc=[[ViewController alloc] init];
        spvc.managedObjectContext = self.managedObjectContext;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:spvc];
        nav.delegate = self;
        [nav setUpCustomizeAppearence];
        [spvc release];
        return [nav autorelease];
    }
}

- (id)setupTab5
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        AboutMeViewControllerPad *vc = [[AboutMeViewControllerPad alloc] init];
        CGRect rect;
        rect.origin = CGPointMake(0, 0);
        rect.size = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
        vc.view.frame = rect;
        vc.view.backgroundColor = [UIColor whiteColor];
        
        UIImage* anImage = [UIImage imageNamed:@"nav_sidebar_icon05.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"none" image:anImage tag:0];
		vc.tabBarItem = theItem;
		[theItem release];
        
        return [vc autorelease];
    }
    else
    {
        AboutMeDetailModelManager *amdmm = [[AboutMeDetailModelManager alloc] initWithItemId:0];
        AboutMeViewController *amvc = [[AboutMeViewController alloc] init];
        amvc.managedObjectContext = self.managedObjectContext;
        amdmm.delegate = amvc;
        amdmm.managedObjectContext = amvc.managedObjectContext;
        amvc.modelManager = amdmm;
        [amdmm release];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:amvc];
        nav.delegate = self;
        [nav setUpCustomizeAppearence];
        [amvc release];
        return [nav autorelease];
    }
}

- (id)setupTab6
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIViewController *vc = [[UIViewController alloc] init];
        CGRect rect;
        rect.origin = CGPointMake(0, 0);
        rect.size = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
        vc.view.frame = rect;
        vc.view.backgroundColor = [UIColor magentaColor];
        
        UIImage* anImage = [UIImage imageNamed:@"nav_sidebar_icon06.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"none" image:anImage tag:0];
		vc.tabBarItem = theItem;
		[theItem release];
        
        return [vc autorelease];
    }
    else
    {
        return nil;
    }
}


#pragma mark - 
#pragma mark EggApiManagerDelegate

/*
- (void)updateFcidCompleted:(EggApiManager *)manager
{
    //
}
 */



/*
- (void)updateFcidFailed:(EggApiManager *)manager
{
    // still try to load it anyways
    //[self loadContentAsync];
}
*/

#pragma mark -
#pragma mark private interface

- (void)updateFcid
{
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    
    if(apiManager.isUpdatingFcid == NO)
    {
        /*
         [MKInfoPanel showPanelInView:self.view
         type:MKInfoPanelTypeProgress
         title:NSLocalizedString(@"更新中... 請稍後", nil) 
         subtitle:nil
         hideAfter:2];
         */
        //[self clearTable];
        [apiManager updateFcid];
        //apiManager.updateFcidDelegate = self;
    }
}


#pragma mark -
#pragma mark theme changes

- (void)updateToCurrentTheme:(NSNotification *)notif {
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    self.bgImageView.image = [UIImage imageNamed:themeManager.commonBgImageName];
    
    for(UIViewController *vc in self.tabBarController.viewControllers)
    {
        if([vc isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *nav = (UINavigationController *)vc;
            [nav applyTheme];
            
            if([nav.navigationItem.titleView isKindOfClass:[UILabel class]])
            {
                UILabel *titleLabel = (UILabel *)nav.navigationItem.titleView;
                titleLabel.textColor = themeManager.navigationBarTitleTextColor;
            }
        }
    }
}

#pragma mark -
#pragma mark for sharing services

- (BOOL)handleOpenURL:(NSURL*)url
{
    NSString* scheme = [url scheme];
    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    if ([scheme hasPrefix:prefix])
        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [self handleOpenURL:url];  
}


#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	// these classes need to handle title configuration on their own
	if([viewController isKindOfClass:[ProductImageViewController class]] || [viewController isKindOfClass:[SVWebViewController class]])
		return;
    
    ThemeManager *themeManager = [ThemeManager sharedInstance];
	
	// needs to customize title display since the background of navigation bar became very light
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.text = viewController.title;
	titleLabel.textColor = themeManager.navigationBarTitleTextColor;
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.frame = CGRectMake(0, 0, [titleLabel.text sizeWithFont:font].width, 44);
	titleLabel.font = font;
	viewController.navigationItem.titleView = titleLabel;
	[titleLabel release];
}


#pragma mark -
#pragma mark Application lifecycle

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_tabBarController release];
    [_tabBarControllerPad release];
    [_bgImageView release];
    [_splashView release];
    [_viewDeckController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // initial checking
	//[TestFlight takeOff:TESTFLIGHT_TOKEN];
	[self setupGoogleAnalytics];
	[self checkForFirstTimeRunning];
    //[self updateFcid];
    
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
    
    // my addition
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(updateToCurrentTheme:) 
												 name:@"com.fingertipcreative.tinysquare.themeChange" object:nil];
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        [self setupTabBarControllers];
        [self.window addSubview:_tabBarControllerPad.view];
    }
    else
    {
        
        /*
        UIImage *commonBgImage = [UIImage imageNamed:themeManager.commonBgImageName];
        _bgImageView = [[UIImageView alloc] initWithImage:commonBgImage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 460);
        [self.window addSubview:_bgImageView];
        
        [self setupTabBarControllers];
        
        [self.window addSubview:_tabBarController.view];
        
        
        _splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [_splashView setImage:[UIImage imageNamed:@"Default2.png"]];
        
        [self.window addSubview:_splashView];
        [self.window bringSubviewToFront:_splashView];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [self performSelector:@selector(changeSplash) withObject:self afterDelay:2];
        
        //EggConnectionManager *connectionManager=[[EggConnectionManager alloc] init];
        //connectionManager.managedObjectContext=self.managedObjectContext;
        */
        
        UIImage *commonBgImage = [UIImage imageNamed:themeManager.commonBgImageName];
        _bgImageView = [[UIImageView alloc] initWithImage:commonBgImage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 460);
        [self.window addSubview:_bgImageView];
        
        [self setupTabBarControllers];
        
        // a new beginning...
        UINavigationController *nav_center = [[[UINavigationController alloc] initWithRootViewController:self.tabBarController] autorelease];
        [nav_center setUpCustomizeAppearence];
        MemberMainViewController *mmvc = [[[MemberMainViewController alloc] init] autorelease];
        _viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:nav_center
                                                                     rightViewController:mmvc];
        _viewDeckController.rightSize = 54;
        
        self.window.rootViewController = self.viewDeckController;
        
        [[EggAppManager sharedInstance] registerDevice:nil failure:nil];
        
        
        /*
        MemberMainViewController *mmvc = [[[MemberMainViewController alloc] init] autorelease];
        _viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:self.tabBarController rightViewController:mmvc];
        _viewDeckController.rightSize = 54;
        
        self.window.rootViewController = self.viewDeckController;
         */
        
        
        //[self.window addSubview:_viewDeckController.view];
        

        _splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [_splashView setImage:[UIImage imageNamed:@"Default2.png"]];
        
        [self.viewDeckController.view addSubview:_splashView];
        [self.viewDeckController.view bringSubviewToFront:_splashView];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [self performSelector:@selector(changeSplash) withObject:self afterDelay:2];

        //EggConnectionManager *connectionManager=[[EggConnectionManager alloc] init];
        //connectionManager.managedObjectContext=self.managedObjectContext;
        
    }

    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)changeSplash{
    
    [_splashView setImage:[UIImage imageNamed:@"asocover.png"]];
    [self performSelector:@selector(removeSplash) withObject:self afterDelay:3];
}

-(void) removeSplash{
    [_splashView removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    CGRect frame = self.window.rootViewController.view.frame;
    frame.origin.y = 20;
    frame.size.height -= 20;
    self.window.rootViewController.view.frame = frame;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    // just set the flag regardless if there is an update or not
	[[EggApiManager sharedInstance] stopUpdateEverything];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // call the update manager whenever the app becomes active, but no more than 1 per every two hours
	NSDate *currentDate = [NSDate date];
	NSDate *lastUpdateDate = [[EggApiManager sharedInstance] getLastUpdateTime];
	
	if(lastUpdateDate) {
		NSTimeInterval sinceLastUpdate = [currentDate timeIntervalSince1970] - [lastUpdateDate timeIntervalSince1970];
		
		if(sinceLastUpdate >= UPDATE_MIN_INTERVAL_IN_SEC)
		{
			[[EggApiManager sharedInstance] updateEverything];
            [[EggApiManager sharedInstance] removeExpiredItems:self.managedObjectContext];
			
			NSError *error;
			if (![[GANTracker sharedTracker] trackEvent:NSLocalizedString(@"搶鮮機 iPhone App" , nil)
												 action:NSLocalizedString(@"APP BecomeActive 所進行的自動更新" , nil)
												  label:nil
												  value:sinceLastUpdate
											  withError:&error]) {
				NSLog(@"APP BecomeActive 所進行的自動更新");
			}
		}
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"tinysquare" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"tinysquare.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
									   NSMigratePersistentStoresAutomaticallyOption, 
									   [NSNumber numberWithBool:YES], 
									   NSInferMappingModelAutomaticallyOption, nil];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
