    //
//  BaseTableViewController.m
//  TinyStore
//
//  Created by jason on 2011/9/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseDetailViewController.h"

#import "DetailCell.h"
#import "DetailCellModel.h"


#import "ProductImageViewController.h"
#import "SVWebViewController.h"
#import "ItemMapViewController.h"

#import "AppDelegate.h"
#import "ThemeManager.h"
#import "SHK.h"
#import "TATabBarController.h"
#import "DictionaryHelper.h"
#import "MemberLoginViewController.h"
#import "DataManager.h"
#import "TmpCart.h"
#import "AddToCartViewController.h"
#import "LoginMember.h"
#import "AboutMeViewController.h"
#import "MKInfoPanel.h"

#import "SignInMemberViewController.h"
#import "SVProgressHUD.h"

@interface BaseDetailViewController ()
- (void)setupCellArray;
- (void)addWaitingIndicatorCell;
- (void)removeWaitingIndicatorCell;
@end

@implementation BaseDetailViewController

#pragma mark -
#pragma mark define

#define NUM_OF_SECTION			1
#define BASE_VIEW_X				0
#define BASE_VIEW_Y				0
#define BASE_VIEW_WIDTH			320
#define BASE_VIEW_HEIGHT		367
#define BASE_VIEW_IMAGE_TAG     25
#define TABLE_VIEW_X			14
#define TABLE_VIEW_Y			14
#define TABLE_VIEW_WIDTH		292
#define TABLE_VIEW_HEIGHT		339
#define PATH_FOR_TRACKING		@"/BaseDetailViewController"

#define ITEM_NAME       @"name"
#define ITEM_IMAGES     @"images"
#define ITEM_PRICE      @"price"
#define ITEM_SUMMARY    @"summary"
#define ITEM_WEB_URL    @"url"
#define ITEM_TEL        @"tel"
#define ITEM_IMAGE      @"image"
#define ITEM_EMAIL      @"email"


#pragma mark -
#pragma mark Macros

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#pragma mark -
#pragma mark synthesize

@synthesize cellDataArray;
@synthesize cellArray;
@synthesize itemId;
@synthesize modelManager;
@synthesize selectedCellRect;
@synthesize selectedCellIndex;
//@synthesize managedObjectContext;


#pragma mark -
#pragma mark dealloc

- (void)dealloc 
{    
	[theTableView release];
	[cellDataArray release];
	[cellArray release];
	[modelManager release];
	[super dealloc];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}


#pragma mark - 
#pragma mark initialization and view construction 

- (void)loadView 
{
	ThemeManager *themeManager = [ThemeManager sharedInstance];
	// setup paper background and transparency
	UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(BASE_VIEW_X, BASE_VIEW_Y, BASE_VIEW_WIDTH, BASE_VIEW_HEIGHT)];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:themeManager.detailViewBgImageName]];
    bgImageView.tag = BASE_VIEW_IMAGE_TAG;
	theTableView = [[UITableView alloc] initWithFrame:CGRectMake(TABLE_VIEW_X, TABLE_VIEW_Y, TABLE_VIEW_WIDTH, TABLE_VIEW_HEIGHT) 
												style:UITableViewStylePlain];

    //baseView.contentMode=UIViewContentModeScaleAspectFit;	
    
    bgImageView.frame = baseView.frame;
	theTableView.delegate = self;
	theTableView.dataSource = self;
	theTableView.opaque = NO;
	theTableView.backgroundColor = [UIColor clearColor];
	
	[baseView addSubview:bgImageView];
	[baseView addSubview:theTableView];
	self.view = baseView;
	
	[bgImageView release];
	[baseView release];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	self.cellArray = [NSMutableArray array];
	self.cellDataArray = [NSMutableArray array];
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
    self.cellDataArray = nil;
	self.cellArray = nil;
	self.modelManager = nil;
}

- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	
	// Unselect the selected row if any
	NSIndexPath *selection = [theTableView indexPathForSelectedRow];
	if (selection)
		[theTableView deselectRowAtIndexPath:selection animated:YES];
	
	[theTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
	
	//	The scrollbars won't flash unless the tableview is long enough.
	[theTableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

#pragma mark-
#pragma mark public methods

- (void)clearTable {
    [self.cellDataArray removeAllObjects];
    [self.cellArray removeAllObjects];
    [self.modelManager clearDetailCellList];
    [theTableView reloadData];
}

#pragma mark - 
#pragma mark utilities methods

- (void)updateToCurrentTheme:(NSNotification *)notif {
    [super updateToCurrentTheme:notif];
    [self applyTheme];
}

- (void)applyTheme {
    [super applyTheme];
    ThemeManager *themeManager = [ThemeManager sharedInstance];
    UIImageView *baseImageView = (UIImageView *)[self.view viewWithTag:BASE_VIEW_IMAGE_TAG];
    baseImageView.image = [UIImage imageNamed:themeManager.detailViewBgImageName];
	
	// needs to customize title display
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.text = self.title;
	titleLabel.textColor = themeManager.navigationBarTitleTextColor;
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.frame = CGRectMake(0, 0, [titleLabel.text sizeWithFont:font].width, 44);
	titleLabel.font = font;
	self.navigationItem.titleView = titleLabel;
	[titleLabel release];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return NUM_OF_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.cellDataArray count];
    //return [self.cellArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return the height of each cell based on precalculated results
	DetailCellModel *cellData = (DetailCellModel *)[self.cellDataArray objectAtIndex:indexPath.row];
	return cellData.totalHeight;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	DetailCell *cell = [self.cellArray objectAtIndex:indexPath.row];
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	DetailCellModel *selectCellData = (DetailCellModel *)[self.cellDataArray objectAtIndex:indexPath.row];
	if(selectCellData.hasAccessory == YES)
		return indexPath;
	else
		return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	self.selectedCellRect = [tableView convertRect:[tableView rectForRowAtIndexPath:indexPath] toView:[tableView superview]];
	self.selectedCellIndex = indexPath.row;
	DetailCellModel *selectedCellData = (DetailCellModel *)[cellDataArray objectAtIndex:indexPath.row];
	
	if(selectedCellData.selectedResponse == CellSelectedResponseOpenInImageBrowser || selectedCellData.selectedResponse == CellSelectedResponseMultiPurpose) 
	{
        [self handleImagesViewing:[[self.modelManager detailInfo] arrayForKey:ITEM_IMAGES]];
	}
	
	if(selectedCellData.selectedResponse == CellSelectedResponseOpenInMap) 
	{
		[self handleAddress:selectedCellData.displayContent 
                        lat:[NSNumber numberWithDouble:selectedCellData.lat] 
                        lon:[NSNumber numberWithDouble:selectedCellData.lon] 
                       name:selectedCellData.title 
                  imagePath:@""];
	}
	
	if(selectedCellData.selectedResponse == CellSelectedResponseCall) 
	{
		[self handlePhoneNumber:selectedCellData.displayContent ownerName:selectedCellData.title];
	}
	
	if(selectedCellData.selectedResponse == CellSelectedResponseOpenInSafari) 
	{
		[self handleWebUrl:selectedCellData.displayContent ownerName:selectedCellData.title];
	}
    
    if(selectedCellData.selectedResponse == CellSelectedResponseSharing)
    {
        [self handleShare];
    }
    
    if(selectedCellData.selectedResponse == CellSelectedResponseEmail)
    {
        [self handleEmailEvent];
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheetType == BaseDetailViewControllerActionSheetTypePhoneCall)
    {
        if(buttonIndex == 0)
        {
            NSString *phoneNumber = [[self.modelManager detailInfo] stringForKey:ITEM_TEL];
            NSString *phoneString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: phoneString]];
        }
    }
    
    DetailCellModel *selectedCellData = (DetailCellModel *)[cellDataArray objectAtIndex:self.selectedCellIndex];
    
    if(selectedCellData.selectedResponse == CellSelectedResponseCall)
    {
        if(buttonIndex == 0)
        {
            NSString *phoneNumber = [[self.modelManager detailInfo] stringForKey:ITEM_TEL];
            NSString *phoneString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: phoneString]];
        }
        
        /*
         DetailCellModel *selectedCellData = (DetailCellModel *)[cellDataArray objectAtIndex:self.selectedCellIndex];
         
         if(selectedCellData.selectedResponse == CellSelectedResponseCall || selectedCellData.selectedResponse == CellSelectedResponseMultiPurpose) 
         {
         // to make sure the phone number contains digits only
         NSString *phoneNumDecimalsOnly = [[selectedCellData.displayContent componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
         phoneNumDecimalsOnly = selectedCellData.displayContent;
         
         NSString *phoneString = [NSString stringWithFormat:@"tel://%@", phoneNumDecimalsOnly];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString: phoneString]];
         }
         */
    }
    
    if(selectedCellData.selectedResponse == CellSelectedResponseEmail || actionSheetType == BaseDetailViewControllerActionSheetTypeEmail)
    {
        NSString *email = [[self.modelManager detailInfo] stringForKey:ITEM_EMAIL];
        
        
        if (buttonIndex == 0)
        {
            UIPasteboard *generalPasteBoard = [UIPasteboard generalPasteboard];
            generalPasteBoard.string = email;
        }
        
        if(buttonIndex == 1)
        {
            NSNumber *showBar = [NSNumber numberWithInt:0];
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
            
            MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init]; 
            
            [emailComposer setMailComposeDelegate: self]; 
            //[emailComposer setSubject:@"[TinySquare App]"];
            [emailComposer setSubject:@""];
            [emailComposer setToRecipients:[NSArray arrayWithObject:email]];
            
            emailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
            
            [self presentModalViewController:emailComposer animated:YES];
            [emailComposer release];
        }
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet 
{
	[UIView animateWithDuration:0.3f animations:^{
		CGRect cellFrame = self.selectedCellRect;
		CGRect actionSheetFrame = actionSheet.frame;
		
		float diff = (480 - actionSheetFrame.size.height) - (cellFrame.origin.y + 20 + 44 + 14 + cellFrame.size.height);
		
		if(diff < 0) {
			CGRect frame = theTableView.frame;
			frame.origin.y += diff;
			theTableView.frame = frame;
		}
	}];
	// Unselect the selected row if any
	NSIndexPath *selection = [theTableView indexPathForSelectedRow];
	if (selection)
		[theTableView deselectRowAtIndexPath:selection animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	[UIView animateWithDuration:0.3f animations:^{
		CGRect frame = theTableView.frame;
		frame.origin.y = 14;
		theTableView.frame = frame;
	}];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:YES];
	NSNumber *showBar = [NSNumber numberWithInt:1];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar];
}


