//
//  Recipe.h
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecipeItem;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSNumber * recipeId;
@property (nonatomic, retain) NSString * webUrl;
@property (nonatomic, retain) RecipeItem *recipeItem;

+ (Recipe *)getRecipeIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Recipe *)getOrCreateRecipeWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteRecipeIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;

@end
