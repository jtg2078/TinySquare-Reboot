//
//  OrderHistoryViewController.h
//  TinySquare
//
//  Created by jason on 12/29/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface OrderHistoryViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) NSMutableArray *headerStateArray;
@property (retain, nonatomic) NSMutableDictionary *cartAdditionalInfo;

@end
