//
//  DataManager.m
//  coredata04
//
//  Created by jason on 2011/8/25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "ProductItem.h"
#import "Product.h"
#import "LocationItem.h"
#import "Location.h"
#import "AssociationItem.h"
#import "Association.h"
#import "RecipeItem.h"
#import "Recipe.h"
#import "ItemImage.h"
#import "EggAppManager.h"
#import "MKInfoPanel.h"
#import "ImageManager.h"
#import "DictionaryHelper.h"
#import "JSONKit.h"
#import "EggApiManager.h"

#import "TmpHotProduct.h"
#import "TmpProduct.h"
#import "TmpSavedProduct.h"
#import "TmpCategory.h"
#import "TmpLocation.h"
#import "TmpAboutMe.h"
#import "TmpImage.h"

#import "Membership.h"
#import "LoginMember.h"
#import "TmpCart.h"

@implementation DataManager

#pragma mark -
#pragma mark define

#define UPDATE_ACTION_DELETE            @"D"
#define UPDATE_ACTION_UPDATE_OR_CREATE  @"U"

#define TIME_ALWAYS_AVAILABLE   @"0"
#define TIME_LIMITED_AVAILABLE  @"1"
#define TIME_NOT_AVAILABLE      @"2"

#define IMAGE_TYPE_ICON         100
#define IMAGE_TYPE_AD           200
#define IMAGE_TYPE_NORMAL       0

#define JSON_KEY_ITEM_ID                            @"eggid"
#define JSON_KEY_ITEM_NAME                          @"name"
#define JSON_KEY_ITEM_CATEGORY                      @"category"
#define JSON_KEY_ITEM_MODIFIED_TIME                 @"mtime"
#define JSON_KEY_ITEM_PHOTOS_ARRAY                  @"photos"
#define JSON_KEY_ITEM_SUMMARY                       @"summary"
#define JSON_KEY_ITEM_HAS_AD                        @"hasad"
#define JSON_KEY_ITEM_ADDRESS                       @"addr"
#define JSON_KEY_ITEM_REGION                        @"region"
#define JSON_KEY_ITEM_LONGITUDE                     @"lon"
#define JSON_KEY_ITEM_LATITUDE                      @"lat"
#define JSON_KEY_ITEM_MAP_DESCRIPTION               @"map_desc"
#define JSON_KEY_ITEM_MAP_STATUS                    @"map_status"
#define JSON_KEY_ITEM_PIN_COLOR                     @"pin_color"
#define JSON_KEY_ITEM_DIRECTION                     @"direction"
#define JSON_KEY_ITEM_DESCRIPTION                   @"desc"
#define JSON_KEY_ITEM_PRICE_IN_NUMBER               @"price"
#define JSON_KEY_ITEM_PRICE_IN_STRING               @"price_range"
#define JSON_KEY_ITEM_TELEPHONE                     @"tel"
#define JSON_KEY_ITEM_WEB_URL                       @"url"
#define JSON_KEY_ITEM_OPERATION_HOUR                @"op_hour"
#define JSON_KEY_ITEM_BRANCH                        @"branch"
#define JSON_KEY_ITEM_AVAILABLE_TIME_IN_STRING      @"av_time"
#define JSON_KEY_ITEM_AVAILABLE_TIME_START          @"av_time_begin"
#define JSON_KEY_ITEM_AVAILABLE_TIME_END            @"av_time_end"
#define JSON_KEY_ITEM_APP_PROMOTION                 @"pm_msg"

#define JSON_KEY_ITEM_PHOTO_ID                      @"photoid"
#define JSON_KEY_ITEM_PHOTO_FILE_NAME               @"filename"
#define JSON_KEY_ITEM_PHOTO_TYPE                    @"purpose"
#define JSON_KEY_ITEM_PHOTO_SOURCE                  @"source"
#define JSON_KEY_ITEM_PHOTO_LAST_MODIFIED           @"lastmodified"

#define JSON_KEY_ITEM_CATEGORY_ID                   @"categoryId"
#define JSON_KEY_ITEM_CATEGORY_NAME                 @"categoryName"
#define JSON_KEY_ITEM_DISPLAY_ORDER                 @"sort"
#define JSON_KEY_ITEM_EXTENSION                     @"extension"
#define JSON_KEY_ITEM_SALE_PRICE                    @"salesPrice"
#define JSON_KEY_ITEM_IS_NEW                        @"isNew"
#define JSON_KEY_ITEM_IS_SALE                       @"isSales"
#define JSON_KEY_ITEM_AD_IMAGE                      @"hotImage"
#define JSON_KEY_ITEM_TAGS                          @"tags"

#define NEW_JSON_PRODUCT_ID                         @"productId"
#define NEW_JSON_PRODUCT_AVAILABLE_TIME_START       @"beginDate"
#define NEW_JSON_PRODUCT_CATEGORY_ID                @"categoryId"
#define NEW_JSON_PRODUCT_CATEGORY_NAME              @"categoryName"
#define NEW_JSON_PRODUCT_CATEGORY_SORT             @"categorySort"
#define NEW_JSON_PRODUCT_DESCRIPTION                @"description"
#define NEW_JSON_PRODUCT_AVAILABLE_TIME_END         @"endDate"
#define NEW_JSON_PRODUCT_EXTENSION                  @"extension"
#define NEW_JSON_PRODUCT_AD_IMAGE                   @"hotImage"
#define NEW_JSON_PRODUCT_IMAGES                     @"images"
#define NEW_JSON_PRODUCT_TAG_IS_NEW                 @"isNew"
#define NEW_JSON_PRODUCT_TAG_IS_SALE                @"isSales"
#define NEW_JSON_PRODUCT_NAME                       @"name"
#define NEW_JSON_PRODUCT_APP_PROMOTION              @"pm_msg"
#define NEW_JSON_PRODUCT_PRICE                      @"price"
#define NEW_JSON_PRODUCT_SALE_PRICE                 @"salesPrice"
#define NEW_JSON_PRODUCT_DISPLAY_ORDER              @"sort"
#define NEW_JSON_PRODUCT_STATUS                     @"status"
#define NEW_JSON_PRODUCT_SUMMARY                    @"summary"
#define NEW_JSON_PRODUCT_TELEPHONE                  @"tel"
#define NEW_JSON_PRODUCT_WEB_URL                    @"url"
#define NEW_JSON_PRODUCT_MODIFIED_TIME              @"mtime"
#define NEW_JSON_PRODUCT_IMAGE_ID                   @"imageId"
#define NEW_JSON_PRODUCT_IMAGE_DISPLAY_ORDDER       @"sort"
#define NEW_JSON_PRODUCT_CUSTOM_TAGS                @"tags"

