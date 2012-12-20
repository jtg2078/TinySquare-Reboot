//
//  ThemeObject.m
//  tinysquare
//
//  Created by  on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ThemeObject.h"

@implementation ThemeObject

@synthesize themeName;
@synthesize themeColor;
@synthesize themeIndex;
@synthesize themeIcon;

- (void)dealloc {
    [themeName release];
    [themeColor release];
    [themeIcon release];
    [super dealloc];
}

@end
