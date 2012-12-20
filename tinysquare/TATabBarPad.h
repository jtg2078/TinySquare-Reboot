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

#import <UIKit/UIKit.h>

@protocol TATabBarDelegatePad;

extern const CGFloat cTabBarHeightPad;

@interface TATabBarPad : UIView {
	id delegate;
	
@private
	NSArray *items_;
	UITabBarItem *selectedItem_;
}

@property (readwrite, nonatomic, assign) id<TATabBarDelegatePad> delegate;
@property (readonly, nonatomic, retain) NSArray *items;
@property (nonatomic, assign) UITabBarItem *selectedItem;

@property (readwrite, nonatomic, retain) UIImage *selectedImageMask;
@property (readwrite, nonatomic, retain) UIImage *unselectedImageMask;

@property (nonatomic, retain) UIColor *line1Color;
@property (nonatomic, retain) UIColor *line2Color;
@property (nonatomic, retain) UIColor *line3Color;
@property (nonatomic, retain) UIColor *baseColor;
@property (nonatomic)         int      baseColorGradient1;
@property (nonatomic)         int      baseColorGradient2;
@property (nonatomic)         int      baseColorGradient3;
@property (nonatomic)         int      baseColorGradient4;
@property (nonatomic)         int      baseColorGradient5;
@property (nonatomic)         int      baseColorGradient6;
@property (nonatomic, retain) UIColor *highlightColor;
@property (nonatomic)         int      highlightColorGradient1;
@property (nonatomic)         int      highlightColorGradient2;
@property (nonatomic)         int      highlightColorGradient3;
@property (nonatomic)         int      highlightColorGradient4;
@property (nonatomic)         int      highlightColorGradient5;
@property (nonatomic)         int      highlightColorGradient6;

- (void)setItems:(NSArray*)items;
- (void)setItems:(NSArray*)items animated:(BOOL)animated;
- (void)applyTheme;

@end

@protocol TATabBarDelegatePad <NSObject>

@optional
- (void)taTabBar:(TATabBarPad*)tabBar didSelectItem:(UIBarItem*)item;

@end