#define NEW_JSON_CATEGORY_ID                        @"id"
#define NEW_JSON_CATEGORY_COUNT                     @"count"
#define NEW_JSON_CATEGORY_NAME                      @"name"
#define NEW_JSON_CATEGORY_DISPLAY_ORDER             @"sort"

#define NEW_JSON_LOCATION_ADDRESS                   @"adress"
#define NEW_JSON_LOCATION_DESCRIPTION               @"description"
#define NEW_JSON_LOCATION_ID                        @"id"
#define NEW_JSON_LOCATION_LATITUDE                  @"lat"
#define NEW_JSON_LOCATION_LONGITUDE                 @"lon"
#define NEW_JSON_LOCATION_NAME                      @"locationName"
#define NEW_JSON_LOCATION_STORE_NAME                @"name"
#define NEW_JSON_LOCATION_REGION                    @"region"
#define NEW_JSON_LOCATION_TELEPHONE                 @"tel"
#define NEW_JSON_LOCATION_STORE_TYPE                @"type"
#define NEW_JSON_LOCATION_WEB_URL                   @"url"
#define NEW_JSON_LOCATION_ZIP_CODE                  @"zip"
#define NEW_JSON_LOCATION_IMAGES                    @"image"

#define NEW_JSON_ABOUT_ME_ADDRESS                   @"address"
#define NEW_JSON_ABOUT_ME_DESCRIPTION               @"description"
#define NEW_JSON_ABOUT_ME_ID                        @"id"
#define NEW_JSON_ABOUT_ME_IMAGES                    @"image"
#define NEW_JSON_ABOUT_ME_NAME                      @"name"
#define NEW_JSON_ABOUT_ME_SUMMARY                   @"summary"
#define NEW_JSON_ABOUT_ME_TELEPHONE                 @"tel"
#define NEW_JSON_ABOUT_ME_WEB_URL                   @"url"
#define NEW_JSON_ABOUT_ME_EMAIL                     @"email"
#define NEW_JSON_ABOUT_ME_FACEBOOK                  @"facebook"
#define NEW_JSON_ABOUT_ME_LATITUDE                  @"lat"
#define NEW_JSON_ABOUT_ME_LONGITUDE                 @"lon"

#define NEW_JSON_IMAGE_ID                           @"imageId"
#define NEW_JSON_IMAGE_DISPLAY_ORDER                @"sort"
#define NEW_JSON_IMAGE_SIZE_TYPE_SIZE_100           @"size100"
#define NEW_JSON_IMAGE_SIZE_TYPE_SIZE_200           @"size200"
#define NEW_JSON_IMAGE_SIZE_TYPE_SIZE_300           @"size300"
#define NEW_JSON_IMAGE_SIZE_TYPE_SIZE_600           @"size600"
#define NEW_JSON_IMAGE_SOURCE_GET                   1
#define NEW_JSON_IMAGE_SOURCE_POST                  2
#define NEW_JSON_IMAGE_SOURCE_S3                    3

#define NEW_JSON_PRODUCT_DURATION_ALWAYS            1
#define NEW_JSON_PRODUCT_DURATION_LIMITED           2
#define NEW_JSON_PRODUCT_DURATION_UNAVAILABLE       3

#define NEW_JSON_IMAGE_TYPE_PHOTO                   0
#define NEW_JSON_IMAGE_TYPE_AD                      1
                  

#define HOT_PRODUCT_IMAGE_ID_PREFIX                 @"HP"
#define HOT_PRODUCT_AD_IMAGE_ID_PREFIX              @"HPAD"
#define PRODUCT_IMAGE_ID_PREFIX                     @"P"
#define LOCATION_IMAGE_ID_PREFIX                    @"L"
#define ABOUTME_IMAGE_ID_PREFIX                     @"A"

#define CATEGORY_ID_FOR_ALL_CATEGORIES              -100


#pragma mark-
#pragma mark synthesize

@synthesize regionNameList;


#pragma mark -
#pragma mark memory management

- (void)dealloc 
{
	[f release];
    [regionNameList release];
    
	[super dealloc];
}


#pragma mark -
#pragma mark initialization

- (id)initWithMoc:(NSManagedObjectContext *)anMoc 
{
	if(self = [super init]){
		moc = anMoc;
		f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
	}else {
		self = nil;
	}
	return self;
}


#pragma mark - 
#pragma mark instance methods

