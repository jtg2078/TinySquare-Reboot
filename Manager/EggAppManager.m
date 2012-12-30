//
//  EggAppManager.m
//  NTIFO
//
//  Created by  on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EggAppManager.h"
#import "UIDevice+IdentifierAddition.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"

typedef void (^AUTH_USER_CALLBACK_SUCCESS)();
typedef void (^AUTH_USER_CALLBACK_FAILURE)(NSString *errorMessage, NSError *error);

@interface EggAppManager ()

- (void)saveToUserDefaults:(id)value forKey:(NSString*)key;
- (id)retrieveFromUserDefaults:(NSString*)key;

@property (nonatomic, copy) AUTH_USER_CALLBACK_SUCCESS authCallbackSuccess;
@property (nonatomic, copy) AUTH_USER_CALLBACK_FAILURE authCallbackFailure;
@property (nonatomic, copy) AUTH_USER_CALLBACK_SUCCESS authCallbackSignIn;

@end

static EggAppManager* singletonManager = nil;

@implementation EggAppManager

#pragma mark -
#pragma mark define

#define APP_SETTINGS_APP_INSTALLED_DATE             @"ntifoAppInstalledDate"
#define APP_SETTINGS_APP_BUNDLE_VERSION             @"ntifoBundleVersion"
#define APP_SETTINGS_LAST_CONNECTED_SERVER_TIME     @"ntifoLastConnectedTime"
#define APP_SETTINGS_CORE_DATA_ITEM_COUNT           @"ntifoCoreDataItemCount"
#define APP_SETTINGS_SHOW_INTRO_MOVIE_CLIP          @"ntifoShowIntroClip"
#define APP_SETTINGS_ALLOW_REPORT_USAGE             @"ntifoAllowReportUsage"
#define APP_SETTINGS_ALLOW_REPORT_CRASH             @"ntifoAllowReportCrash"

#define ALERT_VIEW_PROMPT_SIGN_IN                   10
#define ALERT_VIEW_PROMPT_AUTH                      11

#pragma mark -
#pragma mark synthesize


#pragma mark -
#pragma mark initialization and deallocation

