//
//  ReadyToCheckViewController.h
//  asoapp
//
//  Created by wyde on 12/6/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "EggApiManager.h"

@interface ReadyToCheckViewController : BaseViewController<EggApiManagerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
