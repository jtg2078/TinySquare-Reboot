//
//  ItemAnnotation.m
//  NTIFO_01
//
//  Created by jason on 2011/9/6.
//  Copyright 2011 Fingertip Creative. All rights reserved.
//

#import "ItemAnnotation.h"


@implementation ItemAnnotation

#pragma mark -
#pragma mark initialization and deallocation

- (id)initWithItemName:(NSString *)aName address:(NSString *)anAddress latitude:(double)lat longitude:(double)lon
{
	self = [super init];
	if (self) {
		itemName = [aName copy];
		itemAddress = [anAddress copy];
		itemLatitude = lat;
		itemLongitude = lon;
	}
	return self;
}

- (void)dealloc
{
	[itemName release]; itemName = nil;
	[itemAddress release]; itemAddress = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = itemLatitude;
    theCoordinate.longitude = itemLongitude;
    return theCoordinate; 
}

- (NSString *)title
{
    return itemName;
}

- (NSString *)subtitle
{
    return itemAddress;
}

@end
