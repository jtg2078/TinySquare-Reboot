//
//  CellEx.h
//  LayoutManagerEx
//
//  Created by  on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellEx : NSObject

@property (nonatomic) int  uniqueId;
@property (nonatomic) int  ownerId;
@property (nonatomic) int  cellIndex;
@property (nonatomic) int  horizontalSpan;
@property (nonatomic) int  verticalSpan;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) BOOL isTapped;
@property (nonatomic) CGRect cellFrame;

@end
