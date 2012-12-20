//
//  DetailViewController.h
//  TinyStore
//
//  Created by jason on 2011/9/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BaseDetailViewController.h"




@interface DetailViewController : BaseDetailViewController <MFMailComposeViewControllerDelegate> {

}

- (void)loadContentAsync;



@end