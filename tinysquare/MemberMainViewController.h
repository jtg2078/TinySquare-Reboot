//
//  MemberMainViewController.h
//  asoapp
//
//  Created by jason on 12/19/12.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BaseViewController.h"

@interface MemberMainViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UISearchBar *mySearchBar;


@end
