//
//  SavedProductDetailModelManager.m
//  tinysquare
//
//  Created by ling tsu hsuan on 3/25/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "SavedProductDetailModelManager.h"
#import "TmpSavedProduct.h"
#import "JSONKit.h"

@implementation SavedProductDetailModelManager

#pragma mark - 
#pragma mark define

#define ITEM_NAME       @"name"
#define ITEM_IMAGES     @"images"
#define ITEM_PRICE      @"price"
#define ITEM_SUMMARY    @"summary"
#define ITEM_WEB_URL    @"url"
#define ITEM_TEL        @"tel"

- (void)createDetailCellList
{
    [super createDetailCellList];
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(createDetailCellListStarted:)]) 
	{
		[self.delegate performSelector:@selector(createDetailCellListStarted:) withObject:self];
	}
	
	NSPersistentStoreCoordinator *persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator;
	dispatch_async(backgroundQueue, ^(void) {
        NSManagedObjectContext *managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"TmpSavedProduct" inManagedObjectContext:managedObjectContext];
        request.predicate = [NSPredicate predicateWithFormat:@"productId = %d", itemId];
        
        NSError *err = nil;
        id obj = [[managedObjectContext executeFetchRequest:request error:&err] lastObject];
        [request release];
        
        if (!err && !obj)
        {
            self.error = err;
            [self performSelectorOnMainThread:@selector(reportCreateFailed) withObject:nil 
                                waitUntilDone:[NSThread isMainThread]];
            return;
        }
        
        TmpSavedProduct *p = (TmpSavedProduct *)obj;
        NSMutableArray *array = [NSMutableArray array];
        
        // getting images
        NSArray *images = [TmpSavedProduct getProductImagesWithSize:TmpSavedProductImageSize600 
                                                     imageJson:p.imagesJson];
        
        // title and image
        [array addObject:[self createCellTypeTitleAndImagesEnhancedModel:p.productName 
                                                                  images:images 
                                                                     url:p.webUrl 
                                                                   phone:p.telephone 
                                                                   price:p.price 
                                                               salePrice:p.salePrice]];
        
        // summary
        [array addObject:[self createSummaryModel:p.summary]];
        
        // product avaiable time
        [array addObject:[self createAvailableModel:p.durationString]];
        
        // app promotion
        if([p.promoMsg length])
            [array addObject:[self createAppPromoModel:p.promoMsg]];
        
        // product description
        if([p.fullDescription length])
            [array addObject:[self createProductDescModel:p.fullDescription]];
        
        // tags
        NSArray *tags = [TmpSavedProduct getTagNameArrayFromTagString:p.customTags];
        if([tags count])
            [array addObject:[self createCustomTagModel:tags]];
        
        // custom attributes
        [[p.customAttribute objectFromJSONString] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *title = (NSString *)key;
            NSString *content = (NSString *)obj;
            if([title length] && [content length])
                [array addObject:[self createCustomAttributeModel:[NSString stringWithFormat:@"%@:", title] contentText:content]];
        }];
        
        // ---- detail info -----
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:p.productName   forKey:ITEM_NAME];
        [info setObject:images          forKey:ITEM_IMAGES];
        [info setObject:p.price         forKey:ITEM_PRICE];
        [info setObject:p.summary       forKey:ITEM_SUMMARY];
        [info setObject:p.webUrl        forKey:ITEM_WEB_URL];
        [info setObject:p.telephone     forKey:ITEM_TEL];
        self.detailInfo = info;
        // -------------------
        
        self.cellList = array;
        
        [self performSelectorOnMainThread:@selector(reportCreateFinished) withObject:nil 
                            waitUntilDone:[NSThread isMainThread]];
    });
}

@end