- (id)init
{
	if(self = [super init]) {
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        NSURL *baseURL = [NSURL URLWithString:@"http://api.ideaegg.com.tw"];
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        // why james decided to use json in some api and not others, be consistent.. :(
        //[_httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [_httpClient setDefaultHeader:@"Accept" value:@"application/json"];
        [_httpClient setParameterEncoding:AFJSONParameterEncoding];
        
        _userInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userdefaultUserInfo"];
        
        if(_userInfo)
            [_httpClient setAuthorizationHeaderWithUsername:_userInfo[@"email"] password:_userInfo[@"password"]];
        
        _fcid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userdefaultfcid"];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}


#pragma mark -
#pragma mark public methods

- (void)setupInstalledDate
{
    NSString *installedDate = [standardUserDefaults objectForKey:APP_SETTINGS_APP_INSTALLED_DATE];
    
    if(!installedDate || ![installedDate length])
    {
        NSString *sourceFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Icon.png"];
        
        NSError *error;
        NSDate *lastCreate = [[[NSFileManager defaultManager] attributesOfItemAtPath:sourceFile error:&error] objectForKey:NSFileCreationDate];
        
        [standardUserDefaults setObject:[lastCreate description] forKey:APP_SETTINGS_APP_INSTALLED_DATE];
        [standardUserDefaults synchronize];
    }
}

- (void)setupAppVersionNumber
{
    NSString *bundleVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [self saveToUserDefaults:bundleVer forKey:APP_SETTINGS_APP_BUNDLE_VERSION];
}

- (void)updateInfoLastUpdatedTime:(NSDate *)date
{
    [self saveToUserDefaults:[date description] forKey:APP_SETTINGS_LAST_CONNECTED_SERVER_TIME];
}

- (void)updateInfoCoreDataItemCount:(int)count
{
    NSString *countInSTring = [NSString stringWithFormat:@"%d", count];
    [self saveToUserDefaults:countInSTring forKey:APP_SETTINGS_CORE_DATA_ITEM_COUNT];
}

- (BOOL)showIntroMovieClip
{
    id val = [self retrieveFromUserDefaults:APP_SETTINGS_SHOW_INTRO_MOVIE_CLIP];
    
    if([val isKindOfClass:[NSNumber class]])
    {
        return [val boolValue];
    }
    
    return YES;
}

- (BOOL)allowReportUsage
{
    id val = [self retrieveFromUserDefaults:APP_SETTINGS_ALLOW_REPORT_USAGE];
    
    if([val isKindOfClass:[NSNumber class]])
    {
        return [val boolValue];
    }
    
    return YES;
}

- (BOOL)allowReportCrash
{
    id val = [self retrieveFromUserDefaults:APP_SETTINGS_ALLOW_REPORT_CRASH];
    
    if([val isKindOfClass:[NSNumber class]])
    {
        return [val boolValue];
    }
    
    return YES;
}

#pragma mark - device related

- (void)registerDevice:(void (^)())success
               failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    NSDictionary *params = @{
        @"appid": @(API_APP_ID.intValue),
        @"appversion": @(3), //[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"],
        @"imei": [[UIDevice currentDevice] uniqueDeviceIdentifier],
        @"platform":@(2),
        @"osversion":[[UIDevice currentDevice] systemVersion],
        @"country": @"not available",
        @"phone": @"not available",
        @"token": @"not available",
        @"pushmessage": @(0),
    };
    
    [self.httpClient postPath:@"Member.svc/Init" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *ret = [[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding] autorelease];
        NSString *trimmedRet = [ret stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        self.fcid = @(trimmedRet.intValue);
        
        if(success)
            success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(error.description, error);
    }];
}

#pragma mark - member related

- (void)createMemeberName:(NSString *)name
                  address:(NSString *)address
                    phone:(NSString *)phone
                   gender:(NSNumber *)gender
                 birthday:(NSString *)birthday
                    email:(NSString *)email
                 password:(NSString *)password
                  success:(void (^)(NSString *message))success
                  failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    NSDictionary *params = @{
        @"fcid": self.fcid,
        @"appid": @(API_APP_ID.intValue),
        @"email": email,
        @"password":password,
        @"name":name,
        @"adress": address,
        @"phone": phone,
        @"gender": gender,
        @"birth": birthday,
    };
    
    [self.httpClient postPath:@"Member.svc/Register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"Member.svc/Register: %@", JSON);
        
        if([JSON[@"status"] boolValue] == YES)
        {            
            if(success)
                success(JSON[@"message"]);
        }
        else
        {
            if(failure)
                failure(JSON[@"message"], nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(error.description, error);
    }];
}

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
                  failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    NSDictionary *params = @{
        @"password": password.length ? password : self.userInfo[@"password"],
        @"name": name,
        @"adress": address,
        @"phone": phone,
        @"gender": gender,
        @"birth": birthday,
    };
    
    [self.httpClient postPath:@"Member.svc/Update" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        
        NSLog(@"Member.svc/Update: %@", responseObj);
        
        NSNumber *saveCardInfo = self.userInfo[@"saveCardInfo"] ? self.userInfo[@"saveCardInfo"] : @(NO);
        NSString *cardName = self.userInfo[@"cardName"] ? self.userInfo[@"cardName"] : @"";
        NSString *cardNumber = self.userInfo[@"cardNumber"] ? self.userInfo[@"cardNumber"] : @"";
        NSString *cardExpireMonth = self.userInfo[@"cardExpireMonth"] ? self.userInfo[@"cardExpireMonth"] : @"";
        NSString *cardExpireYear = self.userInfo[@"cardExpireYear"] ? self.userInfo[@"cardExpireYear"] : @"";
        NSString *cardSecurityCode = self.userInfo[@"cardSecurityCode"] ? self.userInfo[@"cardSecurityCode"] : @"";
        
        [self saveUserInfoAddress:address
                         birthday:birthday
                            email:self.userInfo[@"email"]
                             fcid:self.userInfo[@"fcid"]
                           gender:gender
                             name:name
                            phone:phone
                       useReceipt:useReceipt
                      receiptName:receiptName
                            taxID:taxID
               sameReceiptAddress:sameReceiptAddress
                   receiptAddress:receiptAddress
                         password:self.userInfo[@"password"]
                       autoSignIn:self.userInfo[@"autoSignIn"]
                     saveCardInfo:saveCardInfo
                         cardName:cardName
                       cardNumber:cardNumber
                  cardExpireMonth:cardExpireMonth
                   cardExpireYear:cardExpireYear
                 cardSecurityCode:cardSecurityCode];
        
        if(success)
            success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"需先登入帳號驗證身分", error);
    }];
}