+ (void)saveHotProductWithProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view
{
    BOOL addResult = YES;
	Item *item = nil;
	
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpHotProduct" inManagedObjectContext:managedObjectContext];
	request.predicate = [NSPredicate predicateWithFormat:@"productId = %d", [productId intValue]];
	
	NSError *error = nil;
	item = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !item)
	{
		addResult = NO;
		[MKInfoPanel showPanelInView:view
								type:MKInfoPanelTypeError
							   title:NSLocalizedString(@"無法加入收藏", nil) 
							subtitle:[error localizedDescription] 
						   hideAfter:3];
	}
	else
	{
        TmpHotProduct *from = (TmpHotProduct *)item;
        TmpSavedProduct *to = [TmpSavedProduct getOrCreateProductWithProductId:from.productId inManagedObjectContext:managedObjectContext];
        
        to.beginDate =          from.beginDate;
        to.categoryId =         from.categoryId;
        to.categoryName =       from.categoryName;
        to.customAttribute =    from.customAttribute;
        to.customTags =         from.customTags;
        to.displayOrder =       from.displayOrder;
        to.durationStatus =     from.durationStatus;
        to.durationString =     from.durationString;
        to.endDate =            from.endDate;
        to.fullDescription =    from.fullDescription;
        to.id =                 from.id;
        to.isNew =              from.isNew;
        to.isOnSale =           from.isOnSale;
        to.lastModifiedTime =   from.lastModifiedTime;
        to.price =              from.price;
        to.productName =        from.productName;
        to.productId =          from.productId;
        to.promoMsg =           from.promoMsg;
        to.salePrice =          from.salePrice;
        to.summary =            from.summary;
        to.telephone =          from.telephone;
        to.webUrl =             from.webUrl;
        to.savedDate =          [NSDate date];
        to.imageIdentifier =    from.imageIdentifier;
        to.imagesJson =         from.imagesJson;
        
		error = nil;
        if (![managedObjectContext save:&error]) {
            addResult = NO;
            [MKInfoPanel showPanelInView:view
                                    type:MKInfoPanelTypeError
                                   title:NSLocalizedString(@"無法加入收藏", nil) 
                                subtitle:[error localizedDescription] 
                               hideAfter:3];
        }
	}
    
	if(view != nil)
	{
		if(addResult == YES)
		{
			[MKInfoPanel showPanelInView:view 
									type:MKInfoPanelTypeInfo 
								   title:NSLocalizedString(@"已加入收藏", nil)
								subtitle:nil 
							   hideAfter:1];
		}
		else
		{
			[MKInfoPanel showPanelInView:view
									type:MKInfoPanelTypeError
								   title:NSLocalizedString(@"無法加入收藏", nil) 
								subtitle:nil 
							   hideAfter:3];
		}
	}
}

+ (void)saveProductWithProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view
{
	BOOL addResult = YES;
	Item *item = nil;
	
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpProduct" inManagedObjectContext:managedObjectContext];
	request.predicate = [NSPredicate predicateWithFormat:@"productId = %d", [productId intValue]];
	
	NSError *error = nil;
	item = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !item)
	{
		addResult = NO;
		[MKInfoPanel showPanelInView:view
								type:MKInfoPanelTypeError
							   title:NSLocalizedString(@"無法加入收藏", nil) 
							subtitle:[error localizedDescription] 
						   hideAfter:3];
	}
	else
	{
        TmpProduct *from = (TmpProduct *)item;
        TmpSavedProduct *to = [TmpSavedProduct getOrCreateProductWithProductId:from.productId inManagedObjectContext:managedObjectContext];
        
        to.beginDate =          from.beginDate;
        to.categoryId =         from.categoryId;
        to.categoryName =       from.categoryName;
        to.customAttribute =    from.customAttribute;
        to.customTags =         from.customTags;
        to.displayOrder =       from.displayOrder;
        to.durationStatus =     from.durationStatus;
        to.durationString =     from.durationString;
        to.endDate =            from.endDate;
        to.fullDescription =    from.fullDescription;
        to.id =                 from.id;
        to.isNew =              from.isNew;
        to.isOnSale =           from.isOnSale;
        to.lastModifiedTime =   from.lastModifiedTime;
        to.price =              from.price;
        to.productName =        from.productName;
        to.productId =          from.productId;
        to.promoMsg =           from.promoMsg;
        to.salePrice =          from.salePrice;
        to.summary =            from.summary;
        to.telephone =          from.telephone;
        to.webUrl =             from.webUrl;
        to.savedDate =          [NSDate date];
        to.imageIdentifier =    from.imageIdentifier;
        to.imagesJson =         from.imagesJson;
        
		error = nil;
        if (![managedObjectContext save:&error]) {
            addResult = NO;
            [MKInfoPanel showPanelInView:view
                                    type:MKInfoPanelTypeError
                                   title:NSLocalizedString(@"無法加入收藏", nil) 
                                subtitle:[error localizedDescription] 
                               hideAfter:3];
        }
	}
    
	if(view != nil)
	{
		if(addResult == YES)
		{
			[MKInfoPanel showPanelInView:view 
									type:MKInfoPanelTypeInfo 
								   title:NSLocalizedString(@"已加入收藏", nil)
								subtitle:nil 
							   hideAfter:1];
		}
		else
		{
			[MKInfoPanel showPanelInView:view
									type:MKInfoPanelTypeError
								   title:NSLocalizedString(@"無法加入收藏", nil) 
								subtitle:nil 
							   hideAfter:3];
		}
	}
}

+ (void)removeProductWithProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view
{
	[TmpSavedProduct deleteProductIfExistWithProductId:productId inManagedObjectContext:managedObjectContext];
	
	NSError *error = nil;
	if (![managedObjectContext save:&error]) {
		[MKInfoPanel showPanelInView:view
								type:MKInfoPanelTypeError
							   title:NSLocalizedString(@"無法移除收藏", nil) 
							subtitle:[error localizedDescription] 
						   hideAfter:3];
	}
}


//******** new method

