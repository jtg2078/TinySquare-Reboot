//
//  DetailCellDescriptor.h
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	CellTypeUninitialized,
	CellTypeWaiting,
    CellTypeSingleLineCenterNoTitle,
	CellTypeSingleLine2WordTitle,
    CellTypeSingleLine3WordTitle,
    CellTypeSingleLineMultiWordTitle,
    CellTypeMultiLine2WordTitle,
    CellTypeMultiLine4WordTitle,
	CellTypeMultiLineStandAloneTitle,
	CellTypeMultiLineNoTitle,
    CellTypeMultiLineMultiWordTitle,
	CellTypeTitleAndImages,
	CellTypeTitleAndImagesStatic,
    CellTypeTitleAndImagesEnhanced,
	CellTypeAddressAndMap,
	CellTypeSocialAndShare,
    CellTypeCustomAttribute,
    CellTypeCustomTags,
    CellTypeAboutMeTitleAndImages,
} CellType;

typedef enum {
	CellSelectedResponseNone,
	CellSelectedResponseCall,
    CellSelectedResponseOpenInSafari,
    CellSelectedResponseOpenInMap,
	CellSelectedResponseOpenInImageBrowser,
    CellSelectedResponseSharing,
    CellSelectedResponseMultiPurpose,
    CellSelectedResponseEmail,
} CellSelectedResponse;

@interface DetailCellModel : NSObject {
	CellType cellType;
	CellSelectedResponse selectedResponse;
	NSString *title;
	NSString *displayContent;
    NSString *actualContent;
	CGFloat  contentHeight;
	CGFloat  totalHeight;
	bool     hasAccessory;
	NSArray *photos;
	double lat;
	double lon;
	int shareUsing;
	bool inRed;
	NSArray *images;
    NSMutableDictionary *miscContents;
    CGFloat contentStartPointX;
    CGFloat titleHeight;
    NSNumber *productid;
}

@property (nonatomic) CellType cellType;
@property (nonatomic) CellSelectedResponse selectedResponse;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *displayContent;
@property (nonatomic, copy) NSString *actualContent;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) CGFloat totalHeight;
@property (nonatomic) bool hasAccessory;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic) double lat;
@property (nonatomic) double lon;
@property (nonatomic) int shareUsing;
@property (nonatomic) bool inRed;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSMutableDictionary *miscContents;
@property (nonatomic) CGFloat contentStartPointX;
@property (nonatomic) CGFloat titleHeight;
@property (nonatomic, retain) NSNumber *productId;

@end
