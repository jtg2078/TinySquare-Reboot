//
//  PageControl.m
//  TinyStore
//
//  Created by jason on 2011/9/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageControl.h"
#import "PageControlDelegate.h"


@implementation PageControl

#pragma mark -
#pragma mark define

#define kDotDiameter 7.0
#define kDotSpacer 7.0
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#pragma mark -
#pragma mark synthesize

@synthesize dotColorCurrentPage;
@synthesize dotColorOtherPage;
@synthesize delegate;


#pragma mark -
#pragma mark init and dealloc

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        self.dotColorCurrentPage = RGB(255, 103, 20);
        self.dotColorOtherPage = RGB(178,178,178);
    }
    return self;
}

- (void)dealloc 
{
    [dotColorCurrentPage release];
    [dotColorOtherPage release];
    [super dealloc];
}


#pragma mark -
#pragma mark drawing

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetAllowsAntialiasing(context, true);
	
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages*kDotDiameter + MAX(0, self.numberOfPages-1)*kDotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
    CGFloat y = CGRectGetMidY(currentBounds)-kDotDiameter/2;
    for (int i=0; i<_numberOfPages; i++)
    {
        CGRect circleRect = CGRectMake(x, y, kDotDiameter, kDotDiameter);
        if (i == _currentPage)
        {
            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
        }
        CGContextFillEllipseInRect(context, circleRect);
        x += kDotDiameter + kDotSpacer;
    }
}


#pragma mark -
#pragma mark page mechanism

- (NSInteger)currentPage
{
    return _currentPage;
}

- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = MIN(MAX(0, page), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (NSInteger)numberOfPages
{
    return _numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages = MAX(0, pages);
    _currentPage = MIN(MAX(0, _currentPage), _numberOfPages-1);
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark user interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.delegate) return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
	
    CGFloat dotSpanX = self.numberOfPages*(kDotDiameter + kDotSpacer);
    CGFloat dotSpanY = kDotDiameter + kDotSpacer;
	
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX/2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY/2 - CGRectGetMidY(currentBounds);
	
    if ((x<0) || (x>dotSpanX) || (y<0) || (y>dotSpanY)) return;
	
    self.currentPage = floor(x/(kDotDiameter+kDotSpacer));
    if ([self.delegate respondsToSelector:@selector(pageControlPageDidChange:)])
    {
        [self.delegate performSelector:@selector(pageControlPageDidChange:) withObject:self];
    }
}

@end
