//
//  BaseTableViewController.h
//  TinyStore
//
//  Created by jason on 2011/9/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import	<MessageUI/MessageUI.h>
#import "BaseViewController.h"
#import "BaseDetailModelManager.h"
#import "DetailCellDelegate.h"

typedef enum {
    BaseDetailViewControllerActionSheetTypeNone,
	BaseDetailViewControllerActionSheetTypePhoneCall,
    BaseDetailViewControllerActionSheetTypeEmail,
} BaseDetailViewControllerActionSheetType;

@interface BaseDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, DetailCellDelegate, MFMailComposeViewControllerDelegate> 
{
	// ui
	UITableView *theTableView;
	// table view data
	NSMutableArray *cellDataArray;
	NSMutableArray *cellArray;
	// model
	int itemId;
	BaseDetailModelManager *modelManager;
	// misc
	CGRect selectedCellRect;
	int selectedCellIndex;
    BaseDetailViewControllerActionSheetType actionSheetType;
}

@property (nonatomic, retain) BaseDetailModelManager *modelManager;
@property (nonatomic, retain) NSMutableArray *cellDataArray;
@property (nonatomic, retain) NSMutableArray *cellArray;
@property (nonatomic) int itemId;
@property (nonatomic) CGRect selectedCellRect;
@property (nonatomic) int selectedCellIndex;

//@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)clearTable;

// user interaction
- (void)handlePhoneNumber:(NSString *)aPhoneNumber ownerName:(NSString *)aName;
- (void)handleWebUrl:(NSString *)aWebUrl ownerName:(NSString *)aName;
- (void)handleAddress:(NSString *)anAddress lat:(NSNumber *)lat lon:(NSNumber *)lon name:(NSString *)aName imagePath:(NSString *)aPath;
- (void)handleShare;
- (void)handleImagesViewing:(NSArray *)anImageArray;
- (void)handleEmail:(NSString *)anEmail ownerName:(NSString *)aName;

// DetailCellDelegate
- (void)handleImageEvent;
- (void)handleCouponEvent;
- (void)handleBuyEvent;
- (void)handleWebUrlEvent;
- (void)handlePhoneEvent;
- (void)handleShareEvent;
- (void)handleEmailEvent;

@end