+ (void)saveProductToCartProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view
{
	
    //NSLog(@"%@",productId);
    BOOL addResult = YES;
	Item *item = nil;
	
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TmpProduct" inManagedObjectContext:managedObjectContext];
	request.predicate = [NSPredicate predicateWithFormat:@"productId = %d", [productId intValue]];
	
	NSError *error = nil;
	item = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !item)
	{
		addResult = NO;
		[MKInfoPanel showPanelInView:view
								type:MKInfoPanelTypeError
							   title:NSLocalizedString(@"無法開啟購物車", nil) 
							subtitle:[error localizedDescription] 
						   hideAfter:3];
	}
	else
	{
        TmpProduct *from = (TmpProduct *)item;
        TmpCart *to = [TmpCart getOrCreateProductWithProductId:from.productId inManagedObjectContext:managedObjectContext];
        
        to.beginDate =          from.beginDate;
        to.categoryId =         from.categoryId;
        to.categoryName =       from.categoryName;
        to.customAttribute =    from.customAttribute;
        to.customTags =         from.customTags;
        to.displayOrder =       from.displayOrder;
        to.durationStatus =     from.durationStatus;
        to.durationString =     from.durationString;
        to.endDate =            from.endDate;
        to.fullDescription =    from.fullDescription;
        to.id =                 from.id;
        to.isNew =              from.isNew;
        to.isOnSale =           from.isOnSale;
        to.lastModifiedTime =   from.lastModifiedTime;
        to.price =              from.price;
        to.productName =        from.productName;
        to.productId =          from.productId;
        to.promoMsg =           from.promoMsg;
        to.salePrice =          from.salePrice;
        to.summary =            from.summary;
        to.telephone =          from.telephone;
        to.webUrl =             from.webUrl;
        to.savedDate =          [NSDate date];
        to.imageIdentifier =    from.imageIdentifier;
        to.imagesJson =         from.imagesJson;
        
		error = nil;
        if (![managedObjectContext save:&error]) {
            addResult = NO;
            [MKInfoPanel showPanelInView:view
                                    type:MKInfoPanelTypeError
                                   title:NSLocalizedString(@"無法開啟購物車", nil) 
                                subtitle:[error localizedDescription] 
                               hideAfter:3];
        }
	}
    
	if(view != nil)
	{
		if(addResult == YES)
		{
			[MKInfoPanel showPanelInView:view 
									type:MKInfoPanelTypeInfo 
								   title:NSLocalizedString(@"加入購物車", nil)
								subtitle:nil 
							   hideAfter:1];
		}
		else
		{
			[MKInfoPanel showPanelInView:view
									type:MKInfoPanelTypeError
								   title:NSLocalizedString(@"無法開啟購物車", nil) 
								subtitle:nil 
							   hideAfter:3];
		}
	}
}

+ (void)removeProductFromCartWithProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view
{
	[TmpCart deleteProductIfExistWithProductId:productId inManagedObjectContext:managedObjectContext];
	
	NSError *error = nil;
	if (![managedObjectContext save:&error]) {
		[MKInfoPanel showPanelInView:view
								type:MKInfoPanelTypeError
							   title:NSLocalizedString(@"無法移除項目", nil) 
							subtitle:[error localizedDescription] 
						   hideAfter:3];
	}
}


#pragma mark -
#pragma mark main methods

- (void)parseAndImportHotProducts:(NSArray *)toBeParsed
{
    int i = 0;
    int currentGeneration = [[EggApiManager sharedInstance] getHotProductUpdateGeneration];
    for(NSDictionary *item in toBeParsed)
    {
        [self importHotProduct:item identifier:i updateGeneration:currentGeneration];
        i++;
    }
    
    // remove any previous gen hot products
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:@"TmpHotProduct" inManagedObjectContext:moc];
	request.predicate = [NSPredicate predicateWithFormat:@"updateGeneration != %d", currentGeneration];
    
    NSError *error = nil;
    for(TmpHotProduct *invalidP in [moc executeFetchRequest:request error:&error])
    {
        [TmpHotProduct deleteProductIfExistWithId:invalidP.id inManagedObjectContext:moc];
    }
    
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportHotProducts]error while saving manangedObjectContext. Reason:%@",[error description]);
    }
}

- (void)parseAndImportProductWindowProducts:(NSArray *)toBeParsed
{
    int i = 0;
    int currentGeneration = [[EggApiManager sharedInstance] getProductWindowUpdateGeneration];
    for(NSDictionary *item in toBeParsed)
    {
        [self importProduct:item identifier:i updateGeneration:currentGeneration];
        i++;
    }
    
    // remove any previous gen product window products
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:@"TmpProduct" inManagedObjectContext:moc];
	request.predicate = [NSPredicate predicateWithFormat:@"updateGeneration != %d", currentGeneration];
    
    NSError *error = nil;
    for(TmpProduct *invalidP in [moc executeFetchRequest:request error:&error])
    {
        [TmpProduct deleteProductIfExistWithProductId:invalidP.productId inManagedObjectContext:moc];
    }
    
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportProductWindowProducts]error while saving manangedObjectContext. Reason:%@", [error description]);
    }
}

- (void)parseAndImportProductsForCategory:(NSArray *)toBeParsed categoryId:(int)anId
{
    int i = 0;
    int currentGeneration = [[EggApiManager sharedInstance] getProductsForCategoryUpdateGeneration];
    for(NSDictionary *item in toBeParsed)
    {
        [self importProduct:item identifier:i updateGeneration:currentGeneration];
        i++;
    }
    
    // remove any previous gen products for given category
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:@"TmpProduct" inManagedObjectContext:moc];
	request.predicate = [NSPredicate predicateWithFormat:@"categoryId = %d AND updateGeneration != %d", anId, currentGeneration];
    
    NSError *error = nil;
    for(TmpProduct *invalidP in [moc executeFetchRequest:request error:&error])
    {
        [TmpProduct deleteProductIfExistWithProductId:invalidP.productId inManagedObjectContext:moc];
    }
    
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportProductsForCategory]error while saving manangedObjectContext. Reason:%@", [error description]);
    }
}

- (void)parseAndImportSingleProduct:(NSDictionary *)item
{
    int i = 0;
    [self importProduct:item identifier:i updateGeneration:-1];
    
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportSingleProduct]error while saving manangedObjectContext. Reason:%@", [error description]);
    }
}

