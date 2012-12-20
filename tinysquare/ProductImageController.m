    //
//  ProductImageController.m
//  TinyStore
//
//  Created by jason on 2011/9/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductImageController.h"
#import "ImageManager.h"


@implementation ProductImageController

#pragma mark -
#pragma mark define

#define TAG_ITEM_IMAGE 10


#pragma mark -
#pragma mark macro

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize productImage;


#pragma mark -
#pragma mark initialization, view construction and dealloc

- (id)initWithImageName:(NSString *)name
{
	self = [super init];
	if(self){
		imageName = [name retain];
	}
	return self;
}

- (void)loadView 
{
	// base view
	UIView *baseView = [[UIView alloc] init];
	baseView.frame = CGRectMake(0, 0, 320, 367);
	
	// card background
	UIImage *bgImage = [UIImage imageNamed:@"PicDis_PicBFrame.png"];
	UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
	bgView.frame = CGRectMake(0, 0, 320, 325);
	[baseView addSubview:bgView];
	[bgView release];
	
	// item image
	UIImageView *itemImageView = [[UIImageView alloc] init];
	itemImageView.contentMode = UIViewContentModeScaleAspectFit;
	itemImageView.frame = CGRectMake(10, 11, 300, 300);
	itemImageView.tag = TAG_ITEM_IMAGE;
	[baseView addSubview:itemImageView];
	[itemImageView release];
	
	self.view = baseView;
	[baseView release];
}

- (void)dealloc 
{
	[imageName release];
	[productImage release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.productImage = (UIImageView *)[self.view viewWithTag:TAG_ITEM_IMAGE];
	
	// populate with product data
	[self populateProductDetailAsync];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
	// Release any retained subviews of the main view.
	self.productImage = nil;
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

- (void)populateProductDetailAsync
{
	UIImage* image = [ImageManager loadImage:[NSURL URLWithString:imageName]];
    
    if (image) {
        self.productImage.image = image;
    }
}


#pragma mark -
#pragma mark private methods

- (void)imageLoaded:(UIImage *)image withURL:(NSString *)url 
{
    if ([imageName isEqualToString:url]) {
        self.productImage.image = image;
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
