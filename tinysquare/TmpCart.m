//
//  TmpCart.m
//  asoapp
//
//  Created by wyde on 12/5/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TmpCart.h"
#import "JSONKit.h"
#import "DictionaryHelper.h"




@implementation TmpCart

@dynamic beginDate;
@dynamic categoryId;
@dynamic categoryName;
@dynamic customAttribute;
@dynamic customTags;
@dynamic displayOrder;
@dynamic durationString;
@dynamic durationStatus;
@dynamic endDate;
@dynamic fullDescription;
@dynamic id;
@dynamic imageIdentifier;
@dynamic imagesJson;
@dynamic isNew;
@dynamic isOnSale;
@dynamic lastModifiedTime;
@dynamic price;
@dynamic productId;
@dynamic productName;
@dynamic promoMsg;
@dynamic salePrice;
@dynamic summary;
@dynamic savedDate;
@dynamic telephone;
@dynamic updateGeneration;
@dynamic webUrl;
@dynamic buyItemCount;

+ (TmpCart *)getProductIfExistWithProductId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpCart *product = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpCart" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"productId = %d", [anId intValue]];
	
	NSError *error = nil;
	product = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !product)
		return nil;
	
	return product;
}

+ (TmpCart *)getOrCreateProductWithProductId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpCart *product = [TmpCart getProductIfExistWithProductId:anId inManagedObjectContext:context];
	
	if (!product) {
		product = [NSEntityDescription insertNewObjectForEntityForName:@"TmpCart" inManagedObjectContext:context];
        product.productId = anId;
	}
	return product;
}

+ (void)deleteProductIfExistWithProductId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpCart *product = [TmpCart getProductIfExistWithProductId:anId inManagedObjectContext:context];
	
	if(product)
		[context deleteObject:product];
}

+ (void)deleteExpiredProductIfAny:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpCart" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"durationStatus == 2"];
	
	NSError *error = nil;
	NSArray *products = [context executeFetchRequest:request error:&error];
    
    for(TmpCart *p in products)
    {
        if([[p.endDate earlierDate:[NSDate date]] isEqual:p.endDate])
            [context deleteObject:p];
    }
	[request release];
    [context save:&error];
}

+ (NSArray *)getTagNameArrayFromTagString:(NSString *)aString
{
    NSMutableArray *tagArray = [NSMutableArray array];
    id tagObj = [aString objectFromJSONString];
    
    if([tagObj isKindOfClass:[NSArray class]])
    {
        NSArray *tags = (NSArray *)tagObj;
        NSSortDescriptor *orderDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES];
        NSArray *sortedTags = [tags sortedArrayUsingDescriptors:[NSArray arrayWithObject:orderDescriptor]];
        [sortedTags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *tagInfo = (NSDictionary *)obj;
            [tagArray addObject:[tagInfo stringForKey:@"tagname"]];
        }];
    }
    
    return tagArray;
}

+ (NSString *)getLastTagFromTagString:(NSString *)aString
{
    NSString *lastTag = @"暫無屬性";
    id tagObj = [aString objectFromJSONString];
    
    if([tagObj isKindOfClass:[NSArray class]])
    {
        NSArray *tags = (NSArray *)tagObj;
        NSSortDescriptor *orderDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:NO];
        NSArray *sortedArray = [tags sortedArrayUsingDescriptors:[NSArray arrayWithObject:orderDescriptor]];
        tagObj = (NSDictionary *)[sortedArray lastObject];
    }
    
    if([tagObj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *last = (NSDictionary *)tagObj;
        lastTag = [last stringForKey:@"tagname"];
    }
    return lastTag;
}

+ (NSArray *)getProductImagesWithSize:(TmpCartImageSize)imageSize imageJson:(NSString *)aString
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
            case TmpCartImageSize100:
                sizeKey = @"size100";
                break;
            case TmpCartImageSize200:
                sizeKey = @"size200";
                break;
            case TmpCartImageSize300:
                sizeKey = @"size300";
                break;
            case TmpCartImageSize600:
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

+ (NSString *)getFirstProductImageWithSize:(TmpCartImageSize)imageSize imageJson:(NSString *)aString
{
    NSString *firstImagePath = @"";
    
    for(NSString *imagePath in [TmpCart getProductImagesWithSize:imageSize imageJson:aString])
    {
        firstImagePath = imagePath;
        break;
    }
    return firstImagePath;
}

@end
