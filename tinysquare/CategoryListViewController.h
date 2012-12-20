//
//  CategoryListViewController.h
//  tinysquare
//
//  Created by ling tsu hsuan on 3/23/12.
//  Copyright (c) 2012 jtg2078@hotmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
