//
//  HotProductDetailViewController.h
//  TinyStore
//
//  Created by jason on 2011/9/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface HotProductDetailViewController : BaseViewController {
	int itemId;
	
	// UI controls
	UIButton *productImage;
	UILabel *productName;
	UILabel *productTime;
    UILabel *priceTitle;
	UILabel *productPrice;
    UILabel *productOriginalPrice;
	UILabel *productSummary;
	
	// core data
	
    NSString *adImagePath;
}

@property (nonatomic, retain) UIButton *productImage;
@property (nonatomic, retain) UILabel *productName;
@property (nonatomic, retain) UILabel *productTime;
@property (nonatomic, retain) UILabel *priceTitle;
@property (nonatomic, retain) UILabel *productPrice;
@property (nonatomic, retain) UILabel *productOriginalPrice;
@property (nonatomic, retain) UILabel *productSummary;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *adImagePath;

- (id)initWithProductIdentifier:(int)anId;

- (void)displayProductWithId:(int)anId;

@end
