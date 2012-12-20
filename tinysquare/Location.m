//
//  Location.m
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Location.h"
#import "LocationItem.h"


@implementation Location

@dynamic appPromotionMessage;
@dynamic directionDescription;
@dynamic locationId;
@dynamic longText;
@dynamic mapDescription;
@dynamic mapStatus;
@dynamic operationHour;
@dynamic pinColor;
@dynamic priceDescription;
@dynamic telephone;
@dynamic webUrl;
@dynamic locationItem;

+ (Location *)getLocationIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Location *location = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"locationId = %d", [anId intValue]];
	
	NSError *error = nil;
	location = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !location)
		return nil;
	
	return location;
}

+ (Location *)getOrCreateLocationWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Location *location = [Location getLocationIfExistWithId:anId inManagedObjectContext:context];
	
	if (!location) {
		location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
		location.locationItem = [NSEntityDescription insertNewObjectForEntityForName:@"LocationItem" inManagedObjectContext:context];
	}
	return location;
}

+ (void)deleteLocationIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Location *location = [Location getLocationIfExistWithId:anId inManagedObjectContext:context];
	
	if(location)
		[context deleteObject:location];
}

@end
