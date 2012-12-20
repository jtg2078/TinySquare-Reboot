//
//  EggApiManager.m
//  NTIFO
//
//  Created by jason on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EggApiManager.h"
#import "EggConnectionManager.h"
#import "DataManager.h"
#import "EggAppManager.h"
#import "Product.h"


static EggApiManager* singletonManager = nil;

@implementation EggApiManager

#pragma mark -
#pragma mark define

#define LAST_UPDATE_TIME			@"lastUpdateTime"
#define APP_DATA_STATE				@"appDataState"
#define app_RUNTIME_STATE			@"appRunTimeState"
#define DATA_RESET_VALUE			@""
#define DEFAULT_LAST_UPDATE_TIME	@"0";

#define HOT_PRODUCT_UPDATE_GENERATION               @"hotProductUpdateGeneration"
#define PRODUCT_WINDOW_UPDATE_GENERATION            @"productWindowUpdateGeneration"
#define PRODUCT_FOR_CATEGORY_UDPDATE_GENERATION     @"productForCategoryUpdateGeneration"
#define CATEGORY_UPDATE_GENERATION                  @"categoryUpdateGeneration"
#define LOCATION_UPDATE_GENERATION                  @"locationUpdateGeneration"


#pragma mark -
#pragma mark synthesize

@synthesize updateEverythingDelegate;
@synthesize isUpdatingEverything;
@synthesize isAsyncUpdatingEverything;
@synthesize updateEverythingError;

@synthesize updateHotProductDelegate;
@synthesize isUpdatingHotProduct;
@synthesize isAsyncUpdatingHotProduct;
@synthesize updateHotProductError;

@synthesize updateProductWindowDelegate;
@synthesize isUpdatingProductWindow;
@synthesize isAsyncUpdatingProductWindow;
@synthesize updateProductWindowError;

@synthesize updateSingleProductDelegate;
@synthesize isUpdatingSingleProduct;
@synthesize isAsyncUpdatingSingleProduct;
@synthesize updateSingleProductError;

@synthesize updateProductsForCategoryDelegate;
@synthesize categoryIdForUpdateProductsForCategory;
@synthesize isUpdatingProductsForCategory;
@synthesize isAsyncUpdatingProductsForCategory;
@synthesize updateProductsForCategoryError;

@synthesize updateSingleCategoryDelegate;
@synthesize isUpdatingSingleCategory;
@synthesize isAsyncUpdatingSingleCategory;
@synthesize updateSingleCategoryError;

@synthesize updateCategoriesDelegate;
@synthesize isUpdatingCategories;
@synthesize isAsyncUpdatingCategories;
@synthesize updateCategoriesError;

@synthesize updateSingleLocationDelegate;
@synthesize isUpdatingSingleLocation;
@synthesize isAsyncUpdatingSingleLocation;
@synthesize updateSingleLocationError;

@synthesize updateLocationsDelegate;
@synthesize isUpdatingLocations;
@synthesize isAsyncUpdatingLocations;
@synthesize updateLocationsError;

@synthesize updateAboutMeDelegate;
@synthesize isUpdatingAboutMe;
@synthesize isAsyncUpdatingAboutMe;
@synthesize updateAboutMeError;

@synthesize updateFcidDelegate;
@synthesize isUpdatingFcid;
@synthesize isAsyncUpdatingFcid;
@synthesize updateFcidError;

@synthesize updateRegisterDelegate;
@synthesize isUpdatingRegister;
@synthesize isAsyncUpdatingRegister;
@synthesize updateRegisterError;

@synthesize updateLoginError;
@synthesize isAsyncUpdatingLogin;
@synthesize isUpdatingLogin;
@synthesize updateLoginDelegate;

@synthesize updateBuylistError;
@synthesize isAsyncUpdatingBuylist;
@synthesize isUpdatingBuylist;
@synthesize updateBuylistDelegate;

@synthesize updateCheckBillDelegate;
@synthesize isAsyncUpdatingCheckBill;
@synthesize isUpdatingCheckBill;
@synthesize updateCheckBillError;
#pragma mark -
#pragma mark initialization and deallocation

