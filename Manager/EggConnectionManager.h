//
//  EggConnectionManager.h
//  coredata04
//
//  Created by jason on 2011/8/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EggConnectionManagerDelegate.h"


@interface EggConnectionManager : NSObject {
	dispatch_queue_t backgroundQueue;
	NSString *cipherKey;
	NSObject<EggConnectionManagerDelegate> *delegate;
	NSError *error;
	NSArray *itemArray;
    NSDictionary *item;
    NSDictionary *loginheader;
	NSString *mTime;
	NSString *lastUpdateSuccessfulTime;
	int updateItemCount;
}

@property (nonatomic, assign) id<EggConnectionManagerDelegate> delegate;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) NSArray *itemArray;
@property (nonatomic, retain) NSDictionary *item;
@property (nonatomic, retain) NSDictionary *loginheader;
@property (nonatomic, retain) NSString *lastUpdateSuccessfulTime;
@property (nonatomic) int updateItemCount;
@property (nonatomic, retain) NSString *obtainedFcid;

@property (nonatomic, retain) NSString *myDevictoken;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *loginCheck;

- (void)connectToEggWithTime:(NSString *)anTime;
- (void)testConnect;

// for new api
// products
- (void)connectToGetHotProducts;
- (void)connectToGetSingleProduct:(NSString *)productId;
- (void)connectToGetProductWindowProducts:(int)count;
- (void)connectToGetProductsForCategory:(NSString *)categoryId;
// category
- (void)connectToGetSingleCategory:(NSString *)categoryId;
- (void)connectToGetCategories;
// location
- (void)connectToGetSingleLocation:(NSString *)locationId;
- (void)connectToGetLocations;
// about me
- (void)connectToGetAboutMe;
//membership
- (void)connectToGetFcid;
-(void) connectToRegister:(NSMutableDictionary *)registerInfo;
-(void) connectToLogin:(NSString *)account:(NSString *)pass;
-(void) connectToGetBuylist:(NSMutableArray *) buyList loginMember:(NSString *)cookie;
-(void) connectToGetCheckBill:(NSNumber *)orderId loginMember:(NSString *)cookie;



@end
