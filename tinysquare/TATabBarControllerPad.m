//
//  TATabBarControllerPad.m
//  tinysquare
//
//  Created by  on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TATabBarControllerPad.h"
#import "TATabHolderViewPad.h"
#import "UIApplication+AppDimensions.h"
#import "ThemeManager.h"

@interface TATabBarControllerPad ()
- (void)_displayViewController:(id)viewController;
- (void)updateToCurrentTheme:(NSNotification *)notif;
@end

@implementation TATabBarControllerPad

#define SHOW_LAYER_BORDER(s) s.layer.borderWidth = 2.0f; s.layer.borderColor = [[UIColor redColor] CGColor]

@synthesize viewControllers = viewControllers_;
@synthesize selectedViewController = selectedViewController_;
@synthesize selectedIndex = selectedIndex_;
@dynamic selectedImageMask;
@dynamic unselectedImageMask;

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
    [activeTabPointer release]; activeTabPointer = nil;
	[super dealloc];
}

- (void)awakeFromNib
{
	[self setWantsFullScreenLayout:YES];
	selectedIndex_ = -1;
    
    activeTabPointer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activeTabPointer.png"]];
    activeTabPointer.contentMode = UIViewContentModeCenter;
	
	tabBar_ = [[TATabBarPad alloc] initWithFrame:CGRectZero];
	[tabBar_ setDelegate:self];
	
	[self addObserver:self forKeyPath:@"selectedViewController" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}


- (void)loadView
{
	CGSize screenSize = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
	
	holderView_ = [[TATabHolderViewPad alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBarShadowPad.png"]];
    shadowView.frame = CGRectMake(0, 0, 65, screenSize.height);
    [holderView_ addSubview:shadowView];
    [shadowView release];
	
	[holderView_ addSubview:tabBar_];
    //SHOW_LAYER_BORDER(holderView_);
    
    // add the pointer
    activeTabPointer.frame = CGRectMake(50, 0, 13, 75);
    activeTabPointer.alpha = 0.8f;
    [holderView_ addSubview:activeTabPointer];
    
    [self setView:holderView_];
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
	
	if(selectedViewController_ == nil && viewControllers_ != nil && [viewControllers_ count] > 0)
	{
		[tabBar_ setSelectedItem:[[viewControllers_ objectAtIndex:0] tabBarItem]];
	}
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
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
#pragma mark TATabBarDelegatePad methods

- (void)taTabBar:(TATabBarPad *)tabBar didSelectItem:(UIBarItem*)item
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
    
    [UIView animateWithDuration:0.2f 
                          delay:0.0f 
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGRect currentFrame = activeTabPointer.frame;
                         currentFrame.origin.y = i * 75;
                         activeTabPointer.frame = currentFrame;
                     } 
                     completion:^(BOOL finished) {}];
}

#pragma mark -
#pragma mark private interface

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
	frame.size.height = [holderView_ frame].size.height;
	
	if(frame.size.height < 0)
		frame.size.height = [[UIScreen mainScreen] bounds].size.height;
	
	[view setFrame:frame];
	currentView = view;
	
	[selectedViewController_ viewWillAppear:NO];
	[[self view] insertSubview:view atIndex:0];
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
		frame.size.height += cTabBarHeightPad;
		currentView.frame = frame;
	}
	else 
	{
		tabBar_.hidden = NO;
		CGRect frame = currentView.frame;
		frame.size.height -= cTabBarHeightPad;
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
