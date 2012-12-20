//
//  BookmarkViewControllerPad.h
//  tinysquare
//
//  Created by  on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface BookmarkViewControllerPad : UIViewController <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, retain) AQGridView *gridView;

@end
