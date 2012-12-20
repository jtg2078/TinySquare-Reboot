//
//  ThemeManager.h
//  tinysquare
//
//  Created by  on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject {
    
}

// bookkeeping and internals
@property (nonatomic) int selectedThemeIndex;
@property (nonatomic, retain) NSMutableArray *themeArray;

// common bg
@property (nonatomic, retain) NSString *commonBgImageName;

// tab bar
@property (nonatomic, retain) UIColor *tabBarLine1;
@property (nonatomic, retain) UIColor *tabBarLine2;
@property (nonatomic, retain) UIColor *tabBarLine3;
@property (nonatomic, retain) UIColor *tabBarBaseColor;
@property (nonatomic, retain) NSArray *tabBarBaseGradientColorArray;
@property (nonatomic, retain) UIColor *tabBarHighlightColor;
@property (nonatomic, retain) NSArray *tabBarHighlightGradientColorArray;

// navigation bar
@property (nonatomic, retain) NSString *navigationBarBgImageName;
@property (nonatomic, retain) UIColor *navigationBarTitleTextColor;
@property (nonatomic, retain) NSString *navigationBarBackButtonBgImageName;
@property (nonatomic, retain) NSString *navigationBarButtonBgImageName;

// hot product
@property (nonatomic, retain) NSString *hotProductBgImageName;
@property (nonatomic, retain) NSString *hotProductLoadingImageName;
@property (nonatomic, retain) NSString *hotProductTextBg;
@property (nonatomic, retain) UIColor *hotProductPageDotNormal;
@property (nonatomic, retain) UIColor *hotProductPageDotActive;

// detail view
@property (nonatomic, retain) NSString *detailViewBgImageName;

// product window and my bookmark
@property (nonatomic, retain) NSString *searchBarImageName;
@property (nonatomic, retain) NSString *productListBgImageName;
@property (nonatomic, retain) UIColor *productCellBgColor;

// iPad
@property (nonatomic, retain) UIColor *tabBarPadBaseColor;


+ (ThemeManager *)sharedInstance;

- (void)setTheme:(int)themeIndex fireNotification:(BOOL)flag;
- (void)loadThemes;
- (NSArray *)getListOfThemes;

@end