- (void)parseAndImportCategories:(NSArray *)toBeParsed
{
    int i = 0;
    int currentGeneration = [[EggApiManager sharedInstance] getCategoriesUpdateGeneration];
    for(NSDictionary *item in toBeParsed)
    {
        [self importCategory:item identifier:i updateGeneration:currentGeneration];
        i++;
    }
    // ---- this is for manually adding a category for "show all categories" ----
    NSMutableDictionary *g = [NSMutableDictionary dictionary];
    [g setValue:[NSNumber numberWithInt:CATEGORY_ID_FOR_ALL_CATEGORIES]         forKey:NEW_JSON_CATEGORY_ID];
    [g setValue:[NSNumber numberWithInt:0]                                      forKey:NEW_JSON_CATEGORY_COUNT];
    [g setValue:NSLocalizedString(@"全部商品", nil)                              forKey:NEW_JSON_CATEGORY_NAME];
    [g setValue:[NSNumber numberWithInt:CATEGORY_ID_FOR_ALL_CATEGORIES]         forKey:NEW_JSON_CATEGORY_DISPLAY_ORDER];
    [self importCategory:g identifier:i updateGeneration:currentGeneration];
    // --------------------------------------------------------------------------
    
    // remove any previous gen catogories
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:@"TmpCategory" inManagedObjectContext:moc];
	request.predicate = [NSPredicate predicateWithFormat:@"updateGeneration != %d", currentGeneration];
    
    NSError *error = nil;
    for(TmpCategory *invalidC in [moc executeFetchRequest:request error:&error])
    {
        [TmpCategory deleteCategoryIfExistWithCategoryId:invalidC.categoryId inManagedObjectContext:moc];
    }
    
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportCategories]error while saving manangedObjectContext. Reason:%@", [error description]);
    }
}

- (void)parseAndImportSingleCategory:(NSDictionary *)item
{
    int i = 0;
    [self importCategory:item identifier:i updateGeneration:-1];
    
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportSingleProduct]error while saving manangedObjectContext. Reason:%@", [error description]);
    }
}

- (void)parseAndImportLocations:(NSArray *)toBeParsed
{
    int i = 0;
    int currentGeneration = [[EggApiManager sharedInstance] getLocationsUpdateGeneration];
    for(NSDictionary *item in toBeParsed)
    {
        [self importLocation:item identifier:i updateGeneration:currentGeneration];
        i++;
    }
    
    // remove any previous gen locations
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:@"TmpLocation" inManagedObjectContext:moc];
	request.predicate = [NSPredicate predicateWithFormat:@"updateGeneration != %d", currentGeneration];
    
    NSError *error = nil;
    for(TmpLocation *invalidL in [moc executeFetchRequest:request error:&error])
    {
        [TmpLocation deleteLocationIfExistWithLocationId:invalidL.locationId inManagedObjectContext:moc];
    }
    
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportLocations]error while saving manangedObjectContext. Reason:%@", [error description]);
    }
}

- (void)parseAndImportSingleLocation:(NSDictionary *)item
{
    int i = 0;
    [self importLocation:item identifier:i updateGeneration:-1];
    
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportSingleLocation]error while saving manangedObjectContext. Reason:%@", [error description]);
    }
}

- (void)parseAndImportAboutMe:(NSDictionary *)item
{
    int i = 0;
    [self importAboutMe:item identifier:i updateGeneration:0];
    
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportAboutMe]error while saving manangedObjectContext. Reason:%@", [error description]);
    }
}

-(void)parseAndImportFcid:(NSString *)fcid
{
    [self importFcid:fcid identifier:0 updateGeneration:0];
    
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportFcid]error while saving manangedObjectContext. Reason:%@", [error description]);
    }
}

- (void)parseAndImportRegister:(NSDictionary *)item
{
    [self importRegister:item identifier:0 updateGeneration:0];   
    
    NSError *error = nil;
      
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportRegister]error while saving manangedObjectContext. Reason:%@", [error description]);
     
    }
    
}


- (void)parseAndImportLoginWithHeader:(NSDictionary *)header item:(NSDictionary *)item
{
    [self importLoginWithHeader:header item:item identifier:0 updateGeneration:0];
    NSError *error = nil;
    
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportLogin]error while saving manangedObjectContext. Reason:%@", [error description]);
        
    }
    
}


-(void) parseAndImportBuyList:(NSDictionary *)item
{
    [self importBuyList:item identifier:0 updateGeneration:0];
    NSError *error = nil;
    
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportBuylist]error while saving manangedObjectContext. Reason:%@", [error description]);
        
    }
    
}

-(void)parseAndImportCheckBill:(NSDictionary *)item
{
    [self importCheckBill:item identifier:0 updateGeneration:0];
    NSError *error = nil;
    
    if (![moc save:&error]) {
        NSLog(@"[parseAndImportCheckBill]error while saving manangedObjectContext. Reason:%@", [error description]);
        
    }

}


- (void)parseAndImport:(NSArray *)toBeParsed 
{
    /*
    // update total item count stored in core data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:moc];
    
    //NSError *error = nil;
    NSUInteger entityCount = [moc countForFetchRequest:request error:&error];
    [request release];
    
    if(error == nil)
    {
        EggAppManager *appManager = [EggAppManager sharedInstance];
        [appManager updateInfoCoreDataItemCount:entityCount];
    }
     */
}


#pragma mark -
#pragma mark import to core data

