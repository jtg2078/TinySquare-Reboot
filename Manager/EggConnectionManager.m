//
//  EggConnectionManager.m
//  coredata04
//
//  Created by jason on 2011/8/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EggConnectionManager.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "NSString+JTGExt.h"
#import "Membership.h"

@interface EggConnectionManager ()
- (void)setupParameters;
- (void)initiateConnect;
- (void)initiateAuthenticateWithCtime:(NSString *)aCtime sessionId:(NSString *)aSessionId;
- (void)initiateUpdateWithSessionId:(NSString *)aSessionId;
- (NSString *)processKeyWithCtime:(NSString *)aCtime key:(NSString *)aKey;
@end


@implementation EggConnectionManager

#pragma mark -
#pragma mark @synthesize

@synthesize delegate;
@synthesize error;
@synthesize itemArray;
@synthesize item;
@synthesize loginheader;
@synthesize lastUpdateSuccessfulTime;
@synthesize updateItemCount;
@synthesize myDevictoken;

@synthesize obtainedFcid;
@synthesize managedObjectContext;
@synthesize loginCheck;

#pragma mark -
#pragma mark define

#define URL_CONNECT			@"http://ideaegg.com.tw/ideaegg/api_update/connect"
#define URL_AUTHENTICATE	@"http://ideaegg.com.tw/ideaegg/api_update/authenticate"
#define URL_UPDATE			@"http://ideaegg.com.tw/ideaegg/api_update/update"

/*
 #define URL_CONNECT			@"http://192.168.0.2/ideaegg/api_update/connect"
 #define URL_AUTHENTICATE	@"http://192.168.0.2/ideaegg/api_update/authenticate"
 #define URL_UPDATE			@"http://192.168.0.2/ideaegg/api_update/update"
 */
#define APPID				@"5" //@"4" //@"5"//@"2"  //@"5" //"2" //"4"
#define SECRET_TOKEN		@"testapp"
#define HEX_TO_DEC(h) (h < 'a' ? (h - '0'): (h - 'a' + 10))

#define API_URL_HOTPRODUCTS             @"http://api.ideaegg.com.tw/Product.svc/getAllHotProducts"
#define API_URL_PRODUCTS                @"http://api.ideaegg.com.tw/Product.svc/getProducts"
#define API_URL_SALESPRODUCTS           @"http://api.ideaegg.com.tw/Product.svc/getAllSalesProducts"
#define API_URL_PRODUCTS_FOR_CATEGORY   @"http://api.ideaegg.com.tw/Product.svc/getAllProductsInCategory"
#define API_URL_SINGLE_PRODUCT          @"http://api.ideaegg.com.tw/Product.svc/product/%@"
#define API_URL_CATEGORIES              @"http://api.ideaegg.com.tw/Category.svc/getCategoryList"
#define API_URL_SINGLE_CATEGORY         @"http://api.ideaegg.com.tw/Category.svc/category/%@"
#define API_URL_LOCATIONS               @"http://api.ideaegg.com.tw/Location.svc/getAllLocations"
#define API_URL_SINGLE_LOCATION         @"http://api.ideaegg.com.tw/Location.svc/location/{locationid}"
#define API_URL_ABOUT_ME                @"http://api.ideaegg.com.tw/App.svc/getApp"

#define API_URL_GET_FCID                @"http://api.ideaegg.com.tw/Member.svc/Init"
#define API_URL_REGISTER                @"http://api.ideaegg.com.tw/Member.svc/Register"
#define API_URL_LOGIN                   @"http://api.ideaegg.com.tw/Member.svc/Login"
#define API_URL_BUYLIST                 @"http://api.ideaegg.com.tw//Buy.svc/Cart"
#define API_URL_CHECKBILL               @"http://api.ideaegg.com.tw//Buy.svc/CheckOut"


#define API_APP_ID                      @"53"//@"1"
#define API_INPUT_APPID                 @"appid"
#define API_INPUT_PRODUCT_COUNT         @"n"
#define API_INPUT_CATEGORY_ID           @"categoryid"
#define API_INPUT_TAKE_COUNT            @"take"
#define API_INPUT_SKIP_COUNT            @"skip"
#define API_INPUT_PRODUCT_ID            @"productid"
#define API_INPUT_LOCATION_ID           @"locationid"



