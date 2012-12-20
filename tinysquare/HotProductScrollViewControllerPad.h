//
//  HotProductScrollViewControllerPad.h
//  tinysquare
//
//  Created by  on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PageControlDelegate.h"

@class PageControl;
@class ProductDetailViewControllerPad;
@interface HotProductScrollViewControllerPad : BaseViewController <UIScrollViewDelegate, PageControlDelegate, UIGestureRecognizerDelegate> {
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

@property (nonatomic, retain) UIImageView* logoImageView;
@property (nonatomic, retain) UIWebView* descriptionWebView;
@property (nonatomic, retain) ProductDetailViewControllerPad *productDetailViewController;

- (void)updateCurrentPageDetail:(int)page;

@end
