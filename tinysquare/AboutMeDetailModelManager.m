//
//  AboutMeDetailModelManager.m
//  tinysquare
//
//  Created by ling tsu hsuan on 3/23/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import "AboutMeDetailModelManager.h"
#import "TmpAboutMe.h"
#import "JSONKit.h"

@implementation AboutMeDetailModelManager

#pragma mark - 
#pragma mark define

#define ITEM_NAME       @"name"
#define ITEM_IMAGES     @"images"
#define ITEM_PRICE      @"price"
#define ITEM_SUMMARY    @"summary"
#define ITEM_WEB_URL    @"url"
#define ITEM_TEL        @"tel"
#define ITEM_EMAIL      @"email"

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
        request.entity = [NSEntityDescription entityForName:@"TmpAboutMe" inManagedObjectContext:managedObjectContext];
        
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
        
        TmpAboutMe *a = (TmpAboutMe *)obj;
        NSMutableArray *array = [NSMutableArray array];
        
        // getting images
        NSArray *images = [TmpAboutMe getAboutMeImagesWithSize:TmpAboutMeImageSize600 imageJson:a.imagesJson];
        
        // title and image
        [array addObject:[self createAboutMeTitleModel:a.companyName images:images summary:a.summary]];
        
        
        // company description
        if([a.fullDescription length])
            [array addObject:[self createAboutMeDetailDesc:a.fullDescription]];
        
        // address
        if([a.address length])
            [array addObject:[self createAddressModel:a.companyName address:a.address lat:[NSNumber numberWithInt:0] lon:[NSNumber numberWithInt:0]]];
        
        // url
        if([a.webUrl length])
            [array addObject:[self createWebUrlModel:a.webUrl]];
        
        // email
        if([a.email length])
            [array addObject:[self createEmailModel:a.email]];
        
        // telephone
        if([a.telephone length])
            [array addObject:[self createTelephoneModel:a.telephone]];
        
        // remark
        [array addObject:[self createRemarkModel:NSLocalizedString(@"本應用軟體為指尖創意股份有限公司製作", nil)]];
        
        
        
        
        // ---- detail info -----
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:a.companyName   forKey:ITEM_NAME];
        [info setObject:images          forKey:ITEM_IMAGES];
        [info setObject:a.summary       forKey:ITEM_SUMMARY];
        [info setObject:a.webUrl        forKey:ITEM_WEB_URL];
        [info setObject:a.telephone     forKey:ITEM_TEL];
        [info setObject:a.email         forKey:ITEM_EMAIL];
        self.detailInfo = info;
        // -------------------
        
        self.cellList = array;
        
        [self performSelectorOnMainThread:@selector(reportCreateFinished) withObject:nil 
                            waitUntilDone:[NSThread isMainThread]];
    });
}

@end
