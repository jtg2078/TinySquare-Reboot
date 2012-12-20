//
//  ProductWindowViewControllerEx.h
//  TinyStore
//
//  Created by jason on 2011/9/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewcontroller.h"
#import "EggApiManagerDelegate.h"
#import "EGORefreshTableHeaderView.h"
#import "WEPopoverController.h"
#import "JTRevealSidebarV2Delegate.h"


@class EggConnectionManager;
@interface ProductWindowViewController : BaseListViewcontroller <EGORefreshTableHeaderDelegate, EggApiManagerDelegate, WEPopoverControllerDelegate,JTRevealSidebarV2Delegate> {
	// pull to refresh code
	EGORefreshTableHeaderView *refreshTableHeaderView;
    BOOL isReloading;
    Class popoverClass;
}

@property (nonatomic, retain) UIButton* categoryButton;
@property (nonatomic, retain) UIBarButtonItem *categoryBarButton;
@property (nonatomic, retain) WEPopoverController *popoverController;
@property (nonatomic, retain) NSPredicate *predicate;

- (void)loadProducts;
- (void)changeCategoryWithId:(NSNumber *)categoryId categoryName:(NSString *)categoryName;

@end
