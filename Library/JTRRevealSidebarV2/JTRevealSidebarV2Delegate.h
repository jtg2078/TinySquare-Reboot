//
//  JTRevealSidebarV2Delegate.h
//  asoapp
//
//  Created by wyde on 12/10/30.
//
//

#import <Foundation/Foundation.h>

@protocol JTRevealSidebarV2Delegate <NSObject>
@optional
- (UIView *)viewForLeftSidebar;
- (UIView *)viewForRightSidebar;
- (void)willChangeRevealedStateForViewController:(UIViewController *)viewController;
- (void)didChangeRevealedStateForViewController:(UIViewController *)viewController;


@end
