//
//  DetailCell.m
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailCell.h"
#import "ImageManager.h"
#import "UIImage+Transform.h"
#import "DictionaryHelper.h"
#import "DataManager.h"
#import "TmpProduct.h"
#import "LoginMember.h"




@interface DetailCell ()
- (void)imageButtonPressed:(id)sender;
- (void)couponButtonPressed:(id)sender;
- (void)buyButtonPressed:(id)sender;
- (void)webButtonPressed:(id)sender;
- (void)phoneButtonPressed:(id)sender;
- (void)shareButtonPressed:(id)sender;
@end


@implementation DetailCell

#pragma mark -
#pragma mark Macros 

#define FACEBOOK_BUTTON 120
#define TWITTER_BUTTON	121
#define EMAIL_BUTTON	122
#define TAG_COUPON_BUTTON   123
#define TAG_BUY_BUTTON      124
#define TAG_WEB_BUTTON      125
#define TAG_PHONE_BUTTON    126
#define TAG_SHARE_BUTTON    127
#define TAG_IMAGE_BUTTON    128

#define CELL_WIDTH          292

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#pragma mark - 
#pragma mark synthesize

@synthesize delegate;


#pragma mark - 
#pragma mark dealloc

- (void)dealloc 
{    
	[cellView release];
    delegate = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Initialization

- (id)initWithData:(DetailCellModel *)cellData style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		CGRect cellFrame = CGRectMake(0, 0, CELL_WIDTH, cellData.totalHeight);
		cellView = [[DetailCellView alloc] initWithFrame:cellFrame];
		cellView.model = cellData;
		[self.contentView addSubview:cellView];
		
		if(cellData.cellType == CellTypeWaiting)
		{
			UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			CGRect aivFrame = aiv.frame;
			aivFrame.origin = CGPointMake(10, 10);
			aiv.frame = aivFrame;
			[aiv startAnimating];
			[self.contentView addSubview:aiv];
			[aiv release];
		}
        
        if(cellData.cellType == CellTypeAboutMeTitleAndImages)
        {
            CGRect rect = CGRectMake(0, 0, 160, 96);
			UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
			[RGB(100, 100, 100) set];
			[cellData.displayContent drawInRect:rect withFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f]];
			UIImage* stringImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			cellData.photos = [NSArray arrayWithObject:stringImage];
        }
		
		// performance tweak TextToImage
		if(cellData.cellType == CellTypeMultiLineStandAloneTitle)
		{
			CGRect rect = CGRectMake(0, 0, 288, cellData.contentHeight);
			UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
			[RGB(100, 100, 100) set];
			[cellData.displayContent drawInRect:rect withFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f]];
			UIImage* stringImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			cellData.photos = [NSArray arrayWithObject:stringImage];
		}
        
        if(cellData.cellType == CellTypeMultiLineMultiWordTitle)
        {
            CGRect rect = CGRectMake(0, 0, 288, cellData.titleHeight);
			UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
			[[UIColor blackColor] set];
			[cellData.title drawInRect:rect withFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f]];
			UIImage* titleStringImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
            
            rect = CGRectMake(0, 0, 288, cellData.contentHeight);
			UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
			[RGB(100, 100, 100) set];
			[cellData.displayContent drawInRect:rect withFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f]];
			UIImage* contentStringImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			cellData.photos = [NSArray arrayWithObjects:titleStringImage, contentStringImage, nil];
        }
        
        if(cellData.cellType == CellTypeCustomTags)
        {
            // tags
            int numOfTagLines = [[cellData.miscContents objectForKey:@"numLines"] intValue];
            int numOfTags = [[cellData.miscContents objectForKey:@"numTags"] intValue];
            NSArray *tags = [cellData.miscContents objectForKey:@"tags"];
            CGPoint p = CGPointZero;
            p.y = 10;
            
            int marginVertical = 3;
            int marginHorizontal = 3;
            int tagCounter = 0;
            for(int i = 0; i < numOfTagLines; i++)
            {
                p.x = 75 - 10;
                for(int j = 0; j < 3; j++)
                {
                    if(tagCounter >= numOfTags)
                        break;
                    
                    UIButton *attribute1 = [UIButton buttonWithType:UIButtonTypeCustom];
                    attribute1.frame = CGRectMake(p.x, p.y, 70, 23);
                    attribute1.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:11.0f];
                    [attribute1 setBackgroundImage:[UIImage imageNamed:@"Icon-Category1.png"] forState:UIControlStateNormal];
                    [attribute1 setTitle:[tags objectAtIndex:tagCounter] forState:UIControlStateNormal];
                    [attribute1 setTitleColor:RGB(55, 55, 55) forState:UIControlStateNormal];
                    
                    tagCounter++;
                    p.x += (70 + marginHorizontal);
                    [self.contentView addSubview:attribute1];
                }
                p.y += (23 + marginVertical);
            } 
        }
        
