//
//  HotProductPageViewControllerPad.m
//  tinysquare
//
//  Created by  on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HotProductPageViewControllerPad.h"
#import "UIApplication+AppDimensions.h"

@implementation HotProductPageViewControllerPad

#pragma mark -
#pragma mark define

#pragma mark -
#pragma mark synthesize

@synthesize productImageView;


#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{
	[productImageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark init 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - loadView

- (void)loadView
{
    CGSize screenSize = [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    productImageView = [[UIImageView alloc] init];
    productImageView.frame = baseView.frame;
    [baseView addSubview:productImageView];
    
    self.view = baseView;
    [baseView release];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
	return YES;
}

@end
