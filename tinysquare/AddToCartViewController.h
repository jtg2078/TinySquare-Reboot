//
//  AddToCartViewController.h
//  asoapp
//
//  Created by wyde on 12/5/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseListViewcontroller.h"
#import <UIKit/UIKit.h>
#import	<MessageUI/MessageUI.h>
#import "BaseCartViewController.h"


@interface AddToCartViewController : BaseCartViewController <MFMailComposeViewControllerDelegate> {
    
}

- (void)loadSavedProducts;
- (void)shareBookmarks;



@end
