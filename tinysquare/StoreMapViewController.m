    //
//  StoreMapViewController.m
//  TinyStore
//
//  Created by jason on 2011/9/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreMapViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "UINavigationController+Customize.h"
#import "RadiusOptionsViewController.h"
#import "UIBarButtonItem+WEPopover.h"
#import "MKInfoPanel.h"
#import "StoreListingViewController.h"
#import "StoreMapAnnotation.h"
#import "AppDelegate.h"
#import "TATabBarController.h"
#import "ThemeManager.h"

#import "TmpLocation.h"
#import "EggApiManager.h"

@interface StoreMapViewController ()
- (void)selectRadius:(id)sender;
- (void)changeRadius:(int)radiusIndex;
- (void)radiusChanged:(NSNotification *)notif;
- (void)showLocationList;
- (BOOL)canPerformLocationTasks;
- (void)addStoreAnnotationToMapView;
- (void)updateStoreLocations;
- (void)clearStoreLocations;
- (void)setupNavigationBarButtons;
@end


@implementation StoreMapViewController

#pragma mark -
#pragma mark macro


#pragma mark -
#pragma mark define

#define TAB_IMAGE_NAME					@"StoreMapTabIcon.png"
#define MODULE_NAME						@"營業據點"
#define SEVERE_ERROR_WARNING_DURATION	5
#define DEFAULT_RADIUS_INDEX			3
#define SELF_UPDATE_INTERVAL            600 // 10 minutes


#pragma mark -
#pragma mark synthesize

@synthesize popoverController;
@synthesize radiusButton;
@synthesize radiusBarButton;
@synthesize radiusOptions;
@synthesize managedObjectContext;
@synthesize selectedAnnotation;
@synthesize lastUpdateTime;


#pragma mark - 
#pragma mark dealloc

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[popoverController release];
	[radiusButton release];
	[radiusBarButton release];
	[mapView release];
	[radiusOptions release];
	[managedObjectContext release];
	[selectedAnnotation release];
    [super dealloc];
}


#pragma mark -
#pragma mark initialization and view construction

- (id)init
{
	if (self = [super init]) 
	{
		self.title = NSLocalizedString(@"營業據點", nil);
		
		// tab bar item and image
		UIImage* anImage = [UIImage imageNamed:TAB_IMAGE_NAME];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:self.title image:anImage tag:0];
		self.tabBarItem = theItem;
		[theItem release];
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// ---- create MKMapView ----
	mapView = [[MKMapView alloc] init];
	mapView.frame = CGRectMake(0, 0, 320, 367);
	mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
	mapView.mapType = MKMapTypeStandard;
	mapView.delegate = self;
	mapView.showsUserLocation = YES;
	
	UIView *baseView = [[UIView alloc] initWithFrame:mapView.frame];
	[baseView addSubview:mapView];
	self.view = baseView;
	[baseView release];
	
	UIButton *userLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
	userLocationButton.frame = CGRectMake(285, 327, 30, 30);
	[userLocationButton setBackgroundImage:[UIImage imageNamed:@"LBSMap_Icon_Current.png"] forState:UIControlStateNormal];
	[userLocationButton addTarget:self action:@selector(centerUserLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:userLocationButton];
}

- (void)setupNavigationBarButtons
{
    // setup radius button
	UIButton* button = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"10公里", nil) 
                                                                               icon:CustomizeButtonIconAdd
                                                                      iconPlacement:CustomizeButtonIconPlacementRight 
                                                                             target:self 
                                                                             action:@selector(selectRadius:)];
	self.radiusButton = button;
	self.radiusBarButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	self.navigationItem.rightBarButtonItem = self.radiusBarButton;
	
	// setup the store list view button
	UIButton* listButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"據點總覽", nil) 
                                                                                   icon:CustomizeButtonIconAdd
                                                                          iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                 target:self 
                                                                                 action:@selector(showLocationList)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
}


