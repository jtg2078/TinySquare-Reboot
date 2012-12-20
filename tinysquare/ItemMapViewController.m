    //
//  ItemMapViewController.m
//  NTIFO_01
//
//  Created by jason on 2011/9/6.
//  Copyright 2011 Fingertip Creative. All rights reserved.
//

#import "ItemMapViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "UINavigationController+Customize.h"
#import "ItemAnnotation.h"


@implementation ItemMapViewController

#pragma mark -
#pragma mark define

#define PATH_FOR_TRACKING @"/BaseDetailViewController/ItemMapViewController"


#pragma mark -
#pragma mark synthesize


#pragma mark -
#pragma mark initializer dealloc and loadView

- (void)dealloc 
{
	[mapView release]; mapView = nil;
	[itemName release]; itemName = nil;
	[itemAddress release]; itemAddress = nil;
	[itemAnnotation release]; itemAnnotation = nil;
    [super dealloc];
}

- (id)initWithItemId:(int)anId name:(NSString *)aName address:(NSString *)anAddress latitude:(double)lat longitude:(double)lon
{
	self = [super init];
	if (self) {
		itemId = anId;
		itemName = [aName copy];
		itemAddress = [anAddress copy];
		itemLatitude = lat;
		itemLongitude = lon;
	}
	return self;
}

- (void)loadView 
{
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
	
	userLocationAvailable = NO;
	
	UIButton *userLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
	userLocationButton.frame = CGRectMake(285, 381, 30, 30);
	[userLocationButton setBackgroundImage:[UIImage imageNamed:@"currentLoc.png"] forState:UIControlStateNormal];
	[userLocationButton addTarget:self action:@selector(centerUserLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:userLocationButton];
	
	
	UIButton *itemLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
	itemLocationButton.frame = CGRectMake(5, 381, 30, 30);
	[itemLocationButton setBackgroundImage:[UIImage imageNamed:@"LBSMap_Icon_ItemPosition.png"] forState:UIControlStateNormal];
	[itemLocationButton addTarget:self action:@selector(centerItemLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:itemLocationButton];
}


#pragma mark -
#pragma mark view lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// create a custom back button
	UIButton* backButton = [self.navigationController setUpCustomizeBackButtonWithText:NSLocalizedString(@"返回", nil)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	
	// setup initial region
	CLLocationCoordinate2D location; //= {latitude: itemLatitude, longitude: itemLongitude};
	location.latitude = itemLatitude;
	location.longitude = itemLongitude;
	[mapView setCenterCoordinate:location zoomLevel:15 animated:YES];
	
	// setup annotation
	itemAnnotation = [[ItemAnnotation alloc] initWithItemName:itemName 
													  address:itemAddress 
													 latitude:itemLatitude 
													longitude:itemLongitude];
	[mapView addAnnotation:itemAnnotation];
	
	// tracking
	[self googleAnalyticsTrackPageView:PATH_FOR_TRACKING];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:YES];
	/*
    [self setupToolbar];
	[self layoutSubviews];
	*/
	NSNumber *hideBar = [NSNumber numberWithInt:0];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:hideBar];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
	
	NSNumber *showBar = [NSNumber numberWithInt:1];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
}


#pragma mark -
#pragma mark user interaction

- (void)showDetails:(id)sender 
{
	NSString *mapText = NSLocalizedString(@"在 Google Map 開啟", nil);
	NSString *copyText = NSLocalizedString(@"拷貝地址", nil);
	UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:nil
															delegate:self 
												   cancelButtonTitle:NSLocalizedString(@"取消", nil)
											  destructiveButtonTitle:nil
												   otherButtonTitles:mapText, copyText, nil];
	
	[styleAlert showInView:self.view];
	[styleAlert release];
}

- (void)centerUserLocationPressed:(id)sender 
{
	if(userLocationAvailable == YES)
	{
		CLLocationCoordinate2D location;
		location.latitude = mapView.userLocation.coordinate.latitude;
		location.longitude = mapView.userLocation.coordinate.longitude;
		[mapView setCenterCoordinate:location zoomLevel:15 animated:YES];
	}
}

- (void)centerItemLocationPressed:(id)sender 
{
	CLLocationCoordinate2D location;
	location.latitude = itemLatitude;
	location.longitude = itemLongitude;
	[mapView setCenterCoordinate:location zoomLevel:15 animated:YES];
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
			NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", itemAddress];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
			break;
		}
		case 1:
		{
			UIPasteboard *generalPasteBoard = [UIPasteboard generalPasteboard];
			generalPasteBoard.string = itemAddress;
			break;
		}
	}
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	// if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	if ([annotation isKindOfClass:[ItemAnnotation class]])
	{
		// try to dequeue an existing pin view first
        static NSString* ItemAnnotationIdentifier = @"itemAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ItemAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation 
																				 reuseIdentifier:ItemAnnotationIdentifier] autorelease];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
			
			UIImageView *itemIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-0.png", itemId]]];
			itemIcon.frame = CGRectMake(0, 0, 32, 32);
            customPinView.leftCalloutAccessoryView = itemIcon;
            [itemIcon release];
			
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;		
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)_mapView didAddAnnotationViews:(NSArray *)views
{
	for (id<MKAnnotation> currentAnnotation in mapView.annotations) 
	{       
		if ([currentAnnotation isEqual:itemAnnotation]) 
		{
			double delayInSeconds = 0.5;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
			{
				[mapView selectAnnotation:currentAnnotation animated:YES];
			});
		}
	}
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation 
{
	userLocationAvailable = YES;
}


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
