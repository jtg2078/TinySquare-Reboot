//
//  LoginMember.h
//  asoapp
//
//  Created by wyde on 12/7/4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LoginMember : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSNumber * buyCartStatus;
@property (nonatomic, retain) NSNumber * buyCheckStatus;
@property (nonatomic, retain) NSString * cookie;
@property (nonatomic, retain) NSNumber * fcid;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * logincheck;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * orderId;
@property (nonatomic, retain) NSString * payMessage;
@property (nonatomic, retain) NSString * payUrl;
@property (nonatomic, retain) NSNumber * totalMoney;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * phone;

+ (LoginMember *)getMemberIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (LoginMember *)getOrCreateMemberInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteLoginMemberIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;


@end
