//
//  Association.m
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Association.h"
#import "AssociationItem.h"


@implementation Association

@dynamic associationId;
@dynamic associationType;
@dynamic directionDescription;
@dynamic longText;
@dynamic mapDescription;
@dynamic mapStatus;
@dynamic operationHour;
@dynamic pinColor;
@dynamic telephone;
@dynamic webUrl;
@dynamic associationItem;

+ (Association *)getAssociationIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Association *association = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Association" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"associationId = %d", [anId intValue]];
	
	NSError *error = nil;
	association = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !association)
		return nil;
	
	return association;
}

+ (Association *)getOrCreateAssociationWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Association *association = [Association getAssociationIfExistWithId:anId inManagedObjectContext:context];
	
	if (!association) {
		association = [NSEntityDescription insertNewObjectForEntityForName:@"Association" inManagedObjectContext:context];
		association.associationItem = [NSEntityDescription insertNewObjectForEntityForName:@"AssociationItem" inManagedObjectContext:context];
	}
	return association;
}

+ (void)deleteAssociationIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Association *association = [Association getAssociationIfExistWithId:anId inManagedObjectContext:context];
	
	if(association)
		[context deleteObject:association];
}

@end
