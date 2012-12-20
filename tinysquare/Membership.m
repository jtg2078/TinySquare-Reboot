//
//  Membership.m
//  asoapp
//
//  Created by wyde on 12/5/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Membership.h"


@implementation Membership

@dynamic fcid;
@dynamic appid;
@dynamic email;
@dynamic password;
@dynamic name;
@dynamic address;
@dynamic phone;
@dynamic gender;
@dynamic age;
@dynamic appversion;
@dynamic imei;
@dynamic platform;
@dynamic osversion;
@dynamic country;
@dynamic token;
@dynamic pushmessage;
@dynamic id;
@dynamic column;
@dynamic message;
@dynamic status;


+ (Membership *)getMemberIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Membership *member = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Membership" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"id = %d", [anId intValue]];
	
	NSError *error = nil;
	member = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !member)
		return nil;
	
	return member;
}



+ (Membership *)getOrCreateMemberInManagedObjectContext:(NSManagedObjectContext *)context
{
    Membership *member = [Membership getMemberIfExistWithId:0 inManagedObjectContext:context];
    
    if (!member) {
		member = [NSEntityDescription insertNewObjectForEntityForName:@"Membership" inManagedObjectContext:context];
        member.id = [NSNumber numberWithInt:0];
	}
	return member;
}

+ (void)deleteMemberIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
	Membership *member = [Membership getMemberIfExistWithId:anId inManagedObjectContext:context];
	
	if(member)
		[context deleteObject:member];
}


@end
