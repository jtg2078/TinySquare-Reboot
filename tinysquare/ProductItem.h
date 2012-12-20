//
//  ProductItem.h
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Item.h"

@class Product;

@interface ProductItem : Item

@property (nonatomic, retain) Product *product;

@end