#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	// setup navigation bar buttons
    [self setupNavigationBarButtons];
	
	// setup initial region
	CLLocationCoordinate2D location;
    location.latitude = 23.80;
    location.longitude = 121.00;
	[mapView setCenterCoordinate:location zoomLevel:5 animated:NO];
	
	// setup popover for radius selection
	popoverClass = [WEPopoverController class];
	
	// set up notification for changing radius
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(radiusChanged:) 
												 name:@"com.fingertipcreative.tinysquare.changeRadius" object:nil];
	
	self.radiusOptions = [NSArray arrayWithObjects: NSLocalizedString(@"500公尺", nil),
						  NSLocalizedString(@"1公里", nil),
						  NSLocalizedString(@"5公里", nil),
						  NSLocalizedString(@"10公里", nil),
						  NSLocalizedString(@"50公里", nil), nil];
	
	// check if gps service is enabled
    locationServiceEnabled = [CLLocationManager locationServicesEnabled];
	userLocationAvailable = NO;
	locationServiceAllowed = YES; // assume it was enabled
	
	//[self addStoreAnnotationToMapView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[self.popoverController dismissPopoverAnimated:NO];
	self.popoverController = nil;
	self.radiusButton = nil;
	self.radiusBarButton = nil;
	self.radiusOptions = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if(self.lastUpdateTime == nil)
    {
        [self updateStoreLocations];
        self.lastUpdateTime = [NSDate date];
    }
    else
    {
        NSTimeInterval sinceLastUpdate = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
		
		if(sinceLastUpdate >= SELF_UPDATE_INTERVAL)
        {
            [self clearStoreLocations];
            [self updateStoreLocations];
            self.lastUpdateTime = [NSDate date];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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
    
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
    // needs to customize title display
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.text = self.title;
	titleLabel.textColor = themeManager.navigationBarTitleTextColor;
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.frame = CGRectMake(0, 0, [titleLabel.text sizeWithFont:font].width, 44);
	titleLabel.font = font;
	self.navigationItem.titleView = titleLabel;
	[titleLabel release];
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation 
{
	if(userLocationAvailable == NO)
		[self changeRadius:DEFAULT_RADIUS_INDEX];
	
	userLocationAvailable = YES;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [mapView setCenterCoordinate:userLocation.coordinate zoomLevel:11 animated:YES];
    });
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
	locationServiceAllowed = NO;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	// if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	if ([annotation isKindOfClass:[StoreMapAnnotation class]])
	{
		// try to dequeue an existing pin view first
        static NSString* StoreAnnotationIdentifier = @"storeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:StoreAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation 
																				 reuseIdentifier:StoreAnnotationIdentifier] autorelease];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
			
            pinView = customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
		
        return pinView;		
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	self.selectedAnnotation = (StoreMapAnnotation *)view.annotation;
	
	NSString *mapText = NSLocalizedString(@"在 Google Map 開啟", nil);
	NSString *copyText = NSLocalizedString(@"拷貝地址", nil);
	NSString *callText = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"撥號", nil), self.selectedAnnotation.storeTelephone];
	UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:nil
															delegate:self 
												   cancelButtonTitle:NSLocalizedString(@"取消", nil)
											  destructiveButtonTitle:nil
												   otherButtonTitles:mapText, copyText, callText, nil];
	
	AppDelegate* delegate = [AppDelegate sharedAppDelegate];
	
	
	
	[styleAlert showInView:delegate.tabBarController.view];
	[styleAlert release];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	switch (buttonIndex)
	{
		case 0:
		{
			//NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%f,%f",selectedCellData.lat, selectedCellData.lon];
			NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", self.selectedAnnotation.storeAddress];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
			break;
		}
		case 1:
		{
			UIPasteboard *generalPasteBoard = [UIPasteboard generalPasteboard];
			generalPasteBoard.string = self.selectedAnnotation.storeAddress;
			break;
		}
		case 2:
		{
			NSString *alertMsg = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"撥打", nil), self.selectedAnnotation.storeTelephone];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertMsg 
															message:nil
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"取消", nil) 
												  otherButtonTitles:NSLocalizedString(@"撥打", nil),nil];
			[alert show];
			[alert release];
		}
	}
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// 0 = cancel
	// 1 = dial
	if(buttonIndex == 1)
	{
		NSString *phoneString = [NSString stringWithFormat:@"tel://%@", self.selectedAnnotation.storeTelephone];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: phoneString]];
	}
}


#pragma mark - 
#pragma mark EggApiManagerDelegate

- (void)updateLocationsCompleted:(EggApiManager *)manager
{
    [self addStoreAnnotationToMapView];
}

- (void)updateLocationsFailed:(EggApiManager *)manager
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeError
                           title:NSLocalizedString(@"更新失敗... 請稍後再試", nil) 
                        subtitle:nil
                       hideAfter:4];
}


#pragma mark -
#pragma mark private interface

- (void)selectRadius:(id)sender
{	
	if (!self.popoverController) 
	{
		UIViewController *contentViewController = [[RadiusOptionsViewController alloc] initWithStyle:UITableViewStylePlain];
		self.popoverController = [[[popoverClass alloc] initWithContentViewController:contentViewController] autorelease];
		self.popoverController.delegate = self;
		self.popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
		
		[self.popoverController presentPopoverFromBarButtonItem:radiusBarButton
									   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) 
													   animated:YES];
		
		[contentViewController release];
	} 
	else 
	{
		[self.popoverController dismissPopoverAnimated:YES];
		self.popoverController = nil;
	}
}

- (void)radiusChanged:(NSNotification *)notif
{
	NSNumber *radiusOptionsIndex = (NSNumber *)[notif object];
	int index = [radiusOptionsIndex intValue];
	[self changeRadius:index];
}

