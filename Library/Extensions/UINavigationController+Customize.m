//
//  UINavigationController+Customize.m
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UINavigationController+Customize.h"
#import "ThemeManager.h"


@implementation UINavigationController (Customize)

#pragma mark -
#pragma mark define

#define MAX_BACK_BUTTON_WIDTH   95
#define CAP_WIDTH               20
#define TEXT_INSET_LEFT_RIGHT   21
#define NAVIGATION_BAR_SHADOW   @"NavBar_Shadow.png"

#pragma mark -
#pragma mark macro

#define SHOW_LAYER_BORDER(s) s.layer.borderWidth = 2.0f; s.layer.borderColor = [[UIColor redColor] CGColor];

- (UIButton*)setUpCustomizeBackButton {
	// Just like the standard back button, use the title of the previous item as the default back text
	NSString *buttonText = [self checkForInvalidText:self.navigationBar.topItem.title];
	
	return [self setUpCustomizeBackButtonWithText:buttonText];
}

- (UIButton*)setUpCustomizeBackButtonWithText:(NSString *)aString {
    ThemeManager *themeManager = [ThemeManager sharedInstance];
	// Create stretchable images for the normal and highlighted states
	UIImage *backButtonImage = [UIImage imageNamed:themeManager.navigationBarBackButtonBgImageName];
	UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
	
	// Create a custom button
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	// Set the title to use the same font and shadow as the standard back button
	button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	button.titleLabel.textColor = [UIColor whiteColor];
	button.titleLabel.shadowOffset = CGSizeMake(0,-1);
	button.titleLabel.shadowColor = [UIColor darkGrayColor];
	
	// Set the break mode to truncate at the end like the standard back button
	button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	
	// Set textLabel alignment from default center to left
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	
	//SHOW_LAYER_BORDER(button.titleLabel)
	//SHOW_LAYER_BORDER(button)
	
	// Inset the title on the left and right (top, left, bottom, right)
	button.titleEdgeInsets = UIEdgeInsetsMake(0, TEXT_INSET_LEFT_RIGHT, 0, TEXT_INSET_LEFT_RIGHT);
	
	// Make the button as high as the passed in image
	button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
	
	NSString *buttonText = aString;
	CGSize textSize = [buttonText sizeWithFont:button.titleLabel.font];
	// Change the button's frame. The width is either the width of the new text or the max width
	button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, (textSize.width + (TEXT_INSET_LEFT_RIGHT * 2.0)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (TEXT_INSET_LEFT_RIGHT * 2.0)), button.frame.size.height);
	[button setTitle:buttonText forState:UIControlStateNormal];
	button.titleLabel.textColor = [UIColor whiteColor];
	
	// Set the stretchable images as the background for the button
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	
	// Add an action for going back
	[button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}

- (NSString *)checkForInvalidText:(NSString *)aText
{
	NSString *trimmed = [aText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if(trimmed.length == 0 || trimmed.length > 10)
		return NSLocalizedString(@"返回", nil);
	return trimmed;
}

- (void)setUpCustomizeAppearence 
{
    UINavigationBar *navBar = self.navigationBar;
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        // set the background image of navigation bar
        [navBar setBackgroundImage:[UIImage imageNamed:themeManager.navigationBarBgImageName] forBarMetrics:UIBarMetricsDefault];
        
        // adding shadow right below navigation bar for dept effect
        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATION_BAR_SHADOW]];
        shadowImageView.frame = CGRectMake(0, 44, 320, 8);
        [navBar addSubview:shadowImageView];
        [shadowImageView release];
    }
    else
    {
        // set the background image of navigation bar
        CALayer *backgroundImageLayer;
        backgroundImageLayer = [CALayer layer];
        backgroundImageLayer.frame = CGRectMake(0, 0, 320, 44);
        backgroundImageLayer.backgroundColor = [UIColor redColor].CGColor;
        backgroundImageLayer.contents = (id)[[UIImage imageNamed:themeManager.navigationBarBgImageName] CGImage];
        backgroundImageLayer.zPosition = -5.0;
        [navBar.layer addSublayer:backgroundImageLayer];
        
        // adding shadow right below navigation bar for dept effect
        CALayer *shadowLayer = [CALayer layer];
        shadowLayer.frame = CGRectMake(0, 44, 320, 8);
        shadowLayer.contents = (id)[[UIImage imageNamed:NAVIGATION_BAR_SHADOW] CGImage];
        [navBar.layer addSublayer:shadowLayer];
    }
}

