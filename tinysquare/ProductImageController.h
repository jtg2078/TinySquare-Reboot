//
//  ProductImageController.h
//  TinyStore
//
//  Created by jason on 2011/9/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface ProductImageController : BaseViewController {
	NSString *imageName;
	
	// UI controls
	UIImageView *productImage;
}

@property (nonatomic, retain) UIImageView *productImage;

- (id)initWithImageName:(NSString *)name;
- (void)populateProductDetailAsync;

@end
