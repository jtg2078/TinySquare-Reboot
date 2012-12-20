//
//  ItemMapViewController.h
//  NTIFO_01
//
//  Created by jason on 2011/9/6.
//  Copyright 2011 Fingertip Creative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"

@class ItemAnnotation;
@interface ItemMapViewController : BaseViewController <MKMapViewDelegate, UIActionSheetDelegate> {
	MKMapView *mapView;
	int itemId;
	NSString *itemName;
	NSString *itemAddress;
	double itemLatitude;
	double itemLongitude;
	bool userLocationAvailable;
	ItemAnnotation *itemAnnotation;
}

- (id)initWithItemId:(int)anId name:(NSString *)aName address:(NSString *)anAddress latitude:(double)lat longitude:(double)lon;

@end
