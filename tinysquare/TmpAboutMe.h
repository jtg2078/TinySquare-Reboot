//
//  TmpAboutMe.h
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
	TmpAboutMeImageSize100,
    TmpAboutMeImageSize200,
    TmpAboutMeImageSize300,
    TmpAboutMeImageSize600,
} TmpAboutMeImageSize;


@interface TmpAboutMe : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * companyId;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * fullDescription;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * webUrl;
@property (nonatomic, retain) NSString * imageIdentifier;
@property (nonatomic, retain) NSNumber * updateGeneration;
@property (nonatomic, retain) NSString * imagesJson;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebook;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;

+ (TmpAboutMe *)getAboutMeIfExistInManagedObjectContext:(NSManagedObjectContext *)context;
+ (TmpAboutMe *)getOrCreateAboutMeInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAboutMeIfExistInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getAboutMeImagesWithSize:(TmpAboutMeImageSize)imageSize imageJson:(NSString *)aString;
+ (NSString *)getFirstAboutMeImageWithSize:(TmpAboutMeImageSize)imageSize imageJson:(NSString *)aString;

@end
