//
//  ProductWindowScrollViewController.h
//  tinysquare
//
//  Created by  on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PageControlDelegate.h"


@class PageControl;
@class MasonryLayoutManager2;
@class ProductDetailViewControllerPad;
@interface ProductWindowScrollViewControllerPad : BaseViewController <UIScrollViewDelegate, PageControlDelegate> {
	// the main controls
	UIScrollView *scrollView;
	PageControl *pageControl;
	
	// content of each page
	NSMutableArray *viewControllers;
	NSUInteger kNumberOfPages;
	
	// to be used when scrolls came from UIPageControl
	BOOL pageControlUsed;
}

@property (nonatomic, retain) PageControl *pageControl;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@property (nonatomic, retain) MasonryLayoutManager2 *layoutManager;
@property (nonatomic, retain) ProductDetailViewControllerPad *productDetailViewController;

- (void)updateCurrentPageDetail:(int)page;
- (void)showDetailViewController;

@end
