//
//  AboutMeViewController.m
//  LayoutManagerEx
//
//  Created by  on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutMeViewControllerPad.h"

@implementation AboutMeViewControllerPad

#pragma mark - static

#pragma mark - define

#define ABOUT_HTML @"aboutus"
#define ABOUT_HTML_HORIZONTAL @"aboutus7"

#pragma mark - macro

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define SHOW_LAYER_BORDER(s) s.layer.borderWidth = 2.0f; s.layer.borderColor = [[UIColor redColor] CGColor]

#pragma mark - synthesize

@synthesize webView;

#pragma mark - init, dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [webView release];
    [super dealloc];
}

#pragma mark - view construction

- (void)loadView
{
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 0, 768, 1024);
    
    webView = [[UIWebView alloc] init];
    webView.frame = baseView.frame;
    [baseView addSubview:webView];
     
    self.view = baseView;
    [baseView release];
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:ABOUT_HTML ofType:@"html"];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:ABOUT_HTML ofType:@"html"];
        
        NSString *htmlString = [NSString stringWithContentsOfFile:filePath
                                                         encoding:NSUTF8StringEncoding
                                                            error:NULL];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(!self.webView) {
                UIWebView *aWebView = [[UIWebView alloc] init];
                //aWebView.backgroundColor = [UIColor clearColor];
                //aWebView.opaque = NO;
                //aWebView.userInteractionEnabled = NO;
                //aWebView.alpha = 0;
                aWebView.frame = self.view.frame;
                //aWebView.scalesPageToFit = YES;
                [aWebView loadHTMLString:htmlString baseURL:baseURL];
                self.webView = aWebView;
                [aWebView release];
                [self.view addSubview:self.webView];
                //SHOW_LAYER_BORDER(self.webView);
            }
            
        });
        
    });
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    if(self.webView)
        [self.webView reload];
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        {
            //self.view.frame = CGRectMake(0, 0, 1024, 768);
            self.webView.frame = CGRectMake(0, 0, 1024, 768);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *filePath = [[NSBundle mainBundle] pathForResource:ABOUT_HTML_HORIZONTAL ofType:@"html"];
                
                NSString *htmlString = [NSString stringWithContentsOfFile:filePath
                                                                 encoding:NSUTF8StringEncoding
                                                                    error:NULL];
                NSString *path = [[NSBundle mainBundle] bundlePath];
                NSURL *baseURL = [NSURL fileURLWithPath:path];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(self.webView) {
                        [self.webView loadHTMLString:htmlString baseURL:baseURL];
                    }
                    
                });
                
            });
            
        }
        else
        {
            //self.view.frame = CGRectMake(0, 0, 768, 1024);
            self.webView.frame = CGRectMake(0, 0, 768, 1024);
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *filePath = [[NSBundle mainBundle] pathForResource:ABOUT_HTML ofType:@"html"];
                
                NSString *htmlString = [NSString stringWithContentsOfFile:filePath
                                                                 encoding:NSUTF8StringEncoding
                                                                    error:NULL];
                NSString *path = [[NSBundle mainBundle] bundlePath];
                NSURL *baseURL = [NSURL fileURLWithPath:path];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(self.webView) {
                        [self.webView loadHTMLString:htmlString baseURL:baseURL];
                    }
                    
                });
                
            });
        }
    }
}

- (void)layoutSubviews 
{
    
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
