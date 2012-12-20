//
//  StoreMapViewController.h
//  TinyStore
//
//  Created by jason on 2011/9/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
#import "WEPopoverController.h"
#import "EggApiManagerDelegate.h"

@class StoreMapAnnotation;
@interface StoreMapViewController : BaseViewController <WEPopoverControllerDelegate, MKMapViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, EggApiManagerDelegate> {
	MKMapView *mapView;
	WEPopoverController *popoverController;
	Class popoverClass;
	UIButton* radiusButton;
	UIBarButtonItem *radiusBarButton;
	NSArray *radiusOptions;
	bool userLocationAvailable;
	bool locationServiceEnabled;
	bool locationServiceAllowed;
	NSManagedObjectContext *managedObjectContext;
	StoreMapAnnotation *selectedAnnotation;
}

@property (nonatomic, retain) NSArray *radiusOptions;
@property (nonatomic, retain) UIButton* radiusButton;
@property (nonatomic, retain) UIBarButtonItem *radiusBarButton;
@property (nonatomic, retain) WEPopoverController *popoverController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) StoreMapAnnotation *selectedAnnotation;
@property (nonatomic, retain) NSDate *lastUpdateTime;

@end