- (void)updateMemberPassword:(NSString *)currentPwd
                      newPwd:(NSString *)newPwd
                     success:(void (^)())success
                     failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    NSDictionary *params = @{
        @"newpw": newPwd,
        @"password": currentPwd,
    };
    
    [self.httpClient postPath:@"Member.svc/ChangePw" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        
        NSLog(@"Member.svc/ChangePw: %@", responseObj);
        
        NSNumber *saveCardInfo = self.userInfo[@"saveCardInfo"] ? self.userInfo[@"saveCardInfo"] : @(NO);
        NSString *cardName = self.userInfo[@"cardName"] ? self.userInfo[@"cardName"] : @"";
        NSString *cardNumber = self.userInfo[@"cardNumber"] ? self.userInfo[@"cardNumber"] : @"";
        NSString *cardExpireMonth = self.userInfo[@"cardExpireMonth"] ? self.userInfo[@"cardExpireMonth"] : @"";
        NSString *cardExpireYear = self.userInfo[@"cardExpireYear"] ? self.userInfo[@"cardExpireYear"] : @"";
        NSString *cardSecurityCode = self.userInfo[@"cardSecurityCode"] ? self.userInfo[@"cardSecurityCode"] : @"";
        
        [self saveUserInfoAddress:self.userInfo[@"address"]
                         birthday:self.userInfo[@"birthday"]
                            email:self.userInfo[@"email"]
                             fcid:self.userInfo[@"fcid"]
                           gender:self.userInfo[@"gender"]
                             name:self.userInfo[@"name"]
                            phone:self.userInfo[@"phone"]
                       useReceipt:self.userInfo[@"useReceipt"]
                      receiptName:self.userInfo[@"receiptName"]
                            taxID:self.userInfo[@"taxID"]
               sameReceiptAddress:self.userInfo[@"sameReceiptAddress"]
                   receiptAddress:self.userInfo[@"receiptAddress"]
                         password:newPwd
                       autoSignIn:self.userInfo[@"autoSignIn"]
                     saveCardInfo:saveCardInfo
                         cardName:cardName
                       cardNumber:cardNumber
                  cardExpireMonth:cardExpireMonth
                   cardExpireYear:cardExpireYear
                 cardSecurityCode:cardSecurityCode];
        
        if(success)
            success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"密碼不正確", error);
    }];
}

