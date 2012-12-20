//
//  BaseMemberAreaViewController.h
//  asoapp
//
//  Created by wyde on 12/10/31.
//
//

#import "BaseViewController.h"
#import "JTRevealSidebarV2Delegate.h"
#import "SidebarViewController.h"

@class SidebarViewController;


@interface BaseMemberAreaViewController : BaseViewController<JTRevealSidebarV2Delegate,SidebarViewControllerDelegate>


@property (nonatomic, strong) SidebarViewController *leftSidebarViewController;
@property (nonatomic, strong) NSIndexPath *leftSelectedIndexPath;


@end
