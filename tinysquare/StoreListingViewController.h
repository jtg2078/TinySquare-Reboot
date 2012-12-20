//
//  StoreListingViewController.h
//  TinyStore
//
//  Created by jason on 2011/9/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import	<MessageUI/MessageUI.h>
#import "BaseTableViewController.h"

typedef enum {
	StoreCellViewModeNone,
	StoreCellViewModeAddDetail,
	StoreCellViewModeRemoveDetail,
} StoreCellViewMode;


@interface StoreListingViewController : BaseTableViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate> {
	NSArray *regionNames;
	NSIndexPath *indexPathForSelectedCell;
	StoreCellViewMode detailViewMode;
	//UIView *black;
	MKMapView *mapView;
	UILabel *phoneLabel;
	UIButton *dialButton;
	NSString *selectedAddress;
	NSString *selectedPhone;
	NSString *selectedStoreName;
}

@property (nonatomic, retain) NSString *selectedAddress;
@property (nonatomic, retain) NSString *selectedPhone;
@property (nonatomic, retain) NSString *selectedStoreName;
@property (nonatomic, retain) NSIndexPath *indexPathForSelectedCell;
@property (nonatomic, retain) NSArray *regionNames;
@property (nonatomic, retain) UIImage *detailViewImage;
@property (nonatomic, retain) UIView *expandedCellView;

- (void)loadFromCoreData;

@end
