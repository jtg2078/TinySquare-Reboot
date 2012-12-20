//
//  BuyHistory.h
//  asoapp
//
//  Created by wyde on 12/7/2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BuyHistory : NSManagedObject

@property (nonatomic, retain) NSNumber * orderid;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * result;
@property (nonatomic, retain) NSNumber * cash;
@property (nonatomic, retain) NSNumber * exchangeno;
@property (nonatomic, retain) NSString * products;
@property (nonatomic, retain) NSNumber * createdon;
@property (nonatomic, retain) NSNumber * total;

@end
