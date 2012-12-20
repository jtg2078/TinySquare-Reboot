//
//  TmpSavedProduct.m
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "TmpSavedProduct.h"
#import "JSONKit.h"
#import "DictionaryHelper.h"


@implementation TmpSavedProduct

@dynamic beginDate;
@dynamic categoryId;
@dynamic categoryName;
@dynamic customAttribute;
@dynamic customTags;
@dynamic displayOrder;
@dynamic durationStatus;
@dynamic endDate;
@dynamic fullDescription;
@dynamic id;
@dynamic isNew;
@dynamic isOnSale;
@dynamic lastModifiedTime;
@dynamic price;
@dynamic productName;
@dynamic productId;
@dynamic promoMsg;
@dynamic salePrice;
@dynamic summary;
@dynamic telephone;
@dynamic webUrl;
@dynamic savedDate;
@dynamic imageIdentifier;
@dynamic durationString;
@dynamic imagesJson;

+ (TmpSavedProduct *)getProductIfExistWithProductId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpSavedProduct *product = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpSavedProduct" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"productId = %d", [anId intValue]];
	
	NSError *error = nil;
	product = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !product)
		return nil;
	
	return product;
}

+ (TmpSavedProduct *)getOrCreateProductWithProductId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpSavedProduct *product = [TmpSavedProduct getProductIfExistWithProductId:anId inManagedObjectContext:context];
	
	if (!product) {
		product = [NSEntityDescription insertNewObjectForEntityForName:@"TmpSavedProduct" inManagedObjectContext:context];
        product.productId = anId;
	}
	return product;
}

+ (void)deleteProductIfExistWithProductId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	TmpSavedProduct *product = [TmpSavedProduct getProductIfExistWithProductId:anId inManagedObjectContext:context];
	
	if(product)
		[context deleteObject:product];
}

+ (void)deleteExpiredProductIfAny:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpSavedProduct" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"durationStatus == 2"];
	
	NSError *error = nil;
	NSArray *products = [context executeFetchRequest:request error:&error];
    
    for(TmpSavedProduct *p in products)
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

+ (NSArray *)getProductImagesWithSize:(TmpSavedProductImageSize)imageSize imageJson:(NSString *)aString
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
            case TmpSavedProductImageSize100:
                sizeKey = @"size100";
                break;
            case TmpSavedProductImageSize200:
                sizeKey = @"size200";
                break;
            case TmpSavedProductImageSize300:
                sizeKey = @"size300";
                break;
            case TmpSavedProductImageSize600:
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

+ (NSString *)getFirstProductImageWithSize:(TmpSavedProductImageSize)imageSize imageJson:(NSString *)aString
{
    NSString *firstImagePath = @"";
    
    for(NSString *imagePath in [TmpSavedProduct getProductImagesWithSize:imageSize imageJson:aString])
    {
        firstImagePath = imagePath;
        break;
    }
    return firstImagePath;
}

@end
