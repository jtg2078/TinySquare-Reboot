//
//  ProductImageViewControllerEx.h
//  TinyStore
//
//  Created by jason on 2011/9/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ProductImagePageControlDelegate.h"

@class ProductImagePageControl;
@interface ProductImageViewController : BaseViewController <UIScrollViewDelegate, ProductImagePageControlDelegate> 
{
    // the main controls
	UIScrollView *scrollView;
	ProductImagePageControl *pageControl;
	UILabel *titleLabel;
	
	// content of each page
	NSMutableArray *viewControllers;
	NSArray *contentList;
	NSUInteger kNumberOfPages;
	
	// to be used when scrolls came from UIPageControl
	BOOL pageControlUsed;
}

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *contentList;

@end