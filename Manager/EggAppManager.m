//
//  EggAppManager.m
//  NTIFO
//
//  Created by  on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EggAppManager.h"

@interface EggAppManager ()
- (void)saveToUserDefaults:(id)value forKey:(NSString*)key;
- (id)retrieveFromUserDefaults:(NSString*)key;
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


#pragma mark -
#pragma mark synthesize


#pragma mark -
#pragma mark initialization and deallocation

- (id)init
{
	if(self = [super init]) {
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
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
    /*
	// TODO: / apparent Apple bug: if user hasn't opened Settings for this app yet (as if?!), then
	// the defaults haven't been copied in yet.  So do so here.  Adds another null check
	// for every retrieve, but should only trip the first time
	if (val == nil) { 
		NSLog(@"user defaults may not have been loaded from Settings.bundle ... doing that now ...");
		//Get the bundle path
		NSString *bPath = [[NSBundle mainBundle] bundlePath];
		NSString *settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
        
		//Get the Preferences Array from the dictionary
		NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
		NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
		//Loop through the array
		NSDictionary *item;
		for(item in preferencesArray)
		{
			//Get the key of the item.
			NSString *keyValue = [item objectForKey:@"Key"];
            
			//Get the default value specified in the plist file.
			id defaultValue = [item objectForKey:@"DefaultValue"];
            
			if (keyValue && defaultValue) {				
				[standardUserDefaults setObject:defaultValue forKey:keyValue];
			}
		}
		[standardUserDefaults synchronize];
	}
    
    
    if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:key];
      */
    
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
