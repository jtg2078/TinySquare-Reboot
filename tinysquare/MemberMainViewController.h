//
//  MemberMainViewController.h
//  asoapp
//
//  Created by jason on 12/19/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MemberMainViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UISearchBar *mySearchBar;


@end
