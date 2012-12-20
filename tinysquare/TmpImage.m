//
//  TmpImages.m
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "TmpImage.h"


@implementation TmpImage

@dynamic ownerId;
@dynamic imageId;
@dynamic imageType;
@dynamic sourceType;
@dynamic displayOrder;
@dynamic size100;
@dynamic size200;
@dynamic size300;
@dynamic size600;
@dynamic identifier;
@dynamic updateGeneration;


+ (TmpImage *)getImageIfExistWithIdentifier:(NSString *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpImage *image = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpImage" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", anId];
	
	NSError *error = nil;
	image = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !image)
		return nil;
	
	return image;
}

+ (TmpImage *)getOrCreateImageWithIdentifier:(NSString *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpImage *image = [TmpImage getImageIfExistWithIdentifier:anId inManagedObjectContext:context];
	
	if (!image) {
		image = [NSEntityDescription insertNewObjectForEntityForName:@"TmpImage" inManagedObjectContext:context];
	}
	return image;
}

+ (TmpImage *)getImageIfExistWithOwnerId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
    TmpImage *image = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpImage" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"ownerId = %d", [anId intValue]];
	
	NSError *error = nil;
	image = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !image)
		return nil;
	
	return image;
}

+ (TmpImage *)getOrCreateImageWithOwnerId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
    TmpImage *image = [TmpImage getImageIfExistWithOwnerId:anId inManagedObjectContext:context];
	
	if (!image) {
		image = [NSEntityDescription insertNewObjectForEntityForName:@"TmpImage" inManagedObjectContext:context];
	}
	return image;
}

+ (void)deleteImageIfExistWithIdentifier:(NSString *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpImage *image = [TmpImage getImageIfExistWithIdentifier:anId inManagedObjectContext:context];
	
	if(image)
		[context deleteObject:image];
}

+ (NSArray *)getImagesWithOwnerId:(NSNumber *)anId imageType:(NSNumber *)aType inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSArray *images = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpImage" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"ownerId = %d AND imageType = %d", [anId intValue], [aType intValue]];
    //request.predicate = [NSPredicate predicateWithFormat:@"ownerId = %d", anId];
	
	NSError *error = nil;
	images = [context executeFetchRequest:request error:&error];
	[request release];
	
	if (!error && !images)
		return nil;
    [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TmpImage *image = (TmpImage *)obj;
        NSLog(@"ownerId: %d", [image.ownerId intValue]);
        NSLog(@"imageId: %d", [image.imageId intValue]);
        NSLog(@"imageType: %d", [image.imageType intValue]);
        NSLog(@"sourceType: %@", image.sourceType);
        NSLog(@"displayOrder: %d", [image.displayOrder intValue]);
        NSLog(@"size100: %@", image.size100);
        NSLog(@"size200: %@", image.size200);
        NSLog(@"size300: %@", image.size300);
        NSLog(@"size600: %@", image.size600);
        NSLog(@"identifier: %@", image.identifier);
        NSLog(@"updateGeneration: %d", [image.updateGeneration intValue]);
    }];
    
	
	return images;
}

@end