#pragma mark -
#pragma mark Cell Model manager delegate

- (void)createDetailCellListStarted:(BaseDetailModelManager *)manager {
	[self addWaitingIndicatorCell];
}

- (void)createDetailCellListFinished:(BaseDetailModelManager *)manager
{
	[self removeWaitingIndicatorCell];
	
	[self.cellDataArray addObjectsFromArray:manager.cellList];
	
	// setup cells
	[self setupCellArray];
}

- (void)createDetailCellListFailed:(BaseDetailModelManager *)manager {
	[self removeWaitingIndicatorCell];
}


#pragma mark -
#pragma mark async image loading

- (void) imageLoaded:(UIImage*)image withURL:(NSURL*)url {
    [self refreshCellsWithImage:image fromURL:url inTable:theTableView];
    
    NSArray *array = [self.modelManager.detailInfo arrayForKey:ITEM_IMAGES];
    if([array count] && [array objectAtIndex:0])
    {
        NSString *firstImageUrl = (NSString *)[array objectAtIndex:0];
        NSString *urlString = (NSString *)url;
        if([firstImageUrl length] && [urlString isEqualToString:firstImageUrl])
        {
            [self.modelManager.detailInfo setObject:image forKey:ITEM_IMAGE];
        }
    }
}


#pragma mark -
#pragma mark private interface

