//
//  ProductCellViewController.m
//  LayoutManagerEx
//
//  Created by  on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductCellViewControllerPad.h"
#import "UIImage+utility.h"
#import "CellEx.h"

@implementation ProductCellViewControllerPad

#pragma mark - define

#define IMAGE_MASK_GRAYSCALE_SQUARE         @"Product_picall-frontshadow-s.png"
#define IMAGE_MASK_GRAYSCALE_VERTICAL       @"Product_picall-frontshadow-p.png"
#define IMAGE_MASK_GRAYSCALE_HORIZONTAL     @"Product_picall-frontshadow-l.png"
#define IMAGE_MASK_COLOR                    @"Product_picall-frontshadow-border.png"

#pragma mark - macro

#pragma mark - synthesize

@synthesize cellWidth;
@synthesize cellHeight;
@synthesize imageName;
@synthesize htmlName;
@synthesize cellMode;
@synthesize grayScaleImage;
@synthesize image;
@synthesize imageView;
@synthesize imageMask;
@synthesize webView;


#pragma mark - init, loadView and dealloc

- (id)initWithImage:(NSString *)aImageName html:(NSString *)aHtmlName width:(int)aWidth height:(int)aHeight;
{
    self = [super init];
    if(self) {
        self.imageName = aImageName;
        self.htmlName = aHtmlName;
        self.cellWidth = aWidth;
        self.cellHeight = aHeight;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [grayScaleImage release];
    [image release];
    [imageView release];
    [imageMask release];
    [webView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViewAsync];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}

#pragma mark - public method

- (void)initViewAsync
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1. generate a grayscale image
        // 2. resize the gayscale image to appropriate size
        // 3. initialize the web
        CGSize adjustedSize = CGSizeMake(512, 512);
        CGSize grayScaleSize = CGSizeMake(cellWidth, cellHeight);
        //NSLog(@"image name:%@", self.imageName);
        self.image = [UIImage imageNamed:self.imageName];
        //if(cellWidth == 256 && cellHeight == 256)
        {
            self.grayScaleImage = [[self.image imageByScalingAndCroppingForSize:grayScaleSize] convertToGrayscale];
        }
        self.image = [self.image imageByScalingToSize:adjustedSize];
        //self.grayScaleImage = [self.image convertToGrayscale];
        
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.htmlName ofType:@"html"];
        
        NSString *htmlString = [NSString stringWithContentsOfFile:filePath
                                                         encoding:NSUTF8StringEncoding
                                                            error:NULL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // we want to do following on main thread becuase they are ui related
            self.view.frame = CGRectMake(0, 0, cellWidth, cellHeight);
            if(!self.imageView) {
                UIImageView *aImageView = [[UIImageView alloc] initWithImage:self.grayScaleImage highlightedImage:self.image];
                //aImageView.contentMode = UIViewContentModeTopLeft;
                self.imageView = aImageView;
                [aImageView release];
                [self.view addSubview:self.imageView];
            }
            if(!self.imageMask) {
                /*
                UIImageView *aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_MASK_GRAYSCALE] highlightedImage:[UIImage imageNamed:IMAGE_MASK_COLOR]];
                */
                UIImageView *aImageView = [[UIImageView alloc] init];
                aImageView.highlightedImage = [UIImage imageNamed:IMAGE_MASK_COLOR];
                if(cellWidth == 512)
                    aImageView.image = [UIImage imageNamed:IMAGE_MASK_GRAYSCALE_HORIZONTAL];
                else if(cellHeight == 512)
                    aImageView.image = [UIImage imageNamed:IMAGE_MASK_GRAYSCALE_VERTICAL];
                else
                    aImageView.image = [UIImage imageNamed:IMAGE_MASK_GRAYSCALE_SQUARE];
                
                self.imageMask = aImageView;
                [aImageView release];
                [self.view addSubview:self.imageMask];
            }
            if(!self.webView) {
                UIWebView *aWebView = [[UIWebView alloc] init];
                aWebView.backgroundColor = [UIColor clearColor];
                aWebView.opaque = NO;
                aWebView.userInteractionEnabled = NO;
                aWebView.alpha = 0;
                aWebView.frame = self.view.frame;
                [aWebView loadHTMLString:htmlString baseURL:nil];
                self.webView = aWebView;
                [aWebView release];
                [self.view addSubview:self.webView];
            }
        });
    });
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
