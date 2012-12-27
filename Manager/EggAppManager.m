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
        @"appid": API_APP_ID,
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
        @"appid": API_APP_ID,
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
                       autoSignIn:self.userInfo[@"autoSignIn"]];
        
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
                       autoSignIn:self.userInfo[@"autoSignIn"]];
        
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
        @"appid": API_APP_ID,
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
                       autoSignIn:@(remember)];
        
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
{
    self.userInfo = @{
        @"address": address,
        @"birthday": birthday,
        @"email": email,
        @"fcid": fcid,
        @"gender": gender,
        @"name": name,
        @"phone": phone,
        @"useReceipt": useReceipt,
        @"receiptName": receiptName,
        @"taxID": taxID,
        @"sameReceiptAddress": sameReceiptAddress,
        @"receiptAddress": receiptAddress,
        @"password": password,
        @"autoSignIn": autoSignIn,
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

- (void)addToCartProduct:(NSNumber *)pid count:(NSNumber *)count
{
    if(!self.cartTemp)
        self.cartTemp = [NSMutableDictionary dictionary];
    
    
    NSNumber *num = @(0);
    
    if(self.cartTemp[pid])
        num = self.cartTemp[pid];
    
    self.cartTemp[pid] = @(num.intValue + count.intValue);
}

- (void)createShoppingCart:(void (^)())success
                   failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    if(!self.cartTemp)
    {
        if(failure)
            failure(@"購物車是空的", nil);
        
        return;
    }
    
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
        
        self.cartReal = JSON;
        
        NSLog(@"Buy.svc/CartCreate: %@", [self prettyPrintDict:self.cartReal]);
        
        // clear temp cart
        self.cartTemp = nil;
        
        if(success)
            success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"購物車建立失敗", error);
        
    }];
}

- (void)updateShoppingCart
{
    
}

- (void)getLatestShoppingCart:(void (^)())success
                      failure:(void (^)(NSString *errorMessage, NSError *error))failure
{
    [self.httpClient postPath:@"Buy.svc/GetLatestCart" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"Buy.svc/GetLatestCart: %@", JSON);
        
        if(success)
            success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(@"購物車取得失敗", error);
        
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
