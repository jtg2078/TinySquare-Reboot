//
//  ProductImagePageControl.h
//  TinyStore
//
//  Created by jason on 2011/9/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductImagePageControlDelegate;
@interface ProductImagePageControl : UIView {
    NSInteger currentPage;
    NSInteger numberOfPages;
	NSMutableArray *pageIcons;
    UIImage *iconFrameCurrentPage;
    UIImage *iconFrameOtherPage;
    NSObject<ProductImagePageControlDelegate> *delegate;
}

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, retain) UIImage *iconFrameCurrentPage;
@property (nonatomic, retain) UIImage *iconFrameOtherPage;
@property (nonatomic, retain) NSMutableArray *pageIcons;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, assign) NSObject<ProductImagePageControlDelegate> *delegate;

- (void)setPageIcon:(UIImage *)image forPage:(int)pageIndex;
- (void)setupPageControl:(int)pageCount;


@end