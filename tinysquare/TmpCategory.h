//
//  TmpCategory.h
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TmpCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSNumber * updateGeneration;

+ (TmpCategory *)getCategoryIfExistWithCategoryId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (TmpCategory *)getOrCreateCategoryWithCategoryId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteCategoryIfExistWithCategoryId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;

@end
