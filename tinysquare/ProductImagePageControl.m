//
//  ProductImagePageControl.m
//  TinyStore
//
//  Created by jason on 2011/9/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductImagePageControl.h"
#import "ProductImagePageControlDelegate.h"

@implementation ProductImagePageControl

#pragma mark -
#pragma mark define

#define kDotDiameter	38
#define PAGE_ICON_SIZE	34
#define kDotSpacer		8


#pragma mark -
#pragma mark macro

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize iconFrameCurrentPage;
@synthesize iconFrameOtherPage;
@synthesize pageIcons;
@synthesize delegate;
@synthesize currentPage;
@synthesize numberOfPages;


#pragma mark -
#pragma mark init and dealloc

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) 
    {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        //self.iconFrameCurrentPage = [UIImage imageNamed:@"PicDis_PicSBG-select.png"];
        //self.iconFrameOtherPage = [UIImage imageNamed:@"PicDis_PicSBG.png"];
    }
    return self;
}

- (void)dealloc 
{
    [iconFrameCurrentPage release];
    [iconFrameOtherPage release];
	[pageIcons release];
    [super dealloc];
}

- (void)setupPageControl:(int)pageCount
{
	self.numberOfPages = pageCount;
	self.pageIcons = [NSMutableArray array];
	for(int i = 1; i <= self.numberOfPages; i++)
	{
		//[self.pageIcons addObject:[UIImage imageNamed:[NSString stringWithFormat:@"PicDis-default.png", i]]];
        [self.pageIcons addObject:[UIImage imageNamed:@"PicDis-default.png"]];
	}
}


#pragma mark -
#pragma mark drawing

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetAllowsAntialiasing(context, true);
	
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages * kDotDiameter + MAX(0, self.numberOfPages - 1) * kDotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth / 2;
    CGFloat y = CGRectGetMidY(currentBounds) - kDotDiameter / 2;
	CGPoint p;
	p.x = x;
	p.y = y;
    for (int i = 0; i < numberOfPages; i++)
    {
        if (i == currentPage)
        {
            [self.iconFrameCurrentPage drawAtPoint:p];
        }
        else
        {
            [self.iconFrameOtherPage drawAtPoint:p];
        }
		
        
        if([self.pageIcons count] > i)
        {
			UIImage *tmpImageUsedtoCount=[self.pageIcons objectAtIndex:i];
            CGFloat icon_height=tmpImageUsedtoCount.size.height;
            CGFloat icon_width=tmpImageUsedtoCount.size.width;
            CGFloat rect_width=0;
            CGFloat rect_height=0;
            CGPoint drawPoint=p;
            if (icon_width>icon_height)
            {
                rect_width=PAGE_ICON_SIZE;
                rect_height=PAGE_ICON_SIZE*(icon_height/icon_width);
                drawPoint.x+=2;
                drawPoint.y=drawPoint.y+2+((PAGE_ICON_SIZE-rect_height)/2);
            }
            else {
                rect_width=PAGE_ICON_SIZE*(icon_width/icon_height);
                rect_height=PAGE_ICON_SIZE; 
                drawPoint.x=drawPoint.x+2+((PAGE_ICON_SIZE-rect_width)/2);
                drawPoint.y+=2;
                
            }
            
            
            [[self.pageIcons objectAtIndex:i] drawInRect:CGRectMake(drawPoint.x, drawPoint.y , rect_width, rect_height)];
            
            
        }
        
		//if([self.pageIcons count] > i)
        //[[self.pageIcons objectAtIndex:i] drawInRect:CGRectMake(p.x + 2, p.y + 2, PAGE_ICON_SIZE, PAGE_ICON_SIZE)];
        
		p.x += kDotDiameter + kDotSpacer;
    }
}

- (void)setPageIcon:(UIImage *)image forPage:(int)pageIndex
{
	CGFloat icon_width=image.size.width;
    CGFloat icon_height=image.size.height;
    CGFloat rect_width=0;
    CGFloat rect_height=0;
    if (icon_width>icon_height)
    {
        rect_width=PAGE_ICON_SIZE;
        rect_height=PAGE_ICON_SIZE*(icon_height/icon_width);
    }
    else {
        rect_width=PAGE_ICON_SIZE*(icon_width/icon_height);
        rect_height=PAGE_ICON_SIZE; 
    }
    
    CGRect rect = CGRectMake(0, 0, rect_width, rect_height);
    
    
    //CGRect rect = CGRectMake(0, 0, PAGE_ICON_SIZE, PAGE_ICON_SIZE);
	UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
	[image drawInRect:rect];
	UIImage* smallImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[self.pageIcons replaceObjectAtIndex:pageIndex withObject:smallImage];
	[self setNeedsDisplay];
}


#pragma mark -
#pragma mark page mechanism

- (NSInteger)currentPage
{
    return currentPage;
}

- (void)setCurrentPage:(NSInteger)page
{
    currentPage = MIN(MAX(0, page), numberOfPages - 1);
    [self setNeedsDisplay];
}

- (NSInteger)numberOfPages
{
    return numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages
{
    numberOfPages = MAX(0, pages);
    currentPage = MIN(MAX(0, currentPage), numberOfPages - 1);
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark user interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.delegate) return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
	
    CGFloat dotSpanX = self.numberOfPages * (kDotDiameter + kDotSpacer);
    CGFloat dotSpanY = kDotDiameter + kDotSpacer;
	
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX / 2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY / 2 - CGRectGetMidY(currentBounds);
	
    if ((x<0) || (x>dotSpanX) || (y<0) || (y>dotSpanY)) return;
	
    self.currentPage = floor(x/(kDotDiameter+kDotSpacer));
    if ([self.delegate respondsToSelector:@selector(pageControlPageDidChange:)])
    {
        [self.delegate pageControlPageDidChange:self];
    }
}

@end