- (void)memberSignIn:(NSString *)email
            password:(NSString *)password
            remember:(BOOL)remember
             success:(void (^)())success
             failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    NSDictionary *params = @{
        @"appid": @(API_APP_ID.intValue),
        @"email": email,
        @"password": password,
    };
    
    [self.httpClient postPath:@"Member.svc/Login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"Member.svc/Login: %@", JSON);
        
        NSString *address = ![JSON[@"adress"] isKindOfClass:[NSNull class]] ? JSON[@"adress"] : @"";
        NSString *birthday = ![JSON[@"birthday"] isKindOfClass:[NSNull class]] ? JSON[@"birthday"] : @"";
        NSString *email = ![JSON[@"email"] isKindOfClass:[NSNull class]] ? JSON[@"email"] : @"";
        NSNumber *fcid = ![JSON[@"fcid"] isKindOfClass:[NSNull class]] ? JSON[@"fcid"] : [NSNumber numberWithInt:-1];
        NSNumber *gender = ![JSON[@"gender"] isKindOfClass:[NSNull class]] ? JSON[@"gender"] : [NSNumber numberWithInt:3];
        NSString *name = ![JSON[@"name"] isKindOfClass:[NSNull class]] ? JSON[@"name"] : @"";
        NSString *phone = ![JSON[@"phone"] isKindOfClass:[NSNull class]] ? JSON[@"phone"] : @"";
        
        
        NSNumber *useReceipt = self.userInfo[@"useReceipt"] ? self.userInfo[@"useReceipt"] : @(NO);
        NSString *receiptName = self.userInfo[@"receiptName"] ? self.userInfo[@"receiptName"] : name;
        NSString *taxID = self.userInfo[@"taxID"] ? self.userInfo[@"taxID"] : @"";
        NSNumber *sameReceiptAddress = self.userInfo[@"sameReceiptAddress"] ? self.userInfo[@"sameReceiptAddress"] : @(NO);
        NSString *receiptAddress = self.userInfo[@"receiptAddress"] ? self.userInfo[@"receiptAddress"] : @"";
        
        NSNumber *saveCardInfo = self.userInfo[@"saveCardInfo"] ? self.userInfo[@"saveCardInfo"] : @(NO);
        NSString *cardName = self.userInfo[@"cardName"] ? self.userInfo[@"cardName"] : @"";
        NSString *cardNumber = self.userInfo[@"cardNumber"] ? self.userInfo[@"cardNumber"] : @"";
        NSString *cardExpireMonth = self.userInfo[@"cardExpireMonth"] ? self.userInfo[@"cardExpireMonth"] : @"";
        NSString *cardExpireYear = self.userInfo[@"cardExpireYear"] ? self.userInfo[@"cardExpireYear"] : @"";
        NSString *cardSecurityCode = self.userInfo[@"cardSecurityCode"] ? self.userInfo[@"cardSecurityCode"] : @"";
        
        [self saveUserInfoAddress:address
                         birthday:birthday
                            email:email
                             fcid:fcid
                           gender:gender
                             name:name
                            phone:phone
                       useReceipt:useReceipt
                      receiptName:receiptName
                            taxID:taxID
               sameReceiptAddress:sameReceiptAddress
                   receiptAddress:receiptAddress
                         password:password
                       autoSignIn:@(remember)
                     saveCardInfo:saveCardInfo
                         cardName:cardName
                       cardNumber:cardNumber
                  cardExpireMonth:cardExpireMonth
                   cardExpireYear:cardExpireYear
                 cardSecurityCode:cardSecurityCode];
        
        self.isSignedIn = YES;
        self.signedInDate = [NSDate date];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_SIGNED_IN_NOTIF"
                                                            object:self];
        
        if(success)
            success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.isSignedIn = NO;
        
        if(failure)
            failure(@"帳號/密碼不正確", error);
    }];
}

- (void)memberSignOut:(void (^)())success
              failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    self.isSignedIn = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_SIGNED_OUT_NOTIF"
                                                        object:self];
    
    // remove cookies here
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (NSHTTPCookie *cookie in cookies)
    {
        [cookieStorage deleteCookie:cookie];
        NSLog(@"deleted cookie");
    }
    
    if(success)
        success();
}

- (void)authenticateUser:(void (^)())success
                 failure:(void (^)(NSString *errorMessage, NSError *error))failure
                  signIn:(void (^)())signIn
{
    self.authCallbackSuccess = success;
    self.authCallbackFailure = failure;
    self.authCallbackSignIn = signIn;
    
    if(self.isSignedIn == NO)
    {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"會員系統"
                                                             message:@"請先登入"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"登入", nil] autorelease];
        
        alertView.tag = ALERT_VIEW_PROMPT_SIGN_IN;
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"會員系統"
                                                             message:@"輸入帳號密碼"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"確定", nil] autorelease];
        
        alertView.tag = ALERT_VIEW_PROMPT_AUTH;
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alertView show];
    }
}

- (void)saveUserInfoAddress:(NSString *)address
                   birthday:(NSString *)birthday
                      email:(NSString *)email
                       fcid:(NSNumber *)fcid
                     gender:(NSNumber *)gender
                       name:(NSString *)name
                      phone:(NSString *)phone
                 useReceipt:(NSNumber *)useReceipt
                receiptName:(NSString *)receiptName
                      taxID:(NSString *)taxID
         sameReceiptAddress:(NSNumber *)sameReceiptAddress
             receiptAddress:(NSString *)receiptAddress
                   password:(NSString *)password
                 autoSignIn:(NSNumber *)autoSignIn
               saveCardInfo:(NSNumber *)saveCardInfo
                   cardName:(NSString *)cardName
                 cardNumber:(NSString *)cardNumber
            cardExpireMonth:(NSString *)cardExpireMonth
             cardExpireYear:(NSString *)cardExpireYear
           cardSecurityCode:(NSString *)cardSecurityCode
{
    self.userInfo = @{
        @"address": address ? address : @"",
        @"birthday": birthday ? birthday : @"",
        @"email": email ? email : @"",
        @"fcid": fcid ? fcid : @(0),
        @"gender": gender ? gender : @(0),
        @"name": name ? name : @"",
        @"phone": phone ? phone : @"",
        @"useReceipt": useReceipt ? useReceipt : @(NO),
        @"receiptName": receiptName ? receiptName : @"",
        @"taxID": taxID ? taxID : @"",
        @"sameReceiptAddress": sameReceiptAddress ? sameReceiptAddress : @(NO),
        @"receiptAddress": receiptAddress ? receiptAddress : @"",
        @"password": password ? password : @"",
        @"autoSignIn": autoSignIn ? autoSignIn : @(NO),
        @"saveCardInfo": saveCardInfo ? saveCardInfo : @(NO),
        @"cardName": cardName ? cardName : @"",
        @"cardNumber": cardNumber ? cardNumber : @"",
        @"cardExpireMonth": cardExpireMonth ? cardExpireMonth : @"",
        @"cardExpireYear": cardExpireYear ? cardExpireYear : @"",
        @"cardSecurityCode": cardSecurityCode ? cardSecurityCode : @"",
    };
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:self.userInfo forKey:@"userdefaultUserInfo"];
    [df synchronize];
}