- (id)init
{
	if(self = [super init]) {
		connectionManager = [[EggConnectionManager alloc] init];
		connectionManager.delegate = self;
		standardUserDefaults = [NSUserDefaults standardUserDefaults];
		appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        managedObjectContext = appDelegate.managedObjectContext;
	}
	return self;
}

- (void)dealloc {
	connectionManager.delegate = nil;
    updateHotProductDelegate = nil;
    updateProductWindowDelegate = nil;
    updateSingleProductDelegate = nil;
    updateProductsForCategoryDelegate = nil;
    updateSingleCategoryDelegate = nil;
    updateCategoriesDelegate = nil;
    updateSingleLocationDelegate = nil;
    updateLocationsDelegate = nil;
    updateAboutMeDelegate = nil;
    updateEverythingDelegate = nil;
    updateFcidDelegate=nil;
    updateRegisterDelegate=nil;
    updateLoginDelegate=nil;
    updateBuylistDelegate=nil;
    updateCheckBillDelegate=nil;
	[connectionManager release];
	[updateEverythingError release];
    [updateHotProductError release];
    [updateProductWindowError release];
    [updateSingleProductError release];
    [updateProductsForCategoryError release];
    [updateSingleCategoryError release];
    [updateCategoriesError release];
    [updateSingleLocationError release];
    [updateLocationsError release];
    [updateAboutMeError release];
    [updateFcidError release];
    [updateRegisterError release];
    [updateLoginError release];
    [updateBuylistError release];
    [updateCheckBillError release];
	[super dealloc];
}


#pragma mark -
#pragma mark public methods

- (int)getHotProductUpdateGeneration
{
    int savedValue = [standardUserDefaults integerForKey:HOT_PRODUCT_UPDATE_GENERATION];
    return savedValue;
}

- (void)updateHotProduct
{
    self.isAsyncUpdatingHotProduct = NO;
    
    if(self.isUpdatingHotProduct == NO) {
        [connectionManager connectToGetHotProducts];
		self.isUpdatingHotProduct = YES;
	}
}

- (void)updateHotProductAsync
{
    self.isAsyncUpdatingHotProduct = YES;
    
    if(self.isUpdatingHotProduct == NO) {
        [connectionManager connectToGetHotProducts];
		self.isUpdatingHotProduct = YES;
	}
}

- (int)getProductWindowUpdateGeneration
{
    int savedValue = [standardUserDefaults integerForKey:PRODUCT_WINDOW_UPDATE_GENERATION];
    return savedValue;
}

- (void)updateProductWindow
{
    self.isAsyncUpdatingProductWindow = NO;
    
    if(self.isUpdatingProductWindow == NO) {
        [connectionManager connectToGetProductWindowProducts:100];
        self.isUpdatingProductWindow = YES;
    }
}

- (void)updateProductWindowAsync
{
    self.isAsyncUpdatingProductWindow = YES;
    
    if(self.isUpdatingProductWindow == NO) {
        [connectionManager connectToGetProductWindowProducts:100];
        self.isUpdatingProductWindow = YES;
    }
}

- (void)updateSingleProduct:(NSNumber *)productId
{
    self.isAsyncUpdatingSingleProduct = NO;
    
    if(self.isUpdatingSingleProduct == NO) {
        [connectionManager connectToGetSingleProduct:[productId stringValue]];
        self.isUpdatingSingleProduct = YES;
    }
}

- (void)updateSingleProductAsync:(NSNumber *)productId
{
    self.isAsyncUpdatingSingleProduct = YES;
    
    if(self.isUpdatingSingleProduct == NO) {
        [connectionManager connectToGetSingleProduct:[productId stringValue]];
        self.isUpdatingSingleProduct = YES;
    }
}

