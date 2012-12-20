//
//  ProductImagePageControlDelegate.h
//  TinyStore
//
//  Created by jason on 2011/9/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductImagePageControl;
@protocol ProductImagePageControlDelegate
@optional
- (void)pageControlPageDidChange:(ProductImagePageControl *)thePageControl;
@end
