//
//  Association.h
//  tinysquare
//
//  Created by  on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssociationItem;

@interface Association : NSManagedObject

@property (nonatomic, retain) NSNumber * associationId;
@property (nonatomic, retain) NSNumber * associationType;
@property (nonatomic, retain) NSString * directionDescription;
@property (nonatomic, retain) NSString * longText;
@property (nonatomic, retain) NSString * mapDescription;
@property (nonatomic, retain) NSString * mapStatus;
@property (nonatomic, retain) NSString * operationHour;
@property (nonatomic, retain) NSString * pinColor;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * webUrl;
@property (nonatomic, retain) AssociationItem *associationItem;

+ (Association *)getAssociationIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Association *)getOrCreateAssociationWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAssociationIfExistWithId:(NSNumber *)anId inManagedObjectContext:(NSManagedObjectContext *)context;

@end
