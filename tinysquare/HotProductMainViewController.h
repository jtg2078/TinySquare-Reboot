//
//  HotProductMainViewController.h
//  TinyStore
//
//  Created by jason on 2011/9/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PageControlDelegate.h"
#import "EggApiManagerDelegate.h"

@class PageControl;
@class MKInfoPanel;
@interface HotProductMainViewController : BaseViewController <UIScrollViewDelegate, NSFetchedResultsControllerDelegate, PageControlDelegate, EggApiManagerDelegate> {
	// the main controls
	UIScrollView *scrollView;
	PageControl *pageControl;
    MKInfoPanel *panel;
	
	// content of each page
	NSMutableArray *viewControllers;
	NSUInteger kNumberOfPages;
	
	// to be used when scrolls came from UIPageControl
	BOOL pageControlUsed;
	
	// core data
	NSManagedObjectContext *managedObjectContext;
    int totalItemCount;
	int currentItemId;
	NSString* currentItemName;
    int reloadAttempt;
    NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) PageControl *pageControl;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSDate *lastUpdateTime;

- (void)updateCurrentPageDetail:(int)page;

@end
