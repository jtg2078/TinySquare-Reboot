//
//  CartItemCell.h
//  asoapp
//
//  Created by wyde on 12/5/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FastCell.h"

@class ItemCellModel;
@interface CartItemCell : FastCell {
	NSDictionary *info;
	NSString *imageURL;
    UIImage *cellImage;
    NSNumber *itemCount;
}

@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, retain) UIImage *cellImage;
@property (nonatomic, retain) NSString* imageURL;
@property (nonatomic, retain) NSNumber* itemCount;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)updateCellInfo: (NSDictionary *)aInfo;
- (void)imageLoaded:(UIImage *)image withURL:(NSString *)url;

@end
