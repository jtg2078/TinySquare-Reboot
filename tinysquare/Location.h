//
//  Location.h
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocationItem;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * appPromotionMessage;
@property (nonatomic, retain) NSString * directionDescription;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSString * mapDescription;
@property (nonatomic, retain) NSString * mapStatus;
@property (nonatomic, retain) NSString * operationHour;
@property (nonatomic, retain) NSString * pinColor;
@property (nonatomic, retain) NSString * priceDescription;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * webUrl;
@property (nonatomic, retain) LocationItem *locationItem;

+ (Location *)getLocationIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Location *)getOrCreateLocationWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteLocationIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;

@end
