//
//  TmpLocation.h
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
	TmpLocationImageSize100,
    TmpLocationImageSize200,
    TmpLocationImageSize300,
    TmpLocationImageSize600,
} TmpLocationImageSize;


@interface TmpLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * fullDescription;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSString * storeName;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSNumber * regionId;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSNumber * storeType;
@property (nonatomic, retain) NSString * webUrl;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * imageIdentifier;
@property (nonatomic, retain) NSNumber * updateGeneration;
@property (nonatomic, retain) NSString * imagesJson;

+ (TmpLocation *)getLocationIfExistWithLocationId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (TmpLocation *)getOrCreateLocationWithLocationId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteLocationIfExistWithLocationId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getLocationImagesWithSize:(TmpLocationImageSize)imageSize imageJson:(NSString *)aString;
+ (NSString *)getFirstLocationImageWithSize:(TmpLocationImageSize)imageSize imageJson:(NSString *)aString;

@end
