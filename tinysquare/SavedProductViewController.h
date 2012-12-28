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
#import "ShoppingCartViewController.h"

@interface SavedProductViewController : BaseListViewcontroller <MFMailComposeViewControllerDelegate> {

}

@property (nonatomic, retain) ShoppingCartViewController *shoppingCartVC;

- (void)loadSavedProducts;
- (void)shareBookmarks;

@end