//
//  SidebarViewController.h
//  asoapp
//
//  Created by wyde on 12/10/29.
//
//

#import <UIKit/UIKit.h>

@protocol SidebarViewControllerDelegate;

@interface SidebarViewController : UITableViewController
{
    NSArray *myData;
    NSArray *sideImage;
}

@property (nonatomic, assign) id <SidebarViewControllerDelegate> sidebarDelegate;

@end

@protocol SidebarViewControllerDelegate <NSObject>

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController;

@end
