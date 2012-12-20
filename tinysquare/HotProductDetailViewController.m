    //
//  HotProductDetailViewController.m
//  TinyStore
//
//  Created by jason on 2011/9/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotProductDetailViewController.h"
#import "DictionaryHelper.h"
#import "ImageManager.h"
#import "ThemeManager.h"
#import "StrikeThroughUILabel.h"

#import "TmpHotProduct.h"
//#import "TmpImage.h"
#import "JSONKit.h"
#import "Membership.h"

@interface HotProductDetailViewController()
- (void)populateProductDetail;
@end


@implementation HotProductDetailViewController

#pragma mark -
#pragma mark define

#define CONTOLLER_NAME      @"HotProductDetailViewController"

#define TAG_BG_IMAGE            9
#define TAG_ITEM_IMAGE          10
#define TAG_ITEM_NAME           11
#define TAG_ITEM_TIME           12
#define TAG_ITEM_PRICE          13
#define TAG_ITEM_SUMMARY        14
#define TAG_ITEM_ORIGINALPRICE  15
#define TAG_ITEM_TEXT_BG        16
#define TAG_ITEM_ATTRIBUTE_1    17
#define TAG_ITEM_ATTRIBUTE_2    18
#define TAG_ITEM_ATTRIBUTE_3    19
#define TAG_ITEM_COUPON         20
#define TAG_ITEM_PRICE_TITLE    21

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize productImage;
@synthesize productName;
@synthesize productTime;
@synthesize priceTitle;
@synthesize productPrice;
@synthesize productOriginalPrice;
@synthesize productSummary;
@synthesize managedObjectContext;
@synthesize adImagePath;

