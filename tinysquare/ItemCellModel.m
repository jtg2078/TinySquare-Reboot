//
//  ProductCellModel.m
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemCellModel.h"

@implementation ItemCellModel

@synthesize itemId;
@synthesize productType;
@synthesize cellStyle;
@synthesize title;
@synthesize content1;
@synthesize content2;
@synthesize content3;
@synthesize image;
@synthesize imageUrl;

- (void)dealloc 
{	
	[title release];
	[content1 release];
	[content2 release];
    [content3 release];
	[image release];
	[imageUrl release];
	[super dealloc];
}
@end
