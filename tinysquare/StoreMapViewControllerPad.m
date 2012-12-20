//
//  StoreMapViewControllerPad.m
//  tinysquare
//
//  Created by  on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreMapViewControllerPad.h"
#import "UIApplication+AppDimensions.h"
#import "MKMapView+ZoomLevel.h"

@implementation StoreMapViewControllerPad

#pragma mark -
#pragma mark define

#pragma mark -
#pragma mark synthesize

@synthesize mapView;

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
    [mapView release];
    [super dealloc];
}

#pragma mark -
#pragma mark init 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - loadView

- (void)loadView
{
    CGSize screenSize = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    mapView = [[MKMapView alloc] init];
    mapView.frame = baseView.frame;
    mapView.mapType = MKMapTypeStandard;
	mapView.delegate = self;
	mapView.showsUserLocation = YES;
    [baseView addSubview:mapView];
    
    self.view = baseView;
    [baseView release];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup initial region
	CLLocationCoordinate2D location;
    location.latitude = 23.80;
    location.longitude = 121.00;
	[mapView setCenterCoordinate:location zoomLevel:5 animated:NO];
    
    // check if gps service is enabled
    locationServiceEnabled = [CLLocationManager locationServicesEnabled];
	userLocationAvailable = NO;
	locationServiceAllowed = YES; // assume it was enabled
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation 
{	
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


#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
