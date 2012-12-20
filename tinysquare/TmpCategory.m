//
//  TmpCategory.m
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "TmpCategory.h"


@implementation TmpCategory

@dynamic id;
@dynamic categoryId;
@dynamic count;
@dynamic categoryName;
@dynamic displayOrder;
@dynamic updateGeneration;

+ (TmpCategory *)getCategoryIfExistWithCategoryId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
    TmpCategory *category = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpCategory" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"categoryId = %d", [anId intValue]];
	
	NSError *error = nil;
	category = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !category)
		return nil;
	
	return category;
}

+ (TmpCategory *)getOrCreateCategoryWithCategoryId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
    TmpCategory *category = [TmpCategory getCategoryIfExistWithCategoryId:anId inManagedObjectContext:context];
    
    if (!category) {
		category = [NSEntityDescription insertNewObjectForEntityForName:@"TmpCategory" inManagedObjectContext:context];
        category.categoryId = anId;
	}
	return category;
}

+ (void)deleteCategoryIfExistWithCategoryId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
    TmpCategory *category = [TmpCategory getCategoryIfExistWithCategoryId:anId inManagedObjectContext:context];
	
	if(category)
		[context deleteObject:category];
}

@end
