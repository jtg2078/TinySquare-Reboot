//
//  ItemImage.m
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemImage.h"

#import "Item.h"

@implementation ItemImage

@dynamic imageHash;
@dynamic imageId;
@dynamic imageName;
@dynamic imageType;
@dynamic sourceInfo;
@dynamic sourceType;
@dynamic lastModified;
@dynamic order;
@dynamic icon;
@dynamic small;
@dynamic medium;
@dynamic large;
@dynamic item;

+ (ItemImage *)getItemImageIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	ItemImage *image = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"ItemImage" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"imageId = %d", [anId intValue]];
	
	NSError *error = nil;
	image = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !image)
		return nil;
	
	return image;
}

+ (ItemImage *)getOrCreateItemImageWithId:(NSNumber *)anId andItem:(Item *)anItem inManagedObjectContext:(NSManagedObjectContext *)context
{
	ItemImage *image = [ItemImage getItemImageIfExistWithId:anId inManagedObjectContext:context];
	
	if (!image) {
		image = [NSEntityDescription insertNewObjectForEntityForName:@"ItemImage" inManagedObjectContext:context];
		image.item = anItem;
	}
	return image;
}

+ (void)deleteItemImageIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	ItemImage *image = [ItemImage getItemImageIfExistWithId:anId inManagedObjectContext:context];
	
	if(image)
		[context deleteObject:image];
}

@end