- (void)setupCellArray 
{
	static NSString *CellIdentifier = @"detailCellIdentifier";
	NSMutableArray *indexArray = [NSMutableArray array];
	
	for(int i = 0; i < [cellDataArray count]; i++)
	{
		DetailCellModel *cellData = [cellDataArray objectAtIndex:i];
		DetailCell *cell = [[DetailCell alloc] initWithData:cellData 
													  style:UITableViewCellStyleDefault 
											reuseIdentifier:CellIdentifier];
		
		// configure cell;
		if(cellData.hasAccessory == YES) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
        cell.delegate = self;
        
		[indexArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
		[self.cellArray addObject:cell];
		[cell release];
	}
	
	[theTableView beginUpdates];
	[theTableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
	[theTableView endUpdates];
}

- (void)addWaitingIndicatorCell
{
	DetailCellModel *model = [modelManager createWaitingModel];
	[self.cellDataArray addObject:model];
	
	DetailCell *cell = [[DetailCell alloc] initWithData:model 
												  style:UITableViewCellStyleDefault 
										reuseIdentifier:nil];
	[self.cellArray addObject:cell];
	[cell release];
	
	NSArray *indexArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
	[theTableView beginUpdates];
	[theTableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
	[theTableView endUpdates];
}

- (void)removeWaitingIndicatorCell
{
	[self.cellDataArray removeObjectAtIndex:0];
	
	[theTableView beginUpdates];
	[theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] 
						withRowAnimation:UITableViewRowAnimationTop];
	[theTableView endUpdates];
	
	[self.cellArray removeObjectAtIndex:0];
}


#pragma mark - 
#pragma mark user interaction

- (void)handlePhoneNumber:(NSString *)aPhoneNumber ownerName:(NSString *)aName
{
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    NSString *optionText = [NSString stringWithFormat:NSLocalizedString(@"撥打 %@", nil), aPhoneNumber];
    UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self 
                                                   cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:optionText, nil];
    [styleAlert showInView:appDelegate.tabBarController.view];
    [styleAlert release];
    actionSheetType = BaseDetailViewControllerActionSheetTypePhoneCall;
    
    // for tracking
    NSString *stringData = [NSString stringWithFormat:@"%@:%@	%@", NSLocalizedString(@"物件", nil), aName, aPhoneNumber];
    [self googleAnalyticsTrackEvent:NSLocalizedString(@"撥打電話", nil) 
                   atViewController:PATH_FOR_TRACKING 
                     withStringData:stringData
                           intValue:0];
}

- (void)handleWebUrl:(NSString *)aWebUrl ownerName:(NSString *)aName
{
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:aWebUrl];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
    
    // for tracking
    NSString *stringData = [NSString stringWithFormat:@"%@:%@	%@", NSLocalizedString(@"物件", nil), aName, aWebUrl];
    [self googleAnalyticsTrackEvent:NSLocalizedString(@"打開連結", nil) 
                   atViewController:PATH_FOR_TRACKING 
                     withStringData:stringData
                           intValue:0];
}

- (void)handleAddress:(NSString *)anAddress lat:(NSNumber *)lat lon:(NSNumber *)lon name:(NSString *)aName imagePath:(NSString *)aPath
{
    ItemMapViewController *imvc = [[ItemMapViewController alloc] initWithItemId:-1 
                                                                           name:aName 
                                                                        address:anAddress 
                                                                       latitude:[lat doubleValue]
                                                                      longitude:[lon doubleValue]];
    imvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imvc animated:YES];
    [imvc release];
    
    // for tracking
    NSString *stringData = [NSString stringWithFormat:@"%@:%@	%@	(%f,%f)", NSLocalizedString(@"物件", nil), aName, anAddress, [lat doubleValue], [lon doubleValue]];
    [self googleAnalyticsTrackEvent:NSLocalizedString(@"查看地點", nil) 
                   atViewController:PATH_FOR_TRACKING 
                     withStringData:stringData
                           intValue:0];
}


