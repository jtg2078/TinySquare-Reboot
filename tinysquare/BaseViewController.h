//
//  BaseViewController.h
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


#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "EggAppManager.h"
#import "AppDelegate.h"

typedef void (^BASIC_CALLBACK)();


@interface BaseViewController : UIViewController {
	
	NSMutableArray* requests;

}

@property (nonatomic, assign) EggAppManager *appManager;
@property (nonatomic, assign) AppDelegate *appDelegate;

- (ASIHTTPRequest*) requestWithURL:(NSString*) s;
- (ASIFormDataRequest*) formRequestWithURL:(NSString*) s;
- (void) addRequest:(ASIHTTPRequest*)request;
- (void) clearFinishedRequests;
- (void) cancelRequests;

- (void)updateToCurrentTheme:(NSNotification *)notif;
- (void)applyTheme;

- (void) refreshCellsWithImage:(UIImage*)image fromURL:(NSURL*)url inTable:(UITableView*)tableView;

- (void)hideTabBar;
- (void)showTabBar;

- (void)googleAnalyticsTrackPageView:(NSString *)aPagePath;
- (void)googleAnalyticsTrackEvent:(NSString *)aEventName atViewController:(NSString *)aViewController withStringData:(NSString *)aString intValue:(int)aInt;

- (void)showModalSignInViewController:(void (^)())callback;

@end
