//
//  ProductCell.h
//  TinyStore
//
//  Created by jason on 2011/9/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FastCell.h"

@class ItemCellModel;
@interface ItemCell : FastCell {
	NSDictionary *info;
	NSString *imageURL;
    UIImage *cellImage;
}

@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, retain) UIImage *cellImage;
@property (nonatomic, retain) NSString* imageURL;

- (void)updateCellInfo: (NSDictionary *)aInfo;
- (void)imageLoaded:(UIImage *)image withURL:(NSString *)url;

@end