#define DEBUG_MODE                      1 == 2


#pragma mark -
#pragma mark public methods

- (id)init
{
	if(self = [super init]){
		[self setupParameters];
	} else {
		self = nil;
	}
	return self;
}


- (void)connectToEggWithTime:(NSString *)anTime
{
	[self initiateConnect];
	mTime = anTime;
}

- (void)dealloc 
{
	[error release];
	[itemArray release];
    [item release];
	[mTime release];
	[lastUpdateSuccessfulTime release];
	delegate = nil;
	dispatch_release(backgroundQueue);
	[super dealloc];
}

- (void)testConnect
{
    NSMutableDictionary *nameElements = [NSMutableDictionary dictionary];     
    [nameElements setObject:API_APP_ID forKey:@"appid"];  
    NSString* jsonString = [nameElements JSONString];
    
    //ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://api.ideaegg.com.tw/Category.svc/GetData"]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://api.ideaegg.com.tw/Category.svc/GetData"]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    
    
	//[request setPostValue:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"devid"];
	[request setCompletionBlock:^
	 {
         NSString *responseData = [request responseString];
		 
		 // parse json
		 NSError *parseError = nil;
		 //JSONDecoder *decoder = [JSONDecoder decoder];
		 NSDictionary *result = [responseData objectFromJSONString];
         NSLog(@"result is(raw): %@", [responseData description]);
         NSLog(@"result is(parsed): %@  error:%@", [result description], [parseError description]);
         
     }];
    [request setFailedBlock:^
	 {
         NSLog(@"error: %@",[request error]);
     }];
    [request startAsynchronous];
}

