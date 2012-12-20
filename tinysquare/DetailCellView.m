//
//  DetailCellView.m
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailCellView.h"
#import "DetailCell.h"
#import "ImageManager.h"
#import "UIImage+Transform.h"
#import "DictionaryHelper.h"

@implementation DetailCellView

#pragma mark - 
#pragma mark define

#define CELL_WIDTH 292

#pragma mark -
#pragma mark macro

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize model;
@synthesize highlighted;


#pragma mark -
#pragma mark static variables

static UIFont *fontForTitle = nil;
static UIFont *fontForRest = nil;
static UIColor *cellBgColor = nil;
static UIColor *contentTitleColor = nil;
static UIColor *contentColor = nil;
static UIColor *highlightColor = nil;
static UIImage *mapImage = nil;
static UIImage *imageFrame = nil;
static UIImage *dashLine = nil;
static NSString *locTitle = nil;
static UIColor *redContentColor = nil;
static UIImage *loadingImage = nil;

+ (void)initialize
{
	if(self == [DetailCellView class])
	{
		// this is a good spot to load any graphics you might be drawing in -drawContentView:
		// just load them and retain them here (ONLY if they're small enough that you don't care about them wasting memory)
		// the idea is to do as LITTLE work (e.g. allocations) in -drawContentView: as possible
		fontForTitle = [[UIFont fontWithName:@"STHeitiTC-Medium" size:18.0f] retain];
		fontForRest = [[UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f] retain];
		cellBgColor = [RGB(249, 247, 230) retain];
		contentTitleColor = [[UIColor blackColor] retain];
		contentColor = [RGB(100, 100, 100) retain];
		redContentColor = [UIColor redColor];
		highlightColor = [[UIColor whiteColor] retain];
		mapImage = [[UIImage imageNamed:@"MapFrame.png"] retain];
		imageFrame = [[UIImage imageNamed:@"IDetail_PicFrame.png"] retain];
		dashLine = [[UIImage imageNamed:@"IDetail_CellBG_Line.png"] retain];
		locTitle = [NSLocalizedString(@"地址:", @"DetailCellView") retain];
		loadingImage = [[UIImage imageNamed:@"IDetail_NoPic.png"] retain];
	}
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		// blending takes cpu time and resources
		//self.opaque = YES;
		//self.backgroundColor = cellBgColor;
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)lit {
	// If highlighted state changes, need to redisplay.
	if (highlighted != lit) {
		highlighted = lit;	
		[self setNeedsDisplay];
	}
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	
	// setup text color base on highlight status
	UIColor *contentTitleTextColor = nil;
	UIColor *contentTextColor = nil;
	if (self.highlighted) 
	{
		contentTitleTextColor = highlightColor;
		contentTextColor = highlightColor;
	}
	else 
	{
		contentTitleTextColor = contentTitleColor;
		contentTextColor = contentColor;
		if(model.inRed == YES)
			contentTextColor = redContentColor;
	}
	
	// misc
	CGPoint p;
	CGRect r;
	
	// draw the cell line
	p.x = 0;
	p.y = 0;
	//[dashLine drawAtPoint:p];
    
	// construct what to draw base on type
	if(model.cellType == CellTypeWaiting)
	{
		// content
		[contentTextColor set];
		r.origin.x = 45;
		r.origin.y = 14;
		r.size.width = 235;
		r.size.height = model.contentHeight;
		[[model displayContent] drawInRect:r withFont:fontForRest];
	}
	
	if(model.cellType == CellTypeSingleLine2WordTitle)
	{
		// title
		[contentTitleTextColor set];
		p.x = 10 - 10;
		p.y = 14;
		[model.title drawAtPoint:p withFont:fontForRest];
		
		// content
		[contentTextColor set];
		p.x = 45 - 10;
		p.y = 14;
		[[model displayContent] drawAtPoint:p forWidth:235 withFont:fontForRest lineBreakMode:UILineBreakModeTailTruncation];
	}
    
    if(model.cellType == CellTypeSingleLine3WordTitle)
	{
		// title
		[contentTitleTextColor set];
		p.x = 10 - 10;
		p.y = 14;
		[model.title drawAtPoint:p withFont:fontForRest];
		
		// content
		[contentTextColor set];
		p.x = 52 - 10;
		p.y = 14;
		[[model displayContent] drawAtPoint:p forWidth:228 withFont:fontForRest lineBreakMode:UILineBreakModeTailTruncation];
	}
    
    if(model.cellType == CellTypeSingleLineCenterNoTitle)
    {
        [contentTextColor set];
        r.origin.x = 10 - 10;
		r.origin.y = 14;
		r.size.width = 288;
		r.size.height = model.contentHeight;
		[[model displayContent] drawInRect:r withFont:fontForRest lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
    }
    
    if(model.cellType == CellTypeSingleLineMultiWordTitle)
    {
        // title
		[contentTitleTextColor set];
		p.x = 10 - 10;
		p.y = 14;
		[model.title drawAtPoint:p withFont:fontForRest];
		
		// content
		[contentTextColor set];
		p.x = model.contentStartPointX;
		p.y = 14;
		[[model displayContent] drawAtPoint:p forWidth:288 - p.x withFont:fontForRest lineBreakMode:UILineBreakModeTailTruncation];
    }
	
	if(model.cellType == CellTypeMultiLine2WordTitle)
	{
		// title
		[contentTitleTextColor set];
		p.x = 10 - 10;
		p.y = 14;
		[model.title drawAtPoint:p withFont:fontForRest];
		
		// content
		[contentTextColor set];
		r.origin.x = 45 - 10;
		r.origin.y = 14;
		r.size.width = 235;
		r.size.height = model.contentHeight;
		[[model displayContent] drawInRect:r withFont:fontForRest];
	}
	
	if(model.cellType == CellTypeMultiLine4WordTitle)
	{
		// title
		[contentTitleTextColor set];
		p.x = 10 - 10;
		p.y = 14;
		[model.title drawAtPoint:p withFont:fontForRest];
		
		// content
		[contentTextColor set];
		r.origin.x = 70 - 10;
		r.origin.y = 14;
		r.size.width = 210;
		r.size.height = model.contentHeight;
		[[model displayContent] drawInRect:r withFont:fontForRest];
	}
	
	if(model.cellType == CellTypeMultiLineStandAloneTitle)
	{
		// title
		[contentTitleTextColor set];
		p.x = 10 - 10;
		p.y = 14;
		[model.title drawAtPoint:p withFont:fontForRest];
		
		// content
		[contentTextColor set];
		r.origin.x = 10 - 10;
		r.origin.y = 34;
		r.size.width = 288;
		r.size.height = model.contentHeight;
		[[model.photos objectAtIndex:0] drawAtPoint:r.origin];// since pre-render text as photo
		//[model.content drawInRect:r withFont:fontForRest];
	}
    
    if(model.cellType == CellTypeMultiLineMultiWordTitle)
    {
        // title
		[contentTitleTextColor set];
		r.origin.x = 10 - 10;
		r.origin.y = 14;
		r.size.width = 288;
		r.size.height = model.titleHeight;
		[[model.photos objectAtIndex:0] drawAtPoint:r.origin];
		
		// content
		[contentTextColor set];
		r.origin.x = 10 - 10;
		r.origin.y = r.origin.y + model.titleHeight + 5;
		r.size.width = 288;
		r.size.height = model.contentHeight;
		[[model.photos objectAtIndex:1] drawAtPoint:r.origin];
    }
	
	if(model.cellType == CellTypeMultiLineNoTitle)
	{
		// content
		[contentTextColor set];
		r.origin.x = 10 - 10;
		r.origin.y = 10;
		r.size.width = 288;
		r.size.height = model.contentHeight;
		[[model displayContent] drawInRect:r withFont:fontForRest];
	}
	
	if(model.cellType == CellTypeTitleAndImagesStatic)
	{
		// left image
		r.origin.x = 16;
		r.origin.y = 13;
		r.size.width = 120;
		r.size.height = 120;
		UIImage *left = [model.photos objectAtIndex:1];
		[left drawInRect:r];
		
		// right image
		r.origin.x = 155;
		r.origin.y = 14;
		r.size.width = 120;
		r.size.height = 120;
		UIImage *right = [model.photos objectAtIndex:2];
		[right drawInRect:r];
		
		// middle image
		r.origin.x = 68;
		r.origin.y = 18;
		r.size.width = 130;
		r.size.height = 130;
		UIImage *middle = [model.photos objectAtIndex:0];
		[middle drawInRect:r];
		
		// image frame
		p.x = 0;
		p.y = 0;
		[imageFrame drawAtPoint:p];
		
		// title
		[contentTextColor set];
		r.origin.x = 0;
		r.origin.y = 153;
		r.size.width = 306;
		r.size.height = 20;
		[[model displayContent] drawInRect:r withFont:fontForTitle lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	}
	
	if(model.cellType == CellTypeTitleAndImages)
	{
		// left image
		r.origin.x = 16;
		r.origin.y = 13;
		r.size.width = 120;
		r.size.height = 120;
		NSString *leftPath = [model.images objectAtIndex:1];
		if([leftPath length])
		{
			UIImage* img = [ImageManager loadImage:[NSURL URLWithString:leftPath]];
			if (img)
				[[img imageRotatedByDegrees:1.5] drawInRect:r];
			else
				[[loadingImage imageRotatedByDegrees:1.5] drawInRect:r];
		}
		
		// right image
		r.origin.x = 155;
		r.origin.y = 14;
		r.size.width = 120;
		r.size.height = 120;
		NSString *rightPath = [model.images objectAtIndex:2];
		if([rightPath length])
		{
			UIImage* img = [ImageManager loadImage:[NSURL URLWithString:rightPath]];
			if (img)
				[[img imageRotatedByDegrees:0.5] drawInRect:r];
			else
				[[loadingImage imageRotatedByDegrees:0.5] drawInRect:r];
		}
		
		// middle image
		r.origin.x = 68;
		r.origin.y = 18;
		r.size.width = 130;
		r.size.height = 130;
		NSString *middlePath = [model.images objectAtIndex:0];
		if([middlePath length])
		{
			UIImage* img = [ImageManager loadImage:[NSURL URLWithString:middlePath]];
			if (img)
				[[img imageRotatedByDegrees:-5.5] drawInRect:r];
			else
				[[loadingImage imageRotatedByDegrees:-5.5] drawInRect:r];
		}
		
		
		// image frame
		p.x = 0;
		p.y = 0;
		[imageFrame drawAtPoint:p];
		
		// title
		[contentTextColor set];
		r.origin.x = 0;
		r.origin.y = 153;
		r.size.width = 306;
		r.size.height = 40;
		[[model displayContent] drawInRect:r withFont:fontForTitle lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	}
	
	if(model.cellType == CellTypeAddressAndMap)
	{
		// title
		[contentTitleTextColor set];
		p.x = 10 - 10;
		p.y = 14;
		[locTitle drawAtPoint:p withFont:fontForRest];
		
		// address
		[contentTextColor set];
		r.origin.x = 45 - 10;
		r.origin.y = 14;
		r.size.width = 150;
		r.size.height = model.contentHeight;
		[[model displayContent] drawInRect:r withFont:fontForRest];
		
		// map image
		r.origin.x = 200 - 10;
		r.origin.y = 0;
		r.size.width = 85;
		r.size.height = 70;
		[mapImage drawAtPoint:r.origin];
	}
	
	if(model.cellType == CellTypeSocialAndShare)
	{
		// title
		[contentTitleTextColor set];
		p.x = 10 - 10;
		p.y = 14;
		[model.title drawAtPoint:p withFont:fontForRest];
        
        //ShareIcon.png
        p.x = 55 - 10;
		p.y = 10;
        [[UIImage imageNamed:@"ShareIcon.png"] drawAtPoint:p];
	}
    
    if(model.cellType == CellTypeTitleAndImagesEnhanced)
    {
        
        
        
        
        
        // item image
		r.origin.x = 0;
		r.origin.y = 3;
		r.size.width = CELL_WIDTH;
		r.size.height = 225;
        
        NSString *imagePath = [model.images count] ? [model.images objectAtIndex:0] : nil;
		if([imagePath length])
		{
			UIImage* img = [ImageManager loadImage:[NSURL URLWithString:imagePath]];
        
         if (img)
         {
             UIImageView *productDetailPixArrayPreview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 3, CELL_WIDTH, 225)];
             productDetailPixArrayPreview.image=img;
             productDetailPixArrayPreview.contentMode=UIViewContentModeScaleAspectFit;
             [self addSubview:productDetailPixArrayPreview];
            
             UIImageView *textBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 161, 292, 47)];
             textBG.image=[UIImage imageNamed:@"detailTextBg.png"];
             [productDetailPixArrayPreview addSubview:textBG];
             

         }
         
         else
             [loadingImage drawInRect:r];
        
		}

        
        // item title
        [RGB(32, 32, 32) set];
		r.origin.x = 6;
		r.origin.y = 165;
		r.size.width = 286;
		r.size.height = 40;
        UILabel *displayContentField=[[UILabel alloc] initWithFrame:r];
        displayContentField.text=[model displayContent];
        displayContentField.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
        [displayContentField setNumberOfLines:0]; 
        displayContentField.lineBreakMode = UILineBreakModeWordWrap; 
        [self addSubview:displayContentField];
    
		//[[model displayContent] drawInRect:r withFont:[UIFont boldSystemFontOfSize:16.0] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];

 

        
       /* //begin to test
        
        // item image
		r.origin.x = 0;
		r.origin.y = 3;
		r.size.width = CELL_WIDTH;
		r.size.height = 225;
		
        
        NSString *imagePath = [model.images count] ? [model.images objectAtIndex:0] : nil;
		if([imagePath length])
		{
			UIImage* img = [ImageManager loadImage:[NSURL URLWithString:imagePath]];
        
         if (img)
            [img drawInRect:r];
         else
            [loadingImage drawInRect:r];
        }
        
        
        // item image frame
        //p.x = 0;
		//p.y = 0;
        //[[UIImage imageNamed:@"detailPicFrame.png"] drawAtPoint:p];
            
        // item title frame
        
        p.x = 0;
		p.y = 163;
        [[UIImage imageNamed:@"detailTextBg.png"] drawAtPoint:p];
        
        
        // item title
        [RGB(32, 32, 32) set];
		r.origin.x = 6;
		r.origin.y = 165;
		r.size.width = 286;
		r.size.height = 40;
		[[model displayContent] drawInRect:r withFont:[UIFont boldSystemFontOfSize:16.0] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
        */
        
        
        // buttons are not drawn here, (they are added via addSubView methods in DetailCell.m)
        
        // prices
        int salePrice = [[model.miscContents numberForKey:@"salePrice"] intValue];
        int price = [[model.miscContents numberForKey:@"price"] intValue];
        
        if(salePrice == -1) // for product with normal price only
        {
            if(price)
            {
                // title
                NSString *priceTitle = NSLocalizedString(@"售價", nil);
                p.x = 6;
                p.y = 298;
                [RGB(196, 55, 55) set];
                [priceTitle drawAtPoint:p withFont:[UIFont systemFontOfSize:16.0]];
                
                // price
                NSString *priceString = [NSString stringWithFormat:@"%d %@", price, NSLocalizedString(@"元", nil)];
                p.x = 60;
                p.y = 298;
                [RGB(255, 0, 0) set];
                [priceString drawAtPoint:p withFont:[UIFont systemFontOfSize:16.0]];
            }
        }
        else // for product with sale price
        {
            // sales price title
            NSString *priceTitle = NSLocalizedString(@"優惠價", @"DetailCellView");
            p.x = 6;
            p.y = 298;
            [RGB(196, 55, 55) set];
            [priceTitle drawAtPoint:p withFont:[UIFont systemFontOfSize:16.0]];
            
            // sales price
            NSString *salePriceString = [NSString stringWithFormat:@"%d %@", salePrice, NSLocalizedString(@"元", nil)];
            p.x = 60;
            p.y = 298;
            [RGB(255, 0, 0) set];
            [salePriceString drawAtPoint:p withFont:[UIFont systemFontOfSize:16.0]];
            
            // original price
            NSString *priceString = [NSString stringWithFormat:@"%@ %d %@", NSLocalizedString(@"原價", nil), price, NSLocalizedString(@"元", nil)];
            r.origin.x = 180 - 4;
            r.origin.y = 300;
            r.size.width = 115;
            r.size.height = 16;
            [RGB(160, 160, 160) set];
            [priceString drawInRect:r withFont:[UIFont systemFontOfSize:14.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
            
            // the strikethrough line for the original price
            CGSize textSize = [priceString sizeWithFont:[UIFont systemFontOfSize:14.0]];
            int strikeLineStartX = MAX(r.origin.x, r.origin.x + r.size.width - textSize.width);
            CGContextRef context = UIGraphicsGetCurrentContext();
            UIGraphicsPushContext(context);
            CGContextFillRect(context, CGRectMake(strikeLineStartX, r.origin.y + textSize.height / 2, textSize.width, 1));
            UIGraphicsPopContext();
        }
    }
    
    if(model.cellType == CellTypeCustomTags)
    {
        // title
		[contentTitleTextColor set];
		p.x = 10 - 10;
		p.y = 14;
		[model.title drawAtPoint:p withFont:fontForRest];
    }
    
    if(model.cellType == CellTypeAboutMeTitleAndImages)
    {
        // item image
		r.origin.x = 0;
		r.origin.y = 3;
		r.size.width = CELL_WIDTH;
		r.size.height = 225;
		NSString *imagePath = [model.images count] ? [model.images objectAtIndex:0] : nil;
		if([imagePath length])
		{
			UIImage* img = [ImageManager loadImage:[NSURL URLWithString:imagePath]];
			if (img)
				[img drawInRect:r];
			else
				[loadingImage drawInRect:r];
		}
        
        // item image frame
        //p.x = 0;
		//p.y = 0;
        //[[UIImage imageNamed:@"detailPicFrame.png"] drawAtPoint:p];
        
        // item title
        [RGB(32, 32, 32) set];
		r.origin.x = 3;
		r.origin.y = 242;
		r.size.width = 286;
		r.size.height = 20;
		[model.title drawInRect:r withFont:[UIFont boldSystemFontOfSize:16.0] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
        
        // summary image frame
        p.x = 4;
		p.y = 275;
        [[UIImage imageNamed:@"list_propicBg.png"] drawAtPoint:p];
        
        // summary image
        r.origin.x = 6;
        r.origin.y = 277;
        r.size.width = 108;
		r.size.height = 81;
        if(model.images && [model.images count] >= 2)
        {
            NSString *summaryImagePath = [model.images objectAtIndex:1];
            if([summaryImagePath length])
            {
                UIImage* img = [ImageManager loadImage:[NSURL URLWithString:summaryImagePath]];
                if (img)
                    [img drawInRect:r];
                else
                    [loadingImage drawInRect:r];
            }
        }
        
        
        // summary text as image form
        p.x = 125;
        p.y = 274;
        [[model.photos objectAtIndex:0] drawAtPoint:p];
    }
}

- (void)dealloc 
{    
	[model release];
	[super dealloc];
}


@end
