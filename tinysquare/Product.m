//
//  Product.m
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Product.h"

#import "ProductItem.h"

@implementation Product

@dynamic appPromotionMessage;
@dynamic longText;
@dynamic mapDescription;
@dynamic mapStatus;
@dynamic pinColor;
@dynamic productId;
@dynamic telephone;
@dynamic webUrl;
@dynamic hasExpiration;
@dynamic productItem;

@dynamic categoryId;
@dynamic categoryName;
@dynamic displayOrder;
@dynamic extension;
@dynamic salePrice;
@dynamic isNew;
@dynamic isSale;
@dynamic tag;

+ (Product *)getProductIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Product *product = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"productId = %d", [anId intValue]];
	
	NSError *error = nil;
	product = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !product)
		return nil;
	
	return product;
}

+ (Product *)getOrCreateProductWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Product *product = [Product getProductIfExistWithId:anId inManagedObjectContext:context];
	
	if (!product) {
		product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
		product.productItem = [NSEntityDescription insertNewObjectForEntityForName:@"ProductItem" inManagedObjectContext:context];
	}
	return product;
}

+ (void)deleteProductIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Product *product = [Product getProductIfExistWithId:anId inManagedObjectContext:context];
	
	if(product)
		[context deleteObject:product];
}

+ (void)deleteExpiredProductIfAny:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"hasExpiration == YES"];
	
	NSError *error = nil;
	NSArray *products = [context executeFetchRequest:request error:&error];
    
    for(Product *p in products)
    {
        if([[p.productItem.availableTimeEnd earlierDate:[NSDate date]] isEqual:p.productItem.availableTimeEnd])
            [context deleteObject:p];
    }
	[request release];
    [context save:&error];
}

@end
