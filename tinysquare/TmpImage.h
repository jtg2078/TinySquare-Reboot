//
//  TmpImages.h
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TmpImage : NSManagedObject

@property (nonatomic, retain) NSNumber * ownerId;
@property (nonatomic, retain) NSNumber * imageId;
@property (nonatomic, retain) NSNumber * imageType;
@property (nonatomic, retain) NSNumber * sourceType;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSString * size100;
@property (nonatomic, retain) NSString * size200;
@property (nonatomic, retain) NSString * size300;
@property (nonatomic, retain) NSString * size600;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * updateGeneration;

+ (TmpImage *)getImageIfExistWithIdentifier:(NSString *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (TmpImage *)getOrCreateImageWithIdentifier:(NSString *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (TmpImage *)getImageIfExistWithOwnerId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (TmpImage *)getOrCreateImageWithOwnerId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteImageIfExistWithIdentifier:(NSString *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getImagesWithOwnerId:(NSNumber *)anId imageType:(NSNumber *)aType inManagedObjectContext:(NSManagedObjectContext *)context;
@end
