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


#import "TATabBarController.h"
#import "TATabHolderView.h"
#import "ThemeManager.h"

@interface TATabBarController (PrivateMethods)

- (void)_displayViewController:(id)viewController;
- (void)updateToCurrentTheme:(NSNotification *)notif;

@end

@implementation TATabBarController

@synthesize viewControllers = viewControllers_, selectedViewController = selectedViewController_, selectedIndex = selectedIndex_;
@dynamic selectedImageMask, unselectedImageMask;

- (id)init
{
	self = [super init];
	
	if(self != nil)
	{
		[self awakeFromNib];
	}
	
	return self;
}

- (void)dealloc
{
	[holderView_ release], holderView_ = nil;
	[tabBar_ release], tabBar_ = nil;
	[viewControllers_ release], viewControllers_ = nil;
	[selectedViewController_ release], selectedViewController_ = nil;
	[super dealloc];
}

- (void)awakeFromNib
{
	[self setWantsFullScreenLayout:YES];
	selectedIndex_ = -1;
	
	tabBar_ = [[TATabBar alloc] initWithFrame:CGRectZero];
	[tabBar_ setDelegate:self];
	
	[self addObserver:self forKeyPath:@"selectedViewController" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}


- (void)loadView
{
	
	CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
	holderView_ = [[TATabHolderView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
	[self setView:holderView_];
    
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    UIImage *commonBgImage = [UIImage imageNamed:themeManager.commonBgImageName];
    UIImageView *_bgImageView = [[[UIImageView alloc] initWithImage:commonBgImage] autorelease];
    _bgImageView.frame = holderView_.frame;
    [holderView_ addSubview:_bgImageView];
    
	
	//UIImageView *tabBarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new-Tab-bg-shadow.png"]];
	//tabBarShadow.tag = 1001;
	//tabBarShadow.alpha = 0.7;
	//[holderView_ addSubview:tabBarShadow];
	//[tabBarShadow release];
	[holderView_ addSubview:tabBar_];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([keyPath isEqualToString:@"selectedViewController"])
	{
		if([change objectForKey:NSKeyValueChangeOldKey] == [NSNull null])
		{
			[self _displayViewController:[change objectForKey:NSKeyValueChangeNewKey]];
		}
	}
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	// set up notification for hiding the tab bar
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(showOrHideTabBar:) 
												 name:@"com.fingertipcreative.tinysquare.showHideTabBar" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(updateToCurrentTheme:) 
												 name:@"com.fingertipcreative.tinysquare.themeChange" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
	
	if(selectedViewController_ == nil && viewControllers_ != nil && [viewControllers_ count] > 0)
	{
		[tabBar_ setSelectedItem:[[viewControllers_ objectAtIndex:0] tabBarItem]];
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

/*We don't really need the "animated" parameter but keeping it here so this component is as similar as possible
 to the UITabBarController class.*/
- (void)setViewControllers:(NSArray*)vcs animated:(BOOL)animated
{
	[self setViewControllers:vcs];
}

- (void)setViewControllers:(NSArray *)vcs
{
	[vcs retain];
	[viewControllers_ release];
	viewControllers_ = vcs;
	
	NSMutableArray *items = [[NSMutableArray alloc] init];
	for(UIViewController *vc in viewControllers_)
	{
		UITabBarItem *barItem = [vc tabBarItem];
		[items addObject:barItem];
	}

	[tabBar_ setItems:items];
	[items release];
}

- (void)setUnselectedImageMask:(UIImage *)unselectedImageMask
{
	[tabBar_ setUnselectedImageMask:unselectedImageMask];
}

- (UIImage*)unselectedImageMask
{
	return [tabBar_ unselectedImageMask];
}

- (void)setSelectedImageMask:(UIImage *)selectedImageMask
{
	[tabBar_ setSelectedImageMask:selectedImageMask];
}

- (UIImage*)selectedImageMask
{
	return [tabBar_ selectedImageMask];
}

#pragma mark -
#pragma mark TATabBarDelegate methods

- (void)taTabBar:(TATabBar*)tabBar didSelectItem:(UIBarItem*)item
{
	int i = 0;
	for(UIViewController *vc in viewControllers_)
	{
		UITabBarItem *barItem = [vc tabBarItem];
		if(barItem == item)
		{
			selectedIndex_ = i;
			[self _displayViewController:vc];
			break;
		}
		
		i++;
	}
}

#pragma mark -
#pragma mark TATabBarController (PrivateMethods)

- (void)_displayViewController:(id)viewController
{
	if([selectedViewController_ modalViewController] != nil)
		[selectedViewController_ dismissModalViewControllerAnimated:NO];
	
	[selectedViewController_ viewWillDisappear:NO];
	[[selectedViewController_ view] removeFromSuperview];
	[selectedViewController_ viewDidDisappear:NO];
	
	[viewController retain];
	[selectedViewController_ release];
	selectedViewController_ = viewController;
	
	//determine which tab bar item was pressed and if none wasn't (because selectedViewController was set programatically)
	//deselect all tabs
	BOOL vcInTab = NO;
	for(UIViewController *vc in viewControllers_)
		if(vc == viewController)
			vcInTab = YES;
	
	if(!vcInTab)
		[tabBar_ setSelectedItem:[viewController tabBarItem]];
	
	UIView *view = [viewController view];
	CGRect frame = [view frame];
	frame.size.height = [holderView_ frame].size.height - cTabBarHeight;
	
	if(frame.size.height < 0)
		frame.size.height = [[UIScreen mainScreen] bounds].size.height - cTabBarHeight;
	
	[view setFrame:frame];
	currentView = view;
	
	[selectedViewController_ viewWillAppear:NO];
	[[self view] insertSubview:view atIndex:1];
	[selectedViewController_ viewDidAppear:NO];
}

// this is for when view needs to hide the tab bar completely
- (void)showOrHideTabBar:(NSNotification *)notif
{
	NSNumber *status = [notif object];
	BOOL state = [status intValue] == 1 ? NO : YES;
	
	if(state == YES)
	{
		tabBar_.hidden = YES;
		CGRect frame = currentView.frame;
		frame.size.height += cTabBarHeight;
		currentView.frame = frame;
	}
	else 
	{
		tabBar_.hidden = NO;
		CGRect frame = currentView.frame;
		frame.size.height -= cTabBarHeight;
		currentView.frame = frame;
	}
}

- (void)updateToCurrentTheme:(NSNotification *)notif
{
    // so far only tab bar needs to be updated
    [tabBar_ applyTheme];
    [tabBar_ setNeedsDisplay];
}

@end