- (void)updateProductsForCategory:(NSNumber *)categoryId
{
    self.isAsyncUpdatingProductsForCategory = NO;
    self.categoryIdForUpdateProductsForCategory = [categoryId intValue];
    
    if(self.isUpdatingProductsForCategory == NO) {
        [connectionManager connectToGetProductsForCategory:[categoryId stringValue]];
        self.isUpdatingProductsForCategory = YES;
    }
}

- (void)updateProductsForCategoryAsync:(NSNumber *)categoryId
{
    self.isAsyncUpdatingProductsForCategory = YES;
    self.categoryIdForUpdateProductsForCategory = [categoryId intValue];
    
    if(self.isUpdatingProductsForCategory == NO) {
        [connectionManager connectToGetProductsForCategory:[categoryId stringValue]];
        self.isUpdatingProductsForCategory = YES;
    }
}

- (int)getProductsForCategoryUpdateGeneration
{
    int savedValue = [standardUserDefaults integerForKey:PRODUCT_FOR_CATEGORY_UDPDATE_GENERATION];
    return savedValue;
}

- (void)updateSingleCategory:(NSNumber *)categoryId
{
    self.isAsyncUpdatingSingleCategory = NO;
    
    if(self.isUpdatingSingleCategory == NO) {
        [connectionManager connectToGetSingleCategory:[categoryId stringValue]];
        self.isUpdatingSingleCategory = YES;
    }
}

- (void)updateSingleCategoryAsync:(NSNumber *)categoryId
{
    self.isAsyncUpdatingSingleCategory = YES;
    
    if(self.isUpdatingSingleCategory == NO) {
        [connectionManager connectToGetSingleCategory:[categoryId stringValue]];
        self.isUpdatingSingleCategory = YES;
    }
}

- (void)updateCategories
{
    self.isAsyncUpdatingCategories = NO;
    
    if(self.isUpdatingCategories == NO) {
        [connectionManager connectToGetCategories];
        self.isUpdatingCategories = YES;
    }
}

- (void)updateCategoriesAsync
{
    self.isAsyncUpdatingCategories = YES;
    
    if(self.isUpdatingCategories == NO) {
        [connectionManager connectToGetCategories];
        self.isUpdatingCategories = YES;
    }
}

- (int)getCategoriesUpdateGeneration
{
    int savedValue = [standardUserDefaults integerForKey:CATEGORY_UPDATE_GENERATION];
    return savedValue;
}

- (void)updateSingleLocation:(NSString *)locationId
{
    self.isAsyncUpdatingSingleLocation = NO;
    
    if(self.isUpdatingSingleLocation == NO) {
        [connectionManager connectToGetSingleLocation:locationId];
        self.isUpdatingSingleLocation = YES;
    }
}

- (void)updateSingleLocationAsync:(NSString *)locationId
{
    self.isAsyncUpdatingSingleLocation = YES;
    
    if(self.isUpdatingSingleLocation == NO) {
        [connectionManager connectToGetSingleLocation:locationId];
        self.isUpdatingSingleLocation = YES;
    }
}

- (void)updateLocations
{
    self.isAsyncUpdatingLocations = NO;
    
    if(self.isUpdatingLocations == NO) {
        [connectionManager connectToGetLocations];
        self.isUpdatingLocations = YES;
    }
}

- (void)updateLocationsAsync
{
    self.isAsyncUpdatingLocations = YES;
    
    if(self.isUpdatingLocations == NO) {
        [connectionManager connectToGetLocations];
        self.isUpdatingLocations = YES;
    }
}

- (int)getLocationsUpdateGeneration
{
    int savedValue = [standardUserDefaults integerForKey:LOCATION_UPDATE_GENERATION];
    return savedValue;
}

- (void)updateAboutMe
{
    self.isAsyncUpdatingAboutMe = NO;
    
    if(self.isUpdatingAboutMe == NO) {
        [connectionManager connectToGetAboutMe];
        self.isUpdatingAboutMe = YES;
    }
}

- (void)updateAboutMeAsync
{
    self.isAsyncUpdatingAboutMe = YES;
    
    if(self.isUpdatingAboutMe == NO) {
        [connectionManager connectToGetAboutMe];
        self.isUpdatingAboutMe = YES;
    }
}

