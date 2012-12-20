//
//  ItemAnnotation.h
//  NTIFO_01
//
//  Created by jason on 2011/9/6.
//  Copyright 2011 Fingertip Creative. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ItemAnnotation : NSObject <MKAnnotation> {
	NSString *itemName;
	NSString *itemAddress;
	double itemLatitude;
	double itemLongitude;
}

- (id)initWithItemName:(NSString *)aName address:(NSString *)anAddress latitude:(double)lat longitude:(double)lon;

@end
