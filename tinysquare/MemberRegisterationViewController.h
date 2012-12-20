//
//  MemberRegisterationViewController.h
//  asoapp
//
//  Created by wyde on 12/4/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberManager.h"
#import "EggApiManagerDelegate.h"
#import "BaseViewController.h"


@interface MemberRegisterationViewController : BaseViewController<UIScrollViewDelegate,EggApiManagerDelegate,NSFetchedResultsControllerDelegate>{
    
    UIScrollView *scrollView;
    //NSManagedObjectContext *managedObjectContext;
     
 
}
@property (nonatomic,retain) MemberManager *modelManager;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSDate *lastUpdateTime;

/*
@property (nonatomic, retain) UITextField *account;
@property (nonatomic, retain) UITextField *phonenumber;
@property (nonatomic, retain) UITextField *passconfirm;
@property (nonatomic, retain) UITextField *membername;
@property (nonatomic, retain) UITextField *liveaddress;
@property (nonatomic, retain) UITextField *password;
 */
@end