// for new api
- (void)connectToGetHotProducts
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];     
    [postData setObject:API_APP_ID forKey:API_INPUT_APPID];  
    NSString* postJSONString = [postData JSONString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_HOTPRODUCTS]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        // parse json
        //NSLog(@"raw string");
        //NSLog(@"%@", responseData);
        NSError *parseError = nil;
        NSArray *array = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        
        if(parseError == nil)
        {
            self.itemArray = array;
            if ([delegate respondsToSelector:@selector(connectToGetHotProductsFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetHotProductsFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
            if(DEBUG_MODE)
            {
                //NSLog(@"%@", [array description]);
                int i = 1;
                for(NSDictionary *product in self.itemArray)
                {
                    NSLog(@"item %d", i);
                    NSString *pName = [product objectForKey:@"name"];
                    NSLog(@"Name: %@", pName);
                    NSLog(@"%@", [product description]);
                    
                    NSString *jsString = [product objectForKey:@"extension"];
                    NSLog(@"jsonSpec string: %@", jsString);
                    
                    if([jsString length])
                    {
                        NSDictionary *jsonSpec = [jsString objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
                        
                        if(parseError == nil)
                        {
                            [jsonSpec enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                                NSString *sKey = (NSString *)key;
                                NSString *sValue = (NSString *)obj;
                                NSLog(@"key: %@ value: %@", sKey, sValue);
                            }];
                        }
                        else
                        {
                            NSLog(@"error while paring the extention:");
                            NSLog(@"%@", [parseError description]);
                        }
                    }
                    
                    // test image
                    for(NSDictionary *image in [product objectForKey:@"images"])
                    {
                        [image enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                            NSString *sKey = (NSString *)key;
                            NSString *sValue = (NSString *)obj;
                            NSLog(@"Image key: %@ Image value: %@", sKey, sValue);
                        }];
                    }
                    // ad image
                    [[product objectForKey:@"hotImage"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        NSString *sKey = (NSString *)key;
                        NSString *sValue = (NSString *)obj;
                        NSLog(@"Ad Image key: %@ Ad Image value: %@", sKey, sValue);
                    }];
                    
                    i++;
                }
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetHotProductsFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetHotProductsFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetHotProductsFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetHotProductsFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
}

- (void)connectToGetSingleProduct:(NSString *)productId
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];     
    [postData setObject:productId forKey:API_INPUT_PRODUCT_ID]; 
    NSString* postJSONString = [postData JSONString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_SINGLE_PRODUCT]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        
        NSError *parseError = nil;
        NSDictionary *obj = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        
        if(parseError == nil)
        {
            self.item = obj;
            
            if ([delegate respondsToSelector:@selector(connectToGetSingleProductFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetSingleProductFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetSingleProductFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetSingleProductFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetSingleProductFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetSingleProductFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
}

- (void)connectToGetProductWindowProducts:(int)count
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];     
    [postData setObject:API_APP_ID forKey:API_INPUT_APPID]; 
    [postData setObject:[NSString stringWithFormat:@"%d",count] forKey:API_INPUT_PRODUCT_COUNT];
    NSString* postJSONString = [postData JSONString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_PRODUCTS]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        
        NSError *parseError = nil;
        NSArray *array = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        
        if(parseError == nil)
        {
            self.itemArray = array;
            
            if ([delegate respondsToSelector:@selector(connectToGetProductWindowProductsFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetProductWindowProductsFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetProductWindowProductsFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetProductWindowProductsFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetProductWindowProductsFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetProductWindowProductsFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
}

- (void)connectToGetProductsForCategory:(NSString *)categoryId
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];     
    [postData setObject:categoryId forKey:API_INPUT_CATEGORY_ID]; 
    //[postData setObject:@"10" forKey:API_INPUT_PRODUCT_COUNT];
    NSString* postJSONString = [postData JSONString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_PRODUCTS_FOR_CATEGORY]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        
        NSError *parseError = nil;
        NSArray *array = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        NSLog(@"%@",array);
        
        if(parseError == nil)
        {
            self.itemArray = array;
            
            if ([delegate respondsToSelector:@selector(connectToGetProductsForCategoryFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetProductsForCategoryFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetProductsForCategoryFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetProductsForCategoryFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetProductsForCategoryFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetProductsForCategoryFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
}

- (void)connectToGetSingleCategory:(NSString *)categoryId
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];     
    [postData setObject:categoryId forKey:API_INPUT_CATEGORY_ID]; 
    NSString* postJSONString = [postData JSONString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_SINGLE_CATEGORY]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        
        NSError *parseError = nil;
        NSArray *array = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        //NSLog(@"%@",array);
        
        if(parseError == nil)
        {
            self.itemArray = array;
            
            if ([delegate respondsToSelector:@selector(connectToGetSingleCategoryFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetSingleCategoryFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetSingleCategoryFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetSingleCategoryFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetSingleCategoryFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetSingleCategoryFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
}

- (void)connectToGetCategories
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];     
    [postData setObject:API_APP_ID forKey:API_INPUT_APPID]; 
    NSString* postJSONString = [postData JSONString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_CATEGORIES]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        
        NSError *parseError = nil;
        NSArray *array = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        
        if(parseError == nil)
        {
            self.itemArray = array;
            
            if ([delegate respondsToSelector:@selector(connectToGetCategoriesFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetCategoriesFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetCategoriesFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetCategoriesFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetCategoriesFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetCategoriesFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
}

- (void)connectToGetSingleLocation:(NSString *)locationId
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];     
    [postData setObject:locationId forKey:API_INPUT_LOCATION_ID]; 
    NSString* postJSONString = [postData JSONString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_SINGLE_LOCATION]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        
        NSError *parseError = nil;
        NSArray *array = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        
        if(parseError == nil)
        {
            self.itemArray = array;
            
            if ([delegate respondsToSelector:@selector(connectToGetSingleLocationFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetSingleLocationFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetSingleLocationFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetSingleLocationFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetSingleLocationFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetSingleLocationFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
}

- (void)connectToGetLocations
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];     
    [postData setObject:API_APP_ID forKey:API_INPUT_APPID]; 
    NSString* postJSONString = [postData JSONString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_LOCATIONS]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        
        NSError *parseError = nil;
        NSArray *array = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        
        if(parseError == nil)
        {
            self.itemArray = array;
            
            if ([delegate respondsToSelector:@selector(connectToGetLocationsFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetLocationsFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetLocationsFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetLocationsFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetLocationsFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetLocationsFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
}

- (void)connectToGetAboutMe
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];     
    [postData setObject:API_APP_ID forKey:API_INPUT_APPID]; 
    NSString* postJSONString = [postData JSONString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_ABOUT_ME]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        
        NSError *parseError = nil;
        NSDictionary *obj = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
       
        
        if(parseError == nil)
        {
            self.item = obj;
            
            if ([delegate respondsToSelector:@selector(connectToGetAboutMeFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetAboutMeFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetAboutMeFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetAboutMeFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetAboutMeFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetAboutMeFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
}





//**************************



-(void) connectToGetFcid
{
    {
        
        //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         //(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

        
        NSMutableDictionary *postData = [NSMutableDictionary dictionary];  
        [postData setObject:API_APP_ID forKey:API_INPUT_APPID];
        [postData setObject:@"1" forKey:@"appversion"];
        //[postData setObject:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] forKey:@"appversion"];
        //[postData setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"imei"];
        //[postData setObject:@"e884b4161716aa9b7472ad47a331c708e4f09b6a" forKey:@"imei"];
        [postData setObject:@"imeifortesting" forKey:@"imei"];
        [postData setObject:@"2" forKey:@"platform"];
        //[postData setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osversion"];
        [postData setObject:@"5.1.1" forKey:@"osversion"];
        [postData setObject:@"zh_TW" forKey:@"country"];
        [postData setObject:@"" forKey:@"phone"];
        [postData setObject:@"" forKey:@"token"];
        [postData setObject:@"1" forKey:@"pushmessage"];
        
        
        NSString* postJSONString = [postData JSONString];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_GET_FCID]];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
        
        // response code
        [request setCompletionBlock:^{
            NSString *responseData = [request responseString];

            NSError *parseError = nil;
            //NSArray *array = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
            //parseError will go out for some reason, and the method has been modified as below
            
        
            
            if(parseError == nil)
            {
                self.obtainedFcid = responseData;
                
                if ([delegate respondsToSelector:@selector(connectToGetFcidFinished:)])
                {
                    [delegate performSelectorOnMainThread:@selector(connectToGetFcidFinished:) 
                                               withObject:self 
                                            waitUntilDone:[NSThread isMainThread]];
                }
            }
            else 
            {
                self.error = parseError;
                if ([delegate respondsToSelector:@selector(connectToGetFcidFailed:)])
                {
                    [delegate performSelectorOnMainThread:@selector(connectToGetFcidFailed:) 
                                               withObject:self 
                                            waitUntilDone:[NSThread isMainThread]];
                }
            }
        }];//
        
        [request setFailedBlock:^{
            self.error = [request error];
            if ([delegate respondsToSelector:@selector(connectToGetFcidFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetFcidFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }];
        
        // fire the quest
        [request startAsynchronous];
    }
    
}

-(void) connectToRegister:(NSMutableDictionary *)registerInfo
{
    {
        
        //Membership *m=[Membership getMemberIfExistWithId:0 inManagedObjectContext:self.managedObjectContext];
        
        NSMutableDictionary *postData = [NSMutableDictionary dictionaryWithDictionary:registerInfo];  
 
        [postData setObject:API_APP_ID forKey:@"appid"];
        NSString* postJSONString = [postData JSONString];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_REGISTER]];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
        
        // response code
        [request setCompletionBlock:^{
            NSString *responseData = [request responseString];
            
            
            NSError *parseError = nil;
            NSDictionary *obj = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];

            //NSLog(@"%@ , %@",obj,parseError);
            
            
            if(parseError == nil)
            {
                self.item = obj;
                
                if ([delegate respondsToSelector:@selector(connectToRegisterFinished:)])
                {
                    [delegate performSelectorOnMainThread:@selector(connectToRegisterFinished:) 
                                               withObject:self 
                                            waitUntilDone:[NSThread isMainThread]];
                    
                }
            }
            else 
            {
                self.error = parseError;
                if ([delegate respondsToSelector:@selector(connectToRegisterFailed:)])
                {
                    [delegate performSelectorOnMainThread:@selector(connectToRegisterFailed:) 
                                               withObject:self 
                                            waitUntilDone:[NSThread isMainThread]];
                }
            }
        }];//
        
        [request setFailedBlock:^{
            self.error = [request error];
            if ([delegate respondsToSelector:@selector(connectToRegisterFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToRegisterFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }];
        
        // fire the quest
        [request startAsynchronous];
    }
    
}



-(void) connectToLogin:(NSString *) account:(NSString *)pass;
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];  
    
    [postData setObject:API_APP_ID forKey:@"appid"];
    [postData setObject:account forKey:@"email"];
    [postData setObject:pass forKey:@"password"];
    NSString* postJSONString = [postData JSONString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_LOGIN]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        NSDictionary *header=[request responseHeaders];
        NSError *parseError = nil;
        NSDictionary *obj = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        
        if(parseError == nil)
        {
            self.loginCheck = @"true";
            self.loginheader=header;
            self.item=obj;
    
            if ([delegate respondsToSelector:@selector(connectToLoginFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToLoginFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
                
            }
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToLoginFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToLoginFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];//
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToLoginFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToLoginFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];

}




-(void)connectToGetBuylist:(NSMutableArray *)buyList loginMember:(NSString *)cookie
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary]; 
    [postData setObject:buyList forKey:@"products"];
    NSString* postJSONString = [postData JSONString];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [array addObject:cookie];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_BUYLIST]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Cookie" value:cookie];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"request header: %@",[request requestHeaders]);
    //NSLog(@"cookie: %@",cookie);
    //NSLog(@"postJSONString: %@",postJSONString);
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        NSError *parseError = nil;
        NSDictionary *obj = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        
        if(parseError == nil)
        {
            self.item=obj;
            //NSLog(@"result: %@",self.item);
            
            
                if ([delegate respondsToSelector:@selector(connectToGetBuylistFinished:)])
                {
                     [delegate performSelectorOnMainThread:@selector(connectToGetBuylistFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
                
                }
            
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetBuylistFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetBuylistFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];//
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetBuylistFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetBuylistFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
    
}


-(void) connectToGetCheckBill:(NSNumber *)orderId loginMember:(NSString *)cookie
{
    NSMutableDictionary *postData = [NSMutableDictionary dictionary]; 
    [postData setObject:orderId forKey:@"orderid"];
    NSString* postJSONString = [postData JSONString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_CHECKBILL]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Cookie" value:cookie];
    [request appendPostData:[postJSONString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"request header: %@",[request requestHeaders]);
    //NSLog(@"cookie: %@",cookie);
    //NSLog(@"postJSONString: %@",postJSONString);
    
    // response code
    [request setCompletionBlock:^{
        NSString *responseData = [request responseString];
        NSError *parseError = nil;
        NSDictionary *obj = [responseData objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&parseError];
        
        if(parseError == nil)
        {
            self.item=obj;
            //NSLog(@"result: %@",self.item);
            
            
            if ([delegate respondsToSelector:@selector(connectToGetCheckBillFinished:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetCheckBillFinished:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
                
            }
            
        }
        else 
        {
            self.error = parseError;
            if ([delegate respondsToSelector:@selector(connectToGetCheckBillFailed:)])
            {
                [delegate performSelectorOnMainThread:@selector(connectToGetCheckBillFailed:) 
                                           withObject:self 
                                        waitUntilDone:[NSThread isMainThread]];
            }
        }
    }];//
    
    [request setFailedBlock:^{
        self.error = [request error];
        if ([delegate respondsToSelector:@selector(connectToGetCheckBillFailed:)])
        {
            [delegate performSelectorOnMainThread:@selector(connectToGetCheckBillFailed:) 
                                       withObject:self 
                                    waitUntilDone:[NSThread isMainThread]];
        }
    }];
    
    // fire the quest
    [request startAsynchronous];
    

}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    myDevictoken=[[NSString alloc] initWithData:deviceToken encoding:NSASCIIStringEncoding];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)pushError
{
	NSLog(@"Failed to get token, error: %@", pushError);
}



#pragma mark -
#pragma mark private interface

- (void)setupParameters
{
	// set up background dispatch queue
	backgroundQueue = dispatch_queue_create("com.fingertipcreative.tinysquare.backgroundQueue", NULL);
}

- (void)initiateConnect
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_CONNECT]];
	[request setPostValue:APPID forKey:@"appid"];
	[request setPostValue:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"devid"];
	[request setCompletionBlock:^
	 {
		 NSData *responseData = [request responseData];
		 
		 // parse json
		 NSError *parseError = nil;
		 JSONDecoder *decoder = [JSONDecoder decoder];
		 NSDictionary *result = [decoder objectWithData:responseData error:&parseError];
		 
		 //if parse is successful
		 if(parseError == nil)
		 {
			 NSString *ctime =  [(NSNumber *)[result objectForKey:@"ctime"] stringValue];
			 NSString *sessionId = (NSString *)[result objectForKey:@"sessionid"];
			 
			 if([ctime length] == 0 || [sessionId length] == 0)
			 {
				 NSError *anError = [NSError errorWithDomain:@"ctime and/or sessionId is nil or empty" 
														code:1 
													userInfo:nil];
				 self.error = anError;
				 if ([delegate respondsToSelector:@selector(connectUpdateFailed:)])
				 {
					 [delegate performSelectorOnMainThread:@selector(connectUpdateFailed:) 
												withObject:self 
											 waitUntilDone:[NSThread isMainThread]];
				 }
			 }
			 else
			 {
				 [self initiateAuthenticateWithCtime:ctime sessionId:sessionId];
			 }
		 }
		 else
		 {
			 self.error = parseError;
			 if ([delegate respondsToSelector:@selector(connectUpdateFailed:)])
			 {
				 [delegate performSelectorOnMainThread:@selector(connectUpdateFailed:) 
											withObject:self 
										 waitUntilDone:[NSThread isMainThread]];
			 }
		 }
	 }];
	[request setFailedBlock:^
	 {
		 self.error = [request error];
		 if ([delegate respondsToSelector:@selector(connectUpdateFailed:)])
		 {
			 [delegate performSelectorOnMainThread:@selector(connectUpdateFailed:) 
										withObject:self 
									 waitUntilDone:[NSThread isMainThread]];
		 }
	 }];
	
	// start async
	[request startAsynchronous];
}

- (void)initiateAuthenticateWithCtime:(NSString *)aCtime sessionId:(NSString *)aSessionId
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_AUTHENTICATE]];
	// preparing secret
	NSString *secret = [NSString stringWithFormat:@"%@-%@", aCtime, SECRET_TOKEN];
	
	[request setPostValue:[secret md5InHexString]					forKey:@"secret"];
	[request setPostValue:aSessionId								forKey:@"sessionid"];
	[request setPostValue:aCtime									forKey:@"ctime"];
	[request setPostValue:[[UIDevice currentDevice] systemVersion]	forKey:@"devos"];
	[request setPostValue:[[UIDevice currentDevice] model]			forKey:@"devname"];
	[request setPostValue:@"so far so good"							forKey:@"remarks"];
	
	[request setCompletionBlock:^
	 {
		 NSData *responseData = [request responseData];
		 
		 // parse json
		 NSError *parseError = nil;
		 JSONDecoder *decoder = [JSONDecoder decoder];
		 NSDictionary *result = [decoder objectWithData:responseData error:&parseError];
		 
		 //if parse is successful
		 if(parseError == nil)
		 {
			 NSString *rawKey = (NSString *)[result objectForKey:@"key"];
			 
			 if([rawKey length] == 0)
			 {
				 NSError *anError = [NSError errorWithDomain:@"raw key is nil or empty" 
														code:1 
													userInfo:nil];
				 self.error = anError;
				 if ([delegate respondsToSelector:@selector(connectUpdateFailed:)])
				 {
					 [delegate performSelectorOnMainThread:@selector(connectUpdateFailed:) 
												withObject:self 
											 waitUntilDone:[NSThread isMainThread]];
				 }
			 }
			 else
			 {
				 cipherKey = [[self processKeyWithCtime:aCtime key:rawKey] retain];
				 [self initiateUpdateWithSessionId:aSessionId];
			 }
		 }
		 else
		 {
			 self.error = parseError;
			 if ([delegate respondsToSelector:@selector(connectUpdateFailed:)])
			 {
				 [delegate performSelectorOnMainThread:@selector(connectUpdateFailed:) 
											withObject:self 
										 waitUntilDone:[NSThread isMainThread]];
			 }
		 }
	 }];
	[request setFailedBlock:^
	 {
		 self.error = [request error];
		 if ([delegate respondsToSelector:@selector(connectUpdateFailed:)])
		 {
			 [delegate performSelectorOnMainThread:@selector(connectUpdateFailed:) 
										withObject:self 
									 waitUntilDone:[NSThread isMainThread]];
		 }
	 }];
	
	// start async
	[request startAsynchronous];
}

- (void)initiateUpdateWithSessionId:(NSString *)aSessionId
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_UPDATE]];
	[request setPostValue:aSessionId forKey:@"sessionid"];
	[request setPostValue:mTime forKey:@"utime"];
	
	[request setCompletionBlock:^
	 {
		 dispatch_async(backgroundQueue, ^(void) {
			 // parse json
			 NSData *responseData = [request responseData];
			 NSError *parseError = nil;
			 JSONDecoder *decoder = [JSONDecoder decoder];
			 NSDictionary *result = [decoder objectWithData:responseData error:&parseError];
			 
			 // if parse is successful
			 if(parseError == nil)
			 {
				 NSString *encrypted = (NSString *)[result objectForKey:@"eggs"];
				 NSNumber *updatedTime = (NSNumber *)[result objectForKey:@"mtime_max"];
				 self.lastUpdateSuccessfulTime = [updatedTime stringValue];
				 NSNumber *count = [result objectForKey:@"count"];
				 self.updateItemCount = 0;
				 
				 if(count != nil && [count intValue] > 0)
				 {
					 self.updateItemCount = [count intValue];
					 // decrypting content
					 NSString *key = cipherKey;
					 NSString *iv = aSessionId;
					 NSData *decrypted = [encrypted decryptHexStringWithKey:key iv:iv];
					 //NSString *decryptedString = [NSString stringWithUTF8String:[decrypted bytes]];
					 // parse decrypted content into json again
					 //NSArray *array = [decryptedString objectFromJSONStringWithParseOptions:JKParseOptionNone error:&parseError];
					 NSArray *array = [decrypted objectFromJSONDataWithParseOptions:JKParseOptionPermitTextAfterValidJSON error:&parseError];
					 
					 if(parseError == nil)
					 {
						 self.itemArray = array;
						 if ([delegate respondsToSelector:@selector(connectUpdateFinished:)])
						 {
							 [delegate performSelectorOnMainThread:@selector(connectUpdateFinished:) 
														withObject:self 
													 waitUntilDone:[NSThread isMainThread]];
						 }
					 }
					 else 
					 {
						 self.error = parseError;
						 if ([delegate respondsToSelector:@selector(connectUpdateFailed:)])
						 {
							 [delegate performSelectorOnMainThread:@selector(connectUpdateFailed:) 
														withObject:self 
													 waitUntilDone:[NSThread isMainThread]];
						 }
					 }
				 }
				 else {
					 self.itemArray = nil;
					 if ([delegate respondsToSelector:@selector(connectUpdateFinished:)])
					 {
						 [delegate performSelectorOnMainThread:@selector(connectUpdateFinished:) 
													withObject:self 
												 waitUntilDone:[NSThread isMainThread]];
					 }
				 }
			 }
			 else
			 {
				 self.error = parseError;
				 if ([delegate respondsToSelector:@selector(connectUpdateFailed:)])
				 {
					 [delegate performSelectorOnMainThread:@selector(connectUpdateFailed:) 
												withObject:self 
											 waitUntilDone:[NSThread isMainThread]];
				 }
			 }
		 });
	 }];
	[request setFailedBlock:^
	 {
		 self.error = [request error];
		 if ([delegate respondsToSelector:@selector(connectUpdateFailed:)])
		 {
			 [delegate performSelectorOnMainThread:@selector(connectUpdateFailed:) 
										withObject:self 
									 waitUntilDone:[NSThread isMainThread]];
		 }
	 }];
	
	// start async
	[request startAsynchronous];
}

- (NSString *)processKeyWithCtime:(NSString *)aCtime key:(NSString *)aKey 
{	
	int s = [aCtime longLongValue] % 60;
	
	// processing byte and apply the formula
	const char *pos = [aKey cStringUsingEncoding:NSUTF8StringEncoding];
	int len = [aKey length] / 2;
	unsigned char buffer[len];
	NSMutableString *keyInStr = [NSMutableString stringWithCapacity:len];
	
	for(int i = 0; i < len; i++){
		int num = HEX_TO_DEC(*pos) << 4;
		pos++;
		num+= HEX_TO_DEC(*pos);
		pos++;
		buffer[i] = (num + 256 - s) % 256;
		[keyInStr appendFormat:@"%02x",buffer[i]];
	}
	return keyInStr;
}

@end
