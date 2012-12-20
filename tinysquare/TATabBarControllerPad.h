//
//  TATabBarControllerPad.h
//  tinysquare
//
//  Created by  on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "TATabBarPad.h"

@class TATabHolderViewPad;

@interface TATabBarControllerPad : UIViewController <TATabBarDelegatePad> {
    
@private
	TATabHolderViewPad *holderView_;
	TATabBarPad *tabBar_;
	UIView *currentView;
    UIImageView *activeTabPointer;
}

@property (readonly, nonatomic, retain) NSArray *viewControllers;
@property (readwrite, nonatomic, retain) id selectedViewController;
@property NSInteger selectedIndex;

@property (readwrite, nonatomic, retain) UIImage *selectedImageMask;
@property (readwrite, nonatomic, retain) UIImage *unselectedImageMask;

- (void)setViewControllers:(NSArray*)vcs animated:(BOOL)animated;
- (void)setViewControllers:(NSArray *)vcs;

@end
