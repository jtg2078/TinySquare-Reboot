//
//  ProductCellModel.h
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ProductCellStylePlain,
	ProductCellStyleCustomized
} ProductCellStyle;

typedef enum {
	ProductCellTypeProduce,
    ProductCellTypeLocation,
    ProductCellTypeRecipe
} ProductCellType;

@interface ItemCellModel : NSObject {
	int itemId;
	ProductCellType productType;
	ProductCellStyle cellStyle;
	NSString *title;
	NSString *content1;
	NSString *content2;
    NSString *content3;
	UIImage *image;
	NSString *imageUrl;
}

@property (nonatomic) int itemId;
@property (nonatomic) ProductCellType productType;
@property (nonatomic) ProductCellStyle cellStyle;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *content1;
@property (nonatomic,retain) NSString *content2;
@property (nonatomic,retain) NSString *content3;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) NSString *imageUrl;

@end
