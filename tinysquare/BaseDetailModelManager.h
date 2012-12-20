//
//  DetailModelManager.h
//  NTIFO_01
//
//  Created by jason on 2011/9/2.
//  Copyright 2011 Fingertip Creative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailCellModel.h"
#import "DetailModelManagerDelegate.h"


@interface BaseDetailModelManager : NSObject 
{
	dispatch_queue_t backgroundQueue;
	id <DetailModelManagerDelegate> delegate;
	NSArray *cellList;
	UIFont *fontForCalculateCellHeight;
	//NSPersistentStoreCoordinator *persistentStoreCoordinator;
	int itemId;
	NSError *error;
	NSMutableDictionary *detailInfo;
}

@property int itemId;
@property (retain) NSArray *cellList;
@property (nonatomic, retain) NSError *error;
//@property (nonatomic, assign) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSMutableDictionary *detailInfo;

- (id)initWithItemId:(int)number;
- (void)createDetailCellList;
- (void)createDetailCellListForAboutMe;
- (DetailCellModel *)createWaitingModel;
- (void)clearDetailCellList;

- (void)addToBookmarkAndShowIndicatorInView:(UIView *)aView;

- (DetailCellModel *)createModelWithType:(CellType)type Title:(NSString *)aTitle contentText:(NSString *)aText;
- (DetailCellModel *)createTitleAndImageModel:(NSString *)title images:(NSArray *)imageArray;
- (DetailCellModel *)createTitleAndImageModelEx:(NSString *)title images:(NSArray *)imageArray;
- (DetailCellModel *)createSummaryModel:(NSString *)summary;
- (DetailCellModel *)createOperationModel:(NSString *)operation;
- (DetailCellModel *)createAvailableModel:(NSString *)available;
- (DetailCellModel *)createLocationPriceModel:(NSString *)price;
- (DetailCellModel *)createProductPriceModel:(NSString *)price;
- (DetailCellModel *)createAddressModel:(NSString *)name address:(NSString *)address lat:(NSNumber *)lat lon:(NSNumber *)lon;
- (DetailCellModel *)createTelephoneModel:(NSString *)telephone;
- (DetailCellModel *)createWebUrlModel:(NSString *)url;
- (DetailCellModel *)createAppPromoModel:(NSString *)appPromo;
- (DetailCellModel *)createRecipeDescModel:(NSString *)desc;
- (DetailCellModel *)createProductDescModel:(NSString *)desc;
- (DetailCellModel *)createLocationDescModel:(NSString *)desc;
- (DetailCellModel *)createLocationDirectionModel:(NSString *)direction;
- (DetailCellModel *)createAboutMeDetailDesc:(NSString *)desc;
- (DetailCellModel *)createShareModel:(NSString *)optional;
- (DetailCellModel *)createCellTypeTitleAndImagesEnhancedModel:(NSString *)title images:(NSArray *)imageArray url:(NSString *)itemUrl phone:(NSString *)phoneNumber price:(NSNumber *)price salePrice:(NSNumber *)salePrice;
//*******new method
- (DetailCellModel *)createCellTypeTitleAndImagesEnhancedModel:(NSString *)title images:(NSArray *)imageArray url:(NSString *)itemUrl phone:(NSString *)phoneNumber price:(NSNumber *)price salePrice:(NSNumber *)salePrice productId:(NSNumber *)productId;

- (DetailCellModel *)createCustomAttributeModel:(NSString *)aTitle contentText:(NSString *)aText;
- (DetailCellModel *)createCustomTagModel:(NSArray *)anArray;
- (DetailCellModel *)createAboutMeTitleModel:(NSString *)title images:(NSArray *)imageArray summary:(NSString *)itemSummary;
- (DetailCellModel *)createRemarkModel:(NSString *)aMessage;
- (DetailCellModel *)createEmailModel:(NSString *)anEmail;

@end
