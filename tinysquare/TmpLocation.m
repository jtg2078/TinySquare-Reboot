//
//  TmpLocation.m
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "TmpLocation.h"
#import "JSONKit.h"
#import "DictionaryHelper.h"

@implementation TmpLocation

@dynamic id;
@dynamic address;
@dynamic fullDescription;
@dynamic locationId;
@dynamic latitude;
@dynamic longitude;
@dynamic locationName;
@dynamic storeName;
@dynamic region;
@dynamic regionId;
@dynamic telephone;
@dynamic storeType;
@dynamic webUrl;
@dynamic zipCode;
@dynamic imageIdentifier;
@dynamic updateGeneration;
@dynamic imagesJson;


+ (TmpLocation *)getLocationIfExistWithLocationId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpLocation *location = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpLocation" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"locationId = %d", [anId intValue]];
	
	NSError *error = nil;
	location = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !location)
		return nil;
	
	return location;
}

+ (TmpLocation *)getOrCreateLocationWithLocationId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpLocation *location = [TmpLocation getLocationIfExistWithLocationId:anId inManagedObjectContext:context];
	
	if (!location) {
		location = [NSEntityDescription insertNewObjectForEntityForName:@"TmpLocation" inManagedObjectContext:context];
        location.locationId = anId;
	}
	return location;
}

+ (void)deleteLocationIfExistWithLocationId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpLocation *product = [TmpLocation getLocationIfExistWithLocationId:anId inManagedObjectContext:context];
	
	if(product)
		[context deleteObject:product];
}

+ (NSArray *)getLocationImagesWithSize:(TmpLocationImageSize)imageSize imageJson:(NSString *)aString;
{
    id imagesObj = [aString objectFromJSONString];
    NSArray *array = nil;
    NSMutableArray *images = [NSMutableArray array];
    
    if([imagesObj isKindOfClass:[NSDictionary class]])
    {
        array = [NSArray arrayWithObject:imagesObj];
    }
    
    if([imagesObj isKindOfClass:[NSArray class]])
    {
        array = (NSArray *)imagesObj;
    }
    
    if(array)
    {
        NSString *sizeKey = @"";
        
        switch (imageSize) {
            case TmpLocationImageSize100:
                sizeKey = @"size100";
                break;
            case TmpLocationImageSize200:
                sizeKey = @"size200";
                break;
            case TmpLocationImageSize300:
                sizeKey = @"size300";
                break;
            case TmpLocationImageSize600:
                sizeKey = @"size600";
                break;
            default:
                break;
        }
        
        NSSortDescriptor *orderDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES];
        NSArray *sortedArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:orderDescriptor]];
        [sortedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *imageInfo = (NSDictionary *)obj;
            [images addObject:[imageInfo stringForKey:sizeKey]];
        }];
    }
    return images;
}

+ (NSString *)getFirstLocationImageWithSize:(TmpLocationImageSize)imageSize imageJson:(NSString *)aString
{
    NSString *firstImagePath = @"";
    
    for(NSString *imagePath in [TmpLocation getLocationImagesWithSize:imageSize imageJson:aString])
    {
        firstImagePath = imagePath;
        break;
    }
    return firstImagePath;
}

@end
