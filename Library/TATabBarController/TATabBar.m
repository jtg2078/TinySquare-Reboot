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
#import "TATabBar.h"
#import "ThemeManager.h"

const NSUInteger maxItems = 5;
const CGFloat cTabBarHeight = 49.0f;

@interface TATabBar (PrivateMethods)

- (void)_handleTap:(UIGestureRecognizer*)gestureRecognizer;
- (UIImage*)_selectedTabBarLikeIconWith:(UIImage*)tabBarIconImage;
- (UIImage*)_tabBarImage:(UIImage*)tabBarImage withGradient:(UIImage*)gradientImage;
- (void)_fireDidSelectItem;


@end

@implementation TATabBar

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
    self.baseColor = themeManager.tabBarBaseColor;
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
	
	CGRect frame = [self frame];
	CGFloat widthPerItem = frame.size.width / (CGFloat)[[self items] count];
	CGFloat x = 0.0f;
	CGFloat y = 3.0f;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	//draw three lines 1 pixel to mimic depth and divider lines between view and tab bar
    CGMutablePathRef line1 = CGPathCreateMutable();
    CGPathMoveToPoint(line1, NULL, 0, 0);
    CGPathAddLineToPoint(line1, NULL, frame.size.width, 0);
    CGPathCloseSubpath(line1);
    CGContextAddPath(context, line1);
    //CGContextSetStrokeColorWithColor(context, RGB(130, 130, 130).CGColor);
    CGContextSetStrokeColorWithColor(context, self.line1Color.CGColor);
    CGContextStrokePath(context);
    CGPathRelease(line1);
	
	CGMutablePathRef line2 = CGPathCreateMutable();
    CGPathMoveToPoint(line2, NULL, 0, 1);
    CGPathAddLineToPoint(line2, NULL, frame.size.width, 1);
    CGPathCloseSubpath(line2);
    CGContextAddPath(context, line2);
    //CGContextSetStrokeColorWithColor(context, RGB(199, 199, 199).CGColor);
    CGContextSetStrokeColorWithColor(context, self.line2Color.CGColor);
    CGContextStrokePath(context);
    CGPathRelease(line2);
	
	CGMutablePathRef line3 = CGPathCreateMutable();
    CGPathMoveToPoint(line3, NULL, 0, 2);
    CGPathAddLineToPoint(line3, NULL, frame.size.width, 2);
    CGPathCloseSubpath(line3);
    CGContextAddPath(context, line3);
    //CGContextSetStrokeColorWithColor(context, RGB(165, 165, 165).CGColor);
    CGContextSetStrokeColorWithColor(context, self.line3Color.CGColor);
    CGContextStrokePath(context);
    CGPathRelease(line3);
	
	//apply tint
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
	
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 0.5 };
	//CGFloat components[8] = {156.0/255.0, 156.0/255.0, 156.0/255.0, 1.0,  135.0/255.0, 135.0/255.0, 135.0/255.0, 1.0};
    CGFloat components[8] = {self.baseColorGradient1/255.0, 
        self.baseColorGradient2/255.0, 
        self.baseColorGradient3/255.0, 
        1.0,  
        self.baseColorGradient4/255.0, 
        self.baseColorGradient5/255.0, 
        self.baseColorGradient6/255.0, 
        1.0};
	
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
	
	CGPoint myStartPoint, myEndPoint;
	myStartPoint.x = 0.0f;
	myStartPoint.y = 2.0;
	myEndPoint.x = 0.0f;
	myEndPoint.y = (frame.size.height - y) / 2.0f + frame.size.height * 0.05f;
	CGContextDrawLinearGradient (context, myGradient, myStartPoint, myEndPoint, 0);
	
	CGColorSpaceRelease(myColorspace);
	CGGradientRelease(myGradient);
	

	//draw items
	for(UITabBarItem *barItem in [self items])
	{
		UIImage *image = [barItem image];
		NSString *text = [barItem title];
		CGSize imageSize = [image size];
		
		if(barItem == selectedItem_)
		{
			image = [self _tabBarImage:image withGradient:selectedImageMask_];
			
			//draw rounded selection rectangle
			CGMutablePathRef retPath = CGPathCreateMutable();
			
			CGFloat radius = 4.0f;
			CGRect rect = CGRectMake(x + 2.0f, y + 1.0f, widthPerItem - 3.0f, frame.size.height - y - 1.0f);
			CGRect innerRect = CGRectInset(rect, radius, radius);
			
			CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
			CGFloat outside_right = rect.origin.x + rect.size.width;
			CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height - 2.0f;
			CGFloat outside_bottom = rect.origin.y + rect.size.height - 2.0f;
			
			CGFloat inside_top = innerRect.origin.y;
			CGFloat outside_top = rect.origin.y;
			CGFloat outside_left = rect.origin.x;
			
			CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
			
			CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
			CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
			CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
			CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
			
			CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
			CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
			CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
			CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
			
			CGPathCloseSubpath(retPath);
			CGContextAddPath(context, retPath);
			//[RGB(252, 112, 36) set];
            [self.highlightColor set];
			CGContextFillPath(context);
			
			CGContextSaveGState(context);
			CGContextAddPath(context, retPath);
			CGContextClip(context);
			
			num_locations = 2;
			CGFloat locations[2] = { 0.0, 1.0 };
			
			//CGFloat components[8] = {252.0/255.0, 112.0/255.0, 36.0/255.0, 1.0, 252.0/255.0, 125.0/255.0, 54.0/255.0, 1.0};
            CGFloat components[8] = {self.highlightColorGradient1/255.0, 
                self.highlightColorGradient2/255.0, 
                self.highlightColorGradient3/255.0, 
                1.0,  
                self.highlightColorGradient4/255.0, 
                self.highlightColorGradient5/255.0, 
                self.highlightColorGradient6/255.0, 
                1.0};
			
			myColorspace = CGColorSpaceCreateDeviceRGB();
			myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
			
			
			myStartPoint.x = 0;
			myStartPoint.y = outside_top;
			myEndPoint.x = 0;
			myEndPoint.y = outside_bottom / 2.0 + 2.0f;
			
			CGContextDrawLinearGradient (context, myGradient, myStartPoint, myEndPoint, 0);
			
			CGColorSpaceRelease(myColorspace);
			CGGradientRelease(myGradient);
			
			CGContextRestoreGState(context);
			CGPathRelease(retPath);
		}
		else
			image = [self _tabBarImage:image withGradient:unselectedImageMask_];
		
		CGPoint imagePosition = CGPointMake(x + (widthPerItem - [image size].width)/2.0f, (cTabBarHeight - imageSize.height - y) / 2.0f - imageSize.height*0.2f );

		//turn on shadows if this is the selected item
		if(barItem == selectedItem_)
			CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 3, [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f] CGColor]);

		[image drawAtPoint:imagePosition blendMode:kCGBlendModeNormal alpha:1.0f];

		
		[[UIColor whiteColor] set];
		/*
		if(barItem == selectedItem_)
			[[UIColor whiteColor] set];
		else
			[[UIColor grayColor] set];
		 */
        
		[text drawInRect:CGRectMake(x, cTabBarHeight - 14.0f - 2.0f, widthPerItem, 14.0f) withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
		
		//turn off shadows if we were drawing the selected item
		if(barItem == selectedItem_)
			CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
		
		x += widthPerItem;
	}
	
	UIGraphicsPopContext();
}

#pragma mark -
#pragma mark TATabBar (PrivateMethods)

- (void)_handleTap:(UIGestureRecognizer *)gestureRecognizer
{
	if(([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && [gestureRecognizer state] == UIGestureRecognizerStateBegan) ||
	   ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [gestureRecognizer state] == UIGestureRecognizerStateEnded))
	{
		CGPoint location = [gestureRecognizer locationInView:self];
		CGRect frame = [self frame];
		CGFloat widthPerItem = frame.size.width / (CGFloat)[[self items] count];
		NSUInteger itemIndex = floor(location.x / widthPerItem);
		
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
	if(delegate != nil && [delegate conformsToProtocol:@protocol(TATabBarDelegate)] &&
	   [delegate respondsToSelector:selector])
	{
		[delegate taTabBar:self didSelectItem:selectedItem_];
	}
}

@end
