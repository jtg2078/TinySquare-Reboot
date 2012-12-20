//
//  ProductCell.m
//  TinyStore
//
//  Created by jason on 2011/9/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemCell.h"
#import "DictionaryHelper.h"
#import "ImageManager.h"
#import "ThemeManager.h"

@implementation ItemCell

#pragma mark -
#pragma mark define

#define NAME            @"name"
#define PRICE           @"price"
#define SALE_PRICE      @"salePrice"
#define IS_NEW          @"isNew"
#define ON_SALE         @"onSale"
#define CUSTOM_TAG      @"customTag"
#define SUBTITLE        @"subtitle"
#define TIME            @"time"
#define IMAGE           @"image"
#define MODE            @"mode"
#define IMAGE_FRAME     @"list_propicBg.png"


#pragma mark -
#pragma mark macro

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize info;
@synthesize imageURL;
@synthesize cellImage;


#pragma mark -
#pragma mark static variables

static UIFont* system18 = nil;
static UIFont* system16 = nil;
static UIFont* system13 = nil;
static UIFont* system13Bold = nil;
static UIImage *imageFrame = nil;


#pragma mark -
#pragma mark init and dealloc

+ (void)initialize
{
	if(self == [ItemCell class])
	{
		system18 = [[UIFont systemFontOfSize:18] retain];
        system16 = [[UIFont boldSystemFontOfSize:16] retain];
		system13 = [[UIFont systemFontOfSize:13] retain];
		system13Bold = [[UIFont boldSystemFontOfSize:13] retain];
		imageFrame = [[UIImage imageNamed:IMAGE_FRAME] retain];
	}
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.customContentView.backgroundColor = [UIColor whiteColor];
		self.customContentView.opaque = YES;
    }
    return self;
}

- (void)dealloc 
{
    [info release];
	[imageURL release];
    [cellImage release];
    [super dealloc];
}


#pragma mark -
#pragma mark UITableViewCell

- (void) prepareForReuse {
	[super prepareForReuse];
}


#pragma mark -
#pragma mark public methods

- (void)updateCellInfo: (NSDictionary *)aInfo; 
{
	self.info = aInfo;
	self.imageURL = [aInfo stringForKey:IMAGE];
    self.cellImage = nil;
    if ([self.imageURL length]) 
        self.cellImage = [ImageManager loadImage:[NSURL URLWithString:self.imageURL]];
    
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    self.customContentView.backgroundColor = themeManager.productCellBgColor;
        
	[self setNeedsDisplay];
}

- (void) imageLoaded:(UIImage *)image withURL:(NSString *)url 
{	
	if ([self.imageURL isEqualToString:url])
    {
        self.cellImage = image;
		[self setNeedsDisplay];
    }
}


#pragma mark -
#pragma mark view

- (void) drawCustomContentView:(CGRect)rect 
{
    // misc
	CGPoint p;
    CGRect r;
	
	// image frame
	p.x = 4 - 4;
	p.y = 8;
	[imageFrame drawAtPoint:p];
    // the frame of imageFrame is 112x89

	// image
    CGFloat imgWidth=self.cellImage.size.width;
    CGFloat imgHeight=self.cellImage.size.height;
	p.x = 2+((112-imgWidth-2*2)/2);
	p.y = 8+((89-imgHeight-2*2)/2);
	[self.cellImage drawAtPoint:p];
    
    // custom tag
    p.x = 120 - 4;
    p.y = 6;
    [[UIImage imageNamed:@"Icon-Category1.png"] drawAtPoint:p];
    
    // custom tag text
    r.origin.x = 122 - 4;
    r.origin.y = 10;
    r.size.width = 64;
    r.size.height = 12;
    [[info stringForKey:CUSTOM_TAG] drawInRect:r withFont:[UIFont systemFontOfSize:11] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
    
    // new tag
    p.x = 192 - 4;
    p.y = 6;
    if([[info boolForKey:IS_NEW] boolValue])
        [[UIImage imageNamed:@"Icon-New.png"] drawAtPoint:p];
    
    // on sale tag
    p.x = 235 - 4;
    p.y = 6;
    if([[info boolForKey:ON_SALE] boolValue])
        [[UIImage imageNamed:@"Icon-Sale.png"] drawAtPoint:p];
    
    if([[info boolForKey:MODE] boolValue]) // normal price
    {
        if([[info stringForKey:PRICE] length])
        {
            // price title
            [RGB(196, 55, 55) set];
            p.x = 120 - 4;
            p.y = 37;
            [NSLocalizedString(@"商品價", nil) drawAtPoint:p withFont:[UIFont systemFontOfSize:15.0f]];
            
            // price
            [RGB(255, 0, 0) set];
            p.x = 169 - 4;
            p.y = 37;
            [[info stringForKey:PRICE] drawAtPoint:p withFont:[UIFont systemFontOfSize:15.0f]];
            
            // product name
            [RGB(32, 32, 32) set];
            r.origin.x = 120 - 4;
            r.origin.y = 60;
            r.size.width = 155;
            r.size.height = 40;
            [[info stringForKey:NAME] drawInRect:r withFont:[UIFont systemFontOfSize:16.0f]];
        }
        else
        {
            // product name
            [RGB(32, 32, 32) set];
            r.origin.x = 120 - 4;
            r.origin.y = 37;
            r.size.width = 155;
            r.size.height = 40;
            [[info stringForKey:NAME] drawInRect:r withFont:[UIFont systemFontOfSize:16.0f]];
        }
    }
    else // special price
    {
        // sale price title
        [RGB(196, 55, 55) set];
        p.x = 120 - 4;
        p.y = 32;
        [NSLocalizedString(@"優惠價", nil) drawAtPoint:p withFont:[UIFont systemFontOfSize:15.0f]];
        
        // sale price
        [RGB(255, 0, 0) set];
        p.x = 169 - 4;
        p.y = 32;
        [[info stringForKey:SALE_PRICE] drawAtPoint:p withFont:[UIFont systemFontOfSize:15.0f]];
        
        // original price title
        [RGB(160, 160, 160) set];
        p.x = 120 - 4;
        p.y = 50;
        [NSLocalizedString(@"原價", nil) drawAtPoint:p withFont:[UIFont systemFontOfSize:11.0f]];
        
        // original price
        [RGB(160, 160, 160) set];
        p.x = 145 - 4;
        p.y = 50;
        [[info stringForKey:PRICE] drawAtPoint:p withFont:[UIFont systemFontOfSize:11.0f]];
        
        // product name
        [RGB(32, 32, 32) set];
        r.origin.x = 120 - 4;
        r.origin.y = 62;
        r.size.width = 155;
        r.size.height = 40;
        [[info stringForKey:NAME] drawInRect:r withFont:[UIFont systemFontOfSize:16.0f]];
    }
}


@end
