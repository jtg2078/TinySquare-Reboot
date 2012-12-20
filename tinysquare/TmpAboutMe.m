//
//  TmpAboutMe.m
//  tinysquare
//
//  Created by ling tsu hsuan on 3/20/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "TmpAboutMe.h"
#import "JSONKit.h"
#import "DictionaryHelper.h"

@implementation TmpAboutMe

@dynamic id;
@dynamic companyId;
@dynamic address;
@dynamic fullDescription;
@dynamic companyName;
@dynamic summary;
@dynamic telephone;
@dynamic webUrl;
@dynamic imageIdentifier;
@dynamic updateGeneration;
@dynamic imagesJson;
@dynamic email;
@dynamic facebook;
@dynamic lat;
@dynamic lon;

+ (TmpAboutMe *)getAboutMeIfExistInManagedObjectContext:(NSManagedObjectContext *)context
{
    TmpAboutMe *aboutMe = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpAboutMe" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"id = %d", 0];
	
	NSError *error = nil;
	aboutMe = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !aboutMe)
		return nil;
	
	return aboutMe;
}

+ (TmpAboutMe *)getOrCreateAboutMeInManagedObjectContext:(NSManagedObjectContext *)context
{
    TmpAboutMe *aboutMe = [TmpAboutMe getAboutMeIfExistInManagedObjectContext:context];
    
    if (!aboutMe) {
		aboutMe = [NSEntityDescription insertNewObjectForEntityForName:@"TmpAboutMe" inManagedObjectContext:context];
        aboutMe.id = [NSNumber numberWithInt:0];
	}
	return aboutMe;
}

+ (void)deleteAboutMeIfExistInManagedObjectContext:(NSManagedObjectContext *)context
{
    TmpAboutMe *aboutMe = [TmpAboutMe getAboutMeIfExistInManagedObjectContext:context];
	
	if(aboutMe)
		[context deleteObject:aboutMe];
}

+ (NSArray *)getAboutMeImagesWithSize:(TmpAboutMeImageSize)imageSize imageJson:(NSString *)aString
{
    id imagesObj = [aString objectFromJSONString];
    NSArray *array = nil;
    NSMutableArray *images = [NSMutableArray array];
    
    if([imagesObj isKindOfClass:[NSDictionary class]])
    {
        array = [NSArray arrayWithObject:imagesObj];
    }
    
    if([imagesObj isKindOfClass:[NSArray class]])
    {
        array = (NSArray *)imagesObj;
    }
    
    if(array)
    {
        NSString *sizeKey = @"";
        
        switch (imageSize) {
            case TmpAboutMeImageSize100:
                sizeKey = @"size100";
                break;
            case TmpAboutMeImageSize200:
                sizeKey = @"size200";
                break;
            case TmpAboutMeImageSize300:
                sizeKey = @"size300";
                break;
            case TmpAboutMeImageSize600:
                sizeKey = @"size600";
                break;
            default:
                break;
        }
        
        NSSortDescriptor *orderDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES];
        NSArray *sortedArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:orderDescriptor]];
        [sortedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *imageInfo = (NSDictionary *)obj;
            [images addObject:[imageInfo stringForKey:sizeKey]];
        }];
    }
    return images;
}

+ (NSString *)getFirstAboutMeImageWithSize:(TmpAboutMeImageSize)imageSize imageJson:(NSString *)aString
{
    NSString *firstImagePath = @"";
    
    for(NSString *imagePath in [TmpAboutMe getAboutMeImagesWithSize:imageSize imageJson:aString])
    {
        firstImagePath = imagePath;
        break;
    }
    return firstImagePath;
}

@end
