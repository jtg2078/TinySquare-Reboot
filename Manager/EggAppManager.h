//
//  EggAppManager.h
//  NTIFO
//
//  Created by  on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface EggAppManager : NSObject <UIAlertViewDelegate>
{
    NSUserDefaults *standardUserDefaults;
}

+ (EggAppManager *)sharedInstance; // Singleton method

- (void)setupInstalledDate;
- (void)setupAppVersionNumber;
- (void)updateInfoLastUpdatedTime:(NSDate *)date;
- (void)updateInfoCoreDataItemCount:(int)count;
- (BOOL)showIntroMovieClip;
- (BOOL)allowReportUsage;
- (BOOL)allowReportCrash;

@property (nonatomic, retain) AFHTTPClient *httpClient;
@property (nonatomic, assign) BOOL isSignedIn;
@property (nonatomic, retain) NSDate *signedInDate;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSNumber *fcid;
@property (nonatomic, retain) NSMutableDictionary *cartTemp;
@property (nonatomic, retain) NSDictionary *cartReal;
@property (nonatomic, retain) NSArray *allCarts;

// device related

- (void)registerDevice:(void (^)())success
               failure:(void (^)(NSString *errorMessage, NSError *error))failure;

// member related

- (void)createMemeberName:(NSString *)name
                  address:(NSString *)address
                    phone:(NSString *)phone
                   gender:(NSNumber *)gender
                 birthday:(NSString *)birthday
                    email:(NSString *)email
                 password:(NSString *)password
                  success:(void (^)(NSString *message))success
                  failure:(void (^)(NSString *errorMessage, NSError *error))failure;

- (void)updateMemeberName:(NSString *)name
                  address:(NSString *)address
                    phone:(NSString *)phone
                   gender:(NSNumber *)gender
                 birthday:(NSString *)birthday
               useReceipt:(NSNumber *)useReceipt
              receiptName:(NSString *)receiptName
                    taxID:(NSString *)taxID
       sameReceiptAddress:(NSNumber *)sameReceiptAddress
           receiptAddress:(NSString *)receiptAddress
            passwordOrNil:(NSString *)password
                  success:(void (^)())success
                  failure:(void (^)(NSString *errorMessage, NSError *error))failure;

- (void)updateMemberPassword:(NSString *)currentPwd
                      newPwd:(NSString *)newPwd
                     success:(void (^)())success
                     failure:(void (^)(NSString *errorMessage, NSError *error))failure;

- (void)memberSignIn:(NSString *)email
            password:(NSString *)password
            remember:(BOOL)remember
             success:(void (^)())success
             failure:(void (^)(NSString *errorMessage, NSError *error))failure;

- (void)memberSignOut:(void (^)())success
              failure:(void (^)(NSString *errorMessage, NSError *error))failure;

- (void)authenticateUser:(void (^)())success
                 failure:(void (^)(NSString *errorMessage, NSError *error))failure
                  signIn:(void (^)())signIn;

// shopping cart related

- (void)addToTempCartProduct:(NSNumber *)pid count:(NSNumber *)count;

- (void)addToRealCartProduct:(NSNumber *)pid
                       count:(NSNumber *)count
                   needLogin:(void (^)())login
                     success:(void (^)(int code, NSString *msg))success
                     failure:(void (^)(NSString *errorMessage, NSError *error))failure;

// not used for now
- (void)processTempCart:(void (^)())success
              needLogin:(void (^)())login
                failure:(void (^)(NSString *errorMessage, NSError *error))failure;

- (void)createShoppingCart:(void (^)(int code, NSString *msg))success
                   failure:(void (^)(NSString *errorMessage, NSError *error))failure;

- (void)updateShoppingCartForPid:(NSNumber *)pid
                           count:(NSNumber *)count
                         success:(void (^)(int code, NSString *msg))success
                         failure:(void (^)(NSString *errorMessage, NSError *error))failure;

- (void)getLatestShoppingCart:(void (^)(int code, NSString *msg))success
                      failure:(void (^)(NSString *errorMessage, NSError *error))failure;

- (void)getAllShoppingCarts:(void (^)(int code, NSString *msg))success
                    failure:(void (^)(NSString *errorMessage, NSError *error))failure;

-(void)checkShoppingCart:(void (^)(int code, NSString *msg))success
                 failure:(void (^)(NSString *errorMessage, NSError *error))failure;

@end