//when touch down sharing in social network
- (void)handleShare
{
    NSMutableString *shareText = [NSMutableString stringWithCapacity:300];
    [shareText appendFormat:@"%@\n", [self.modelManager.detailInfo stringForKey:ITEM_NAME]];
    [shareText appendFormat:@"%@\n", [self.modelManager.detailInfo stringForKey:ITEM_WEB_URL]];
    [shareText appendFormat:@"NT. %d %@\n", [[self.modelManager.detailInfo numberForKey:ITEM_PRICE] intValue], NSLocalizedString(@"元",nil)];
    [shareText appendFormat:@"%@\n", [self.modelManager.detailInfo stringForKey:ITEM_SUMMARY]];
    [shareText appendFormat:@"%@\n", [self.modelManager.detailInfo stringForKey:ITEM_TEL]];
    
    SHKItem *item = [SHKItem text:shareText];
    item.URL = [NSURL URLWithString:[self.modelManager.detailInfo stringForKey:ITEM_WEB_URL]];
    item.title = [self.modelManager.detailInfo stringForKey:ITEM_NAME];
    item.text = shareText;
    
    UIImage *image = (UIImage *)[self.modelManager.detailInfo objectForKey:ITEM_IMAGE];
    if(image)
        item.image = image;
    
    NSArray *images = [self.modelManager.detailInfo arrayForKey:ITEM_IMAGES];
    if([images count])
    {
        NSString *urlImage = [images objectAtIndex:0];
        if(urlImage)
        {
            [item setCustomValue:urlImage forKey:@"picture"];
            item.shareType = SHKShareTypeURL;
        }
    }
    
    /*NSURL *testUrl = [NSURL URLWithString:@"http://getsharekit.com"];
    SHKItem *testItem = [SHKItem URL:testUrl title:@"ShareKit is Awesome!"];*/
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [SHK setRootViewController:self];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [actionSheet showInView:appDelegate.tabBarController.view];
}

- (void)handleImagesViewing:(NSArray *)anImageArray
{
    ProductImageViewController *pibc = [[ProductImageViewController alloc] init];
    pibc.contentList = anImageArray;
    [self.navigationController pushViewController:pibc animated:YES];
    [pibc release];
}

- (void)handleEmail:(NSString *)anEmail ownerName:(NSString *)aName
{
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    NSString *optionText1 = NSLocalizedString(@"複製Email地址", nil);
    NSString *optionText2 = [NSString stringWithFormat:NSLocalizedString(@"To: %@", nil), anEmail];
    UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self 
                                                   cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:optionText1, optionText2, nil];
    [styleAlert showInView:appDelegate.tabBarController.view];
    [styleAlert release];
    actionSheetType = BaseDetailViewControllerActionSheetTypeEmail;
    
    // for tracking
    NSString *stringData = [NSString stringWithFormat:@"%@:%@	%@", NSLocalizedString(@"物件", nil), aName, anEmail];
    [self googleAnalyticsTrackEvent:NSLocalizedString(@"Email", nil) 
                   atViewController:PATH_FOR_TRACKING 
                     withStringData:stringData
                           intValue:0];
}

#pragma mark - shopping cart related

- (void)addToShoppingCart
{
    if(self.appManager.isSignedIn == YES)
    {
        NSNumber *pid = [[self.modelManager detailInfo] numberForKey:@"productId"];
        NSNumber *count = @(1);
        NSString *msg = [NSString stringWithFormat:@"加到購物車 pid:%@", pid.stringValue];
        
        [SVProgressHUD showWithStatus:msg];
        
        [self.appManager addToRealCartProduct:pid
                                        count:count
                                    needLogin:^{ [SVProgressHUD showErrorWithStatus:@"請先登入"];}
                                      success:^(int code, NSString *msg) { [SVProgressHUD showSuccessWithStatus:msg];}
                                      failure:^(NSString *errorMessage, NSError *error) {
                                          NSString *msg = [NSString stringWithFormat:@"%@ pid: %@", errorMessage, pid.stringValue];
                                          [SVProgressHUD showErrorWithStatus:msg];
                                      }];
        
        /*
        [self.appManager addToTempCartProduct:[[self.modelManager detailInfo] numberForKey:@"productId"] count:@(1)];
        
        [SVProgressHUD showSuccessWithStatus:@"加到購物車"];
         */
    }
}