- (void)changeRadius:(int)radiusIndex
{
	[self.radiusButton setTitle:[self.radiusOptions objectAtIndex:radiusIndex] forState:UIControlStateNormal];
	[self.popoverController dismissPopoverAnimated:YES];
	self.popoverController = nil;
	
	
	if([self canPerformLocationTasks] == NO)
		return;
	
	if(mapView.userLocation == nil)
	{
		[MKInfoPanel showPanelInView:self.view 
								type:MKInfoPanelTypeError 
							   title:NSLocalizedString(@"無法定位", nil) 
							subtitle:NSLocalizedString(@"沒有GPS訊號", nil) 
						   hideAfter:SEVERE_ERROR_WARNING_DURATION];
		return;
	}
	
	double distanceInMeter = 0;
	switch (radiusIndex) {
		case 0:
			distanceInMeter = 500;
			break;
		case 1:
			distanceInMeter = 1000;
			break;
		case 2:
			distanceInMeter = 5000;
			break;
		case 3:
			distanceInMeter = 10000;
			break;
		case 4:
			distanceInMeter = 50000;
			break;
		default:
			break;
	}
	
	CLLocationCoordinate2D userCoordinate = mapView.userLocation.coordinate;
	MKCoordinateRegion boundBox = MKCoordinateRegionMakeWithDistance(userCoordinate, distanceInMeter, distanceInMeter);
	
	[mapView setRegion:boundBox animated:YES];
}

- (void)showLocationList
{
	StoreListingViewController *slvc = [[StoreListingViewController alloc] init];
	slvc.managedObjectContext = self.managedObjectContext;
	[self.navigationController pushViewController:slvc animated:YES];
	[slvc release];
}

- (BOOL)canPerformLocationTasks
{
	if (locationServiceEnabled == NO) 
	{
		[MKInfoPanel showPanelInView:self.view 
								type:MKInfoPanelTypeError 
							   title:NSLocalizedString(@"無法定位", nil) 
							subtitle:NSLocalizedString(@"請到設定->定位服務來開啟此服務", nil)
						   hideAfter:SEVERE_ERROR_WARNING_DURATION];
		return NO;
	}
	
	if(locationServiceAllowed == NO)
	{
		[MKInfoPanel showPanelInView:self.view 
								type:MKInfoPanelTypeError 
							   title:NSLocalizedString(@"無法使用定位服務", nil) 
							subtitle:NSLocalizedString(@"請到設定->定位服務來開啟此APP的定位權限", nil)
						   hideAfter:SEVERE_ERROR_WARNING_DURATION];
		return NO;
	}
	
	return YES;
}

- (void)addStoreAnnotationToMapView
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
	{
		NSManagedObjectContext *moc = [[[NSManagedObjectContext alloc] init] autorelease];
		[moc setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
		
		// setup fetch request
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"TmpLocation" inManagedObjectContext:moc];
		[fetchRequest setEntity:entity];
		
		NSError *error = nil;
		NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
		[fetchRequest release];
		
		if(error != nil || [array count] == 0)
			return;
		
		NSMutableArray *locations = [NSMutableArray array];
		for(TmpLocation *location in array)
		{
			StoreMapAnnotation *annotation = [[StoreMapAnnotation alloc] init];
			annotation.itemId = [location.locationId intValue];
			annotation.storeName = location.storeName;
			annotation.storeAddress = location.address;
			annotation.storeTelephone = location.telephone;
			annotation.storeLatitude = [location.latitude doubleValue];
			annotation.storeLongitude = [location.longitude doubleValue];
			[locations addObject:annotation];
			[annotation release];
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{ [mapView addAnnotations:locations]; });
	});
}

- (void)updateStoreLocations
{
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeProgress
                           title:NSLocalizedString(@"更新中... 請稍後", nil) 
                        subtitle:nil
                       hideAfter:3];
    
    EggApiManager *apiManager = [EggApiManager sharedInstance];
    
    if(apiManager.isUpdatingLocations == NO)
    {
        [apiManager updateLocations];
        apiManager.updateLocationsDelegate = self;
    }
}

- (void)clearStoreLocations
{
    for (int i =0; i < [mapView.annotations count]; i++) 
    { 
        if ([[mapView.annotations objectAtIndex:i] isKindOfClass:[StoreMapAnnotation class]]) 
        {                      
            [mapView removeAnnotation:[mapView.annotations objectAtIndex:i]]; 
        } 
    } 
}


#pragma mark -
#pragma mark user interaction

- (IBAction)centerUserLocationPressed:(id)sender 
{
	if([self canPerformLocationTasks] == NO)
		return;
	
	if(userLocationAvailable == YES)
	{
		CLLocationCoordinate2D location;
		location.latitude = mapView.userLocation.coordinate.latitude;
		location.longitude = mapView.userLocation.coordinate.longitude;
		[mapView setCenterCoordinate:location zoomLevel:13 animated:YES];
	}
}

- (IBAction)defaultViewRegionPressed:(id)sender
{
	CLLocationCoordinate2D location;
    location.latitude = 23.80;
    location.longitude = 121.00;
	[mapView setCenterCoordinate:location zoomLevel:5 animated:YES];
}


#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
