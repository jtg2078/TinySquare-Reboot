//
//  ProductDetailViewControllerPad.m
//  tinysquare
//
//  Created by  on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailViewControllerPad.h"

@implementation ProductDetailViewControllerPad

#pragma mark - define

#define DUMMY_MAIN_PRODUCT_IMAGE    @"Product_detail_BigPro-1.jpg"
#define DUMMY_PRODUCT_SPEC_HTML     @"proAll_detail-3"
#define DUMMY_PRODUCT_DESC_IMAGE    @"Detail_Description.png"
#define BACK_BUTTON_IMAGE           @"detailViewBackButton.png"
#define STATUS_DISCOUNT_IMAGE       @"detailViewStatusDiscount.png"
#define SELECTED_IMAGE_FRAME        @"detailViewScrollActiveFrame.png"

#define SHOW_LAYER_BORDER(s) s.layer.borderWidth = 2.0f; s.layer.borderColor = [[UIColor redColor] CGColor]

#pragma mark - synthesize

@synthesize productImagesScrollView;
@synthesize productDescriptionScrollView;
@synthesize productSpecWebView;
@synthesize specialStatusImageView;
@synthesize mainImageView;
@synthesize selectedImageFrame;

#pragma mark - dealloc

- (void)dealloc {
    [mainImageView release];
    [specialStatusImageView release];
    [productImagesScrollView release];
    [productSpecWebView release];
    [productDescriptionScrollView release];
    [selectedImageFrame release];
    [super dealloc];
}

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup dummy data and stuff
    self.mainImageView.image = [UIImage imageNamed:DUMMY_MAIN_PRODUCT_IMAGE];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:DUMMY_PRODUCT_SPEC_HTML  ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
    self.productSpecWebView.userInteractionEnabled = NO;
    [self.productSpecWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:filePath]];
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DUMMY_PRODUCT_DESC_IMAGE]];
    descriptionImageView.frame = CGRectMake(0, 0, 368, 680);
    self.productDescriptionScrollView.contentSize = descriptionImageView.frame.size;
    [self.productDescriptionScrollView addSubview:descriptionImageView];
    [descriptionImageView release];
    
    int numOfImages = 6;
    int imageWidth = 128;
    int x = 0;
    for(int i = 1; i <= numOfImages; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Detail_Photo_S%d.png", i]]];
        imageView.frame = CGRectMake(x, 4, 128, 128);
        [self.productImagesScrollView addSubview:imageView];
        [imageView release];
        x += imageWidth;
    }
    self.productImagesScrollView.contentSize = CGSizeMake(imageWidth * numOfImages, 128);
    // setup frame
    selectedImageFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SELECTED_IMAGE_FRAME]];
    selectedImageFrame.frame = CGRectMake(0, 0, 128, 132);
    [self.productImagesScrollView addSubview:selectedImageFrame];
    
    //SHOW_LAYER_BORDER(self.mainImageView);
    //SHOW_LAYER_BORDER(self.productImagesScrollView);
}

- (void)viewDidUnload
{
    [self setMainImageView:nil];
    [self setSpecialStatusImageView:nil];
    [self setProductImagesScrollView:nil];
    [self setProductSpecWebView:nil];
    [self setProductDescriptionScrollView:nil];
    [self setSelectedImageFrame:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - user interaction

- (IBAction)addToBookmarkTapped:(id)sender {
}

- (IBAction)addToFacebookTapped:(id)sender {
}

- (IBAction)backButtonTapped:(id)sender 
{
    // First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.4;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	//NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	//NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
	//int rnd = random() % 4;
	transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[self.view.superview.layer addAnimation:transition forKey:nil];
	
	self.view.hidden = YES;
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



@end
