//
//  DetailCellDescriptor.m
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailCellModel.h"

@implementation DetailCellModel


#pragma mark -
#pragma mark synthesize

@synthesize cellType;
@synthesize selectedResponse;
@synthesize title;
@synthesize displayContent;
@synthesize actualContent;
@synthesize contentHeight;
@synthesize totalHeight;
@synthesize hasAccessory;
@synthesize photos;
@synthesize lat;
@synthesize lon;
@synthesize shareUsing;
@synthesize inRed;
@synthesize images;
@synthesize miscContents;
@synthesize contentStartPointX;
@synthesize titleHeight;
@synthesize productId;


#pragma mark -
#pragma mark constructor and destructor

- (id)init 
{
	if(self = [super init])
	{
		cellType = CellTypeUninitialized;
		selectedResponse = CellSelectedResponseNone;
		title = nil;
		displayContent = nil;
		contentHeight = 0;
		totalHeight = 0;
		hasAccessory = NO;
		photos = nil;
		lat = 0;
		lon = 0;
        contentStartPointX = 0;
        titleHeight = 0;
        productId=0;
	}
	else 
	{
		self = nil;
	}
	return self;
}

- (void)dealloc 
{
	[title release];
	[displayContent release];
    [actualContent release];
	[photos release];
	[images release];
    [miscContents release];
    [productid release];
	[super dealloc];
}

@end
