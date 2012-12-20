//
//  Product.h
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ProductItem;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * appPromotionMessage;
@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSString * mapDescription;
@property (nonatomic, retain) NSString * mapStatus;
@property (nonatomic, retain) NSString * pinColor;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * webUrl;
@property (nonatomic, retain) NSNumber * hasExpiration;
@property (nonatomic, retain) ProductItem *productItem;

// newly added for new backend
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSString * extension;
@property (nonatomic, retain) NSNumber * salePrice;
@property (nonatomic, retain) NSNumber * isNew;
@property (nonatomic, retain) NSNumber * isSale;
@property (nonatomic, retain) NSString * tag;




+ (Product *)getProductIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Product *)getOrCreateProductWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteProductIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteExpiredProductIfAny:(NSManagedObjectContext *)context;
@end