#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
	[productImage release];
	[productName release];
	[productTime release];
    [priceTitle release];
	[productPrice release];
    [productOriginalPrice release];
	[productSummary release];
	[managedObjectContext release];
    [adImagePath release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark initialization and view construction  

- (id)initWithProductIdentifier:(int)anId
{
    self = [super init];
	if(self){
		itemId = anId;
	}
	return self;
}

- (void)loadView 
{
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    NSString *bgImageName = themeManager.hotProductBgImageName;
    //NSString *loadingImageName = themeManager.hotProductLoadingImageName;
    NSString *textBgImageName = themeManager.hotProductTextBg;

    
	// base view
	UIView *baseView = [[UIView alloc] init];
	baseView.frame = CGRectMake(0, 0, 320, 367);
	
	// card background
	UIImage *bgImage = [UIImage imageNamed:bgImageName];
	UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
	bgView.frame = CGRectMake(0, 0, 320, 367);
    bgView.tag = TAG_BG_IMAGE;
	[baseView addSubview:bgView];
	[bgView release];
      

	// item image
	UIButton *itemImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	itemImageButton.frame = CGRectMake(10, 14, 300, 225);
	itemImageButton.tag = TAG_ITEM_IMAGE;
	//[itemImageButton setBackgroundImage:[UIImage imageNamed:loadingImageName] forState:UIControlStateNormal];
    [itemImageButton setBackgroundImage:[UIImage imageNamed:@"300x225white.png"] forState:UIControlStateNormal];
	[itemImageButton addTarget:self action:@selector(goToDetail) forControlEvents:UIControlEventTouchUpInside];
	[baseView addSubview:itemImageButton];
    
     
    // item title image chrome
    UIImageView *titleBgImageView = [[UIImageView alloc] init];
    titleBgImageView.tag = TAG_ITEM_TEXT_BG;
    titleBgImageView.frame = CGRectMake(10, 174, 300, 65);
    titleBgImageView.image = [UIImage imageNamed:textBgImageName];
    [baseView addSubview:titleBgImageView];
    [titleBgImageView release];
	
	// item title label
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.frame = CGRectMake(16, 180, 288, 16);
	titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:16.0f];
	titleLabel.textColor = RGB(32, 32, 32);
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.tag = TAG_ITEM_NAME;
	[baseView addSubview:titleLabel];
	[titleLabel release];
    
    // item price title
	UILabel *priceTitleLabel = [[UILabel alloc] init];
	priceTitleLabel.frame = CGRectMake(16, 201, 60, 16);
	priceTitleLabel.text = NSLocalizedString(@"優惠價:", nil);
	priceTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:16.0f];
	priceTitleLabel.textColor = RGB(196, 55, 55);
	priceTitleLabel.backgroundColor = [UIColor clearColor];
    priceTitleLabel.tag = TAG_ITEM_PRICE_TITLE;
	[baseView addSubview:priceTitleLabel];
	[priceTitleLabel release];
    
    // item price
	UILabel *priceLabel = [[UILabel alloc] init];
	priceLabel.frame = CGRectMake(75, 201, 105, 18);
	priceLabel.tag = TAG_ITEM_PRICE;
	priceLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:16.0f];
	priceLabel.textColor = RGB(255, 0, 0);
	priceLabel.backgroundColor = [UIColor clearColor];
	[baseView addSubview:priceLabel];
	[priceLabel release];
    
    // original price text
    UILabel *originalPriceLabel = [[StrikeThroughUILabel alloc] init];
	originalPriceLabel.frame = CGRectMake(189, 203, 115, 14);
    originalPriceLabel.textAlignment = UITextAlignmentRight;
	originalPriceLabel.tag = TAG_ITEM_ORIGINALPRICE;
	originalPriceLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14.0f];
	originalPriceLabel.textColor = RGB(160, 160, 160);
	originalPriceLabel.backgroundColor = [UIColor clearColor];
	[baseView addSubview:originalPriceLabel];
	[originalPriceLabel release];
    
	// item available time label
	UILabel *availableTimeTitleLabel = [[UILabel alloc] init];
	availableTimeTitleLabel.frame = CGRectMake(16, 225, 40, 11);
	availableTimeTitleLabel.text = NSLocalizedString(@"時間:", nil);
	availableTimeTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:11.0f];
	availableTimeTitleLabel.textColor = RGB(60, 60, 60);
	availableTimeTitleLabel.backgroundColor = [UIColor clearColor];
	[baseView addSubview:availableTimeTitleLabel];
	[availableTimeTitleLabel release];
	
	// item available time
	UILabel *availableTimeLabel = [[UILabel alloc] init];
	availableTimeLabel.frame = CGRectMake(59, 225, 245, 13);
	availableTimeLabel.tag = TAG_ITEM_TIME;
	availableTimeLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:11.0f];
	availableTimeLabel.textColor = RGB(60, 60, 60);
	availableTimeLabel.backgroundColor = [UIColor clearColor];
    availableTimeLabel.numberOfLines = 1;
	[baseView addSubview:availableTimeLabel];
	[availableTimeLabel release];
	
	// item summary
	UILabel *summaryLabel = [[UILabel alloc] init];
	summaryLabel.frame = CGRectMake(16, 255, 288, 48);
	summaryLabel.tag = TAG_ITEM_SUMMARY;
	summaryLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f];
	summaryLabel.textColor = RGB(80, 80, 80);
	summaryLabel.backgroundColor = [UIColor clearColor];
	summaryLabel.numberOfLines = 3;
	[baseView addSubview:summaryLabel];
	[summaryLabel release];
    
    // item attribute 1
    UIButton *attribute1 = [UIButton buttonWithType:UIButtonTypeCustom];
    attribute1.frame = CGRectMake(17, 313, 70, 23);
    attribute1.tag = TAG_ITEM_ATTRIBUTE_1;
    attribute1.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:11.0f];
    [attribute1 setBackgroundImage:[UIImage imageNamed:@"Icon-Category1.png"] forState:UIControlStateNormal];
    [attribute1 setTitle:NSLocalizedString(@"暫無屬性", CONTOLLER_NAME) forState:UIControlStateNormal];
    [attribute1 setTitleColor:RGB(55, 55, 55) forState:UIControlStateNormal];
    [baseView addSubview:attribute1];
    
    // item attribute 2
    UIImageView *attribute2 = [[UIImageView alloc] init ];
    attribute2.frame = CGRectMake(93, 313, 41, 23);
    attribute2.image = [UIImage imageNamed:@"Icon-New.png"];
    attribute2.tag = TAG_ITEM_ATTRIBUTE_2;
    [baseView addSubview:attribute2];
	[attribute2 release];
    
    // item attribute 3
    UIImageView *attribute3 = [[UIImageView alloc] init ];
    attribute3.frame = CGRectMake(139, 313, 41, 23);
    attribute3.image = [UIImage imageNamed:@"Icon-Sale.png"];
    attribute3.tag = TAG_ITEM_ATTRIBUTE_3;
    [baseView addSubview:attribute3];
	[attribute3 release];
    
    // item coupon button
    UIButton *couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
    couponButton.frame = CGRectMake(212, 310, 92, 28);
    couponButton.tag = TAG_ITEM_COUPON;
    couponButton.hidden = YES;
    [couponButton setImage:[UIImage imageNamed:@"Icon-Appcoupon.png"] forState:UIControlStateNormal];
    [baseView addSubview:couponButton];
    
	self.view = baseView;
	[baseView release];
}


