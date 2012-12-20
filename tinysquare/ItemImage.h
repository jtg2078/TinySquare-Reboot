//
//  ItemImage.h
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;
@interface ItemImage : NSManagedObject

@property (nonatomic, retain) NSString * imageHash;
@property (nonatomic, retain) NSNumber * imageId;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * imageType;
@property (nonatomic, retain) NSString * sourceInfo;
@property (nonatomic, retain) NSNumber * sourceType;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * small;
@property (nonatomic, retain) NSString * medium;
@property (nonatomic, retain) NSString * large;
@property (nonatomic, retain) Item *item;

+ (ItemImage *)getItemImageIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (ItemImage *)getOrCreateItemImageWithId:(NSNumber *)anId andItem:(Item *)anItem inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteItemImageIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;

@end
