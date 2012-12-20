//
//  StoreMapViewControllerPad.h
//  tinysquare
//
//  Created by  on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"

@interface StoreMapViewControllerPad : BaseViewController <MKMapViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
	bool userLocationAvailable;
	bool locationServiceEnabled;
	bool locationServiceAllowed;
}

@property (nonatomic, retain) MKMapView *mapView;

@end
