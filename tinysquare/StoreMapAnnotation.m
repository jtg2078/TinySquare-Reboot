//
//  MapAnnotation.m
//  NTIFO_01
//
//  Created by jason on 2011/9/7.
//  Copyright 2011 Fingertip Creative. All rights reserved.
//

#import "StoreMapAnnotation.h"


@implementation StoreMapAnnotation

#pragma mark -
#pragma mark @synthesize

@synthesize itemId;
@synthesize storeName;
@synthesize storeAddress;
@synthesize storeTelephone;
@synthesize storeLatitude;
@synthesize storeLongitude;


#pragma mark -
#pragma mark initialization and deallocation

- (void)dealloc
{
	[storeName release]; storeName = nil;
	[storeAddress release]; storeAddress = nil;
	[storeTelephone release]; storeTelephone = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = storeLatitude;
    theCoordinate.longitude = storeLongitude;
    return theCoordinate; 
}

- (NSString *)title
{
    return storeName;
}

- (NSString *)subtitle
{
    return storeAddress;
}



@end
