//
//  Item.h
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemImage;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * availableTime;
@property (nonatomic, retain) NSDate * availableTimeEnd;
@property (nonatomic, retain) NSDate * availableTimeStart;
@property (nonatomic, retain) NSNumber * hasAd;
@property (nonatomic, retain) NSNumber * hasLocation;
@property (nonatomic, retain) NSNumber * isBookmarked;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * itemPrice;
@property (nonatomic, retain) NSNumber * itemType;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSNumber * region;
@property (nonatomic, retain) NSString * shortText;
@property (nonatomic, retain) NSSet *itemImages;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addItemImagesObject:(ItemImage *)value;
- (void)removeItemImagesObject:(ItemImage *)value;
- (void)addItemImages:(NSSet *)values;
- (void)removeItemImages:(NSSet *)values;
@end