- (void)applyTheme
{
    UINavigationBar *navBar = self.navigationBar;
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [navBar setBackgroundImage:[UIImage imageNamed:themeManager.navigationBarBgImageName] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        for(CALayer *layer in [navBar.layer sublayers])
        {
            if(layer.zPosition == -5.0)
            {
                layer.contents = (id)[[UIImage imageNamed:themeManager.navigationBarBgImageName] CGImage];
            }
        }
    }
    [navBar setNeedsDisplay];
}

// With a custom back button, we have to provide the action. We simply pop the view controller
- (IBAction)back:(id)sender{
	[self popViewControllerAnimated:YES];
}

- (UIButton*)setUpCustomizeButtonWithText:(NSString *)aString icon:(UIImage *)anIcon iconPlacement:(CustomizeButtonIconPlacement)placement target:(id)target action:(SEL)action {
    ThemeManager *themeManager = [ThemeManager sharedInstance];
	// Create stretchable images for the normal and highlighted states
	UIImage *image = [UIImage imageNamed:themeManager.navigationBarButtonBgImageName];
	UIImage *buttonBackgroundImage = [image stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
	
	// Create a custom button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	// Set the title to use the same font and shadow as the standard back button
	button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	button.titleLabel.textColor = [UIColor whiteColor];
	button.titleLabel.shadowOffset = CGSizeMake(0,-1);
	button.titleLabel.shadowColor = [UIColor darkGrayColor];
	
	// Set the break mode to truncate at the end like the standard back button
	button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	
	// Set textLabel alignment from default center to left
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	
	// Find out the text's size
	NSString *buttonText = aString;
	CGSize textSize = [buttonText sizeWithFont:button.titleLabel.font];
	
	// Set the stretchable images as the background for the button
	[button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
	
	// Set icon image 
	[button setImage:anIcon forState:UIControlStateNormal];
	
	// Set button text
	[button setTitle:buttonText forState:UIControlStateNormal];
	
	int buttonWidth = 0;
#define MAX_RIGHT_BUTTON_WIDTH 110
#define ICON_SIZE 19
#define ICON_TOP_INSET -1
#define TEXT_TOP_INSET 0
	// for left placement icon
#define ICON_LEFT_INSET_FOR_LEFT_ALIGN 3
#define TEXT_LEFT_INSET_FOR_LEFT_ALIGN_ICON 6
#define TEXT_RIGHT_INSET_FOR_LEFT_ALIGN_ICON 10
	// for right palcement icon
#define TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON 10
#define ICON_RIGHT_INSET_FOR_RIGHT_ALIGN 3
#define TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON 6
	// Adjust button icon and text inset base on position of image (left or right)
	if(placement == CustomizeButtonIconPlacementLeft) {
		// UIEdgeInsetsMake(top, left, bottom, right)
		button.imageEdgeInsets = UIEdgeInsetsMake(ICON_TOP_INSET, 
												  ICON_LEFT_INSET_FOR_LEFT_ALIGN, 
												  0, 
												  0);
		
		button.titleEdgeInsets = UIEdgeInsetsMake(TEXT_TOP_INSET, 
												  TEXT_LEFT_INSET_FOR_LEFT_ALIGN_ICON, 
												  0, 
												  TEXT_RIGHT_INSET_FOR_LEFT_ALIGN_ICON);
		
		buttonWidth = ICON_LEFT_INSET_FOR_LEFT_ALIGN + ICON_SIZE + TEXT_LEFT_INSET_FOR_LEFT_ALIGN_ICON + textSize.width + TEXT_RIGHT_INSET_FOR_LEFT_ALIGN_ICON;
		
		if(buttonWidth > MAX_RIGHT_BUTTON_WIDTH)
			buttonWidth = MAX_RIGHT_BUTTON_WIDTH;
		
	} else {
		button.titleEdgeInsets = UIEdgeInsetsMake(TEXT_TOP_INSET, 
												  TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON - ICON_SIZE + ICON_RIGHT_INSET_FOR_RIGHT_ALIGN, 
												  0, 
												  TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON + ICON_SIZE);
		button.imageEdgeInsets = UIEdgeInsetsMake(ICON_TOP_INSET, 
												  TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON + textSize.width + TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON, 
												  0, 
												  ICON_RIGHT_INSET_FOR_RIGHT_ALIGN);
		
		buttonWidth = TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON + textSize.width + TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON + ICON_SIZE + ICON_RIGHT_INSET_FOR_RIGHT_ALIGN;
		
		if(buttonWidth > MAX_RIGHT_BUTTON_WIDTH){
			buttonWidth = MAX_RIGHT_BUTTON_WIDTH;
			button.imageEdgeInsets = UIEdgeInsetsMake(ICON_TOP_INSET, buttonWidth - (ICON_RIGHT_INSET_FOR_RIGHT_ALIGN + ICON_SIZE), 0, ICON_RIGHT_INSET_FOR_RIGHT_ALIGN);
		}
	}
	
	button.frame = CGRectMake(0, 
							  0, 
							  buttonWidth, 
							  buttonBackgroundImage.size.height);
	
	//SHOW_LAYER_BORDER(button.titleLabel)
	//SHOW_LAYER_BORDER(button)
	//SHOW_LAYER_BORDER(button.imageView)
	
	// Add corresponding action
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}

- (UIButton*)createNavigationBarButtonWithText:(NSString *)aString icon:(CustomizeButtonIcon)iconType iconPlacement:(CustomizeButtonIconPlacement)placement target:(id)target action:(SEL)action
{
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    // Create stretchable images for the normal and highlighted states
	UIImage *image = [UIImage imageNamed:themeManager.navigationBarButtonBgImageName];
	UIImage *buttonBackgroundImage = [image stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
	
	// Create a custom button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	// Set the title to use the same font and shadow as the standard back button
	button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	button.titleLabel.textColor = [UIColor whiteColor];
	button.titleLabel.shadowOffset = CGSizeMake(0,-1);
	button.titleLabel.shadowColor = [UIColor darkGrayColor];
	
	// Set the break mode to truncate at the end like the standard back button
	button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	
	// Set textLabel alignment from default center to left
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	
	// Find out the text's size
	NSString *buttonText = aString;
	CGSize textSize = [buttonText sizeWithFont:button.titleLabel.font];
	
	// Set the stretchable images as the background for the button
	[button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    
	// Set icon image
    switch (iconType) {
        case CustomizeButtonIconAdd:
            [button setImage:[UIImage imageNamed:@"icon_Add"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconArrow:
            [button setImage:[UIImage imageNamed:@"icon_Arrow"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconEdit:
            [button setImage:[UIImage imageNamed:@"icon_Edit"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconDetail:
            [button setImage:[UIImage imageNamed:@"icon_Detail"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconSearch:
            [button setImage:[UIImage imageNamed:@"icon_Search"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconShare:
            [button setImage:[UIImage imageNamed:@"icon_Share"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconList:
            [button setImage:[UIImage imageNamed:@"icon_List"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconEmail:
            [button setImage:[UIImage imageNamed:@"icon_Email"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconSetting:
            [button setImage:[UIImage imageNamed:@"icon_Setting"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconReload:
            [button setImage:[UIImage imageNamed:@"icon_Reload"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconQRcode:
            [button setImage:[UIImage imageNamed:@"icon_QRcode"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconMembership:
            [button setImage:[UIImage imageNamed:@"icon_Membership"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconKey:
            [button setImage:[UIImage imageNamed:@"icon_Key"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconMembership2:
            [button setImage:[UIImage imageNamed:@"icon_Membership2"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconFavortie:
            [button setImage:[UIImage imageNamed:@"icon_Favorite"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconShop:
            [button setImage:[UIImage imageNamed:@"icon_Shop"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconCollapse:
            [button setImage:[UIImage imageNamed:@"pack up"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    //KeyFIcon
	
	// Set button text
	[button setTitle:buttonText forState:UIControlStateNormal];
	
	int buttonWidth = 0;
#define MAX_RIGHT_BUTTON_WIDTH 110
#define ICON_SIZE 19
#define ICON_TOP_INSET -1
#define TEXT_TOP_INSET 0
	// for left placement icon
#define ICON_LEFT_INSET_FOR_LEFT_ALIGN 3
#define TEXT_LEFT_INSET_FOR_LEFT_ALIGN_ICON 6
#define TEXT_RIGHT_INSET_FOR_LEFT_ALIGN_ICON 10
	// for right palcement icon
#define TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON 10
#define ICON_RIGHT_INSET_FOR_RIGHT_ALIGN 3
#define TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON 6
	// Adjust button icon and text inset base on position of image (left or right)
	if(placement == CustomizeButtonIconPlacementLeft) {
		// UIEdgeInsetsMake(top, left, bottom, right)
		button.imageEdgeInsets = UIEdgeInsetsMake(ICON_TOP_INSET, 
												  ICON_LEFT_INSET_FOR_LEFT_ALIGN, 
												  0, 
												  0);
		
		button.titleEdgeInsets = UIEdgeInsetsMake(TEXT_TOP_INSET, 
												  TEXT_LEFT_INSET_FOR_LEFT_ALIGN_ICON, 
												  0, 
												  TEXT_RIGHT_INSET_FOR_LEFT_ALIGN_ICON);
		
		buttonWidth = ICON_LEFT_INSET_FOR_LEFT_ALIGN + ICON_SIZE + TEXT_LEFT_INSET_FOR_LEFT_ALIGN_ICON + textSize.width + TEXT_RIGHT_INSET_FOR_LEFT_ALIGN_ICON;
		
		if(buttonWidth > MAX_RIGHT_BUTTON_WIDTH)
			buttonWidth = MAX_RIGHT_BUTTON_WIDTH;
		
	} else {
		button.titleEdgeInsets = UIEdgeInsetsMake(TEXT_TOP_INSET, 
												  TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON - ICON_SIZE + ICON_RIGHT_INSET_FOR_RIGHT_ALIGN, 
												  0, 
												  TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON + ICON_SIZE);
		button.imageEdgeInsets = UIEdgeInsetsMake(ICON_TOP_INSET, 
												  TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON + textSize.width + TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON, 
												  0, 
												  ICON_RIGHT_INSET_FOR_RIGHT_ALIGN);
		
		buttonWidth = TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON + textSize.width + TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON + ICON_SIZE + ICON_RIGHT_INSET_FOR_RIGHT_ALIGN;
		
		if(buttonWidth > MAX_RIGHT_BUTTON_WIDTH){
			buttonWidth = MAX_RIGHT_BUTTON_WIDTH;
			button.imageEdgeInsets = UIEdgeInsetsMake(ICON_TOP_INSET, buttonWidth - (ICON_RIGHT_INSET_FOR_RIGHT_ALIGN + ICON_SIZE), 0, ICON_RIGHT_INSET_FOR_RIGHT_ALIGN);
		}
	}
	
	button.frame = CGRectMake(0, 
							  0, 
							  buttonWidth, 
							  buttonBackgroundImage.size.height);
	
	//SHOW_LAYER_BORDER(button.titleLabel)
	//SHOW_LAYER_BORDER(button)
	//SHOW_LAYER_BORDER(button.imageView)
	
	// Add corresponding action
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}


-(UIButton*)createNavigationBarButtonWithOutTextandSetIcon:(CustomizeButtonIcon)iconType iconPlacement:(CustomizeButtonIconPlacement)placement target:(id)target action:(SEL)action
{
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    // Create stretchable images for the normal and highlighted states
	UIImage *image = [UIImage imageNamed:themeManager.navigationBarButtonBgImageName];
	UIImage *buttonBackgroundImage = [image stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
	
	// Create a custom button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	// Set the title to use the same font and shadow as the standard back button
	button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	button.titleLabel.textColor = [UIColor whiteColor];
	button.titleLabel.shadowOffset = CGSizeMake(0,-1);
	button.titleLabel.shadowColor = [UIColor darkGrayColor];
	
	// Set the break mode to truncate at the end like the standard back button
	button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	
	// Set textLabel alignment from default center to left
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		
	// Set the stretchable images as the background for the button
	[button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    
    //default setting button width
    int buttonWidth = 50;

    
	// Set icon image
    switch (iconType) {
        case CustomizeButtonIconAdd:
            [button setImage:[UIImage imageNamed:@"icon_Add"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconArrow:
            [button setImage:[UIImage imageNamed:@"icon_Arrow"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconEdit:
            [button setImage:[UIImage imageNamed:@"icon_Edit"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconDetail:
            [button setImage:[UIImage imageNamed:@"icon_Detail"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconSearch:
            [button setImage:[UIImage imageNamed:@"icon_Search"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconShare:
            [button setImage:[UIImage imageNamed:@"icon_Share"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconList:
            [button setImage:[UIImage imageNamed:@"icon_List"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconEmail:
            [button setImage:[UIImage imageNamed:@"icon_Email"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconSetting:
            [button setImage:[UIImage imageNamed:@"icon_Setting"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconReload:
            [button setImage:[UIImage imageNamed:@"icon_Reload"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconQRcode:
            [button setImage:[UIImage imageNamed:@"icon_QRcode"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconMembership:
            [button setImage:[UIImage imageNamed:@"icon_Membership"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconKey:
            [button setImage:[UIImage imageNamed:@"icon_Key"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconMembership2:
            [button setImage:[UIImage imageNamed:@"icon_Membership2"] forState:UIControlStateNormal];
            break;
        case CustomizeButtonIconFavortie:
            [button setImage:[UIImage imageNamed:@"icon_Favorite"] forState:UIControlStateNormal];
            buttonWidth=61;
            break;
        case CustomizeButtonIconShop:
            [button setImage:[UIImage imageNamed:@"icon_Shop"] forState:UIControlStateNormal];
            buttonWidth=61;
            break;
        case CustomizeButtonIconCollapse:
            [button setImage:[UIImage imageNamed:@"pack up"] forState:UIControlStateNormal];
            buttonWidth=34;
            break;
    
        default:
            break;
    }
    //KeyFIcon
	

	
     /*

	// Adjust button icon and text inset base on position of image (left or right)
	if(placement == CustomizeButtonIconPlacementLeft) {
		// UIEdgeInsetsMake(top, left, bottom, right)
		button.imageEdgeInsets = UIEdgeInsetsMake(ICON_TOP_INSET,
												  ICON_LEFT_INSET_FOR_LEFT_ALIGN,
												  0,
												  0);
		
		button.titleEdgeInsets = UIEdgeInsetsMake(TEXT_TOP_INSET,
												  TEXT_LEFT_INSET_FOR_LEFT_ALIGN_ICON,
												  0,
												  TEXT_RIGHT_INSET_FOR_LEFT_ALIGN_ICON);
		
		buttonWidth = ICON_LEFT_INSET_FOR_LEFT_ALIGN + ICON_SIZE + TEXT_LEFT_INSET_FOR_LEFT_ALIGN_ICON + TEXT_RIGHT_INSET_FOR_LEFT_ALIGN_ICON;
		
		if(buttonWidth > MAX_RIGHT_BUTTON_WIDTH)
			buttonWidth = MAX_RIGHT_BUTTON_WIDTH;
		
	} else {
		button.titleEdgeInsets = UIEdgeInsetsMake(TEXT_TOP_INSET,
												  TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON - ICON_SIZE + ICON_RIGHT_INSET_FOR_RIGHT_ALIGN,
												  0,
												  TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON + ICON_SIZE);
		button.imageEdgeInsets = UIEdgeInsetsMake(ICON_TOP_INSET,
												  TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON + TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON,
												  0,
												  ICON_RIGHT_INSET_FOR_RIGHT_ALIGN);
		
		buttonWidth = TEXT_LEFT_INSET_FOR_RIGHT_ALIGN_ICON + TEXT_RIGHT_INSET_FOR_RIGHT_ALIGN_ICON + ICON_SIZE + ICON_RIGHT_INSET_FOR_RIGHT_ALIGN;
		
		if(buttonWidth > MAX_RIGHT_BUTTON_WIDTH){
			buttonWidth = MAX_RIGHT_BUTTON_WIDTH;
			button.imageEdgeInsets = UIEdgeInsetsMake(ICON_TOP_INSET, buttonWidth - (ICON_RIGHT_INSET_FOR_RIGHT_ALIGN + ICON_SIZE), 0, ICON_RIGHT_INSET_FOR_RIGHT_ALIGN);
		}
	}
	*/
	button.frame = CGRectMake(0,
							  0,
							  buttonWidth,
							  buttonBackgroundImage.size.height);
	
	//SHOW_LAYER_BORDER(button.titleLabel)
	//SHOW_LAYER_BORDER(button)
	//SHOW_LAYER_BORDER(button.imageView)
	
	// Add corresponding action
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}

@end
