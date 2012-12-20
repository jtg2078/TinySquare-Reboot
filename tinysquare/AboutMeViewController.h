//
//  AboutMeViewControllerEx.h
//  TinyStore
//
//  Created by jason on 2011/9/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDetailViewController.h"
#import "EggApiManagerDelegate.h"

@interface AboutMeViewController : BaseDetailViewController <EggApiManagerDelegate> {

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSDate *lastUpdateTime;

- (void)loadContentAsync;

@end
