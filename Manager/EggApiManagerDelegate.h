//
//  EggApiManagerDelegate.h
//  NTIFO
//
//  Created by jason on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EggApiManager;

@protocol EggApiManagerDelegate <NSObject>

@optional

- (void)updateDataCompleted:(EggApiManager *)manager;
- (void)updateDataFailed:(EggApiManager *)manager;

// -------------------- product related --------------------
- (void)updateHotProductCompleted:(EggApiManager *)manager;
- (void)updateHotProductFailed:(EggApiManager *)manager;

- (void)updateProductWindowCompleted:(EggApiManager *)manager;
- (void)updateProductWindowFailed:(EggApiManager *)manager;

- (void)updateSingleProductCompleted:(EggApiManager *)manager;
- (void)updateSingleProductFailed:(EggApiManager *)manager;

- (void)updateProductsForCategoryCompleted:(EggApiManager *)manager;
- (void)updateProductsForCategoryFailed:(EggApiManager *)manager;
// ---------------------------------------------------------

// -------------------- category related -------------------
- (void)updateSingleCategoryCompleted:(EggApiManager *)manager;
- (void)updateSingleCategoryFailed:(EggApiManager *)manager;

- (void)updateCategoriesCompleted:(EggApiManager *)manager;
- (void)updateCategoriesFailed:(EggApiManager *)manager;
// ---------------------------------------------------------

// -------------------- location related -------------------
- (void)updateSingleLocationCompleted:(EggApiManager *)manager;
- (void)updateSingleLocationFailed:(EggApiManager *)manager;

- (void)updateLocationsCompleted:(EggApiManager *)manager;
- (void)updateLocationsFailed:(EggApiManager *)manager;
// ---------------------------------------------------------

// -------------------- about me related -------------------
- (void)updateAboutMeCompleted:(EggApiManager *)manager;
- (void)updateAboutMeFailed:(EggApiManager *)manager;
// ---------------------------------------------------------


// -------------------- membership related -----------------
- (void)updateFcidCompleted:(EggApiManager *)manager;
- (void)updateFcidFailed:(EggApiManager *)manager;

- (void)updateRegisterCompleted:(EggApiManager *)manager;
- (void)updateRegisterFailed:(EggApiManager *)manager;

- (void)updateLoginCompleted:(EggApiManager *)manager;
- (void)updateLoginFailed:(EggApiManager *)manager;
// ----------------------------------------------------------

//----------------------buylist related----------------------
-(void)updateBuylistCompleted:(EggApiManager *)manager;
-(void)updateBuylistFailed:(EggApiManager *)manager;


-(void)updateCheckBillCompleted:(EggApiManager *)manager;
-(void)updateCheckBillFailed:(EggApiManager *)manager;
@end
