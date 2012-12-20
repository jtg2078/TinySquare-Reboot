//
//  Recipe.m
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Recipe.h"
#import "RecipeItem.h"


@implementation Recipe

@dynamic longText;
@dynamic recipeId;
@dynamic webUrl;
@dynamic recipeItem;

+ (Recipe *)getRecipeIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Recipe *recipe = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"recipeId = %d", [anId intValue]];
	
	NSError *error = nil;
	recipe = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !recipe)
		return nil;
	
	return recipe;
}

+ (Recipe *)getOrCreateRecipeWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Recipe *recipe = [Recipe getRecipeIfExistWithId:anId inManagedObjectContext:context];
	
	if (!recipe) {
		recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
		recipe.recipeItem = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:context];
	}
	return recipe;
}

+ (void)deleteRecipeIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Recipe *recipe = [Recipe getRecipeIfExistWithId:anId inManagedObjectContext:context];
	
	if(recipe)
		[context deleteObject:recipe];
}

@end
