//
//  MemberLoginViewController.h
//  asoapp
//
//  Created by wyde on 12/4/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDetailViewController.h"
#import "EggApiManagerDelegate.h"
#import "BaseViewController.h"
#import "FBConnect.h"
#import "Facebook.h"



@interface MemberLoginViewController :BaseViewController <EggApiManagerDelegate,FBSessionDelegate,FBRequestDelegate,FBDialogDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *account;
    NSString *password;
    UIWindow *window;
    UIView *preLoginView;
    UITableView *didLoginView;
    NSArray *loginMemberCellOption;
    Facebook *facebook;
    UIView *headerView;
    UILabel *nameLabel;
    UIImageView *profilePhotoImageView;
    NSArray *permissions;
    NSString *whichViewFrom;
    
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) UIView *preLoginView;
@property (nonatomic, retain) UITableView *didLoginView;
@property (nonatomic, retain) NSArray *loginMemberCellOption;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIImageView *profilePhotoImageView;
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) NSString *whichViewFrom;
//- (void)loadContentAsync;


@end
