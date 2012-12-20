//
//  RecipeItem.h
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <CoreData/CoreData.h>
#import "Item.h"

@class Recipe;

@interface RecipeItem : Item

@property (nonatomic, retain) Recipe * recipe;

@end