- (void)saveFCID:(NSNumber *)num
{
    self.fcid = num;
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:self.fcid forKey:@"userdefaultfcid"];
    [df synchronize];
}

#pragma mark - shopping cart related

- (void)addToTempCartProduct:(NSNumber *)pid count:(NSNumber *)count
{
    if(!self.cartTemp)
        self.cartTemp = [NSMutableDictionary dictionary];
    
    
    NSNumber *num = @(0);
    
    if(self.cartTemp[pid])
        num = self.cartTemp[pid];
    
    self.cartTemp[pid] = @(num.intValue + count.intValue);
}

- (void)addToRealCartProduct:(NSNumber *)pid
                       count:(NSNumber *)count
                   needLogin:(void (^)())login
                     success:(void (^)(int code, NSString *msg))success
                     failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    [self getLatestShoppingCart:^(int code, NSString *msg) {
        
        if(code == GET_CART_CODE_not_logged_in)
        {
            if(login)
                login();
        }
        else if(code == GET_CART_CODE_cart_not_exist)
        {
            [self addToTempCartProduct:pid count:count];
            [self createShoppingCart:success failure:failure];
        }
        else if(code == GET_CART_CODE_ok)
        {
            // find out current count and add to it
            NSNumber *updateCount = @(count.intValue);
            for(NSDictionary *p in self.cartReal[CART_KEY_products])
            {
                NSNumber *cartPid = p[CART_ITEM_KEY_pid];
                if([cartPid isEqualToNumber:pid])
                {
                    updateCount = @(count.intValue + [p[CART_ITEM_KEY_size] intValue]);
                    break;
                }
            }
            
            NSArray *items = @[@{@"pid":pid, @"size":updateCount}];
            
            [self updateShoppingCartWith:items index:0 success:^(int code, NSString *msg) {
                
                if(code == UPDATE_CART_CODE_db_add_success ||
                   code == UPDATE_CART_CODE_db_delete_success ||
                   code == UPDATE_CART_CODE_db_update_success)
                {
                    if(success)
                        success(code, @"加入購物車成功");
                }
                else
                {
                    if(failure)
                        failure(msg, nil);
                }
                
            } failure:failure];
        }
        
    } failure:failure];
}

