//
//  MemberManager.m
//  asoapp
//
//  Created by wyde on 12/5/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MemberManager.h"
#import "Membership.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "DataManager.h"
//#import "NSString+JTGExt.h"


//static MemberManager* singletonManager = nil;


#define API_URL_GET_FCID                @"http://api.ideaegg.com.tw/Member.svc/Init"
#define API_INPUT_APPID                 @"appid"

@implementation MemberManager

-(void) updateFcidComplete
{
    //in EggAppManagerDelegate
}

-(void) updateFcidFailed
{
    //in EggAppManagerDelegate
}


-(void)connectToGetFcidFinished
{
    //in EggAppManager
}

-(void) connectToGetFcidFailed
{
    //in EggAppManager
}

-(void) updateFcid
{
    //in EggAppManager
}

-(void)updateFicdAsync
{
    //in EggAppManager
}

-(void)importFcid
{
    //in DataManager
}

-(void)parseAndImportFcid
{
    //in DataManager
}



#pragma mark -
#pragma mark register part

//create myself
-(BOOL) ifRegisterSucess
{
    BOOL registerSucessOrNot=NO;
    return registerSucessOrNot;
}




/*
#pragma mark -
#pragma mark main connect

//main connection
-(void) connectToGetFcid
{
    {
        
        NSMutableDictionary *postData = [NSMutableDictionary dictionary];  
        //[postData setObject:appid forKey:API_APP_ID];
        [postData setObject:API_APP_ID forKey:API_INPUT_APPID];
        [postData setObject:[NSString stringWithFormat:@"%d",[NSBundle version]] forKey:@"appversion"];
        [postData setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"imei"];
        [postData setObject:@"2" forKey:@"platform"];
        [postData setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osversion"];
        [postData setObject:@"zh_TW" forKey:@"country"];
        [postData setObject:@"0912345678" forKey:@"phone"];
        [postData setObject:@"1234567890987654321" forKey:@"token"];
        [postData setObject:@"1" forKey:@"pushmessage"];
        NSString* postJSONString = [postData JSONString];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_URL_GET_FCID]];
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
        }];
        
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

- (void)connectToGetFcidFinished:(MemberManager *)manager
{
    if(self.isAsyncUpdatingFcid == YES)
    {
        
    }
    else
    {
        DataManager *dm = [[DataManager alloc] initWithMoc:managedObjectContext];
        [dm parseAndImportAboutMe:[manager item]];
        [dm release];
        
        if ([updateFcidDelegate respondsToSelector:@selector(updateFcidCompleted:)])
        {
            [updateFcidDelegate performSelectorOnMainThread:@selector(updateFcidCompleted:) withObject:self waitUntilDone:[NSThread isMainThread]];
        }
        self.isUpdatingAboutMe = NO;
    }
}

- (void)connectToGetFcidFailed:(MemberManager *)manager
{
    self.updateFcidError = [manager error];
    self.isUpdatingFcid = NO;
    
	if ([updateFcidDelegate respondsToSelector:@selector(updateFcidFailed:)])
	{
		[updateFcidDelegate performSelectorOnMainThread:@selector(updateFcidFailed:) withObject:self waitUntilDone:[NSThread isMainThread]];
	}
}




#pragma mark -
#pragma mark singleton implementation code

+ (MemberManager *)sharedInstance {
	
	static dispatch_once_t pred;
	static MemberManager *manager;
	
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


*/


@end
