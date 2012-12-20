//
//  DetailModelManagerDelegate.h
//  NTIFO_01
//
//  Created by jason on 2011/9/2.
//  Copyright 2011 Fingertip Creative. All rights reserved.
//

@class BaseDetailModelManager;

@protocol DetailModelManagerDelegate <NSObject>

@optional

- (void)createDetailCellListStarted:(BaseDetailModelManager *)manager;
- (void)createDetailCellListFinished:(BaseDetailModelManager *)manager;
- (void)createDetailCellListFailed:(BaseDetailModelManager *)manager;

- (void)refreshDetailCellListStarted:(BaseDetailModelManager *)manager;
- (void)refreshDetailCellListFinished:(BaseDetailModelManager *)manager;
- (void)refreshDetailCellListFailed:(BaseDetailModelManager *)manager;

@end