- (void)processTempCart:(void (^)())success
              needLogin:(void (^)())login
                failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    /*
     - get latest cart from server
        - cart existed
            - go over all the items in the cart and compare with the temp cart
                - if item is on both temp cart and cart
                    - add the size from temp cart and update the cart and send to server
                - if item is on temp cart but not on cart
                    - modify the cart by adding the item to with size from temp cart
                - if item is on cart but on on temp cart
                    - do nothing
            - get the cart from server again at the end
        - cart does not exist
            - create cart with items from temp cart
     - clear items on temp cart
     */
    
    [self getLatestShoppingCart:^(int code, NSString *msg) {
        
        if(code == GET_CART_CODE_ok)
        {
            for(NSDictionary *p in self.cartReal[CART_KEY_products])
            {
                NSNumber *pid = p[CART_ITEM_KEY_pid];
                NSNumber *count = self.cartTemp[pid];
                if(count)
                    self.cartTemp[pid] = @(count.intValue + [p[CART_ITEM_KEY_size] intValue]);
            }
            
            // change cartTemp to array
            __block NSMutableArray *items = [NSMutableArray array];
            [self.cartTemp enumerateKeysAndObjectsUsingBlock:^(id pid, id count, BOOL *stop) {
                [items addObject:@{@"pid":pid, @"size":count}];
            }];
            
            if(items.count == 0 && self.cartReal.count == 0)
            {
                if(failure)
                    failure(@"購物車是空的", nil);
            }
            else
            {
                if(items.count)
                {
                    [self updateShoppingCartWith:items index:0 success:^(int code, NSString *msg){
                        
                        self.cartTemp = nil;
                        
                        [self getLatestShoppingCart:^(int code, NSString *msg) {
                            
                            if(success)
                                success();
                            
                            
                        } failure:^(NSString *errorMessage, NSError *error) {
                            
                            if(failure)
                                failure(errorMessage, error);
                            
                        }];
                        
                    } failure:^(NSString *errorMessage, NSError *error) {
                        
                        if(failure)
                            failure(errorMessage, error);
                    }];
                }
                else
                {
                    if(success)
                        success();
                }
            }
        }
        else if(code == GET_CART_CODE_cart_not_exist)
        {
            [self createShoppingCart:^(int code, NSString *msg) {
                
                if(success)
                    success();
                
            } failure:^(NSString *errorMessage, NSError *error) {
                
                if(failure)
                    failure(errorMessage, error);
                
            }];
            
        }
        else if(code == GET_CART_CODE_not_logged_in)
        {
            if(login)
                login();
        }
        else
        {
            if(failure)
                failure(msg, nil);
        }
        
    } failure:^(NSString *errorMessage, NSError *error) {
        
        if(failure)
            failure(errorMessage, error);
        
    }];
}

- (void)createShoppingCart:(void (^)(int code, NSString *msg))success
                   failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    if(!self.cartTemp)
    {
        if(failure)
            failure(@"購物車是空的", nil);
        
        return;
    }
    
    // change cartTemp to array
    __block NSMutableArray *array = [NSMutableArray array];
    [self.cartTemp enumerateKeysAndObjectsUsingBlock:^(id pid, id count, BOOL *stop) {
        [array addObject:@{@"pid":pid, @"size":count}];
    }];
    
    NSDictionary *params = @{
        @"products": array,
    };
    
    [self.httpClient postPath:@"Buy.svc/CartCreate" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        self.cartReal = [JSON[JSON_KEY_rsp] objectFromJSONString];
        
        NSLog(@"Buy.svc/CartCreate: %@", [self prettyPrintDict:self.cartReal]);
        
        // clear temp cart
        self.cartTemp = nil;
        
        int code = [JSON[JSON_KEY_code] intValue];
        NSString *msg = [JSON[JSON_KEY_msg] isKindOfClass:[NSNull class]] ? @"" : JSON[JSON_KEY_msg];
        
        if(code == CREATE_CART_CODE_success)
        {
            if(success)
                success(code, @"購物車建立成功");
        }
        else
        {
            if(failure)
                failure(msg, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"購物車建立失敗", error);
        
    }];
}

- (void)updateShoppingCartForPid:(NSNumber *)pid
                           count:(NSNumber *)count
                         success:(void (^)(int code, NSString *msg))success
                         failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    NSDictionary *params = @{
        @"orderid": self.cartReal[CART_KEY_orderid],
        @"pid": pid,
        @"count": count,
    };
    
    [self.httpClient postPath:@"Buy.svc/CartModify" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        
        NSLog(@"Buy.svc/CartModify: %@", [self prettyPrintDict:self.cartReal]);
        
        NSString *msg = [JSON[JSON_KEY_msg] isKindOfClass:[NSNull class]] ? @"" : JSON[JSON_KEY_msg];
        
        if(success)
            success([JSON[JSON_KEY_code] intValue], msg);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"更新購物車失敗", error);
        
    }];
}

- (void)updateShoppingCartWith:(NSArray *)items
                         index:(int)index
                       success:(void (^)(int code, NSString *msg))success
                       failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    [self updateShoppingCartForPid:items[index][CART_ITEM_KEY_pid]
                             count:items[index][CART_ITEM_KEY_size]
                           success:^(int code, NSString *msg) {
                               
                               if(index < items.count - 1)
                               {
                                   [self updateShoppingCartWith:items index:index + 1 success:success failure:failure];
                               }
                               else
                               {
                                   if(success)
                                       success(code, msg);
                               }
                               
                           } failure:failure];
}