#pragma mark -
#pragma mark DetailCellDelegate

- (void)handleImageEvent
{
    [self handleImagesViewing:[[self.modelManager detailInfo] arrayForKey:ITEM_IMAGES]];
}

- (void)handleCouponEvent
{
    // do nothing for now
}

- (void)handleBuyEvent
{
    
    if(self.appManager.isSignedIn == YES)
    {
        [self addToShoppingCart];
        
        /*
        [SVProgressHUD showWithStatus:@"建立中"];
        [self.appManager createShoppingCart:^{
            
            [SVProgressHUD showSuccessWithStatus:@"建立成功"];
            
        } failure:^(NSString *errorMessage, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:errorMessage];
            
        }];
         */
    }
    else
    {
        [self showModalSignInViewController:^{
            
            [self addToShoppingCart];
            
        }];
    }
    
    return;
    
    
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:self.modelManager.managedObjectContext];

    
    
        if (lm.logincheck && [lm.logincheck isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [DataManager saveProductToCartProductId:[[self.modelManager detailInfo] numberForKey:@"productId"] 
                               managedObjectContext:self.modelManager.managedObjectContext 
                                showIndicatorInView:self.view];
            TmpCart *t=[TmpCart getProductIfExistWithProductId:[[self.modelManager detailInfo] numberForKey:@"productId"] inManagedObjectContext:self.modelManager.managedObjectContext];
            t.buyItemCount=[NSNumber numberWithInt:1];
            
            AddToCartViewController *loginView =[[AddToCartViewController alloc] init];
            loginView.managedObjectContext = self.modelManager.managedObjectContext;
            [self.navigationController pushViewController:loginView animated:YES];
            [loginView release];
            // NSLog(@"%@",[[self.modelManager detailInfo] numberForKey:@"productId"]);

        }
        else {
            MemberLoginViewController *memberlogin=[[MemberLoginViewController alloc] init];
            memberlogin.managedObjectContext=self.modelManager.managedObjectContext;
            [self presentModalViewController:memberlogin animated:YES];
            memberlogin.modalPresentationStyle=UIModalPresentationFullScreen;
            
            //[self performSelector:@selector(backToCart) withObject:self afterDelay:5];
            //[MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeProgress title:@"稍等五秒自動跳轉" subtitle:nil hideAfter:3];
            //[self.navigationController pushViewController:memberlogin animated:YES];
            memberlogin.whichViewFrom=@"BaseDetailViewController";
            [memberlogin release];

        }

 
}

-(void) backToCart
{
    [self dismissModalViewControllerAnimated:NO];
}



- (void)handleWebUrlEvent
{
    //NSLog(@"%@",[self.modelManager detailInfo]);
    
    NSString *name = [[self.modelManager detailInfo] stringForKey:ITEM_NAME];
    NSString *url = [[self.modelManager detailInfo] stringForKey:ITEM_WEB_URL];
    [self handleWebUrl:url ownerName:name];
}

- (void)handlePhoneEvent
{
    NSString *name = [[self.modelManager detailInfo] stringForKey:ITEM_NAME];
    NSString *phone = [[self.modelManager detailInfo] stringForKey:ITEM_TEL];
    [self handlePhoneNumber:phone ownerName:name];
}

- (void)handleShareEvent
{
    // do nothing for now
    [self handleShare];
}

- (void)handleEmailEvent
{
    NSString *name = [[self.modelManager detailInfo] stringForKey:ITEM_NAME];
    NSString *email = [[self.modelManager detailInfo] stringForKey:ITEM_EMAIL];
    [self handleEmail:email ownerName:name];
}

@end

