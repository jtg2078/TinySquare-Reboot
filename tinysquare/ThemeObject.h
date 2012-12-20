//
//  ThemeObject.h
//  tinysquare
//
//  Created by  on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeObject : NSObject

@property (nonatomic, retain) NSString *themeName;
@property (nonatomic, retain) UIColor *themeColor;
@property (nonatomic) int themeIndex;
@property (nonatomic, retain) UIImage *themeIcon;


@end