/*
- (void)updateShoppingCartWith:(NSArray *)items
                         index:(int)index
                       success:(void (^)(int code, NSString *msg))success
                       failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    NSDictionary *params = @{
        @"orderid": self.cartReal[CART_KEY_orderid],
        @"pid": items[index][CART_ITEM_KEY_pid],
        @"count": items[index][CART_ITEM_KEY_size],
    };
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"更新購物車:%@ pid:%@ size:%@",
                                   params[@"orderid"],
                                   params[@"pid"],
                                   params[@"count"]]];
    
    [self.httpClient postPath:@"Buy.svc/CartModify" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        
        NSLog(@"Buy.svc/CartModify: %@", [self prettyPrintDict:self.cartReal]);
        
        NSString *msg = [JSON[JSON_KEY_msg] isKindOfClass:[NSNull class]] ? @"" : JSON[JSON_KEY_msg];
        
        if(index < items.count - 1)
        {
            [self updateShoppingCartWith:items index:index + 1 success:success failure:failure];
        }
        else
        {
            if(success)
                success([JSON[JSON_KEY_code] intValue], msg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"更新購物車失敗", error);
    }];
}
 */

- (void)getLatestShoppingCart:(void (^)(int code, NSString *msg))success
                      failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    [self.httpClient postPath:@"Buy.svc/GetLatestCart" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"Buy.svc/GetLatestCart: %@", JSON);
        
        int code = [JSON[JSON_KEY_code] intValue];
        NSString *msg = [JSON[JSON_KEY_msg] isKindOfClass:[NSNull class]] ? @"" : JSON[JSON_KEY_msg];
        
        if(code == GET_CART_CODE_ok)
        {            
            self.cartReal = [JSON[JSON_KEY_rsp] objectFromJSONString];
        }
        
        if(success)
            success(code, msg);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"購物車取得失敗", error);
        
    }];
}

- (void)getAllShoppingCarts:(void (^)(int code, NSString *msg))success
                    failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    [self.httpClient postPath:@"Buy.svc/GetAllCarts" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        NSLog(@"Buy.svc/GetAllCarts: %@", JSON);
        
        int code = [JSON[JSON_KEY_ok] intValue];
        NSString *msg = [JSON[JSON_KEY_msg] isKindOfClass:[NSNull class]] ? @"" : JSON[JSON_KEY_msg];
        
        if(code == GET_ALL_CARTS_ok)
        {
            self.allCarts = [JSON[JSON_KEY_rsp] objectFromJSONString];
            
            if(success)
                success(code, @"讀取成功");
        }
        else
        {
            if(failure)
                failure(msg, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"購物記錄取得失敗", error);
        
    }];
}

- (void)checkShoppingCart:(void (^)(int code, NSString *msg))success
                  failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    NSDictionary *params = @{
        @"orderid": self.cartReal[CART_KEY_orderid],
    };
    
    [self.httpClient postPath:@"Buy.svc/CartCheck" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"Buy.svc/CartCheck: %@", JSON);
        
        int code = [JSON[JSON_KEY_code] intValue];
        NSString *msg = [JSON[JSON_KEY_msg] isKindOfClass:[NSNull class]] ? @"" : JSON[JSON_KEY_msg];
        
        if(code == CART_CHECK_ok)
        {
            self.cartReal = [JSON[JSON_KEY_rsp] objectFromJSONString];
            
            if(success)
                success(code, msg);
        }
        else
        {
            if(failure)
                failure(msg, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"咬貨失敗", error);
        
    }];
}

