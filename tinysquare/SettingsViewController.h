//
//  SettingsViewController.h
//  tinysquare
//
//  Created by  on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemeManager;
@interface SettingsViewController : UITableViewController {
    ThemeManager *themeManager;
}

@property (nonatomic, retain) NSArray *sectionNameArray;
@property (nonatomic, retain) NSArray *sectionDataArray;
@property (nonatomic) int selectedIndex;

@end
