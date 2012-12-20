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

#import <QuartzCore/QuartzCore.h>
#import "TATabBarPad.h"
#import "ThemeManager.h"

const NSUInteger maxItemsPad = 10;
const CGFloat cTabBarHeightPad = 49.0f;

@interface TATabBarPad()

- (void)_handleTap:(UIGestureRecognizer*)gestureRecognizer;
//- (UIImage*)_selectedTabBarLikeIconWith:(UIImage*)tabBarIconImage;
- (UIImage*)_tabBarImage:(UIImage*)tabBarImage withGradient:(UIImage*)gradientImage;
- (void)_fireDidSelectItem;


@end

@implementation TATabBarPad

@synthesize delegate, items = items_, selectedItem = selectedItem_, selectedImageMask = selectedImageMask_, unselectedImageMask = unselectedImageMask_;

@synthesize line1Color;
@synthesize line2Color;
@synthesize line3Color;
@synthesize baseColor;
@synthesize baseColorGradient1;
@synthesize baseColorGradient2;
@synthesize baseColorGradient3;
@synthesize baseColorGradient4;
@synthesize baseColorGradient5;
@synthesize baseColorGradient6;
@synthesize highlightColor;
@synthesize highlightColorGradient1;
@synthesize highlightColorGradient2;
@synthesize highlightColorGradient3;
@synthesize highlightColorGradient4;
@synthesize highlightColorGradient5;
@synthesize highlightColorGradient6;

#pragma mark -
#pragma mark define

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		[self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [self applyTheme];
	[self setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin)];
	
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
	UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
	[longPressGestureRecognizer setMinimumPressDuration:0.3f];
	[self addGestureRecognizer:tapGestureRecognizer];
	[self addGestureRecognizer:longPressGestureRecognizer];
	[tapGestureRecognizer release];
	[longPressGestureRecognizer release];
	
	[self addObserver:self forKeyPath:@"selectedItem" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([keyPath isEqualToString:@"selectedItem"])
	{
		[self setNeedsDisplay];
		[self _fireDidSelectItem];
	}
}

- (void)dealloc
{
	[items_ release], items_ = nil;
	[selectedImageMask_ release], selectedImageMask_ = nil;
	[unselectedImageMask_ release], unselectedImageMask_ = nil;
    
    [line1Color release];
    [line2Color release];
    [line3Color release];
    [baseColor release];
    [highlightColor release];
    
    [super dealloc];
}

- (void)applyTheme
{
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
    // updating tab bar appearence
    self.line1Color = themeManager.tabBarLine1;
    self.line2Color = themeManager.tabBarLine2;
    self.line3Color = themeManager.tabBarLine3;
    self.baseColor = themeManager.tabBarPadBaseColor;
    self.baseColorGradient1 = [[themeManager.tabBarBaseGradientColorArray objectAtIndex:0] floatValue];
    self.baseColorGradient2 = [[themeManager.tabBarBaseGradientColorArray objectAtIndex:1] floatValue];
    self.baseColorGradient3 = [[themeManager.tabBarBaseGradientColorArray objectAtIndex:2] floatValue];
    self.baseColorGradient4 = [[themeManager.tabBarBaseGradientColorArray objectAtIndex:3] floatValue];
    self.baseColorGradient5 = [[themeManager.tabBarBaseGradientColorArray objectAtIndex:4] floatValue];
    self.baseColorGradient6 = [[themeManager.tabBarBaseGradientColorArray objectAtIndex:5] floatValue];
    self.highlightColor = themeManager.tabBarHighlightColor;
    self.highlightColorGradient1 = [[themeManager.tabBarHighlightGradientColorArray objectAtIndex:0] floatValue];
    self.highlightColorGradient2 = [[themeManager.tabBarHighlightGradientColorArray objectAtIndex:1] floatValue];
    self.highlightColorGradient3 = [[themeManager.tabBarHighlightGradientColorArray objectAtIndex:2] floatValue];
    self.highlightColorGradient4 = [[themeManager.tabBarHighlightGradientColorArray objectAtIndex:3] floatValue];
    self.highlightColorGradient5 = [[themeManager.tabBarHighlightGradientColorArray objectAtIndex:4] floatValue];
    self.highlightColorGradient6 = [[themeManager.tabBarHighlightGradientColorArray objectAtIndex:5] floatValue];
    
    [self setBackgroundColor:self.baseColor];
}

