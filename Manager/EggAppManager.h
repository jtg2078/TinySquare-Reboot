//
//  EggAppManager.h
//  NTIFO
//
//  Created by  on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EggAppManager : NSObject {
    NSUserDefaults *standardUserDefaults;
}

- (void)setupInstalledDate;
- (void)setupAppVersionNumber;
- (void)updateInfoLastUpdatedTime:(NSDate *)date;
- (void)updateInfoCoreDataItemCount:(int)count;
- (BOOL)showIntroMovieClip;
- (BOOL)allowReportUsage;
- (BOOL)allowReportCrash;


+ (EggAppManager *)sharedInstance; // Singleton method

@end
