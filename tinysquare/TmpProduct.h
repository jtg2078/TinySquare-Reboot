//
//  TmpProduct.h
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
	TmpProductAdImageSize100,
    TmpProductAdImageSize200,
    TmpProductAdImageSize300,
    TmpProductAdImageSize600,
} TmpProductAdImageSize;

typedef enum {
	TmpProductImageSize100,
    TmpProductImageSize200,
    TmpProductImageSize300,
    TmpProductImageSize600,
} TmpProductImageSize;


@interface TmpProduct : NSManagedObject

@property (nonatomic, retain) NSDate * beginDate;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * categorySort;
@property (nonatomic, retain) NSString * customAttribute;
@property (nonatomic, retain) NSString * customTags;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSNumber * durationStatus;
@property (nonatomic, retain) NSString * durationString;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * fullDescription;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isNew;
@property (nonatomic, retain) NSNumber * isOnSale;
@property (nonatomic, retain) NSDate * lastModifiedTime;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSString * promoMsg;
@property (nonatomic, retain) NSNumber * salePrice;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * webUrl;
@property (nonatomic, retain) NSString * imageIdentifier;
@property (nonatomic, retain) NSNumber * updateGeneration;
@property (nonatomic, retain) NSString * imagesJson;

+ (TmpProduct *)getProductIfExistWithProductId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (TmpProduct *)getOrCreateProductWithProductId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteProductIfExistWithProductId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteExpiredProductIfAny:(NSManagedObjectContext *)context;
+ (NSArray *)getTagNameArrayFromTagString:(NSString *)aString;
+ (NSString *)getLastTagFromTagString:(NSString *)aString;
+ (NSString *)getAdImagePathWithSize:(TmpProductAdImageSize) imageSize adImageJson:(NSString *)aString;
+ (NSArray *)getProductImagesWithSize:(TmpProductImageSize) imageSize imageJson:(NSString *)aString;
+ (NSString *)getFirstProductImageWithSize:(TmpProductImageSize) imageSize imageJson:(NSString *)aString;

@end
