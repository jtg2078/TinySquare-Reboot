//
//  MapAnnotation.h
//  NTIFO_01
//
//  Created by jason on 2011/9/7.
//  Copyright 2011 Fingertip Creative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StoreMapAnnotation : NSObject <MKAnnotation> 
{
	int itemId;
	NSString *storeName;
	NSString *storeAddress;
	NSString *storeTelephone;
	double storeLatitude;
	double storeLongitude;
}

@property (nonatomic) int itemId;
@property (nonatomic) double storeLatitude;
@property (nonatomic) double storeLongitude;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *storeAddress;
@property (nonatomic, copy) NSString *storeTelephone;

@end
