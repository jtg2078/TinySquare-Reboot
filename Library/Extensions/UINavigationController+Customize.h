//
//  UINavigationController+Customize.h
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    CustomizeButtonIconPlacementLeft,
    CustomizeButtonIconPlacementRight
} CustomizeButtonIconPlacement;

typedef enum{
    CustomizeButtonIconAdd,
    CustomizeButtonIconArrow,
    CustomizeButtonIconEdit,
    CustomizeButtonIconDetail,
    CustomizeButtonIconSearch,
    CustomizeButtonIconShare,
    CustomizeButtonIconList,
    CustomizeButtonIconEmail,
    CustomizeButtonIconSetting,
    CustomizeButtonIconReload,
    // new added
    CustomizeButtonIconQRcode,
    CustomizeButtonIconMembership,
    CustomizeButtonIconKey,
    CustomizeButtonIconMembership2,
    CustomizeButtonIconFavortie,
    CustomizeButtonIconShop,
    CustomizeButtonIconCollapse,
} CustomizeButtonIcon;

@interface UINavigationController (Customize)
- (UIButton*)setUpCustomizeBackButton;
- (UIButton*)setUpCustomizeBackButtonWithText:(NSString *)aString;
- (NSString *)checkForInvalidText:(NSString *)aText;

- (UIButton*)setUpCustomizeButtonWithText:(NSString *)aString icon:(UIImage *)anIcon iconPlacement:(CustomizeButtonIconPlacement)placement target:(id)target action:(SEL)action;
- (UIButton*)createNavigationBarButtonWithText:(NSString *)aString icon:(CustomizeButtonIcon)iconType iconPlacement:(CustomizeButtonIconPlacement)placement target:(id)target action:(SEL)action;
-(UIButton*)createNavigationBarButtonWithOutTextandSetIcon:(CustomizeButtonIcon)iconType iconPlacement:(CustomizeButtonIconPlacement)placement target:(id)target action:(SEL)action;

- (void)setUpCustomizeAppearence;
- (void)applyTheme;
@end

