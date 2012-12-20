//
//  EggApiManager.h
//  NTIFO
//
//  Created by jason on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EggApiManagerDelegate.h"
#import "EggConnectionManagerDelegate.h"
#import "AppDelegate.h"

@class EggConnectionManager;

@interface EggApiManager : NSObject <EggConnectionManagerDelegate> {
    NSObject<EggApiManagerDelegate> *updateHotProductDelegate;
    NSObject<EggApiManagerDelegate> *updateProductWindowDelegate;
    NSObject<EggApiManagerDelegate> *updateSingleProductDelegate;
    NSObject<EggApiManagerDelegate> *updateProductsForCategoryDelegate;
    NSObject<EggApiManagerDelegate> *updateSingleCategoryDelegate;
    NSObject<EggApiManagerDelegate> *updateCategoriesDelegate;
    NSObject<EggApiManagerDelegate> *updateSingleLocationDelegate;
    NSObject<EggApiManagerDelegate> *updateLocationsDelegate;
    NSObject<EggApiManagerDelegate> *updateAboutMeDelegate;
    NSObject<EggApiManagerDelegate> *updateEverythingDelegate;
    
    NSObject<EggApiManagerDelegate> *updateFcidDelegate;
    NSObject<EggApiManagerDelegate> *updateRegisterDelegate;
    NSObject<EggApiManagerDelegate> *updateLoginDelegate;
    NSObject<EggApiManagerDelegate> *updateBuylistDelegate;
    NSObject<EggApiManagerDelegate> *updateCheckBillDelegate;



    
    
    EggConnectionManager *connectionManager;
	NSUserDefaults *standardUserDefaults;
	NSManagedObjectContext *managedObjectContext;
	AppDelegate *appDelegate;
}

@property (nonatomic, assign) id<EggApiManagerDelegate> updateHotProductDelegate;
@property BOOL isUpdatingHotProduct;
@property BOOL isAsyncUpdatingHotProduct;
@property (nonatomic, retain) NSError *updateHotProductError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateProductWindowDelegate;
@property BOOL isUpdatingProductWindow;
@property BOOL isAsyncUpdatingProductWindow;
@property (nonatomic, retain) NSError *updateProductWindowError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateSingleProductDelegate;
@property BOOL isUpdatingSingleProduct;
@property BOOL isAsyncUpdatingSingleProduct;
@property (nonatomic, retain) NSError *updateSingleProductError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateProductsForCategoryDelegate;
@property int categoryIdForUpdateProductsForCategory;
@property BOOL isUpdatingProductsForCategory;
@property BOOL isAsyncUpdatingProductsForCategory;
@property (nonatomic, retain) NSError *updateProductsForCategoryError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateSingleCategoryDelegate;
@property BOOL isUpdatingSingleCategory;
@property BOOL isAsyncUpdatingSingleCategory;
@property (nonatomic, retain) NSError *updateSingleCategoryError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateCategoriesDelegate;
@property BOOL isUpdatingCategories;
@property BOOL isAsyncUpdatingCategories;
@property (nonatomic, retain) NSError *updateCategoriesError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateSingleLocationDelegate;
@property BOOL isUpdatingSingleLocation;
@property BOOL isAsyncUpdatingSingleLocation;
@property (nonatomic, retain) NSError *updateSingleLocationError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateLocationsDelegate;
@property BOOL isUpdatingLocations;
@property BOOL isAsyncUpdatingLocations;
@property (nonatomic, retain) NSError *updateLocationsError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateAboutMeDelegate;
@property BOOL isUpdatingAboutMe;
@property BOOL isAsyncUpdatingAboutMe;
@property (nonatomic, retain) NSError *updateAboutMeError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateEverythingDelegate;
@property BOOL isAsyncUpdatingEverything;
@property BOOL isUpdatingEverything;
@property (nonatomic, retain) NSError *updateEverythingError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateFcidDelegate;
@property BOOL isAsyncUpdatingFcid;
@property BOOL isUpdatingFcid;
@property (nonatomic, retain) NSError *updateFcidError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateRegisterDelegate;
@property BOOL isAsyncUpdatingRegister;
@property BOOL isUpdatingRegister;
@property (nonatomic, retain) NSError *updateRegisterError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateLoginDelegate;
@property BOOL isAsyncUpdatingLogin;
@property BOOL isUpdatingLogin;
@property (nonatomic, retain) NSError *updateLoginError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateBuylistDelegate;
@property BOOL isAsyncUpdatingBuylist;
@property BOOL isUpdatingBuylist;
@property (nonatomic, retain) NSError *updateBuylistError;

@property (nonatomic, assign) id<EggApiManagerDelegate> updateCheckBillDelegate;
@property BOOL isAsyncUpdatingCheckBill;
@property BOOL isUpdatingCheckBill;
@property (nonatomic, retain) NSError *updateCheckBillError;


+ (EggApiManager *)sharedInstance; // Singleton method

- (void)updateEverything;
- (void)updateEverythingAsync;
- (void)stopUpdateEverything;
- (NSDate *)getLastUpdateTime;
- (void)removeExpiredItems:(NSManagedObjectContext *)context;

- (void)updateHotProduct;
- (void)updateHotProductAsync;
- (int)getHotProductUpdateGeneration;

- (void)updateProductWindow;
- (void)updateProductWindowAsync;
- (int)getProductWindowUpdateGeneration;

- (void)updateSingleProduct:(NSNumber *)productId;
- (void)updateSingleProductAsync:(NSNumber *)productId;

- (void)updateProductsForCategory:(NSNumber *)categoryId;
- (void)updateProductsForCategoryAsync:(NSNumber *)categoryId;
- (int)getProductsForCategoryUpdateGeneration;

- (void)updateSingleCategory:(NSNumber *)categoryId;
- (void)updateSingleCategoryAsync:(NSNumber *)categoryId;

- (void)updateCategories;
- (void)updateCategoriesAsync;
- (int)getCategoriesUpdateGeneration;

- (void)updateSingleLocation:(NSNumber *)locationId;
- (void)updateSingleLocationAsync:(NSNumber *)locationId;

- (void)updateLocations;
- (void)updateLocationsAsync;
- (int)getLocationsUpdateGeneration;

- (void)updateAboutMe;
- (void)updateAboutMeAsync;



-(void) updateFcid;
-(void) updateFcidAsync;

-(void) updateRegister:(NSMutableDictionary *)registerInfo;
-(void) updateRegisterAsync:(NSMutableDictionary *)registerInfo;

-(void) updateLogin:(NSString *) account:(NSString *)pass;
-(void) updateLoginAsync:(NSString *) account:(NSString *)pass;

-(void) updateBuyList:(NSMutableArray *)buyList loginMember:(NSString *)cookie;
-(void) updateBuyListAsync:(NSMutableArray *)buyList loginMember:(NSString *)cookie;

-(void) updateCheckBill:(NSNumber *)orderId loginMember:(NSString *)cookie;
-(void) updateCheckBillAsync:(NSNumber *)orderId loginMember:(NSString *)cookie;


@end
