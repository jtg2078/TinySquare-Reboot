//
//  BuyDetailViewController.h
//  asoapp
//
//  Created by wyde on 12/6/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


@interface BuyDetailViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>
{
    int productId;
    NSArray *myData;
    NSMutableArray *myDataDescription;
}
@property int productId;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