- (void)submitPaymentForOrder:(NSString *)orderID
                        total:(NSString *)total
                         name:(NSString *)name
                      address:(NSString *)address
                        phone:(NSString *)phone
                     shiptime:(NSString *)shiptime
                         note:(NSString *)note
                        email:(NSString *)email
                       rtitle:(NSString *)rtitle
                      rnumber:(NSString *)rnumber
                     raddress:(NSString *)raddress
                 saveCardInfo:(BOOL)saveCardInfo
                       cardno:(NSString *)cardno
                        cardm:(NSString *)cardm
                        cardy:(NSString *)cardy
                         cvv2:(NSString *)cvv2
                      success:(void (^)(int code, NSString *msg))success
                      failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    NSDictionary *params = @{
        @"orderid": orderID,
        @"total": total,
        @"name": name,
        @"address": address,
        @"phone": phone,
        @"shiptime": shiptime,
        @"note": note,
        @"email": email,
        @"rtitle": rtitle,
        @"rnumber": rnumber,
        @"raddress": raddress,
        @"cardno": cardno,
        @"cardm": cardm,
        @"cardy": cardy,
        @"cvv2": cvv2,
    };
    
    if(saveCardInfo)
    {
        [self saveUserInfoAddress:self.userInfo[@"address"]
                         birthday:self.userInfo[@"birthday"]
                            email:self.userInfo[@"email"]
                             fcid:self.userInfo[@"fcid"]
                           gender:self.userInfo[@"gender"]
                             name:self.userInfo[@"name"]
                            phone:self.userInfo[@"phone"]
                       useReceipt:self.userInfo[@"useReceipt"]
                      receiptName:self.userInfo[@"receiptName"]
                            taxID:self.userInfo[@"taxID"]
               sameReceiptAddress:self.userInfo[@"sameReceiptAddress"]
                   receiptAddress:self.userInfo[@"receiptAddress"]
                         password:self.userInfo[@"password"]
                       autoSignIn:self.userInfo[@"autoSignIn"]
                     saveCardInfo:@(saveCardInfo)
                         cardName:name
                       cardNumber:cardno
                  cardExpireMonth:cardm
                   cardExpireYear:cardy
                 cardSecurityCode:cvv2];
    }
    
    BOOL debug = NO;
    if(debug)
    {
        if(success)
            success(0, [params description]);
        
        return;
    }
    
    [self.httpClient postPath:@"Buy.svc/CartCheckOut" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"Buy.svc/CartCheckOut: %@", JSON);
        
        int code = [JSON[JSON_KEY_code] intValue];
        NSString *msg = [JSON[JSON_KEY_msg] isKindOfClass:[NSNull class]] ? @"" : JSON[JSON_KEY_msg];
        
        if(code == CHECK_OUT_success)
        {
            if(success)
                success(code, @"訂單結帳成功");
        }
        else
        {
            if(failure)
                failure(msg, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"訂單結帳失敗", error);
        
    }];
}

#pragma mark - misc

- (NSString *)prettyPrintDict:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ALERT_VIEW_PROMPT_SIGN_IN)
    {
        if(buttonIndex == 0)
        {
            if(self.authCallbackFailure)
                self.authCallbackFailure(@"需要登入才能進行", nil);
        }
        else if (buttonIndex == 1)
        {
            if(self.authCallbackSignIn)
                self.authCallbackSignIn();
        }
    }
    else if (alertView.tag == ALERT_VIEW_PROMPT_AUTH)
    {
        if(buttonIndex == 0)
        {
            if(self.authCallbackFailure)
                self.authCallbackFailure(@"需要認證才能進行", nil);
        }
        else if (buttonIndex == 1)
        {
            UITextField *pwd = [alertView textFieldAtIndex:0];
            if([pwd.text isEqualToString:self.userInfo[@"password"]] == YES)
            {
                if(self.authCallbackSuccess)
                    self.authCallbackSuccess();
            }
            else
            {
                if(self.authCallbackFailure)
                    self.authCallbackFailure(@"密碼不對", nil);
            }
        }
    }
}

#pragma mark -
#pragma mark private methods

- (void)saveToUserDefaults:(id)value forKey:(NSString*)key
{
	if (standardUserDefaults) {
		[standardUserDefaults setObject:value forKey:key];
		[standardUserDefaults synchronize];
	} else {
		NSLog(@"Unable to save %@ = %@ to user defaults", key, [value description]);
	}
}

- (id)retrieveFromUserDefaults:(NSString*)key
{
	id val = [standardUserDefaults objectForKey:key];
    
	return val;
}


#pragma mark -
#pragma mark singleton implementation code

+ (EggAppManager *)sharedInstance {
	
	static dispatch_once_t pred;
	static EggAppManager *manager;
	
	dispatch_once(&pred, ^{ 
		manager = [[self alloc] init]; 
	});
	return manager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singletonManager == nil) {
            singletonManager = [super allocWithZone:zone];
            return singletonManager;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