#pragma mark -
#pragma mark setup all the button        
        if(cellData.cellType == CellTypeTitleAndImagesEnhanced)
        {
            /*
            UIButton *image = [UIButton buttonWithType:UIButtonTypeCustom];
            //image.imageView.contentMode=UIViewContentModeScaleAspectFit;
            [image setImage:[UIImage imageNamed:@"detailPicFrame.png"] forState:UIControlStateNormal];
            //image.frame = CGRectMake(0, 3, CELL_WIDTH, 225);
            image.frame = CGRectMake(0, 0, CELL_WIDTH, 240);
            image.tag = TAG_IMAGE_BUTTON;
            [image setBackgroundImage:[UIImage imageNamed:@"detailPicFrame.png"] forState:UIControlStateNormal];
            [image addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            //image.imageView.contentMode=UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:image];
            */
            
            
            //NSLog(@"%@",cellData.miscContents);
            
            UIButton *image = [UIButton buttonWithType:UIButtonTypeCustom];
            //image.frame = CGRectMake(0, 3, CELL_WIDTH, 225);
            image.frame = CGRectMake(0, 0, CELL_WIDTH, 240);
            image.tag = TAG_IMAGE_BUTTON;
            [image setBackgroundImage:[UIImage imageNamed:@"detailPicFrame.png"] forState:UIControlStateNormal];
            [image addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:image];
            
            
			UIButton *coupon = [UIButton buttonWithType:UIButtonTypeCustom];
			coupon.frame = CGRectMake(203 - 4, 205, 92, 28);
			coupon.tag = TAG_COUPON_BUTTON;
            coupon.hidden = YES;
			[coupon setBackgroundImage:[UIImage imageNamed:@"Icon-Appcoupon.png"] forState:UIControlStateNormal];
			[coupon addTarget:self action:@selector(couponButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[self.contentView addSubview:coupon];
            
            UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
			buy.frame = CGRectMake(5 - 4, 240, 68, 53);
			buy.tag = TAG_BUY_BUTTON;
            //LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:
            //buy button enabled here
            buy.enabled = [[cellData.miscContents objectForKey:@"price"] isEqualToNumber:[NSNumber numberWithInt:0]] ? NO:YES ;
			[buy setBackgroundImage:[UIImage imageNamed:@"detailIconBuy.png"] forState:UIControlStateNormal];
			[buy addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			//[self.contentView addSubview:buy];
            
            UIButton *web = [UIButton buttonWithType:UIButtonTypeCustom];
			web.frame = CGRectMake(5 - 4, 240, 93, 53);
			web.tag = TAG_WEB_BUTTON;
            NSString *url = (NSString *)[cellData.miscContents objectForKey:@"url"];
            web.enabled = [url length] ? YES: NO;
			[web setBackgroundImage:[UIImage imageNamed:@"nonBuy_IconWeb.png"] forState:UIControlStateNormal];
			[web addTarget:self action:@selector(webButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[self.contentView addSubview:web];
            
            UIButton *phone = [UIButton buttonWithType:UIButtonTypeCustom];
			phone.frame = CGRectMake(98, 240, 93, 53);
			phone.tag = TAG_PHONE_BUTTON;
            NSString *phoneNumber = (NSString *)[cellData.miscContents objectForKey:@"phoneNumber"];
            phone.enabled = [phoneNumber length] ? YES: NO;
			[phone setBackgroundImage:[UIImage imageNamed:@"nonBuy_IconPhone.png"] forState:UIControlStateNormal];
			[phone addTarget:self action:@selector(phoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[self.contentView addSubview:phone];
            
            UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
			share.frame = CGRectMake(196, 240, 93, 53);
			share.tag = TAG_SHARE_BUTTON;
			[share setBackgroundImage:[UIImage imageNamed:@"nonBuy_IconSocial.png"] forState:UIControlStateNormal];
			[share addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[self.contentView addSubview:share];
        }
        
        if(cellData.cellType == CellTypeAboutMeTitleAndImages)
        {
            UIButton *image = [UIButton buttonWithType:UIButtonTypeCustom];
            //image.frame = CGRectMake(0, 3, CELL_WIDTH, 225);
            image.frame = CGRectMake(0, 0, CELL_WIDTH, 240);
            image.tag = TAG_IMAGE_BUTTON;
            [image setBackgroundImage:[UIImage imageNamed:@"detailPicFrame.png"] forState:UIControlStateNormal];
            [image addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:image];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		cellView = [[DetailCellView alloc] initWithFrame:CGRectMake(0.0, 0.0, CELL_WIDTH, self.contentView.bounds.size.height)];
		[self.contentView addSubview:cellView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)redrawWithModel:(DetailCellModel *)anModel {
	cellView.model = anModel;
	cellView.frame = CGRectMake(0, 0, CELL_WIDTH, anModel.totalHeight);
	[cellView setNeedsDisplay];
}

- (void)redrawCellView {
	[cellView setNeedsDisplay];
}

- (void) imageLoaded:(UIImage *)image withURL:(NSString *)url {
	[self redrawCellView];
}

#pragma mark - 
#pragma mark user interaction

- (void)imageButtonPressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(handleImageEvent)])
        [self.delegate performSelector:@selector(handleImageEvent)];
}

- (void)couponButtonPressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(handleCouponEvent)])
        [self.delegate performSelector:@selector(handleCouponEvent)];
}

- (void)buyButtonPressed:(id)sender
{
    //if([self.delegate respondsToSelector:@selector(handleAddToCart)])
    //[self.delegate performSelector:@selector(handleAddToCart)];
   
    if([self.delegate respondsToSelector:@selector(handleBuyEvent)])
        [self.delegate performSelector:@selector(handleBuyEvent)];
}

- (void)webButtonPressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(handleWebUrlEvent)])
        [self.delegate performSelector:@selector(handleWebUrlEvent)];
}

- (void)phoneButtonPressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(handlePhoneEvent)])
        [self.delegate performSelector:@selector(handlePhoneEvent)];
}

- (void)shareButtonPressed:(id)sender
{
	if([self.delegate respondsToSelector:@selector(handleShareEvent)])
        [self.delegate performSelector:@selector(handleShareEvent)];
}




@end