#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
    

    
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.productImage = (UIButton *)[self.view viewWithTag:TAG_ITEM_IMAGE];
	self.productName = (UILabel *)[self.view viewWithTag:TAG_ITEM_NAME];
	self.productTime = (UILabel *)[self.view viewWithTag:TAG_ITEM_TIME];
    self.priceTitle = (UILabel *)[self.view viewWithTag:TAG_ITEM_PRICE_TITLE];
	self.productPrice = (UILabel *)[self.view viewWithTag:TAG_ITEM_PRICE];
    self.productOriginalPrice = (UILabel *)[self.view viewWithTag:TAG_ITEM_ORIGINALPRICE];
	self.productSummary = (UILabel *)[self.view viewWithTag:TAG_ITEM_SUMMARY];
    
    // populate with product data
	[self populateProductDetail];
	
	}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
	// Release any retained subviews of the main view.
	self.productImage = nil;
	self.productName = nil;
	self.productTime = nil;
    self.priceTitle = nil;
	self.productPrice = nil;
    self.productOriginalPrice = nil;
	self.productSummary = nil;
	self.managedObjectContext = nil;
    self.adImagePath = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark public methods

- (void)displayProductWithId:(int)anId
{
    itemId = anId;
    [self populateProductDetail];
}


#pragma mark -
#pragma mark theme change

- (void)updateToCurrentTheme:(NSNotification *)notif {
    [super updateToCurrentTheme:notif];
    [self applyTheme];
    [self.view setNeedsDisplay];
}

- (void)applyTheme {
    [super applyTheme];
    
    // update bg background the default loading image
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    
    // background image view
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:TAG_BG_IMAGE];
    imageView.image = [UIImage imageNamed:themeManager.hotProductBgImageName];
    
    // product loading image
    [self.productImage setBackgroundImage:[UIImage imageNamed:themeManager.hotProductLoadingImageName] forState:UIControlStateNormal];
    
    // product text image
    UIImageView *textImageView = (UIImageView *)[self.view viewWithTag:TAG_ITEM_TEXT_BG];
    textImageView.image = [UIImage imageNamed:themeManager.hotProductTextBg];
}


#pragma mark -
#pragma mark private methods

