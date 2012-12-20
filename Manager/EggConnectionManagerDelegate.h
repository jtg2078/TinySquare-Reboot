//
//  EggConnectionManagerDelegate.h
//  coredata04
//
//  Created by jason on 2011/8/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class EggConnectionManager;

@protocol EggConnectionManagerDelegate <NSObject>

@optional

- (void)connectUpdateFinished:(EggConnectionManager *)manager;
- (void)connectUpdateFailed:(EggConnectionManager *)manager;

// -------------------- product related --------------------
- (void)connectToGetHotProductsFinished:(EggConnectionManager *)manager;
- (void)connectToGetHotProductsFailed:(EggConnectionManager *)manager;

- (void)connectToGetSingleProductFinished:(EggConnectionManager *)manager;
- (void)connectToGetSingleProductFailed:(EggConnectionManager *)manager;

- (void)connectToGetProductWindowProductsFinished:(EggConnectionManager *)manager;
- (void)connectToGetProductWindowProductsFailed:(EggConnectionManager *)manager;

- (void)connectToGetProductsForCategoryFinished:(EggConnectionManager *)manager;
- (void)connectToGetProductsForCategoryFailed:(EggConnectionManager *)manager;
// ---------------------------------------------------------

// -------------------- category related -------------------
- (void)connectToGetSingleCategoryFinished:(EggConnectionManager *)manager;
- (void)connectToGetSingleCategoryFailed:(EggConnectionManager *)manager;

- (void)connectToGetCategoriesFinished:(EggConnectionManager *)manager;
- (void)connectToGetCategoriesFailed:(EggConnectionManager *)manager;
// ---------------------------------------------------------

// -------------------- location related -------------------
- (void)connectToGetSingleLocationFinished:(EggConnectionManager *)manager;
- (void)connectToGetSingleLocationFailed:(EggConnectionManager *)manager;

- (void)connectToGetLocationsFinished:(EggConnectionManager *)manager;
- (void)connectToGetLocationsFailed:(EggConnectionManager *)manager;
// ---------------------------------------------------------

// -------------------- about me related -------------------
- (void)connectToGetAboutMeFinished:(EggConnectionManager *)manager;
- (void)connectToGetAboutMeFailed:(EggConnectionManager *)manager;
// ---------------------------------------------------------

//----------------------membership related------------------
- (void)connectToGetFcidFinished:(EggConnectionManager *)manager;
- (void)connectToGetFcidFailed:(EggConnectionManager *)manager;

- (void)connectToRegisterFinished:(EggConnectionManager *)manager;
- (void)connectToRegisterFailed:(EggConnectionManager *)manager;

- (void)connectToLoginFinished:(EggConnectionManager *)manager;
- (void)connectToLoginFailed:(EggConnectionManager *)manager;

//----------------------------------------------------------

//---------------------buylist related----------------------
-(void) connectToGetBuylistFinished:(EggConnectionManager *)manager;
-(void) connectToGetBuylistFailed:(EggConnectionManager *)manager;

-(void) connectToGetCheckBillFinished:(EggConnectionManager *)manager;
-(void) connectToGetCheckBillFailed:(EggConnectionManager *)manager;//----------------------------------------------------------
@end
