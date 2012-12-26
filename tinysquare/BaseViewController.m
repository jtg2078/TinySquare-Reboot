//
//  BaseViewController.m
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "GANTracker.h"



@implementation BaseViewController

#pragma mark -
#pragma mark HTTP requests

- (ASIHTTPRequest*) requestWithURL:(NSString*) s {
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s]];
	[self addRequest:request];
	return request;
}

- (ASIFormDataRequest*) formRequestWithURL:(NSString*) s {
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:s]];
	[self addRequest:request];
	return request;
}

- (void) addRequest:(ASIHTTPRequest*)request {
	[request setDelegate:self];
	if (!requests) {
		requests = [[NSMutableArray alloc] initWithCapacity:3];
	} else {
		[self clearFinishedRequests];
	}
	[requests addObject:request];
}

- (void) clearFinishedRequests {
	NSMutableArray* toremove = [[NSMutableArray alloc] initWithCapacity:[requests count]];
	for (ASIHTTPRequest* r in requests) {
		if ([r isFinished]) {
			[toremove addObject:r];
		}
	}
	
	for (ASIHTTPRequest* r in toremove) {
		[requests removeObject:r];
	}
	[toremove release];
}

- (void) cancelRequests {
	for (ASIHTTPRequest* r in requests) {
		r.delegate = nil;
		[r cancel];
	}	
	[requests removeAllObjects];
}

- (void) refreshCellsWithImage:(UIImage*)image fromURL:(NSURL*)url inTable:(UITableView*)tableView {
    NSArray *cells = [tableView visibleCells];
    [cells retain];
    SEL selector = @selector(imageLoaded:withURL:);
    for (int i = 0; i < [cells count]; i++) {
		UITableViewCell* c = [[cells objectAtIndex: i] retain];
        if ([c respondsToSelector:selector]) {
            [c performSelector:selector withObject:image withObject:url];
        }
        [c release];
		c = nil;
    }
    [cells release];
}

#pragma mark -
#pragma mark UIViewController

- (void) viewDidLoad {
	[super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(updateToCurrentTheme:) 
												 name:@"com.fingertipcreative.tinysquare.themeChange" object:nil];
    
    self.appManager = [EggAppManager sharedInstance];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

#pragma mark - 
#pragma mark utilities methods

- (void)updateToCurrentTheme:(NSNotification *)notif {
}

- (void)applyTheme {
    
}


#pragma mark -
#pragma mark public methods

- (void)hideTabBar
{
	NSNumber *showBar = [NSNumber numberWithInt:0];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
}

- (void)showTabBar
{
	NSNumber *showBar = [NSNumber numberWithInt:1];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
}

- (void)googleAnalyticsTrackPageView:(NSString *)aPagePath
{
    if([[EggAppManager sharedInstance] allowReportUsage])
    {
        NSError *error;
        if (![[GANTracker sharedTracker] trackPageview:aPagePath withError:&error]) {
            NSLog(@"Error in googleAnalyticsTrackPageView with page path(%@): %@", aPagePath, error);
        }
    }
}

- (void)googleAnalyticsTrackEvent:(NSString *)aEventName atViewController:(NSString *)aViewController withStringData:(NSString *)aString intValue:(int)aInt 
{
    if([[EggAppManager sharedInstance] allowReportUsage])
    {
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:aViewController
                                             action:aEventName
                                              label:aString
                                              value:aInt
                                          withError:&error]) {
            NSLog(@"Error: %@", error);
        }
    }
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[self cancelRequests];
	[requests release];
	
    [super dealloc];
}


@end
