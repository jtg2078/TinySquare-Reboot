//
//  AssociationItem.h
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Item.h"

@class Association;

@interface AssociationItem : Item

@property (nonatomic, retain) Association * association;

@end
