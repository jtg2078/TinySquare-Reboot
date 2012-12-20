//
// Copyright 2010-2011 Toad Away Limited
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

/*
 This component tries to resemble UITabBarController as much as possible whilst specifying a custom image mask for selected and unselected tab bar items. It's not fully functional when compared to UITabBarController - no customizing, no animating, no landscape orientation, no "More" button when over 5 view controllers set.
 */


#import <Foundation/Foundation.h>
#import "TATabBar.h"

@class TATabHolderView;

@interface TATabBarController : UIViewController <TATabBarDelegate> {

	@private
	TATabHolderView *holderView_;
	TATabBar *tabBar_;
	UIView *currentView;
}

@property (readonly, nonatomic, retain) NSArray *viewControllers;
@property (readwrite, nonatomic, retain) id selectedViewController;
@property NSInteger selectedIndex;

@property (readwrite, nonatomic, retain) UIImage *selectedImageMask;
@property (readwrite, nonatomic, retain) UIImage *unselectedImageMask;

- (void)setViewControllers:(NSArray*)vcs animated:(BOOL)animated;
- (void)setViewControllers:(NSArray *)vcs;

@end
