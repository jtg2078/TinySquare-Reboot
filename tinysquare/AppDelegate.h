//
//  AppDelegate.h
//  tinysquare
//
//  Created by  on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TATabBarController;
@class TATabBarControllerPad;
@class IIViewDeckController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

// my addition
@property (strong, nonatomic) TATabBarController *tabBarController;
@property (strong, nonatomic) TATabBarControllerPad *tabBarControllerPad;
@property (strong, nonatomic) IIViewDeckController *viewDeckController;
@property (strong, nonatomic) UIImageView *bgImageView;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIImageView *splashView;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (AppDelegate *) sharedAppDelegate;
- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
- (void)dismissModalViewControllerAnimated:(BOOL)animated;
@end