- (void)importImagesForOwnerWithIdentifier:(NSString *)anId ownerId:(NSNumber *)ownerId images:(NSArray *)images imageType:(int)imageType
{
    for(NSDictionary *imageInfo in images)
	{
        TmpImage *image = nil;
        
        if(imageType == NEW_JSON_IMAGE_TYPE_PHOTO)
            image = [TmpImage getOrCreateImageWithOwnerId:ownerId inManagedObjectContext:moc];
        if(imageType == NEW_JSON_IMAGE_TYPE_AD)
            image = [TmpImage getOrCreateImageWithIdentifier:anId inManagedObjectContext:moc];
            
        image.ownerId = ownerId;
        image.identifier = anId;
        image.imageId = [imageInfo numberForKey:NEW_JSON_IMAGE_ID];
        image.imageType = [NSNumber numberWithInt:imageType];
        image.sourceType = [NSNumber numberWithInt:NEW_JSON_IMAGE_SOURCE_GET];
        image.displayOrder = [imageInfo numberForKey:NEW_JSON_IMAGE_DISPLAY_ORDER];
        image.size100 = [imageInfo stringForKey:NEW_JSON_IMAGE_SIZE_TYPE_SIZE_100];
        image.size200 = [imageInfo stringForKey:NEW_JSON_IMAGE_SIZE_TYPE_SIZE_200];
        image.size300 = [imageInfo stringForKey:NEW_JSON_IMAGE_SIZE_TYPE_SIZE_300];
        image.size600 = [imageInfo stringForKey:NEW_JSON_IMAGE_SIZE_TYPE_SIZE_600];
        image.updateGeneration = [NSNumber numberWithInt:0];
    }
}

- (void)importHotProduct:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;
{
    NSNumber *identifier = [NSNumber numberWithInt:anId];
    TmpHotProduct *p = [TmpHotProduct getOrCreateProductWithId:identifier inManagedObjectContext:moc];
    
    p.id =                  [NSNumber numberWithInt:anId];
    p.beginDate =           [item unixStampStringForKey:NEW_JSON_PRODUCT_AVAILABLE_TIME_START];
    p.categoryId =          [item numberForKey:NEW_JSON_PRODUCT_CATEGORY_ID];
    p.categoryName =        [item stringForKey:NEW_JSON_PRODUCT_CATEGORY_NAME];
    p.categorySort =        [item numberForKey:NEW_JSON_PRODUCT_CATEGORY_SORT];
    p.fullDescription =     [item stringForKey:NEW_JSON_PRODUCT_DESCRIPTION];
    p.endDate =             [item unixStampStringForKey:NEW_JSON_PRODUCT_AVAILABLE_TIME_END];
    p.customAttribute =     [item stringForKey:NEW_JSON_PRODUCT_EXTENSION];
    p.isNew =               [item boolForKey:NEW_JSON_PRODUCT_TAG_IS_NEW];
    p.isOnSale =            [item boolForKey:NEW_JSON_PRODUCT_TAG_IS_SALE];
    p.lastModifiedTime =    [item unixStampStringForKey:NEW_JSON_PRODUCT_MODIFIED_TIME];
    p.productName =         [item stringForKey:NEW_JSON_PRODUCT_NAME];
    p.productId =           [item numberForKey:NEW_JSON_PRODUCT_ID];
    p.promoMsg =            [item stringForKey:NEW_JSON_PRODUCT_APP_PROMOTION];
    p.price =               [item numberForKey:NEW_JSON_PRODUCT_PRICE];
    p.salePrice =           [item numberForKey:NEW_JSON_PRODUCT_SALE_PRICE];
    p.displayOrder =        [item numberForKey:NEW_JSON_PRODUCT_DISPLAY_ORDER];
    p.durationStatus =      [item numberForKey:NEW_JSON_PRODUCT_STATUS];
    p.summary =             [item stringForKey:NEW_JSON_PRODUCT_SUMMARY];
    p.customTags =          [[item arrayForKey:NEW_JSON_PRODUCT_CUSTOM_TAGS] JSONString];
    p.telephone =           [item stringForKey:NEW_JSON_PRODUCT_TELEPHONE];
    p.webUrl =              [item stringForKey:NEW_JSON_PRODUCT_WEB_URL];
    p.imageIdentifier =     [NSString stringWithFormat:@"%@_%d", HOT_PRODUCT_IMAGE_ID_PREFIX, [p.productId intValue]];
    p.adImageIdentifier =   [NSString stringWithFormat:@"%@_%d", HOT_PRODUCT_AD_IMAGE_ID_PREFIX, [p.id intValue]];
    p.durationString =      [self constructDurtaionString:[p.durationStatus intValue] beginDate:p.beginDate endDate:p.endDate];
    p.updateGeneration =    [NSNumber numberWithInt:genId];
    
    // import product images
    p.imagesJson =          [[item arrayForKey:NEW_JSON_PRODUCT_IMAGES] JSONString];
    
    // import ad image
    p.adImageJson =         [[item dictionaryForKey:NEW_JSON_PRODUCT_AD_IMAGE] JSONString];
}

- (void)importProduct:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId
{
    NSNumber *productId = [item numberForKey:NEW_JSON_PRODUCT_ID];
    TmpProduct *p = [TmpProduct getOrCreateProductWithProductId:productId inManagedObjectContext:moc]; 
    
    p.id =                  [NSNumber numberWithInt:anId];
    p.beginDate =           [item unixStampStringForKey:NEW_JSON_PRODUCT_AVAILABLE_TIME_START];
    p.categoryId =          [item numberForKey:NEW_JSON_PRODUCT_CATEGORY_ID];
    p.categoryName =        [item stringForKey:NEW_JSON_PRODUCT_CATEGORY_NAME];
    p.categorySort =        [item numberForKey:NEW_JSON_PRODUCT_CATEGORY_SORT];
    p.fullDescription =     [item stringForKey:NEW_JSON_PRODUCT_DESCRIPTION];
    p.endDate =             [item unixStampStringForKey:NEW_JSON_PRODUCT_AVAILABLE_TIME_END];
    p.customAttribute =     [item stringForKey:NEW_JSON_PRODUCT_EXTENSION];
    p.isNew =               [item boolForKey:NEW_JSON_PRODUCT_TAG_IS_NEW];
    p.isOnSale =            [item boolForKey:NEW_JSON_PRODUCT_TAG_IS_SALE];
    p.lastModifiedTime =    [item unixStampStringForKey:NEW_JSON_PRODUCT_MODIFIED_TIME];
    p.productName =         [item stringForKey:NEW_JSON_PRODUCT_NAME];
    p.productId =           [item numberForKey:NEW_JSON_PRODUCT_ID];
    p.promoMsg =            [item stringForKey:NEW_JSON_PRODUCT_APP_PROMOTION];
    p.price =               [item numberForKey:NEW_JSON_PRODUCT_PRICE];
    p.salePrice =           [item numberForKey:NEW_JSON_PRODUCT_SALE_PRICE];
    p.displayOrder =        [item numberForKey:NEW_JSON_PRODUCT_DISPLAY_ORDER];
    p.durationStatus =      [item numberForKey:NEW_JSON_PRODUCT_STATUS];
    p.summary =             [item stringForKey:NEW_JSON_PRODUCT_SUMMARY];
    p.customTags =          [[item arrayForKey:NEW_JSON_PRODUCT_CUSTOM_TAGS] JSONString];
    p.telephone =           [item stringForKey:NEW_JSON_PRODUCT_TELEPHONE];
    p.webUrl =              [item stringForKey:NEW_JSON_PRODUCT_WEB_URL];
    p.imageIdentifier =     [NSString stringWithFormat:@"%@_%d", HOT_PRODUCT_IMAGE_ID_PREFIX, [p.productId intValue]];
    p.updateGeneration =    [NSNumber numberWithInt:genId];
    p.durationString =      [self constructDurtaionString:[p.durationStatus intValue] beginDate:p.beginDate endDate:p.endDate];
    
    // special treatment for handling sort order
    p.categoryName = [NSString stringWithFormat:@"%d%@", [p.categorySort intValue], p.categoryName];
    
    // import images
    p.imagesJson =          [[item arrayForKey:NEW_JSON_PRODUCT_IMAGES] JSONString];
}