- (void)populateProductDetail
{
 
    

    
    TmpHotProduct *p = [TmpHotProduct getProductIfExistWithId:[NSNumber numberWithInt:itemId] inManagedObjectContext:self.managedObjectContext];
    
    // zomg p is not found!!!
    if(!p)
    {
        return;
    }
    

    // setting ad images
    // set the solution to 600
    self.adImagePath = [TmpHotProduct getAdImagePathWithSize:TmpHotProductAdImageSize600 adImageJson:p.adImageJson];
    
    
    if([self.adImagePath length])
    {
        
        UIImageView *hotProductimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 225)];
        //UIImageView *hotProductimageView=(UIImageView *)[self.view viewWithTag:TAG_ITEM_IMAGE];
        hotProductimageView.image=[ImageManager loadImage:[NSURL URLWithString:self.adImagePath]];
        hotProductimageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.productImage setImage:[UIImage imageNamed:@"detailPicFrame.png"] forState:UIControlStateNormal];
        [self.productImage addSubview:hotProductimageView];
        
     }

    
    /*
    if([self.adImagePath length])
    {
        UIImage* image = [ImageManager loadImage:[NSURL URLWithString:self.adImagePath]];
		
         [self.productImage setImage:image forState:UIControlStateHighlighted];
         self.productImage.imageView.contentMode=UIViewContentModeScaleAspectFit;
		//if (image)
        //{
            //modify image to fit the view frame
           
        //}
        
        
    }
     */
    
    //[self.productImage setImage:[UIImage imageNamed:@"detailPicFrame.png"] forState:UIControlStateNormal];
    
    self.productName.text = p.productName;
    self.productTime.text = p.durationString;
    
    if([p.salePrice intValue] != -1) // this item is on sale
    {
        // need to adjust the price position since the price label might be changed
        self.productPrice.frame = CGRectMake(75, 201, 105, 18);
        
        self.priceTitle.text = NSLocalizedString(@"優惠價:", nil);
        self.productPrice.text = [NSString stringWithFormat:@"NT. %d 元", [p.salePrice intValue]];
        self.productOriginalPrice.hidden = NO;
        self.productOriginalPrice.text = [NSString stringWithFormat:@"%@ %d %@", NSLocalizedString(@"原價", @"HotProductDetailViewController"), [p.price intValue], NSLocalizedString(@"元", @"HotProductDetailViewController")];
    }
    else
    {
        if([p.price intValue])
        {
            // need to adjust the price position since the price label might be changed
            self.productPrice.frame = CGRectMake(55, 201, 105, 18);
            
            self.priceTitle.text = NSLocalizedString(@"價錢:", nil);
            self.productPrice.text = [NSString stringWithFormat:@"NT. %d 元", [p.price intValue]];
            self.productOriginalPrice.hidden = YES;
        }
    }
    
    NSString *customTag = [TmpHotProduct getLastTagFromTagString:p.customTags];
    UIButton *attribute1 = (UIButton *)[self.view viewWithTag:TAG_ITEM_ATTRIBUTE_1];
    [attribute1 setTitle:customTag forState:UIControlStateNormal];
    
    UIImageView *isNewTag = (UIImageView *)[self.view viewWithTag:TAG_ITEM_ATTRIBUTE_2];
    isNewTag.hidden =  ![p.isNew boolValue];
    
    UIImageView *isOnSaleTag = (UIImageView *)[self.view viewWithTag:TAG_ITEM_ATTRIBUTE_3];
    isOnSaleTag.hidden =  ![p.isOnSale boolValue];
    
    self.productSummary.text = p.summary;
    
    
    
    
}

- (void)goToDetail
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.goToDetail" object:nil];
}


#pragma mark -
#pragma mark Image loading

- (void)imageLoaded:(UIImage*)image withURL:(NSString *)url 
{
    if ([self.adImagePath isEqualToString:url])
    {
        
        UIImageView *hotProductimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 225)];
        //UIImageView *hotProductimageView=(UIImageView *)[self.view viewWithTag:TAG_ITEM_IMAGE];
        hotProductimageView.image=[ImageManager loadImage:[NSURL URLWithString:self.adImagePath]];
        hotProductimageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.productImage setImage:[UIImage imageNamed:@"detailPicFrame.png"] forState:UIControlStateNormal];
        [self.productImage addSubview:hotProductimageView];
        
    }

}


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
