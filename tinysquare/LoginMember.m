//
//  LoginMember.m
//  asoapp
//
//  Created by wyde on 12/7/4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginMember.h"


@implementation LoginMember

@dynamic account;
@dynamic buyCartStatus;
@dynamic buyCheckStatus;
@dynamic cookie;
@dynamic fcid;
@dynamic id;
@dynamic logincheck;
@dynamic name;
@dynamic orderId;
@dynamic payMessage;
@dynamic payUrl;
@dynamic totalMoney;
@dynamic address;
@dynamic birthday;
@dynamic email;
@dynamic gender;
@dynamic phone;



+ (LoginMember *)getMemberIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
    LoginMember *member = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"LoginMember" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %d", [anId intValue]];
    
    NSError *error = nil;
    member = [[context executeFetchRequest:request error:&error] lastObject];
    [request release];
    
    if (!error && !member)
        return nil;
    
    return member;
}



+ (LoginMember *)getOrCreateMemberInManagedObjectContext:(NSManagedObjectContext *)context
{
    LoginMember *member = [LoginMember getMemberIfExistWithId:0 inManagedObjectContext:context];
    
    if (!member) {
        member = [NSEntityDescription insertNewObjectForEntityForName:@"LoginMember"inManagedObjectContext:context];
        member.id = [NSNumber numberWithInt:0];
    }
    return member;
}

+ (void)deleteLoginMemberIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context
{
    LoginMember *member = [LoginMember getMemberIfExistWithId:anId inManagedObjectContext:context];
    
    if(member)
        [context deleteObject:member];
}


@end