- (void)importCategory:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId
{
    NSNumber *categoryId = [item numberForKey:NEW_JSON_CATEGORY_ID];
    TmpCategory *c = [TmpCategory getOrCreateCategoryWithCategoryId:categoryId inManagedObjectContext:moc];
    
    c.id =                  [NSNumber numberWithInt:anId];
    c.categoryId =          [item numberForKey:NEW_JSON_CATEGORY_ID];
    c.count =               [item numberForKey:NEW_JSON_CATEGORY_COUNT];
    c.categoryName =        [item stringForKey:NEW_JSON_CATEGORY_NAME];
    c.displayOrder =        [item numberForKey:NEW_JSON_CATEGORY_DISPLAY_ORDER];
    c.updateGeneration =    [NSNumber numberWithInt:genId];
}

- (void)importLocation:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId
{
    NSNumber *locationId = [item numberForKey:NEW_JSON_LOCATION_ID];
    TmpLocation *l = [TmpLocation getOrCreateLocationWithLocationId:locationId inManagedObjectContext:moc];
    
    l.id =                  [NSNumber numberWithInt:anId];
    l.address =             [item stringForKey:NEW_JSON_LOCATION_ADDRESS];
    l.fullDescription =     [item stringForKey:NEW_JSON_LOCATION_DESCRIPTION];
    l.locationId =          [item numberForKey:NEW_JSON_LOCATION_ID];
    l.latitude =            [f numberFromString:[item stringForKey:NEW_JSON_LOCATION_LATITUDE]];
    l.longitude =           [f numberFromString:[item stringForKey:NEW_JSON_LOCATION_LONGITUDE]];
    l.locationName =        [item stringForKey:NEW_JSON_LOCATION_NAME];
    l.storeName =           [item stringForKey:NEW_JSON_LOCATION_STORE_NAME];
    l.region =              [item stringForKey:NEW_JSON_LOCATION_REGION];
    l.regionId =            [self regionToRegionIdMapper:l.region];
    l.telephone =           [item stringForKey:NEW_JSON_LOCATION_TELEPHONE];
    l.storeType =           [item numberForKey:NEW_JSON_LOCATION_STORE_TYPE];
    l.webUrl =              [item stringForKey:NEW_JSON_LOCATION_WEB_URL];
    l.zipCode =             [item stringForKey:NEW_JSON_LOCATION_ZIP_CODE];
    l.updateGeneration =    [NSNumber numberWithInt:genId];
    
    // import images
    l.imagesJson =          [[item arrayForKey:NEW_JSON_LOCATION_IMAGES] JSONString];
}

- (void)importAboutMe:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId
{
    TmpAboutMe *a = [TmpAboutMe getOrCreateAboutMeInManagedObjectContext:moc];
    
    a.id =                  [NSNumber numberWithInt:anId];
    a.companyId =           [item numberForKey:NEW_JSON_ABOUT_ME_ID];
    a.address =             [item stringForKey:NEW_JSON_ABOUT_ME_ADDRESS];
    a.fullDescription =     [item stringForKey:NEW_JSON_ABOUT_ME_DESCRIPTION];
    a.companyName =         [item stringForKey:NEW_JSON_ABOUT_ME_NAME];
    a.summary =             [item stringForKey:NEW_JSON_ABOUT_ME_SUMMARY];
    a.telephone =           [item stringForKey:NEW_JSON_ABOUT_ME_TELEPHONE];
    a.webUrl =              [item stringForKey:NEW_JSON_ABOUT_ME_WEB_URL];
    a.email =               [item stringForKey:NEW_JSON_ABOUT_ME_EMAIL];
    a.facebook =            [item stringForKey:NEW_JSON_ABOUT_ME_FACEBOOK];
    a.lat =                 [item numberForKey:NEW_JSON_ABOUT_ME_LATITUDE];
    a.lon =                 [item numberForKey:NEW_JSON_ABOUT_ME_LONGITUDE];
    a.updateGeneration =    [NSNumber numberWithInt:genId];
    
    // import images
    a.imagesJson =          [[item arrayForKey:NEW_JSON_ABOUT_ME_IMAGES] JSONString];
}


-(void)importFcid:(NSString *)fcid identifier:(int)anId  updateGeneration:(int)genId
{
    Membership *m=[Membership getOrCreateMemberInManagedObjectContext:moc];
    m.id=  [NSNumber numberWithInt:anId];
    m.fcid=[NSNumber numberWithInt:[fcid intValue]];
    //NSLog(@"here comes the fcid %@",m.fcid);
    
}


