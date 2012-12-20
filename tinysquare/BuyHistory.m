//
//  BuyHistory.m
//  asoapp
//
//  Created by wyde on 12/7/2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BuyHistory.h"


@implementation BuyHistory

@dynamic orderid;
@dynamic status;
@dynamic amount;
@dynamic result;
@dynamic cash;
@dynamic exchangeno;
@dynamic products;
@dynamic createdon;
@dynamic total;

+ (BuyHistory *)getBuyHistoryIfExistWithOrderId:(NSNumber *)orderId inManagedObjectContext:(NSManagedObjectContext *)context
{
	BuyHistory *buyHis = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"BuyHistory" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"orderid = %d", [orderId intValue]];
	
	NSError *error = nil;
	buyHis = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !buyHis)
		return nil;
	
	return buyHis;
}

+ (BuyHistory *)getOrCreateBuyHistoryWithOrderId:(NSNumber *)orderId inManagedObjectContext:(NSManagedObjectContext *)context
{
	BuyHistory *buyHis = [BuyHistory getBuyHistoryIfExistWithOrderId:orderId inManagedObjectContext:context];
	
	if (!buyHis) {
		buyHis = [NSEntityDescription insertNewObjectForEntityForName:@"BuyHistory" inManagedObjectContext:context];
        buyHis.orderid = orderId;
	}
	return buyHis;
}

+ (void)deleteProductIfExistWithProductId:(NSNumber *)orderId inManagedObjectContext:(NSManagedObjectContext *)context
{
	BuyHistory *buyHis = [BuyHistory getBuyHistoryIfExistWithOrderId:orderId inManagedObjectContext:context];
	
	if(buyHis)
		[context deleteObject:buyHis];
}


@end
