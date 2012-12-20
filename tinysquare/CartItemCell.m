//
//  CartItemCell.m
//  asoapp
//
//  Created by wyde on 12/5/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CartItemCell.h"
#import "DictionaryHelper.h"
#import "ImageManager.h"
#import "ThemeManager.h"
#import "TmpCart.h"

@implementation CartItemCell

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
@synthesize itemCount;
@synthesize managedObjectContext;


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
	if(self == [CartItemCell class])
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
    self.itemCount=[aInfo numberForKey:@"buyItemCount"];
    //NSLog(@"buy itemcount%@",[aInfo numberForKey:@"buyItemCount"]);
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
	itemCount=[NSNumber numberWithInt:0];
    
	// image frame
	p.x = 4 - 4;
	p.y = 8;
	[imageFrame drawAtPoint:p];
	
	// image
	//p.x = 6 - 4;
	//p.y = 10;
    CGFloat imgWidth=self.cellImage.size.width;
    CGFloat imgHeight=self.cellImage.size.height;
	p.x = 2+((112-imgWidth-2*2)/2);
	p.y = 8+((89-imgHeight-2*2)/2);
	[self.cellImage drawAtPoint:p];
    
    // custom tag
    /*
    p.x = 120 - 4;
    p.y = 6;
    [[UIImage imageNamed:@"Icon-Category1.png"] drawAtPoint:p];
    */
     
    // custom tag text
    // may be 暫無屬性 tag
    r.origin.x = 120 - 4;
    r.origin.y = 10;
    r.size.width = 74;
    r.size.height = 12;
    //[[info stringForKey:CUSTOM_TAG] drawInRect:r withFont:[UIFont systemFontOfSize:11] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
    [@"欲購數量" drawInRect:r withFont:[UIFont systemFontOfSize:18] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
    
    
    
    p.x=200;
    p.y=10;
    [[NSString stringWithFormat:@"%@",[info numberForKey:@"buyItemCount"]] drawAtPoint:p withFont:[UIFont systemFontOfSize:18]];
    //UILabel *buyNumber=[[UILabel alloc] initWithFrame:CGRectMake(200, 10, 20, 20)];
 
    // new tag
  
    
     /*
    UILabel *littleSum=[[UILabel alloc] initWithFrame:r];
    littleSum.textAlignment=UITextAlignmentCenter;
    int singlePrice=[[info stringForKey:PRICE] intValue];
    int numberBuy=[[info numberForKey:@"buyItemCount"] intValue];
    NSNumber *cellTotal=[NSNumber numberWithInt: singlePrice*numberBuy];
    littleSum.text=[NSString stringWithFormat:@"商品價錢小計: %@ 元",cellTotal];
    littleSum.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    [self.contentView addSubview:littleSum];
    */
    
        
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
            
            
            r.origin.x= 0;
            r.origin.y=115;
            r.size.width=300;
            r.size.height=20;
            int singlePrice=[[info stringForKey:PRICE] intValue];
            int numberBuy=[[info numberForKey:@"buyItemCount"] intValue];
            NSNumber *cellTotal=[NSNumber numberWithInt: singlePrice*numberBuy];
            
            [[NSString stringWithFormat:@"商品價錢小計: %@ 元",cellTotal] drawInRect:r withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
            //NSLog(@"singleprice %@ X numberbuy %@  = cell total%@ ",[NSNumber numberWithInt:singlePrice], [NSNumber numberWithInt:numberBuy], cellTotal);
            
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
        
        
        
        r.origin.x= 0;
        r.origin.y=115;
        r.size.width=300;
        r.size.height=20;
        int singlePrice=[[info stringForKey:SALE_PRICE] intValue];
        int numberBuy=[[info numberForKey:@"buyItemCount"] intValue];
        NSNumber *cellTotal=[NSNumber numberWithInt: singlePrice*numberBuy];
        
        [[NSString stringWithFormat:@"商品價錢小計: %@ 元",cellTotal] drawInRect:r withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
    }
}


@end
