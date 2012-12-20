//
//  MemberManager.h
//  asoapp
//
//  Created by wyde on 12/5/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@interface MemberManager : NSObject {
    NSUserDefaults *standardUserDefaults;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *moc;

}

/*
@property (nonatomic, assign) id<EggConnectionManagerDelegate> delegate;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) NSArray *itemArray;
@property (nonatomic, retain) NSDictionary *item;
@property (nonatomic, retain) NSString *lastUpdateSuccessfulTime;
@property (nonatomic) int updateItemCount;

@property (nonatomic, assign) id<MemberManagerDelegate> updateFcidDelegate;
@property BOOL isAsyncUpdatingFcid;
@property BOOL isUpdatingFcid;
@property (nonatomic, retain) NSError *updateFcidError;

//----------------------membership related------------------
- (void)connectToGetFcidFinished:(MemberManager *)manager;
- (void)connectToGetFcidFailed:(MemberManager *)manager;

//----------------------------------------------------------
*/
@end
