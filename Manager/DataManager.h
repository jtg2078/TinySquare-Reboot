//
//  DataManager.h
//  coredata04
//
//  Created by jason on 2011/8/25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataManager : NSObject {
	NSManagedObjectContext *moc;
	NSNumberFormatter * f;
}

@property (nonatomic, retain) NSArray *regionNameList;

- (id)initWithMoc:(NSManagedObjectContext *)anMoc;

- (void)parseAndImport:(NSArray *)toBeParsed;


- (void)parseAndImportHotProducts:(NSArray *)toBeParsed;
- (void)importHotProduct:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;
- (void)deleteHotProduct:(int)anId;

- (void)parseAndImportProductWindowProducts:(NSArray *)toBeParsed;
- (void)parseAndImportProductsForCategory:(NSArray *)toBeParsed categoryId:(int)anId;
- (void)parseAndImportSingleProduct:(NSDictionary *)item;
- (void)importProduct:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;
- (void)deleteProduct:(int)anId;

- (void)parseAndImportCategories:(NSArray *)toBeParsed;
- (void)parseAndImportSingleCategory:(NSDictionary *)item;
- (void)importCategory:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;
- (void)deleteCategory:(int)anId;

- (void)parseAndImportLocations:(NSArray *)toBeParsed;
- (void)parseAndImportSingleLocation:(NSDictionary *)item;
- (void)importLocation:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;
- (void)deleteLocation:(int)anId;

- (void)parseAndImportAboutMe:(NSDictionary *)item;
- (void)importAboutMe:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;
- (void)deleteAboutMe;

-(void)parseAndImportFcid:(NSString *)item;
-(void)importFcid:(NSString *)item identifier:(int)anId updateGeneration:(int)genId;


//************
-(void)parseAndImportRegister:(NSDictionary *)item;
- (void)importRegister:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;

- (void)parseAndImportLoginWithHeader:(NSDictionary *)header item:(NSDictionary *)item;
-(void)importLoginWithHeader:(NSDictionary *)header item:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;

-(void) parseAndImportBuyList:(NSDictionary *)item;
-(void) importBuyList:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;

-(void) parseAndImportCheckBill:(NSDictionary *)item;
-(void) importCheckBill:(NSDictionary *)item identifier:(int)anId updateGeneration:(int)genId;


- (void)importImagesForOwnerWithIdentifier:(NSString *)anId ownerId:(NSNumber *)ownerId images:(NSArray *)images imageType:(int)imageType;

- (NSNumber *)imageTypeMapper:(NSString *)typeName;
- (NSNumber *)imageSourceTypeMapper:(NSString *)typeName;
- (NSString *)productStatusTypeMapper:(NSString *)statusValue;
- (NSString *)constructDurtaionString:(int)durationStatus beginDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSNumber *)regionToRegionIdMapper:(NSString *)region;

+ (void)saveHotProductWithProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view;
+ (void)saveProductWithProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view;
+ (void)removeProductWithProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view;


+ (void)saveProductToCartProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view;
+ (void)removeProductFromCartWithProductId:(NSNumber *)productId managedObjectContext:(NSManagedObjectContext *)managedObjectContext showIndicatorInView:(UIView *)view;

@end