- (void)updateEverything 
{
    self.isAsyncUpdatingEverything = NO;
    
    if(self.isUpdatingEverything == NO) {
        [self updateHotProduct];
        [self updateProductWindow];
        [self updateCategories];
        [self updateLocations];
        [self updateAboutMe];
        self.isUpdatingEverything = YES;
    }
}

- (void)updateEverythingAsync
{
    self.isAsyncUpdatingEverything = YES;
    
    if(self.isUpdatingEverything == NO) {
        [self updateHotProduct];
        [self updateProductWindow];
        [self updateCategories];
        [self updateLocations];
        [self updateAboutMe];
        self.isUpdatingEverything = YES;
        
        // since it is the combination of everything, we dont know when will be end
        [standardUserDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:LAST_UPDATE_TIME];
        [standardUserDefaults synchronize];
    }
}


//********************


-(void) updateFcid
{
    self.isAsyncUpdatingFcid = NO;
    
    if(self.isUpdatingFcid == NO) {
        [connectionManager connectToGetFcid];
        self.isUpdatingFcid = YES;
    }
    
    
}

-(void) updateFcidAsync
{
    self.isAsyncUpdatingFcid = YES;
    
    if(self.isUpdatingFcid == NO) {
        [connectionManager connectToGetFcid];
        self.isUpdatingFcid = YES;
    }
    
    
}


-(void) updateRegister:(NSMutableDictionary *)registerInfo
{
    self.isAsyncUpdatingRegister = NO;
    
    if(self.isUpdatingRegister == NO) {
        [connectionManager connectToRegister:registerInfo];
        self.isUpdatingRegister = YES;
    }
}
    
-(void) updateRegisterAsync:(NSMutableDictionary *)registerInfo
{
    self.isAsyncUpdatingRegister = YES;
    
    if(self.isUpdatingRegister == NO) {
        [connectionManager connectToRegister:registerInfo];
        self.isUpdatingRegister = YES;
    }
    
    
}

-(void) updateLogin:(NSString *)account:(NSString *)pass
{
    self.isAsyncUpdatingLogin = NO;
    
    if(self.isAsyncUpdatingLogin == NO) {
        [connectionManager connectToLogin:account:pass];
        self.isUpdatingLogin = YES;
    }
}


-(void) updateLoginAsync:(NSString *)account:(NSString *)pass
{
    self.isAsyncUpdatingLogin = YES;
    
    if(self.isUpdatingLogin == NO) {
        [connectionManager connectToLogin:account:pass];
        self.isUpdatingLogin = YES;
    }

}



-(void) updateBuyList:(NSMutableArray *)buyList loginMember:(NSString *)cookie
{
    self.isAsyncUpdatingBuylist = NO;
    if(self.isAsyncUpdatingBuylist == NO) {
        [connectionManager connectToGetBuylist:buyList loginMember:cookie];
        self.isUpdatingBuylist = YES;
    }
}


-(void) updateBuyListAsync:(NSMutableArray *)buyList loginMember:(NSString *)cookie
{
    self.isAsyncUpdatingBuylist = YES;
    
    if(self.isUpdatingBuylist == NO) {
        [connectionManager connectToGetBuylist:buyList loginMember:cookie];
        self.isUpdatingBuylist = YES;
    }
    
}


-(void) updateCheckBill:(NSNumber *)orderId loginMember:(NSString *)cookie
{
    self.isAsyncUpdatingCheckBill = NO;
    if(self.isAsyncUpdatingCheckBill == NO) {
        [connectionManager connectToGetCheckBill:orderId loginMember:cookie];
        self.isUpdatingCheckBill = YES;
    }
}

-(void) updateCheckBillAsync:(NSNumber *)orderId loginMember:(NSString *)cookie
{
    self.isAsyncUpdatingCheckBill = YES;
    
    if(self.isUpdatingCheckBill == NO) {
        [connectionManager connectToGetCheckBill:orderId loginMember:cookie];        
        self.isUpdatingCheckBill = YES;
    }
    
}