- (void)setItems:(NSArray*)items
{
	[items retain];
	[items_ release];
	items_ = items;
    
	[self setNeedsDisplay];
}

- (void)setItems:(NSArray*)items animated:(BOOL)animated
{
	[self setItems:items];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	//CGRect frame = [self frame];
	//CGFloat widthPerItem = 50.0f;
    CGFloat heightPerItem = 75.0f;
	CGFloat x = 6.0f;
	CGFloat y = 18.0f;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    
	//draw items
	for(UITabBarItem *barItem in [self items])
	{
		UIImage *image = [barItem image];
		
		if(barItem == selectedItem_)
			image = [self _tabBarImage:image withGradient:selectedImageMask_];
		else
			image = [self _tabBarImage:image withGradient:unselectedImageMask_];
		
		CGPoint imagePosition = CGPointMake(x, y);
        
		//turn on shadows if this is the selected item
		if(barItem == selectedItem_)
			CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 3, [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f] CGColor]);
        
        /*
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGRectMake(0, y, 50, 75);
        [imageView.layer renderInContext:context];
        [imageView release];
         */
        
		[image drawAtPoint:imagePosition blendMode:kCGBlendModeNormal alpha:1.0f];
        
		y += heightPerItem;
	}
	
	UIGraphicsPopContext();
}

#pragma mark -
#pragma mark private interface

- (void)_handleTap:(UIGestureRecognizer *)gestureRecognizer
{
	if(([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && [gestureRecognizer state] == UIGestureRecognizerStateBegan) ||
	   ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [gestureRecognizer state] == UIGestureRecognizerStateEnded))
	{
		CGPoint location = [gestureRecognizer locationInView:self];
		CGFloat heightPerItem = 75.0f;
		NSUInteger itemIndex = floor(location.y / heightPerItem);
		
		if([items_ count] == 0)
			return;
		
		[self setSelectedItem:[items_ objectAtIndex:itemIndex]];
	}
}

- (UIImage*)_tabBarImage:(UIImage*)tabBarImage withGradient:(UIImage*)gradientImage
{
	CGSize size = CGSizeMake(tabBarImage.size.width, tabBarImage.size.height);
	CGRect bounds = CGRectMake(0, 0, size.width, size.height);
	CGFloat scale = [tabBarImage scale];
    
	//invert colors for tab bar image (at the same time removes the alpha channel thats not supported by image masks)
	UIGraphicsBeginImageContextWithOptions(size, NO, scale);
	CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
	[tabBarImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
	CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
	CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
	CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height));
	tabBarImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//clip the background image to size of the tab bar icon image
	UIGraphicsBeginImageContextWithOptions(size, YES, scale);
	[gradientImage drawAtPoint:CGPointMake(( size.width - gradientImage.size.width) / 2, ( size.height - gradientImage.size.height ) / 2)];
	UIImage* backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	//convert image mask to grayscale
	CGColorSpaceRef grayscaleColorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
													   size.width*scale,
													   size.height*scale,
													   8,
													   8 * size.width * scale,
													   grayscaleColorSpace,
													   0
													   );
	
	CGRect scaledBounds = CGRectApplyAffineTransform(bounds, CGAffineTransformMakeScale(scale, scale));
	CGContextDrawImage(bitmapContext, scaledBounds, tabBarImage.CGImage);
	CGImageRef maskImageRef = CGBitmapContextCreateImage(bitmapContext);
	
	UIImage *maskImage = [UIImage imageWithCGImage:maskImageRef];
	
	CGContextRelease(bitmapContext);
	CGImageRelease(maskImageRef);
	CGColorSpaceRelease(grayscaleColorSpace);
    
	//apply image mask
	CGImageRef maskRef = maskImage.CGImage; 
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), NULL, true);
    
	CGImageRef masked = CGImageCreateWithMask([backgroundImage CGImage], mask);
	
	maskImage = [UIImage imageWithCGImage:masked scale:scale orientation:UIImageOrientationUp];
	
	CGImageRelease(mask);
	CGImageRelease(masked);
	
	return maskImage;
}

- (void)_fireDidSelectItem
{
	SEL selector = @selector(taTabBar:didSelectItem:);
	if(delegate != nil && [delegate conformsToProtocol:@protocol(TATabBarDelegatePad)] &&
	   [delegate respondsToSelector:selector])
	{
		[delegate taTabBar:self didSelectItem:selectedItem_];
	}
}

@end