- (void)importRegister:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId
{
    Membership *m = [Membership getOrCreateMemberInManagedObjectContext:moc];
    
    m.id =                  [NSNumber numberWithInt:anId];
    m.column=               [item stringForKey:@"column"];
    m.message=              [item stringForKey:@"message"];
    m.status=               [item numberForKey:@"status"];    
}

-(void)importBuyList:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId
{
    LoginMember *lm=[LoginMember getMemberIfExistWithId:0 inManagedObjectContext:moc];
    lm.totalMoney=          [item numberForKey:@"total"];
    lm.buyCartStatus=       [item numberForKey:@"status"];
    lm.orderId=             [item numberForKey:@"orderid"];
    //NSLog(@"%@",lm.buyCartStatus);
}

-(void)importLoginWithHeader:(NSDictionary *)header item:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId
{
    LoginMember *lm = [LoginMember getOrCreateMemberInManagedObjectContext:moc];
    lm.cookie=             [header stringForKey:@"Set-Cookie"];
    lm.logincheck=         [NSNumber numberWithInt:1];
    lm.address=       [item stringForKey:@"address"];
    
    lm.birthday=      [item stringForKey:@"birthday"];
    lm.email=         [item stringForKey:@"email"];
    lm.fcid=          [item numberForKey:@"fcid"];
    lm.gender=        [item numberForKey:@"gender"];
    lm.name=          [item stringForKey:@"name"];
    lm.phone=         [item stringForKey:@"phone"];

    //NSLog(@"%@",lm.cookie);
}



-(void)importCheckBill:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId
{
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:moc];
    lm.payUrl=             [item stringForKey:@"payurl"];
    lm.buyCheckStatus=     [item numberForKey:@"status"];
    lm.payMessage=         [item stringForKey:@"message"];
}

#pragma mark -
#pragma mark delete from core data

- (void)deleteHotProduct:(int)anId;
{
    NSNumber *id = [NSNumber numberWithInt:anId];
    [TmpHotProduct deleteProductIfExistWithId:id inManagedObjectContext:moc];
}

- (void)deleteProduct:(int)anId
{
    NSNumber *id = [NSNumber numberWithInt:anId];
    [TmpProduct deleteProductIfExistWithProductId:id inManagedObjectContext:moc];
}

- (void)deleteCategory:(int)anId
{
    NSNumber *id = [NSNumber numberWithInt:anId];
    [TmpCategory deleteCategoryIfExistWithCategoryId:id inManagedObjectContext:moc];
}

- (void)deleteLocation:(int)anId
{
    NSNumber *id = [NSNumber numberWithInt:anId];
    [TmpLocation deleteLocationIfExistWithLocationId:id inManagedObjectContext:moc];
}

- (void)deleteAboutMe
{
    [TmpAboutMe deleteAboutMeIfExistInManagedObjectContext:moc];
}


#pragma mark -
#pragma mark misc

- (NSNumber *)imageTypeMapper:(NSString *)typeName
{
	if([typeName isEqualToString:@"ICON"])
		return [NSNumber numberWithInt:IMAGE_TYPE_ICON];
	else if([typeName isEqualToString:@"AD"])
		return [NSNumber numberWithInt:IMAGE_TYPE_AD];
	
	return [NSNumber numberWithInt:IMAGE_TYPE_NORMAL];
}

- (NSNumber *)imageSourceTypeMapper:(NSString *)typeName
{
	if([typeName isEqualToString:@"S3"])
		return [NSNumber numberWithInt:0];
	else if([typeName isEqualToString:@"GET"])
		return [NSNumber numberWithInt:1];
	else if([typeName isEqualToString:@"POST"])
		return [NSNumber numberWithInt:2];
	
	return [NSNumber numberWithInt:0];
}

- (NSString *)productStatusTypeMapper:(NSString *)statusValue
{
    if([statusValue isEqualToString:@"1"])
        return @"0";
    else if([statusValue isEqualToString:@"2"])
        return @"1";
    else if([statusValue isEqualToString:@"3"])
        return @"2";
    
    return @"0";
}

- (NSString *)constructDurtaionString:(int)durationStatus beginDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSString *durationString = NSLocalizedString(@"請來電確認", nil);
    
    if(durationStatus == NEW_JSON_PRODUCT_DURATION_ALWAYS)
    {
        durationString = NSLocalizedString(@"現貨供應中", nil);
    }
    
    if(durationStatus == NEW_JSON_PRODUCT_DURATION_LIMITED)
    {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        NSString *start = [dateFormatter stringFromDate:startDate];
        NSString *end = [dateFormatter stringFromDate:endDate];
        
        durationString = [NSString stringWithFormat:@"%@ ~ %@", start, end];
    }
    
    if(durationStatus == NEW_JSON_PRODUCT_DURATION_UNAVAILABLE)
    {
        durationString = NSLocalizedString(@"已下架", nil);
    }
    
    return durationString;
}

- (NSNumber *)regionToRegionIdMapper:(NSString *)region
{
    if(self.regionNameList == nil)
    {
        self.regionNameList = [NSArray arrayWithObjects: @"基隆市",
                               @"台北市",
                               @"新北市",
                               @"桃園縣",
                               @"新竹市",
                               @"新竹縣",
                               @"苗栗縣",
                               @"台中市",
                               @"彰化縣",
                               @"南投縣",
                               @"雲林縣",
                               @"嘉義市",
                               @"嘉義縣",
                               @"台南市",
                               @"高雄市",
                               @"屏東縣",
                               @"台東縣",
                               @"花蓮縣",
                               @"宜蘭縣",
                               @"澎湖縣",
                               @"金門縣",
                               @"連江縣", nil];
    }    
    int regionId = [regionNameList indexOfObject:region];
    return [NSNumber numberWithInt:regionId];
}

@end