- (void)stopUpdateEverything
{
    
}

- (NSDate *)getLastUpdateTime
{
	NSString *savedValue = [standardUserDefaults stringForKey:LAST_UPDATE_TIME];
	
	if(savedValue == nil || [savedValue length] == 0)
		return nil;
	
	return [NSDate dateWithTimeIntervalSince1970:[savedValue doubleValue]];
}

- (void)resetUpdate {
	[standardUserDefaults setObject:DATA_RESET_VALUE forKey:LAST_UPDATE_TIME];
	[standardUserDefaults synchronize];
}

- (void)refreshImages {
}

- (void)removeExpiredItems:(NSManagedObjectContext *)context
{
    [Product deleteExpiredProductIfAny:context];
}


#pragma mark -
#pragma mark private methods

- (void)update
{
	if(self.isUpdatingEverything == NO) {
		NSString *savedValue = [standardUserDefaults stringForKey:LAST_UPDATE_TIME];
		
		if(savedValue == nil || [savedValue length] == 0)
			savedValue = DEFAULT_LAST_UPDATE_TIME;
        
		[connectionManager connectToEggWithTime:savedValue];
		self.isUpdatingEverything = YES;
	}
}


#pragma mark -
#pragma mark EggConnectionManagerDelegate

// -------------------- product related --------------------
- (void)connectToGetHotProductsFinished:(EggConnectionManager *)manager;
{
    int savedValue = [standardUserDefaults integerForKey:HOT_PRODUCT_UPDATE_GENERATION];
    int newValue = savedValue + 1;
    [standardUserDefaults setInteger:newValue forKey:HOT_PRODUCT_UPDATE_GENERATION];
    [standardUserDefaults synchronize];
    
    if(self.isAsyncUpdatingHotProduct == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportHotProducts:[manager itemArray]];
        [dm release];
        
        if ([updateHotProductDelegate respondsToSelector:@selector(updateHotProductCompleted:)])
        {
            [updateHotProductDelegate performSelectorOnMainThread:@selector(updateHotProductCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingHotProduct = NO;
    }
}

- (void)connectToGetHotProductsFailed:(EggConnectionManager *)manager
{
    self.updateHotProductError = [manager error];
    self.isUpdatingHotProduct = NO;
    
	if ([updateHotProductDelegate respondsToSelector:@selector(updateHotProductFailed:)])
	{
		[updateHotProductDelegate performSelectorOnMainThread:@selector(updateHotProductFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

- (void)connectToGetProductWindowProductsFinished:(EggConnectionManager *)manager;
{
    int savedValue = [standardUserDefaults integerForKey:PRODUCT_WINDOW_UPDATE_GENERATION];
    int newValue = savedValue + 1;
    [standardUserDefaults setInteger:newValue forKey:PRODUCT_WINDOW_UPDATE_GENERATION];
    [standardUserDefaults synchronize];
    
    if(self.isAsyncUpdatingProductWindow == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportProductWindowProducts:[manager itemArray]];
        [dm release];
        
        if ([updateProductWindowDelegate respondsToSelector:@selector(updateProductWindowCompleted:)])
        {
            [updateProductWindowDelegate performSelectorOnMainThread:@selector(updateProductWindowCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingProductWindow = NO;
    }
}

- (void)connectToGetProductWindowProductsFailed:(EggConnectionManager *)manager;
{
    self.updateProductWindowError = [manager error];
    self.isUpdatingProductWindow = NO;
    
	if ([updateProductWindowDelegate respondsToSelector:@selector(updateProductWindowFailed:)])
	{
		[updateProductWindowDelegate performSelectorOnMainThread:@selector(updateProductWindowFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

- (void)connectToGetSingleProductFinished:(EggConnectionManager *)manager
{
    if(self.isAsyncUpdatingSingleProduct == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportSingleProduct:[manager item]];
        [dm release];
        
        if ([updateSingleProductDelegate respondsToSelector:@selector(updateSingleProductCompleted:)])
        {
            [updateSingleProductDelegate performSelectorOnMainThread:@selector(updateSingleProductCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingSingleProduct = NO;
    }
}

- (void)connectToGetSingleProductFailed:(EggConnectionManager *)manager
{
    self.updateSingleProductError = [manager error];
    self.isUpdatingSingleProduct = NO;
    
	if ([updateSingleProductDelegate respondsToSelector:@selector(updateSingleProductFailed:)])
	{
		[updateSingleProductDelegate performSelectorOnMainThread:@selector(updateSingleProductFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

- (void)connectToGetProductsForCategoryFinished:(EggConnectionManager *)manager
{
    int savedValue = [standardUserDefaults integerForKey:PRODUCT_FOR_CATEGORY_UDPDATE_GENERATION];
    int newValue = savedValue + 1;
    [standardUserDefaults setInteger:newValue forKey:PRODUCT_FOR_CATEGORY_UDPDATE_GENERATION];
    [standardUserDefaults synchronize];
    
    if(self.isAsyncUpdatingProductsForCategory == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportProductsForCategory:[manager itemArray] categoryId:self.categoryIdForUpdateProductsForCategory];
        [dm release];
        
        if ([updateProductsForCategoryDelegate respondsToSelector:@selector(updateProductsForCategoryCompleted:)])
        {
            [updateProductsForCategoryDelegate performSelectorOnMainThread:@selector(updateProductsForCategoryCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingProductsForCategory = NO;
    }
}

- (void)connectToGetProductsForCategoryFailed:(EggConnectionManager *)manager
{
    self.updateProductsForCategoryError = [manager error];
    self.isUpdatingProductsForCategory = NO;
    
	if ([updateProductsForCategoryDelegate respondsToSelector:@selector(updateProductsForCategoryFailed:)])
	{
		[updateProductsForCategoryDelegate performSelectorOnMainThread:@selector(updateProductsForCategoryFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

// ---------------------------------------------------------

// -------------------- category related -------------------
- (void)connectToGetSingleCategoryFinished:(EggConnectionManager *)manager
{
    if(self.isAsyncUpdatingSingleCategory == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportSingleCategory:[manager item]];
        [dm release];
        
        if ([updateSingleCategoryDelegate respondsToSelector:@selector(updateSingleCategoryCompleted:)])
        {
            [updateSingleCategoryDelegate performSelectorOnMainThread:@selector(updateSingleCategoryCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingSingleCategory = NO;
    }
}

- (void)connectToGetSingleCategoryFailed:(EggConnectionManager *)manager
{
    self.updateSingleCategoryError = [manager error];
    self.isUpdatingSingleCategory = NO;
    
	if ([updateSingleCategoryDelegate respondsToSelector:@selector(updateSingleCategoryFailed:)])
	{
		[updateSingleCategoryDelegate performSelectorOnMainThread:@selector(updateSingleCategoryFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

- (void)connectToGetCategoriesFinished:(EggConnectionManager *)manager
{
    int savedValue = [standardUserDefaults integerForKey:CATEGORY_UPDATE_GENERATION];
    int newValue = savedValue + 1;
    [standardUserDefaults setInteger:newValue forKey:CATEGORY_UPDATE_GENERATION];
    [standardUserDefaults synchronize];
    
    if(self.isAsyncUpdatingCategories == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportCategories:[manager itemArray]];
        [dm release];
        
        if ([updateCategoriesDelegate respondsToSelector:@selector(updateCategoriesCompleted:)])
        {
            [updateCategoriesDelegate performSelectorOnMainThread:@selector(updateCategoriesCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingCategories = NO;
    }
}

- (void)connectToGetCategoriesFailed:(EggConnectionManager *)manager
{
    self.updateCategoriesError = [manager error];
    self.isUpdatingCategories = NO;
    
	if ([updateCategoriesDelegate respondsToSelector:@selector(updateCategoriesFailed:)])
	{
		[updateCategoriesDelegate performSelectorOnMainThread:@selector(updateCategoriesFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}
// ---------------------------------------------------------

// -------------------- location related -------------------
- (void)connectToGetSingleLocationFinished:(EggConnectionManager *)manager
{
    if(self.isAsyncUpdatingSingleLocation == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportSingleLocation:[manager item]];
        [dm release];
        
        if ([updateSingleLocationDelegate respondsToSelector:@selector(updateSingleLocationCompleted:)])
        {
            [updateSingleLocationDelegate performSelectorOnMainThread:@selector(updateSingleLocationCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingSingleLocation = NO;
    }
}

- (void)connectToGetSingleLocationFailed:(EggConnectionManager *)manager
{
    self.updateSingleLocationError = [manager error];
    self.isUpdatingSingleLocation = NO;
    
	if ([updateSingleLocationDelegate respondsToSelector:@selector(updateSingleLocationFailed:)])
	{
		[updateSingleLocationDelegate performSelectorOnMainThread:@selector(updateSingleLocationFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

- (void)connectToGetLocationsFinished:(EggConnectionManager *)manager
{
    int savedValue = [standardUserDefaults integerForKey:LOCATION_UPDATE_GENERATION];
    int newValue = savedValue + 1;
    [standardUserDefaults setInteger:newValue forKey:LOCATION_UPDATE_GENERATION];
    [standardUserDefaults synchronize];
    
    if(self.isAsyncUpdatingLocations == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportLocations:[manager itemArray]];
        [dm release];
        
        if ([updateLocationsDelegate respondsToSelector:@selector(updateLocationsCompleted:)])
        {
            [updateLocationsDelegate performSelectorOnMainThread:@selector(updateLocationsCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingLocations = NO;
    }
}

- (void)connectToGetLocationsFailed:(EggConnectionManager *)manager
{
    self.updateLocationsError = [manager error];
    self.isUpdatingLocations = NO;
    
	if ([updateLocationsDelegate respondsToSelector:@selector(updateLocationsFailed:)])
	{
		[updateLocationsDelegate performSelectorOnMainThread:@selector(updateLocationsFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}
// ---------------------------------------------------------

// -------------------- about me related -------------------
- (void)connectToGetAboutMeFinished:(EggConnectionManager *)manager
{
    if(self.isAsyncUpdatingAboutMe == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportAboutMe:[manager item]];
        [dm release];
        
        if ([updateAboutMeDelegate respondsToSelector:@selector(updateAboutMeCompleted:)])
        {
            [updateAboutMeDelegate performSelectorOnMainThread:@selector(updateAboutMeCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingAboutMe = NO;
    }
}

- (void)connectToGetAboutMeFailed:(EggConnectionManager *)manager
{
    self.updateAboutMeError = [manager error];
    self.isUpdatingAboutMe = NO;
    
	if ([updateAboutMeDelegate respondsToSelector:@selector(updateAboutMeFailed:)])
	{
		[updateAboutMeDelegate performSelectorOnMainThread:@selector(updateAboutMeFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}
// ---------------------------------------------------------


// membership related---------------------------------------


- (void)connectToGetFcidFinished:(EggConnectionManager *)manager
{
    if(self.isAsyncUpdatingFcid == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportFcid:[manager obtainedFcid]];
        [dm release];
        
        if ([updateFcidDelegate respondsToSelector:@selector(updateFcidCompleted:)])
        {
            [updateFcidDelegate performSelectorOnMainThread:@selector(updateFcidCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingFcid = NO;
    }
}

- (void)connectToGetFcidFailed:(EggConnectionManager *)manager
{
    self.updateFcidError = [manager error];
    self.isUpdatingFcid = NO;
    
	if ([updateFcidDelegate respondsToSelector:@selector(updateFcidFailed:)])
	{
		[updateFcidDelegate performSelectorOnMainThread:@selector(updateFcidFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}



- (void)connectToRegisterFinished:(EggConnectionManager *)manager
{
    if(self.isAsyncUpdatingRegister == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        //NSLog(@"%@",[manager item]);
        [dm parseAndImportRegister:[manager item]];
        [dm release];
        
        if ([updateRegisterDelegate respondsToSelector:@selector(updateRegisterCompleted:)])
        {
            [updateRegisterDelegate performSelectorOnMainThread:@selector(updateRegisterCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingRegister = NO;
    }
}

- (void)connectToRegisterFailed:(EggConnectionManager *)manager
{
    self.updateRegisterError = [manager error];
    self.isUpdatingRegister = NO;
    
	if ([updateRegisterDelegate respondsToSelector:@selector(updateRegisterFailed:)])
	{
		[updateRegisterDelegate performSelectorOnMainThread:@selector(updateRegisterFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}


- (void)connectToLoginFinished:(EggConnectionManager *)manager
{
    if(self.isAsyncUpdatingLogin == YES)
    {
        
    }
    else
    {
        if ([[manager loginCheck] isEqualToString:@"true"]) {
        
           if ([updateLoginDelegate respondsToSelector:@selector(updateLoginCompleted:)])
           {
               DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
               [dm parseAndImportLoginWithHeader:[manager loginheader] item:[manager item]];
               [dm release];
               [updateLoginDelegate performSelectorOnMainThread:@selector(updateLoginCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
           }
          
        }
        else {
            [updateLoginDelegate performSelectorOnMainThread:@selector(updateLoginFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingLogin = NO;
    }
}

- (void)connectToLoginFailed:(EggConnectionManager *)manager
{
    self.updateLoginError = [manager error];
    self.isUpdatingLogin = NO;
    
	if ([updateLoginDelegate respondsToSelector:@selector(updateLoginFailed:)])
	{
		[updateLoginDelegate performSelectorOnMainThread:@selector(updateLoginFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

//----------------------------------------------------------

- (void)connectToGetBuylistFinished:(EggConnectionManager *)manager
{
    if(self.isAsyncUpdatingBuylist == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        //NSLog(@"%@",[manager item]);
        [dm parseAndImportBuyList:[manager item]];
        [dm release];
        
        if ([updateBuylistDelegate respondsToSelector:@selector(updateBuyListCompleted:)])
        {
            [updateBuylistDelegate performSelectorOnMainThread:@selector(updateBuyListCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingBuylist = NO;
    }
}

- (void)connectToGetBuylistFailed:(EggConnectionManager *)manager
{
    self.updateBuylistError = [manager error];
    self.isUpdatingBuylist = NO;
    
	if ([updateBuylistDelegate respondsToSelector:@selector(updateBuyListFailed:)])
	{
		[updateBuylistDelegate performSelectorOnMainThread:@selector(updateBuyListFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}

-(void)connectToGetCheckBillFinished:(EggConnectionManager *)manager
{
    if(self.isAsyncUpdatingCheckBill == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportCheckBill:[manager item]];
        [dm release];
        
        if ([updateCheckBillDelegate respondsToSelector:@selector(updateCheckBillCompleted:)])
        {
            [updateCheckBillDelegate performSelectorOnMainThread:@selector(updateCheckBillCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingCheckBill = NO;
    }
}


-(void)connectToGetCheckBillFailed:(EggConnectionManager *)manager
{
    self.updateCheckBillError = [manager error];
    self.isUpdatingCheckBill = NO;
    
	if ([updateCheckBillError respondsToSelector:@selector(updateCheckBillFailed:)])
	{
		[updateCheckBillDelegate performSelectorOnMainThread:@selector(updateCheckBillFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}


#pragma mark -
#pragma mark singleton implementation code

+ (EggApiManager *)sharedInstance {
	/*
     @synchronized(self) {
     if (singletonManager == nil) {
     [[self alloc] init];
     }
     }
     return singletonManager;
	 */
	
	static dispatch_once_t pred;
	static EggApiManager *manager;
	
	dispatch_once(&pred, ^{ 
		manager = [[self alloc] init]; 
	});
	return manager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singletonManager == nil) {
            singletonManager = [super allocWithZone:zone];
            return singletonManager;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
