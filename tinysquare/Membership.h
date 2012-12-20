//
//  Membership.h
//  asoapp
//
//  Created by wyde on 12/5/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Membership : NSManagedObject

@property (nonatomic, retain) NSNumber * fcid;
@property (nonatomic, retain) NSNumber * appid;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSNumber * appversion;
@property (nonatomic, retain) NSString * imei;
@property (nonatomic, retain) NSNumber * platform;
@property (nonatomic, retain) NSString * osversion;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSNumber * pushmessage;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * column;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * status;

+ (Membership *)getMemberIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Membership *)getOrCreateMemberInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteMemberIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;

@end
