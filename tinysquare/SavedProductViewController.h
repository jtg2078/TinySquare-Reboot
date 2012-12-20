//
//  SavedProductViewController.h
//  TinyStore
//
//  Created by jason on 2011/9/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	<MessageUI/MessageUI.h>
#import "BaseListViewcontroller.h"
#import "JTRevealSidebarV2Delegate.h"

@class SidebarViewController;

@interface SavedProductViewController : BaseListViewcontroller <MFMailComposeViewControllerDelegate,JTRevealSidebarV2Delegate> {

}

@property (nonatomic, strong) SidebarViewController *leftSidebarViewController;
@property (nonatomic, strong) NSIndexPath *leftSelectedIndexPath;
@property (nonatomic, strong) UITableView *rightSidebarView;



- (void)loadSavedProducts;
- (void)shareBookmarks;

@end